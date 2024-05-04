function [] = step2_BatchPP()
 
%preprocessing script

 
 
clear;
curdir = pwd; % Run function at top of directory structure
 
%% Define variables
ROOTDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/Preprocessed_Files/';  %folders with subject seperated 3D files from Step 1
FUNCDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/Preprocessed_Files/';    %folders with subject seperated 3D files from Step 1
ANATDIR = '/Users/Mohammed/Documents/StructureFunction/DATA/anats_only/';   %folder with T1w
WRITEDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/Preprocessed_Files/'; %folders with subject seperated 3D files from Step 1
 
 
%% Bootstraps from the sturcute of the dataset to come up with a list of subs and runs %%
subjects = dir(ROOTDIR);
subjects = {subjects.name};
subjects = subjects(~ismember(subjects, {'.','..','.DS_Store'}));       
 
 
 
runs = dir(strcat(FUNCDIR,subjects{1},'/func/'));
runs = {runs.name};
runs = runs(~ismember(runs, {'.','..','.DS_Store', 'Run1', 'Run2', 'Run3'}));  %you can run all Runs at once, IFF they all have the same number of runs, otherwise, can't


%% List all files in file directories %
 
raw_files_func = cell(size(subjects,1),size(runs,2)); 
raw_files_anat = cell(size(subjects,2),1);
 
 
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
        
        ffiles = dir(fullfile(ROOTDIR,subjects{i},'func',runs{j}));
        ffiles = {ffiles.name};
        ffiles = ffiles(~ismember(ffiles,{'.','..', '.DS_Store'}))'; %'
        raw_files_func{i,j} = ffiles;
    end
end
 
for i = 1:size(subjects,2)
    
    count_a=1;
    anatfiles = dir(fullfile(ANATDIR,subjects{i},'anat'));
    anatfiles = {anatfiles.name};
    anatfiles = anatfiles(~ismember(anatfiles,{'.','..', '.DS_Store'}));
    for j = 1:size(anatfiles,2)
        
        tempfile = anatfiles{1,j};
        tempstr = tempfile(end-9:end);
        if strcmp(tempstr, 'T1w.nii.gz')            
            raw_files_anat{i,count_a} = tempfile;
            
            count_a = count_a+1;
        end
    end
end
    
%% Move and unzip the anatomical
 
for i = 1:size(subjects,2)
    anat_dir = strcat(ROOTDIR,subjects{i},'/anat/');
    if ~exist(anat_dir,'dir')
        mkdir(anat_dir)
    end
    source = strcat(ANATDIR,subjects{i},'/anat/',raw_files_anat{i,1});
    destination = strcat(anat_dir,raw_files_anat{i,1});
    copyfile(source,destination)
    gunzip(destination)
    tempstr = raw_files_anat{i,1};
    raw_files_anat{i,1} = tempstr(1:end-3);
end


%% Create lists of files and filepaths for pre-processing output %%
 
files = cell(size(subjects,2),size(runs,2),7);

 
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
        
        
        ffiles_temp = cell2mat(raw_files_func{i,j}); % Read data in
        
        raw_files = cell(1,1); % temp storage    
        realigned_files = cell(1,1); % temp storage 
        warped_files = cell(1,1); % temp storage 
        
        for k = 1:size(ffiles_temp,1)
            
            raw = fullfile(WRITEDIR,subjects{i},'func',runs{j},ffiles_temp(k,:));
            raw_files{k,1} = strcat(raw,',1');
            
            realign_f = strcat('r', ffiles_temp(k,:));
            realigned_files{k,1} = strcat(WRITEDIR,subjects{i},'/func/',runs{j},'/',realign_f,',1'); 

            slice_time = strcat('ar', ffiles_temp(k,:));
            ST_realigned_files{k,1} = strcat(WRITEDIR,subjects{i},'/func/',runs{j},'/',slice_time,',1'); 
            
            warp_f = strcat('war', ffiles_temp(k,:));
            warped_files{k,1} = strcat(WRITEDIR,subjects{i},'/func/',runs{j},'/',warp_f,',1');
            
        end
        
        anat_temp = char(raw_files_anat{i,1}); %
        anat_temp_r = strcat('r',anat_temp);
        param_temp = strcat('r',anat_temp(1:end-4),'_sn.mat');
        
        anat_temp = strcat(WRITEDIR,subjects{i},'/anat/',anat_temp);            %need to know location of anatomicals'
        anat_temp_r = strcat(WRITEDIR,subjects{i},'/anat/',anat_temp_r);
        param_temp = strcat(WRITEDIR,subjects{i},'/anat/',param_temp);              %this is the warping parameters; to warp the struc to stereotaxic space'
        
        files{i,j,1} = raw_files;
        files{i,j,2} = realigned_files;
        files{i,j,3} = ST_realigned_files;
        files{i,j,4} = warped_files;
        
        files{i,j,5} = anat_temp;
        files{i,j,6} = anat_temp_r;
        files{i,j,7} = param_temp;                          %this is the warping parameters
        
        mean_temp = raw_files_func{i,j}{1};
        mean_temp = strcat('mean',mean_temp(1,:));
        
        files{i,j,8} = strcat(WRITEDIR,subjects{i},'/func/',runs{j},'/',mean_temp);             %need to know location of functionals
        
    end
end
        
%% MOTION CORRECTION -- 
% Creates a strcuture b that passes variables to MOCO function
    
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
            
            b.curSubj = subjects{i};
            b.dataDir = fullfile(ROOTDIR,b.curSubj,'func',runs{j});
            b.runs = runs{j};
            b.anatDir = fullfile(ANATDIR,subjects{i},'anat');
            b.files = files{i,j,1};
            
            matlabbatch = moco_job(b);
 
            %run matlabbatch job
            cd(b.dataDir);
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
%% Slice Time Correction Creates a strcuture b that passes variables to Slicetime function
    
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
            
        m.curSubj = subjects{i};
        m.dataDir = fullfile(ROOTDIR,m.curSubj,'func',runs{j});
        m.files = files{i,j,2};
        
           matlabbatch = slicetime(m);
            %run matlabbatch job
            cd(m.dataDir);
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
%% COREGISTRATION -- 
% Creates a strcuture C that passes variables to Coregistration function
 
    
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
        
        c.curSubj = subjects{i};
        c.dataDir = fullfile(ROOTDIR,c.curSubj,'func',runs{j});
        c.ref = files{i,j,8}; %files{i,j,7}
        c.source = raw_files_anat{i,1};
        c.source = fullfile(ROOTDIR,subjects{i},'anat',c.source);
        c.source = strcat(c.source,',1');
 
            matlabbatch = coreg_job(c);
 
            %run matlabbatch job
            cd(c.dataDir);
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
 
%% SPATIAL NORMALIZATON -- 
% % Creates a structure d that passes variables to a warping function
% 
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
        
        d.curSubj = subjects{i};
        d.dataDir = fullfile(ROOTDIR,d.curSubj,'func',runs{j});
        d.files = files{i,j,3};   
        d.paramfile = files{i,j,7}; % files{i,j,6}
        d.source = files{i,j,5}; % raw anatomical files{i,j,4}
        d.source = strcat(d.source,',1');
 
            matlabbatch = warp_job(d);
 
            %run matlabbatch job
            cd(d.dataDir);
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
 
%% SPATIAL SMOOTHING -- 
% % Creates a structure e that passes variables to a smoothing function
% 
for i = 1:size(subjects,2)
    for j = 1:size(runs,2)
        
        e.curSubj = subjects{i};
        e.dataDir = strcat(ROOTDIR,e.curSubj,'/func/',runs{j});
        e.files = files{i,j,4}; %files{i,j,3}
        
            matlabbatch = smooth_job(e);
 
            %run matlabbatch job
            cd(e.dataDir);
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
 
% 
% 
 
%%
%%%%%%%%%%%%%%%%
% SUBFUNCTIONS %
%%%%%%%%%%%%%%%%

function [matlabbatch] = moco_job(b)
 
matlabbatch{1}.spm.spatial.realign.estwrite.data = {b.FuFunc};
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
 
end
 
function [matlabbatch] = slicetime(m)
matlabbatch{1}.spm.temporal.st.scans = {m.files};
matlabbatch{1}.spm.temporal.st.nslices = 35;
matlabbatch{1}.spm.temporal.st.tr = 2;
matlabbatch{1}.spm.temporal.st.ta = 1.94285714285714;
matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34];
matlabbatch{1}.spm.temporal.st.refslice = 1;
matlabbatch{1}.spm.temporal.st.prefix = 'a';


end


function [matlabbatch] = coreg_job(c)
 
matlabbatch{1}.spm.spatial.coreg.estimate.ref = {c.ref}; %mean
matlabbatch{1}.spm.spatial.coreg.estimate.source = {c.source}; %anat
matlabbatch{1}.spm.spatial.coreg.estimate.other = {''}; %leave empty 
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
 
end
 
 
function [matlabbatch] = warp_job(d)
 
 
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.vol = {d.source};
matlabbatch{1}.spm.spatial.normalise.estwrite.subj.resample = d.files;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.biasfwhm = 60;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.tpm = {'/Users/Mohammed/Desktop/spm12/tpm/TPM.nii'};
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.affreg = 'mni';
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.reg = [0 0.001 0.5 0.05 0.2];
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.fwhm = 0;
matlabbatch{1}.spm.spatial.normalise.estwrite.eoptions.samp = 3;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.bb = [-90 -126 -72
                                                          90 90 108];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.interp = 4;
matlabbatch{1}.spm.spatial.normalise.estwrite.woptions.prefix = 'w';
end
 
 
function [matlabbatch] = smooth_job(e)
 
matlabbatch{1}.spm.spatial.smooth.data = e.files;
matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{1}.spm.spatial.smooth.dtype = 0;
matlabbatch{1}.spm.spatial.smooth.im = 0;
matlabbatch{1}.spm.spatial.smooth.prefix = 's';
 
 
end
 
end
