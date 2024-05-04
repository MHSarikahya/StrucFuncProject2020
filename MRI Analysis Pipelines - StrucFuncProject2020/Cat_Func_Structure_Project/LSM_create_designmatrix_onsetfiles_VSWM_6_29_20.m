%%%%%%%%%%% created by Lien, Fuyu, and Eric on 06/30/2020

% This file takes the long format files generated from the R code that are
% labeled "..._WithConditions_forDesignMatrices.csv" and spits out a .mat
% file for each participant for each MRI scanner run.

clc;
clear all;


%% Where do you want the design matrix onset files to go?
cd('/Users/eric/GoogleDrive/6_LSM/MRI_Data/Processing_MRI_data/onset_matfiles_6_29_20/VSWM_onsets');

%% Pull data from the long text file created in R
VSWM_all = readtable('/Users/eric/GoogleDrive/6_LSM/MRI_Data/Processing_MRI_data/CSVs_WithConditions_for_Onsets/vswm_long_06_29_20_WithConditions_forOnsetFiles.csv');

identifier_all = unique(VSWM_all.Subject); % list of all subjects

% Subject-level loop
for a = 1:length(unique(VSWM_all.Subject))
    
    identifier = identifier_all(a); % which subject id?
    
    % Subject data
    subject_data = VSWM_all(VSWM_all.Subject==identifier, :);

    
    % Run-level loop
    for b = 1:length(unique(subject_data.run))
        
        % Run data
        run_data =  subject_data(subject_data.run==b, :);

        filename = [VSWM_all.Task{a, :} '_subject_' num2str(identifier) '_run_' num2str(run_data.run(1))];
   
        gap_time = run_data.StartFixation_OnsetTime(b); % time waiting for "s" press
        
 %   numconditions = length(unique(VSWM_all.condition))
        
        % Fill three variables with 3 columns

        % Initialize variables
        clear('durations');
        clear('names');
        clear('onsets');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill conditions variable %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        if mean(run_data.targetscreen_ACC)== 1.0
            names = {'con3', 'con5', 'stm3', 'stm5'};
        elseif mean(run_data.targetscreen_ACC) < 1.0
            names = {'con3', 'con5', 'stm3', 'stm5', 'incorrect'};
        end
        

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill Onsets variable %%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Fill onsets variable
        % Condition-level loop 
        for c = 1:length(unique(run_data.condition))
           
            %Condition data
            condition_data = run_data(strcmp(run_data.condition,names{1, c}), :);

            onsets{:, c} = [(condition_data.targetscreen_OnsetTime - gap_time)/1000]';
            
            % Set all corresponding durations to zero
            durations{:, c} = [zeros(length(condition_data.targetscreen_OnsetTime), 1)]';
            
        end
        
        
        save(filename,'names','onsets','durations');
        
    end
end



return;