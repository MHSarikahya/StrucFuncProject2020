function CAT12subfunc_fixed(sub_raw, xsub, targetdir, reproc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CAT12 segmentation; surface param; and other stuff - does      %
%       everything up to the basic model (under construction)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks if T1w exists in the called folder; starts if yes, aborts, otherwise%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(sub_raw,'file')

% --- how many subjects are processed in parallel [in window = 0 ] --
jobs  = 2;    %  a job will use min 4 cores for i.e. denoising; default is 0
cores  = 0;   %  1 if multiple subjects are processed - but for FD not needed otherwise
vbmFWHM = [5 8]; % smoothing of volume 5,8 is defualt
FD      = 0; % keep off, its Fractal Dimension
thkFWHM = [0 8]; %smoothing of CT, 8mm works, but 15 is default
srfFWHM = [0 8]; %smoothing of extra surface parameters; 25 is default


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sends files for segmentation (calls Cat_Segment_Fixed.m)%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def = fullfile(spm_file(which('CAT12subfunc_Slow'), 'path'), 'Cat_Segment_Slow'); %fix
try global cat; if cat.extopts.expertgui == 0; spm fmri; cat12(def); end
catch;  spm fmri; cat12(def); end

sub_nii  = fullfile(targetdir, [xsub '.nii']);          %T1 file


if  reproc == 1                                         %deletes rawdata if on, to save space on iMac
    try rmdir(targetdir,'s'); end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts .nii into the bootstrapped data dir%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(sub_nii,'file')
    mkdir(targetdir);
        if strcmp(spm_file(sub_raw,'ext'),'gz')
            copyfile(sub_raw, fullfile(targetdir, [xsub '.nii.gz']));
            gunzip(fullfile(targetdir, [xsub '.nii.gz']));
            delete(fullfile(targetdir, [xsub '.nii.gz']));
        elseif strcmp(spm_file(sub_raw,'ext'),'nii')
            copyfile(sub_raw, sub_nii);
        else
            return
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Setting some variables for proc in segmentation%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    V = spm_vol(sub_nii);
    com_reference = [0 -20 -15];    
    Affine = eye(4);
    vol = spm_read_vols(V)
    avg = mean(vol(:));                                 %DONT EDIT ANY OF THESE
    avg = mean(vol(vol>avg));
    [x,y,z] = ind2sub(size(vol),find(vol>avg));
    com = V.mat(1:3,:)*[mean(x) mean(y) mean(z) 1]';
    com = com';
    M = spm_get_space(V.fname);
    Affine(1:3,4) = (com - com_reference);
    spm_get_space(V.fname,Affine\M);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DARTEL/SHOOT normalization%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist(fullfile(targetdir, 'mri', ['m0wp1' xsub '.nii']), 'file') || reproc == 1
    matlabbatch = {};
    matlabbatch{1}.spm.tools.cat.estwrite.nproc = jobs;
    % data to process
    matlabbatch{1}.spm.tools.cat.estwrite.data{1} = [sub_nii ',1'];
    % run things
    spm_jobman('run', matlabbatch)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Smooth modulated gray & white matter segments%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(fullfile(targetdir, 'mri', ['s' num2str(vbmFWHM(1)) 'm0wp1' xsub '.nii']),'file') ...
        || reproc == 1
    matlabbatch = {};
    matlabbatch{1}.spm.spatial.smooth.data = {
                               fullfile(targetdir, 'mri', ['mwp1' xsub '.nii'])
                               fullfile(targetdir, 'mri', ['m0wp1' xsub '.nii'])};
    for i = 1:numel(vbmFWHM)
        matlabbatch{1}.spm.spatial.smooth.fwhm = [vbmFWHM(i) vbmFWHM(i) vbmFWHM(i)];
        matlabbatch{1}.spm.spatial.smooth.prefix = ['s' num2str(vbmFWHM(i))];
        spm_jobman('run', matlabbatch)
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate GM, WM, CSF, and WMH + TIV%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (~exist(fullfile(targetdir, ['TIV_' xsub '.txt']),'file') || reproc == 1) && ...
  exist(fullfile(targetdir, 'report', ['cat_' xsub '.xml']), 'file');   % only with existing 'report/cat_subj.mat'
    matlabbatch = {};
    matlabbatch{1}.spm.tools.cat.tools.calcvol.data_xml = ...
    {fullfile(targetdir, 'report', ['cat_' xsub '.xml'])};
    matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_TIV = 1;     %make it 0 just for TIV; but we want it to write all QC vals
    matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_name = [ 'TIV_' xsub '.txt'];
    spm_jobman('run', matlabbatch);
    movefile(fullfile(pwd, ['TIV_' xsub '.txt']), fullfile(targetdir, ['TIV_' xsub '.txt']))    
end
fprintf('Segmentation and QC done, control C out');
pause
if exist(fullfile(targetdir, 'surf', ['lh.central.' xsub '.gii']),'file')
    if ~exist(fullfile(targetdir, 'surf', ['rh.sqrtsulc.' xsub]),'file') || reproc == 1
        matlabbatch = {};
        matlabbatch{1}.spm.tools.cat.stools.surfextract.data_surf = {
                                fullfile(targetdir, 'surf', ['lh.central.' xsub '.gii'])};
        matlabbatch{1}.spm.tools.cat.stools.surfextract.GI = 1;
        matlabbatch{1}.spm.tools.cat.stools.surfextract.FD = FD;
        matlabbatch{1}.spm.tools.cat.stools.surfextract.SD = 1;
        matlabbatch{1}.spm.tools.cat.stools.surfextract.nproc = cores;
        spm_jobman('run', matlabbatch)
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%
%Resample and smooth   %
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%
    if ~exist(fullfile(targetdir, 'surf', ['s' num2str(thkFWHM(1)) '.rh.thickness.resampled.' xsub '.gii']),'file') ...
            || reproc == 1
        matlabbatch = {};
        matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = {
                                fullfile(targetdir, 'surf', ['lh.thickness.' xsub])};
        matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = cores;
        for i = 1:numel(thkFWHM)
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = thkFWHM(i);
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 0;
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
            spm_jobman('run', matlabbatch)
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
            spm_jobman('run', matlabbatch)
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Resample and smooth GI and SD%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if ~exist(fullfile(targetdir, 'surf', ['s' num2str(srfFWHM(1)) '.rh.sqrtsulc.resampled.' xsub '.gii']),'file') ...
            || reproc == 1
        matlabbatch = {};
        if FD == 0
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = {
                                    fullfile(targetdir, 'surf', ['lh.gyrification.' xsub])
                                    fullfile(targetdir, 'surf', ['lh.sqrtsulc.' xsub])};
        else
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.data_surf = {
                                    fullfile(targetdir, 'surf', ['lh.gyrification.' xsub])
                                    fullfile(targetdir, 'surf', ['lh.sqrtsulc.' xsub])
                                    fullfile(targetdir, 'surf', ['lh.fractaldimension.' xsub])};    %this is only if FD exisits
        end
        matlabbatch{1}.spm.tools.cat.stools.surfresamp.nproc = cores;
        for i = 1:numel(srfFWHM)
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.fwhm_surf = srfFWHM(i);
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 0;
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 0;
            spm_jobman('run', matlabbatch)
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.merge_hemi = 1;
            matlabbatch{1}.spm.tools.cat.stools.surfresamp.mesh32k = 1;
            spm_jobman('run', matlabbatch)
        end
    end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Basic model - under construction %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       if ~exist(fullfile(targetdir, 'surf', ['s' num2str(srfFWHM(1)) '.mesh.thickness.resampled.' xsub '.gii']),'file') ...
%            || reproc == 1
%        matlabbatch = {};
%        if FD == 0
%            
%            matlabbatch{1}.spm.stats.factorial_design.dir = {'C:\Users\M\Desktop\SPM_folder\'}; %fix this
%            matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = {
%                                    fullfile(targetdir, 'surf', ['s25.mesh.gyrification.resampled' xsub]) 
%                                    fullfile(targetdir, 'surf', ['s8.mesh.thickness.resampled.' xsub])
%                                    fullfile(targetdir, 'surf', ['s25.mesh.sqrtsulc.resampled.' xsub])};
%        end
%        for i = 1:numel(srfFWHM)
%            matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
%            matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
%            matlabbatch{1}.spm.stats.factorial_design.masking.tm.tma.athresh = 100;
%            matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
%            matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
%            matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
%            matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
%            matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
%            matlabbatch{2}.spm.tools.cat.tools.check_SPM.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%            matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.use_unsmoothed_data = 1;
%            matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_cov.do_check_cov.adjust_data = 1;
%            matlabbatch{2}.spm.tools.cat.tools.check_SPM.check_SPM_ortho = 1;
%            spm_jobman('run', matlabbatch)
%        end
%    end    
    
    
    
end
end
end
