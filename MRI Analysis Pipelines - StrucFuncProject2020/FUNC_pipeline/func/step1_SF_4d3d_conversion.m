function [] = step1_SF_4d3d_conversion()

clear;
curdir = pwd; 

%results in a folder, with the same name as the sub, will have anat and func in each sub folder, and under each run of the Func will have all the 3D files
%% Define variables %

DATADIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/4Dnii/';   %change DIR, 4D nii files here from bids
WRITEDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/3Dnii/';	     %change DIR; where data is sent == 'Preprocessed_Files'

subjects = cell(1,1);
 
subjects_list = dir(DATADIR);
subjects_list = {subjects_list.name};
subjects_list = subjects_list(~ismember(subjects_list,{'.','..', '.DS_Store'}));
for i = 1:size(subjects_list,2)
    count = 1;
    tempstr = subjects_list{i};            %bootstrapping from the BIDs folder, and then dropping fromthat list anyhting thats not sub
    tempstr = tempstr(1:3);
    if strcmp(tempstr,'sub')
        subjects{count,1} = subjects_list{i};
    end
end
        
   % I need this for mine
 
%% Create list of 4D files from nifti.
 
unzipfiles=cell(size(subjects,2),1);
files = cell(size(subjects,2),1);
run_counts = cell(size(subjects,2),1);
%runs_str = {'01','02','03','04','05','06','07','08','09','10'};
 
for i = 1:size(subjects,2)
    count = 1;
    temp_dir = strcat(DATADIR,subjects{i},'/func/');
    temp_files = dir(temp_dir);
    temp_files = {temp_files.name};
    temp_files = temp_files(~ismember(temp_files, {'.','..','.DS_Store'}));   
    for j = 1:size(temp_files,2)
        filestr = temp_files{j};
        filestr = filestr(end-10:end);
        if strcmp(filestr,'bold.nii.gz')                    % code for grabbing JUST the 4D files from the directory
            setstr = strcat(temp_dir,'/',temp_files{1,j});
            unzipfiles{i,count} = setstr;
            files{1,count} = strcat(setstr(1:end-3),',1');
            count = count + 1;
        end
    end
    run_counts{i,1} = count-1;
end

%% Create output directories for writing 3D data. %
output_dirs = cell(1,1);
 
 
for i = 1:size(subjects,2)
    nruns = run_counts{i,1};
    for j = 1:nruns
        temp_mkdir = strcat(WRITEDIR, num2str(subjects{i}), '/func/', 'Run', num2str(j), '/');
        if ~exist(temp_mkdir, 'dir')
            mkdir(temp_mkdir)
        end
        output_dirs{i,j} = temp_mkdir;                  %creates an output directory for each sub in directory
    end
end

% Unzip files %
 
for i = 1:size(subjects,2)
    for j = 1:run_counts{i,1}
        tempfile = unzipfiles{i,j};
        gunzip(tempfile)                        %unzips then resaves back into that directory
    end
end


%% Creates a strcuture 'a' that passes variables to CONVERSION subfunction below
 
 
for i = 1:size(subjects,2)
    nruns = run_counts{i,1};
    for j = 1:nruns
    
            a.curSubj = subjects{i};
            a.dataDir = strcat(DATADIR,a.curSubj,'/');
            a.files = files{i,j};               %where the 4D files are
            a.outputDir = output_dirs{i,j};
 
            matlabbatch = conversion_job(a);
 
            %run matlabbatch job
            cd(a.dataDir);
                try
                    spm_jobman('initcfg')
                    spm('defaults', 'FMRI');
                    spm_jobman('serial', matlabbatch);
                catch
                    cd(curdir);
                    continue;
                end
                cd(curdir);
    end    
end
end
    
 
%% SUBFUNCTION %
 
function [matlabbatch]=conversion_job(a)
 
matlabbatch{1}.spm.util.split.vol = {a.files};
matlabbatch{1}.spm.util.split.outdir = {a.outputDir};
 
end

