
%% PURPOSE OF THIS SCRIPT %%
% Extracts number of outlying volumes per subject from ART toolbox output(via CONN)

%% BEFORE USING THIS SCRIPT %%
% Input into the ART function within CONN toolbox: unsmoothed functional
% volumes and rp_ files (after realignment)
% Output: art_regression_outliers_ files and art_movement_stats_ files, and
% art_regression_outliers_and_movement_ files

%% THIS SCRIPT %%
% input for this script: all art_regression_outliers_ files in a separate
% folder. DO A SEARCH FOR "change" to make changes for your files.


% Created by Darren Yeo on 3/20/2017, modified by Eric Wilkey 11/20/2017

%%
clear all;

% make a list of filenames
outlier_filenames = dir('*.mat');

% get number of files based on length of filenames
num = length(outlier_filenames);

% create a holding array for number of volumes
volumes = zeros(num,1);

% create a holding array for number of outlying volumes
outliers = zeros(num,1);

% create a holding array for filenames
filename = char.empty(num, 0);

% extract the number of outlying volumes from each file
for i = 1:num;
    load(outlier_filenames(i).name);
    outliers(i,1) = size(R,2);
end

% calculate total number of volumes
for i = 1:num;
    load(outlier_filenames(i).name);
    volumes(i,1) = size(R,1);
end

% calculate percentage of outlying volumes
outlier_percentage = outliers./volumes;


% write to text [CHANGE FILENAME ACCORDINGLY]
filename = ['SF_56subjects_106runs_outlier.txt'];
fid = fopen(filename, 'w');
    
fprintf(fid, 'filename\t outliers\t volumes\t percentage'); % label columns

fprintf(fid, '\r\n');

for i = 1:num;
    fprintf(fid, '%s', outlier_filenames(i).name);
    fprintf(fid, '\t');
    fprintf(fid, '%i', outliers(i));
    fprintf(fid, '\t');
    fprintf(fid, '%i', volumes(i));
    fprintf(fid, '\t');
    fprintf(fid, '%6.3f', outlier_percentage(i));
    fprintf(fid, '\r\n');
end    

fclose(fid);


%%%% OPTIONAL ORGANIZATION %%%%

% % 
% % % Add filenames to check for mistakes
% % 
% % % Here is an excel sheet with a column for each task. I take the filename and
% % % stack each subjects 6 columns onto one another to create on long file
% % % that corresponds to the above row/column structure.
% % 
% % [~,excelsheet] = xlsread('CNMofDD_filenames_rowpersubject_53_318.xlsx');
% % 
% % runs = {'Digits_A', 'Digits_B', 'Dots_A', 'Dots_B', 'Flanker_A', 'Flanker_B'};
% % tasks = {'Digits', 'Digits', 'Dots', 'Dots', 'Flanker', 'Flanker'};
% % 
% % % write to text
% % filename2 = ['CNMofDD_53subjects_318runs_additionalinfo.txt'];
% % fid = fopen(filename2, 'w');
% %     
% % fprintf(fid, 'subject\t filename_comp\t run\t task\t'); % label columns
% % 
% % fprintf(fid, '\r\n');
% % 
% % for subject = 1:53;
% %     for columns = 2:7;
% %         fprintf(fid, '%s', excelsheet{subject, 1});
% %         fprintf(fid, '\t');      
% %         fprintf(fid, '%s', excelsheet{subject, columns});
% %         fprintf(fid, '\t');
% %         fprintf(fid, '%s', runs{columns-1});
% %         fprintf(fid, '\t');
% %         fprintf(fid, '%s', tasks{columns-1});
% %         fprintf(fid, '\r\n');
% %     end
% % end  
% % 
% % fclose(fid);
% %     