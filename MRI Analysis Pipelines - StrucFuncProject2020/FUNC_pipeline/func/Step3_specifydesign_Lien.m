%-------------------------------------------------------------------------
% This function constructs a design matrix for each subject, saves it in
% a Subject specific directory, and then estimates the model. Should be 
% run after BatchPP and onsets have been extracted.
% -------------------------------------------------------------------------

function [] = Step3_for_odds()

clear;
curdir = pwd; % Run function in the directory that contains swf files

% --------------- %
% PART ONE: Setup %
% --------------- %


%% Define variables %

 
ROOTDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/Preprocessed_Files/'; % EDIT - folders MUST have the same number of volumes; eg., must be run seperatly for each task, can have more than one run within a task
DATADIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Data/Preprocessed_Files/'; % EDIT
ANDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Analysis/1stLevel/'; % EDIT
% OUTLIERDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_QC/art_outliers/';
 

ps = dir(strcat(ANDIR, 'Onsets'));
ps = {ps.name};
ps = ps(~ismember(ps, {'.', '..', '.DS_Store', 'DesignEstimate'}));


runs = dir(strcat(DATADIR,ps{1},'/func/'));% 
runs = {runs.name};
runs = runs(~ismember(runs, {'.', '..', '.DS_Store', 'Run3', 'Run4'})); % edit for runs

%% Create directories to store design matrices & save directory name. %

for i = 1:size(ps,2)
    if ~exist(strcat(ANDIR, 'DesignEstimate/', ps{i}),'dir') 
        mkdir(strcat(ANDIR, 'DesignEstimate/', ps{i}, runs)) %if doesn't work, due to permissions issues, just generate the files names by hand, or copy paste in the onsets folders and just removed the .mats using search in finder
    end
end

%%%%%%% fix the subfolder issue... %%%%%%%%%%%%%%%%%%
% subFolder = sprintf('pp%d', welke_pp);
% fullPath = fullfile(someRootFolder, subFolder);
% if ~exist(fullPath , 'dir')
%     % Folder does not exist so create it.
%     mkdir(fullPath );
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

design_dirs = cell(1,size(ps,2));

for i = 1:size(ps,2)
    design_dirs{1,i} = strcat(ANDIR, 'DesignEstimate/', ps{i}); 
end

%% Create lists of swr and rp files. These are the data that will be modelled  %

swffiles = cell(size(ps,2), size(runs,2)); % 4 functional runs, 1 structural

rp2files = cell(size(ps,2), size(runs,2)); 

for i = 1:size(ps,2)
    for j = 1:size(runs,2)
        count = 1;
        tmpfiles = dir(fullfile(DATADIR,ps{i},'func',runs{j}));
        tmpfiles = {tmpfiles.name};
        tmpfiles = tmpfiles(~ismember(tmpfiles,{'.','..','.DS_Store', '.Rapp.history'}));
        templist = cell(1,1);
        rplist = cell(1,1);
        outlielist = cell(1,1);
        for k = 1:size(tmpfiles,2)
            tmpfilename = tmpfiles{k};
            tmpstr = tmpfilename(1:3);
            tmpstrout = extractBetween(tmpfilename, 5, 31);
            tmptxt = tmpfilename(43:end);
            if strcmp(tmpstr, 'swa') %smoothed warsub
                templist{count,1} = fullfile(DATADIR,ps{i},'func',runs{j},strcat(tmpfilename, ',1'));
                count = count + 1;
            elseif strcmp(tmpstr, 'rp_')
                rplist{1,1} = fullfile(DATADIR,ps{i},'func',runs{j},tmpfilename);
            elseif strcmp(tmptxt, 'txt')
                outlielist{1,1} = fullfile(DATADIR,ps{i},'func',runs{j},strcat('art_regression_outliers_and_movement_au', tmpstrout, '_outlier_vector.txt'));
            elseif strcmp(tmptxt, '.txt')
                outlielist{1,1} = fullfile(DATADIR,ps{i},'func',runs{j},strcat('art_regression_outliers_and_movement_au', tmpstrout, '_outlier_vector.txt'));
            elseif strcmp(tmptxt, '.nii')
                outlielist{1,1} = fullfile(DATADIR,ps{i},'func',runs{j},strcat('art_regression_outliers_and_movement_au', tmpstrout, '_outlier_vector.txt'));
            end
        end
        swffiles{i,j} = templist;
        rp2files{i,j} = rplist;
        outliefiles{i,j} = [outlielist{:}];
        %rpfiles{i,j} = rplist;
        
    end  
end

rpxfiles = [rp2files, outliefiles];  %EDIT change location


%     MotionRX1 = rpxfiles{i,1};
%      art1 = rpxfiles{i,3};
%     MotionRX2 = rpxfiles{i,2};
%      art2 = rpxfiles {i,4};
%      
%      z = importdata(MotionRX2);
%      a = importdata(art2);
% rpfiles1 = [MotionRX1, art1];
% rpfiles2 = [MotionRX2, art2];
%         rpfiles1 = rpfiles1';
%         rpfiles2 = rpfiles2';

% 
% % art_regression_outliers_and_movement_ausub-01_task-dotmatrix_run-01_outlier_vector
% 


  
%% Create lists of files containing condition names, onsets, and durations %
% for each run.

condfiles = cell(size(ps,2),size(runs,2));

for i = 1:size(ps,2)
    tmpfiles = dir(fullfile(ANDIR,'Onsets',ps{i}));
    tmpfiles = {tmpfiles.name};
    tmpfiles = tmpfiles(~ismember(tmpfiles,{'.','..','.DS_Store'}));
    for j = 1:size(tmpfiles,2)
        condfiles{i,j} = strcat(ANDIR,'Onsets/',ps{i},'/', tmpfiles{j}); 
    end
end
        

%% Create list of design (SPM.mat) files used in model estimation. %

SPMFiles = cell(size(ps,2),1);

for i = 1:size(ps,2)
    tempdir = design_dirs{1,i};
    tempfile = 'SPM.mat';
    SPMFiles{i,1} = fullfile(tempdir, tempfile);
end
    

%%
% ----------------------------------------------- %
%  Define structures and pass to spmjobs          %
% ----------------------------------------------- %

% Create a structure to SPECIFIY the model. %

for i = 1:size(ps,2)
    
    a.DesignDir = design_dirs{1,i};
        
    a.ScansR1 = swffiles{i,1};
%     a.ScansR2 = swffiles{i,2};
%     a.ScansR3 = swffiles{i,3};
%     a.ScansR4 = swffiles{i,4};

        
    a.ConditionsR1 = {condfiles{i,1}};
%    a.ConditionsR2 = {condfiles{i,2}};
%    a.ConditionsR3 = {condfiles{i,3}};
%    a.ConditionsR4 = {condfiles{i,4}};




  %Motion1
  
      a.x = importdata(char(rpxfiles{i,1}));
         a.x1 = a.x(:,1);
         a.x2 = a.x(:,2);
         a.x3 = a.x(:,3);
         a.x4 = a.x(:,4);
         a.x5 = a.x(:,5);
         a.x6 = a.x(:,6);
     a.y = importdata(char(rpxfiles{i,2})); %%NOTE -  one of the subs is MISSING their file, and it breaks loop, FIND MISSING ART_OUTLIER.
         a.oa1 = a.y(:,1);
         
         
  %Motion2
  
%      a.q = importdata(char(rpxfiles{i,2}));
%          a.q1 = a.q(:,1);
%          a.q2 = a.q(:,2);
%          a.q3 = a.q(:,3);
%          a.q4 = a.q(:,4);
%          a.q5 = a.q(:,5);
%          a.q6 = a.q(:,6);
%      a.z = importdata(char(rpxfiles{i,4}));   %NOTE -  one of the subs is MISSING their file, and it breaks loop, FIND MISSING ART_OUTLIER.
%          a.oa2 = a.z(:,1);
%      
      
    matlabbatch = design_job(a);
         
    cd(a.DesignDir);
        try
            spm_jobman('initcfg')
            spm('defaults', 'FMRI');
            spm_jobman('serial', matlabbatch);
        catch
            cd(curdir);
            continue;
        end
        cd(curdir)                        
end

% Create a structure that is passed to SPM for model ESTIMATION. %


for i = 1:size(ps,2)
    
    b.DesignFile = SPMFiles{i,1};
    b.DesignDir = design_dirs{1,i};
    
    matlabbatch = estimate_job(b);
    cd(b.DesignDir)
    try
        spm_jobman('initcfg')
        spm('defaults', 'FMRI');
        spm_jobman('serial', matlabbatch);
    catch
        cd(curdir)
        continue;
    end
    cd(curdir)
        
end


% ------------------------------------------------- %
% PART THREE: SUBFUNCTIONS COPIED DIRECTLY FROM SPM %
% ------------------------------------------------- %


%%%%%%%%%%%%%%%%
% SUBFUNCTIONS %
%%%%%%%%%%%%%%%%

function [matlabbatch] = design_job(a)

matlabbatch{1}.spm.stats.fmri_spec.dir = {a.DesignDir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 35;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;

matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = a.ScansR1;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = a.ConditionsR1;  
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(1).name = 'M1';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(1).val = [a.x1];
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(2).name = 'M2';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(2).val = a.x2;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(3).name = 'M3';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(3).val = a.x3;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(4).name = 'M4';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(4).val = a.x4;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(5).name = 'M5';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(5).val = a.x5;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(6).name = 'M6';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(6).val = a.x6;  
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(7).name = 'OV7';
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress(7).val = a.oa1; 
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;



% matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = a.ScansR2;
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = a.ConditionsR2; 
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(1).name = 'M1';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(1).val = [a.q1];
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(2).name = 'M2';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(2).val = a.q2;
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(3).name = 'M3';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(3).val = a.q3;
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(4).name = 'M4';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(4).val = a.q4;
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(5).name = 'M5';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(5).val = a.q5;
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(6).name = 'M6';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(6).val = a.q6;  
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(7).name = 'OV7';
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress(7).val = a.oa2; 
% matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;




matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';

end

function [matlabbatch] = estimate_job(b)
    
matlabbatch{1}.spm.stats.fmri_est.spmmat = {b.DesignFile};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 1;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;


end

end
