%%%%%%%%%%% created by Mo and Eric on 07/02/2020


% This file takes the long format files generated from the R code that are
% labeled "..._WithConditions_forDesignMatrices.csv" and spits out a .mat
% file for each participant for each MRI scanner run.

clc;
clear all;


%% Where do you want the design matrix onset files to go?
cd('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/onsets');

%% Pull data from the long text file created in R
VSWM_all = readtable('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/onsets/SF_vswm_long_07_09_20_WithConditions_forOnsetFiles.csv');

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
        clear('names1');
        clear('names2');
        clear('names3');
        clear('names4');
        clear('names5');
        clear('onsets');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill conditions variable %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        names = {};
        
        % If there are no errors, there are only 3 conditions, no condition of "incorrect".
        if mean(run_data.targetscreen_ACC)== 1.0
            names = {'con2', 'con4', 'stm2', 'stm4'};
        end
        
        % If there is at least one correct "con2" trial, make a condition for it. 
        if mean(run_data.targetscreen_ACC(run_data.condition == "con2", :)) ~= 0;
            names1 = 'con2';
        else names1 = {};
        end
        
        % If there is at least one correct "con4" trial, make a condition for it. 
        if mean(run_data.targetscreen_ACC(run_data.condition == "con4", :)) ~= 0;
            names2 = {names1, 'con4'};
        else names2 = names1;
        end
        
        % If there is at least one correct "stm2" trial, make a condition for it. 
        if mean(run_data.targetscreen_ACC(run_data.condition == "stm2", :)) ~= 0;
            names3 = {names2{:}, 'stm2'};
        else names3 = names2;
        end
        
        % If there is at least one correct "stm4" trial, make a condition for it. 
        if mean(run_data.targetscreen_ACC(run_data.condition == "stm4", :)) ~= 0;
            names4 = {names3{:}, 'stm4'};
        else names4 = names3;
        end
        
        % If there is at least one incorrect trial, make a condition for it.
        if mean(run_data.targetscreen_ACC) < 1.0;
            names5 = {names4{:}, 'incorrect'};
        else names5 = names4;
        end
        
        % If no error, choose "names" stays name, but if there is an error "names5" is written to "names".
        if isempty(names);
            names = names5;
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