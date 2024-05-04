function [] = BasicModel_Surf_standalone ()
 
clear, clc; warning off all
curdir = pwd; % Run function at top of directory structure
 
 
 
 
DATADIR = '/Users/Mohammed/Documents/Derivatives/StructureFunctionBids/'; %change to MacOSX file version;'
spmdir = 'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\'; %'
subjects=dir(DATADIR); %
subjects={subjects.name};
subjects=subjects(~ismember(subjects,{'.','..','.DS_Store'}));  % if it doesnt work then {'.', '..', '__MACOSX','.DS_Store'})); 
 
Dirs = {'surf'}; %change to mri or surf
 
 
% Create lists of files
 
files = cell(size(subjects,2),size(Dirs,2));
 
for i=1:size(subjects,2)
    for j=1:size(Dirs,2)
        
        temp_dir=fullfile(DATADIR,subjects{i},Dirs{j});
        temp_files=dir(temp_dir);
        temp_files={temp_files.name};
        temp_files=temp_files(~ismember(temp_files, {'.','..','.DS_Store'}));
       
    %temp_list = fullfile(DATADIR,subjects{i},Dirs{j},temp_files); %will return a cell array directly; perhaps faster than next 4 lines
 
        temp_list=cell(1,1);
        
        for k=1:size(temp_files,2)
           temp_list{1} = [temp_list{1}; {fullfile(DATADIR,subjects{i},Dirs{j},temp_files{1,k})}];
        end
            
        
        files{i,j} = temp_list;
 
 
    end
end
 
% Creats a strcuture c that passes variables to the DCM2nii SPM function
    
for i = 1:size(subjects,2)
  for j =1:size(Dirs,2)
            
            c.dataDir=fullfile(DATADIR,subjects{i},Dirs{j});
            c.outDir=fullfile(DATADIR,subjects{i},Dirs{j});
            c.files=files{i,j}{1};
 
            matlabbatch = spmdesign(c);
 
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
 
end
 
%%%Subfunction%%% 

 
function [matlabbatch]= spmdesign(c)
 
                matlabbatch{1}.spm.stats.factorial_design.dir =  {'/Users/Mohammed/Documents/Derivatives/'};   %'
                matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {c.files};
                matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
                matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
                matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
                matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
                matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
                matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
                matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
                matlabbatch{2}.spm.tools.cat.tools.check_SPM.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
                matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.use_unsmoothed_data = 1;
                matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.adjust_data = 1;
                matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_ortho = 1;
    %estimate design
       matlabbatch = {};
                    matlabbatch{1}.spm.tools.cat.stools.SPM.spmmat = {'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\Analysis\SPM.mat'};
    %ROI extraction
      % matlabbatch = {};
                    matlabbatch{1}.spm.tools.cat.stools.surf2roi.cdata = {
                                                      {
                                                      'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\sub-02\surf\lh.gyrification.resampled.sub-02.gii'
                                                      'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\sub-02\surf\lh.sqrtsulc.resampled.sub-02.gii'
                                                      'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\sub-02\surf\lh.thickness.resampled.sub-02.gii'
                                                      }
                                                      }';
    %'ROI volume estimatation
      % matlabbatch = {};
                    matlabbatch{1}.spm.tools.cat.tools.calcroi.roi_xml = {
                                                      'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\sub-02\label\catROI_sub-02.xml'
                                                      'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\SFAnsari\sub-02\label\catROIs_sub-02.xml'
                                                      };
                        matlabbatch{1}.spm.tools.cat.tools.calcroi.point = '.';
                        matlabbatch{1}.spm.tools.cat.tools.calcroi.outdir = {'C:\Users\M\Desktop\CAT_Pipeline\DATA\Derivatives\Analysis'};
                        matlabbatch{1}.spm.tools.cat.tools.calcroi.calcroi_name = 'ROI';
end
    

