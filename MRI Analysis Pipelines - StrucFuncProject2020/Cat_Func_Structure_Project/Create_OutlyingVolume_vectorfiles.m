%% CREATE VECTOR WITH OUTLYING VOLUMES BASED ON CONN TOOLBOX

%% navigate to folder with all the .mat files from CONN in sidebar first

clear all;

cd('/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_QC/art_outliers/outliers_and_movement')

% make a list of filenames
outlier_filenames = dir('*.mat');

% get number of files based on length of filenames
num = length(outlier_filenames);

for i=1:num

    %% load file
    load(outlier_filenames(i).name);
    
    %% delete final 7 columns from the file (not problematic volumes but overall motion parameters)
    A = size(R);
    R(:,(A(2)-6):A(2)) = [];

    %% create a single column vector with values
    vols = sum(R,2);

    %% save volumes to problematicvolumes.txt
    filename_new = outlier_filenames(i).name(1:end-9);
    dlmwrite([filename_new '_outlier_vector' '.txt'], vols);

end