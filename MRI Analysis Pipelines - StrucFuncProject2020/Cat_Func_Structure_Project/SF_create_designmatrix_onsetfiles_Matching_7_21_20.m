%%%%%%%%%%% created by Mo and Eric (And Lien) on 07/02/2020

% This file takes the long format files generated from the R code that are
% labeled "..._WithConditions_forDesignMatrices.csv" and spits out a .mat
% file for each participant for each MRI scanner run.

clc;
clear all;


%% Where do you want the design matrix onset files to go?
cd('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/onsets');

%% Pull data from the long text file created in R
Matching_all = readtable('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/onsets/SF_matching_long_07_09_20_WithConditions_forOnsetFiles.csv');

identifier_all = unique(Matching_all.Subject); % list of all subjects

% Subject-level loop
for a = 1:length(unique(Matching_all.Subject))
    
    identifier = identifier_all(a); % which subject id?
    
    % Subject data
    subject_data = Matching_all(Matching_all.Subject==identifier, :);

    
    % Run-level loop
    for b = 1:length(unique(subject_data.run))
        
        % Run data
        run_data =  subject_data(subject_data.run==b, :);

        filename = [Matching_all.Task{a, :} '_subject_' num2str(identifier) '_run_' num2str(run_data.run(1))];
   
        gap_time = run_data.Startline_OnsetTime(b); % time waiting for "s" press
        
 %   numconditions = length(unique(Matching_all.condition))
        
        % Fill three variables with 3 columns

        % Initialize variables
        clear('durations');
        clear('names');
        clear('names1');
        clear('names2');
        clear('names3');
        clear('onsets');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill conditions variable %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        
        names = {};
        
        % If there are no errors, there are only 3 conditions, no condition of "incorrect".
        if mean(run_data.task_ACC)== 1.0
            names = {'number', 'shape'};
        end
        
        % If there is at least one correct "number" trial, make a condition for it. 
        if mean(run_data.task_ACC(run_data.condition == "number", :)) ~= 0;
            names1 = 'number';
        else names1 = {};
        end
        
        % If there is at least one correct "shape" trial, make a condition for it. 
        if mean(run_data.task_ACC(run_data.condition == "shape", :)) ~= 0;
            names2 = {names1, 'shape'};
        else names2 = names1;
        end
        
        
        % If there is at least one incorrect trial, make a condition for it.
        if mean(run_data.task_ACC) < 1.0;
            names3 = {names2{:}, 'incorrect'};
        else names3 = names2;
        end
        
        % If no error, choose "names" stays name, but if there is an error "names3" is written to "names".
        if isempty(names);
            names = names3;
        end
          
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill Onsets variable %%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Fill onsets variable
        % Condition-level loop 
        for c = 1:length(unique(run_data.condition))
           
            %Condition data
            condition_data = run_data(strcmp(run_data.condition,names{1, c}), :);

            onsets{:, c} = [(condition_data.task_OnsetTime - gap_time)/1000]';
            
            % Set all corresponding durations to zero
            durations{:, c} = [zeros(length(condition_data.task_OnsetTime), 1)]';
            
        end
        
        
        save(filename,'names','onsets','durations');
        
    end
end



return;