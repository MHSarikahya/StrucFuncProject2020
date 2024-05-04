%%%%%%%%%%% created by Mo and Eric on 07/02/2020

% This file takes the long format files generated from the R code that are
% labeled "..._WithConditions_forDesignMatrices.csv" and spits out a .mat
% file for each participant for each MRI scanner run.

clc;
clear all;


%% Where do you want the design matrix onset files to go?
cd('/Users/Mohammed/Documents/StructureFunction/Code');

%% Pull data from the long text file created in R
Arithmetic_all = readtable('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/onsets/SF_arithmetic2_long_07_09_20_WithConditions_forOnsetFiles.csv');

identifier_all = unique(Arithmetic_all.Subject); % list of all subjects

% Subject-level loop
for a = 1:length(unique(Arithmetic_all.Subject))
    
    identifier = identifier_all(a); % which subject id?
    
    % Subject data
    subject_data = Arithmetic_all(Arithmetic_all.Subject==identifier, :);

    
    % Run-level loop
    for b = 1:length(unique(subject_data.run))
        
        % Run data
        run_data =  subject_data(subject_data.run==b, :);

        filename = [Arithmetic_all.Task{a, :} '_subject_' num2str(identifier) '_run_' num2str(run_data.run(1))];
   
        gap_time = run_data.StartFixation_OnsetTime(b); % time waiting for "s" press
        
 %   numconditions = length(unique(Arithmetic_all.condition))
        
        % Fill three variables with 3 columns

        % Initialize variables
        clear('durations');
        clear('names');
        clear('names1');
        clear('names2');
        clear('names3');
        clear('names4');
        clear('onsets');
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill conditions variable %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        names = {};
        
        % If there are no errors, there are only 3 conditions, no condition of "incorrect".
        if mean(run_data.Problem_ACC)== 1.0
            names = {'small', 'large', 'plus1'};
        end
        
        % If there is at least one correct "small" trial, make a condition for it. 
        if mean(run_data.Problem_ACC(run_data.condition == "small", :)) ~= 0;
            names1 = 'small';
        else names1 = {};
        end
        
        % If there is at least one correct "large" trial, make a condition for it. 
        if mean(run_data.Problem_ACC(run_data.condition == "large", :)) ~= 0;
            names2 = {names1, 'large'};
        else names2 = names1;
        end
        
        % If there is at least one correct "plus1" trial, make a condition for it. 
        if mean(run_data.Problem_ACC(run_data.condition == "plus1", :)) ~= 0;
            names3 = {names2{:}, 'plus1'};
        else names3 = names2;
        end
        
        % If there is at least one incorrect trial, make a condition for it.
        if mean(run_data.Problem_ACC) < 1.0;
            names4 = {names3{:}, 'incorrect'};
        else names4 = names3;
        end
        
        % If no error, choose "names" stays name, but if there is an error "names4" is written to "names".
        if isempty(names);
            names = names4;
        end
          
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% Fill Onsets variable %%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Fill onsets variable
        % Condition-level loop 
        for c = 1:length(unique(run_data.condition))
           
            %Condition data
            condition_data = run_data(strcmp(run_data.condition,names{1, c}), :);

            onsets{:, c} = [(condition_data.Problem_OnsetTime - gap_time)/1000]';
            
            % Set all corresponding durations to zero
            durations{:, c} = [zeros(length(condition_data.Problem_OnsetTime), 1)]';
            
        end
        
        
        save(filename,'names','onsets','durations');
        
    end
end



return;