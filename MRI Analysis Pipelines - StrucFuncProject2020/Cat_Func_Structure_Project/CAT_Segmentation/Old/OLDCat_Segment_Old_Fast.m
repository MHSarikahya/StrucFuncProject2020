function Cat_Segment_Fixed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentation.m code, with some possible edits                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('cat','var'), clear cat; end
global cat

%SEGMENTATION%
cat.opts.tpm       = {fullfile(spm('dir'),'tpm','TPM.nii')};
cat.opts.ngaus     = [1 1 2 3 4 2];           % Gaussians per class #Dont touch
cat.opts.affreg    = 'mni';                   % Affine regularisation #Edit: mni; eastern; subj; none; rigid
cat.opts.warpreg   = [0 0.001 0.5 0.05 0.2];  % Warping regularisation #Dont touch
cat.opts.tol       = 1e-4;                    % SPM preprocessing accuracy #Edit: 1e-2 bad accuract but fast; 1e-4 is the def; and 1e-6 is the best but slow - maybe turn it on tho for iMAC
cat.opts.accstr    = 1;                     % SPM preprocessing accuracy #Edit: 0 very low accuracy (fast); 1 very high accuracy (slow); value is continuous tho
cat.opts.biasstr   = 0.5;                     % Strength of the bias correction that controls the biasreg and biasfwhm parameter #Edit: 0 - use SPM parameter; eps - ultralight, 0.25, 0.5, 0.75, and 1 - heavy corrections
cat.opts.biasreg   = 0.001;                   % Bias regularisation #Edit: can edit but no reason to; but smaller values have stronger bias fields
cat.opts.biasfwhm  = 60;                      % Bias FWHM #Edit: Can edit (30:10:120,inf); lower vals stronger bias fields, but sometimes problem if low
cat.opts.samp      = 1.5;                     % Sampling distance #Dont touch
cat.opts.redspmres = 0.0;                     % Image resolution #Edit: no need to? (default: 1.0)

% Extraction parameters %
cat.output.surface     = 1;     % GI/SD/and CT extraction: 0-just lh; 1-lh+rh; more vals but not relevant; lh=left hemisphere; rh=right hemisphere
cat.output.ROI         = 1;     % write xml-file w/ ROI data
cat.output.bias.native = 1;
cat.output.bias.warped = 1;
cat.output.bias.dartel = 0;
cat.output.las.native = 1;
cat.output.las.warped = 1;
cat.output.las.dartel = 2;
cat.output.GM.native  = 1;
cat.output.GM.warped  = 1;
cat.output.GM.mod     = 1;
cat.output.GM.dartel  = 2;
cat.output.WM.native  = 1;
cat.output.WM.warped  = 1;
cat.output.WM.mod     = 1;
cat.output.WM.dartel  = 2;
cat.output.CSF.native = 1;
cat.output.CSF.warped = 1;
cat.output.CSF.mod    = 1;
cat.output.CSF.dartel = 2;
cat.output.WMH.native  = 0;
cat.output.WMH.warped  = 0;     %keep off; dont work? No need either
cat.output.WMH.mod     = 0;		
cat.output.WMH.dartel  = 0;
cat.output.SL.native  = 0;
cat.output.SL.warped  = 0;
cat.output.SL.mod     = 0;
cat.output.SL.dartel  = 0;

% labels: default/background=0, CSF=1, GM=2, WM=3 #unsure if we need to change, but double check
cat.output.label.native = 1;
cat.output.label.warped = 1;
cat.output.label.dartel = 2;

% cortical thickness? (apparently experimental; but CT is extracted earlier??)
cat.output.ct.native = 0;
cat.output.ct.warped = 0;
cat.output.ct.dartel = 0;

% More options
cat.output.jacobian.warped = 1;     % #Edit: dont change
cat.output.warps        = [1 1];    % #Edit: dont change
cat.extopts.gcutstr      = 2;       % Strength of skull-stripping:               0 - SPM approach; eps to 1  - gcut; 2 - new APRG approach; -1 - no skull-stripping (already skull-stripped); default = 2
cat.extopts.cleanupstr   = 0.5;     % Strength of the cleanup process:           0 to 1; default 0.5
cat.extopts.spm_kamap    = 0;       % Replace initial SPM by k-means AMAP segm.  0 - Unified Segmentation, 2 - k-means AMAP
cat.extopts.NCstr        = 1;       % Strength of the noise correction:          0 to 1; 0 - no filter, -Inf - auto, 1 - full, 2 - ISARNLM (else SANLM), default -Inf
cat.extopts.LASstr       = 0.5;     % Strength of the local adaption:            0 to 1; default 0.5
cat.extopts.BVCstr       = 0.5;     % Strength of the Blood Vessel Correction:   0 to 1; default 0.5
cat.extopts.regstr       = [1 0];   % Strength of Shooting registration:         0 - Dartel, eps (fast), 0.5 (default) to 1 (accurate) optimized Shooting, 4 - default Shooting; default 0
cat.extopts.WMHC         = 1;       % Correction of WM hyperintensities:         0 - no correction, 1 - only for Dartel/Shooting; 2 - also correct segmentation (to WM), 3 - handle as separate class; default 1
cat.extopts.WMHCstr      = 0.5;     % Strength of WM hyperintensity correction:  0 to 1; default 0.5
cat.extopts.SLC          = 0;       % #Edit: dont change
cat.extopts.mrf          = 1;       % #Edit: dont change
cat.extopts.INV          = 1;       % % #Edit: maybe use? It inverts PD/T2 images for preprocessing: 0 - no processing, 1 - try intensity inversion, 2 - synthesize T1 image; default 1
cat.extopts.restype      = 'fixed';      % resolution: 'native','fixed','best'
cat.extopts.resval       = [1.0 0.10];   % #Edit: dont edit

% registration and normalization options%
cat.extopts.species      = 'human'; % #Edit: dont change
cat.extopts.APP          = 1070;  % #Edit: dont change?; but 0 - none; 1070 - default; 1 - light; 2 - full; 3 - strong; 4 - heavy
cat.extopts.vox          = 1;   % voxel size for normalized data (EXPERIMENTAL:  inf - use Tempate values)
cat.extopts.darteltpm    = {fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','Template_1_IXI555_MNI152.nii')};
cat.extopts.shootingtpm  = {fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','Template_0_IXI555_MNI152_GS.nii')};
cat.extopts.cat12atlas   = {fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','cat.nii')};
cat.extopts.brainmask    = {fullfile(spm('Dir'),'toolbox','FieldMap','brainmask.nii')};
cat.extopts.T1           = {fullfile(spm('Dir'),'toolbox','FieldMap','T1.nii')};

% surface options%
cat.extopts.pbtres         = 0.5;   % internal resolution for thickness estimation in mm (default 0.5)
cat.extopts.close_parahipp = 0;     % some holes appear in PHC gyrus; but ruins topology if on; negligible change
cat.extopts.scale_cortex   = 0.7;   % just dont edit
cat.extopts.add_parahipp   = 0.1;   % just dont edit; if problems appear/doesnt run, then change to 0.15

% visualisation options%
cat.extopts.colormap     = 'BCGWHw'; % Colour map selection
cat.extopts.verb         = 2;     % just dont edit
cat.extopts.ignoreErrors = 0;     % just dont edit
cat.extopts.expertgui    = 1;     % just dont edit
cat.extopts.subfolders   = 1;     % just dont edit
cat.extopts.experimental = 0;     % just dont edit
cat.extopts.print        = 0;     % just dont edit


% ROI stuff
%===================%
% ROI maps from different sources mapped to Dartel CAT-space of IXI-template

cat.extopts.atlas       = { ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','neuromorphometrics.nii')  0      {'csf','gm'}        1; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','lpba40.nii')              0      {'gm'}              1; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','cobra.nii')               0      {'gm','wm'}         1; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','hammers.nii')             0      {'csf','gm','wm'}   1; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','ibsr.nii')                1      {'csf','gm'}        0; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','aal.nii')                 1      {'gm'}              0; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','mori.nii')                1      {'gm','wm'}         1; ...
  fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','anatomy.nii')             1      {'gm','wm'}         1; ...
};

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dont change any of these; these must remain the same as copied in from the cat12 matlab.m code      %                                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for custom TPMs?
cat.output.TPMC.native = 0;
cat.output.TPMC.warped = 0;
cat.output.TPMC.mod    = 0;
cat.output.TPMC.dartel = 0;

% atlas maps 
cat.output.atlas.native = 0;
cat.output.atlas.warped = 0;
cat.output.atlas.dartel = 0;

% IDs of the ROIs 
cat.extopts.LAB.NB =  0; 
cat.extopts.LAB.CT =  1; 
cat.extopts.LAB.CB =  3; 
cat.extopts.LAB.BG =  5; 
cat.extopts.LAB.BV =  7; 
cat.extopts.LAB.TH =  9; 
cat.extopts.LAB.ON = 11; 
cat.extopts.LAB.MB = 13; 
cat.extopts.LAB.BS = 13; 
cat.extopts.LAB.VT = 15; 
cat.extopts.LAB.NV = 17; 
cat.extopts.LAB.HC = 19; 
cat.extopts.LAB.HD = 21; 
cat.extopts.LAB.HI = 23; 
cat.extopts.LAB.PH = 25; 
cat.extopts.LAB.LE = 27; 