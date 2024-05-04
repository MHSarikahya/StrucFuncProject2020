if exist('spmx','var'), clear spmx; end
global spmx
 
spmx.tools.cat.estwrite.nproc = 2;
spmx.tools.cat.estwrite.opts.tpm = {'C:\Users\M\Desktop\AnsariEricLab\spm12\spm12\tpm\TPM.nii'};
spmx.tools.cat.estwrite.opts.affreg = 'mni';
spmx.tools.cat.estwrite.opts.biasstr = 0.5;
spmx.tools.cat.estwrite.opts.accstr = 0.5;
spmx.tools.cat.estwrite.extopts.segmentation.APP = 1070;
spmx.tools.cat.estwrite.extopts.segmentation.NCstr = -Inf;
spmx.tools.cat.estwrite.extopts.segmentation.LASstr = 0.5;
spmx.tools.cat.estwrite.extopts.segmentation.gcutstr = 2;
spmx.tools.cat.estwrite.extopts.segmentation.cleanupstr = 0.5;
spmx.tools.cat.estwrite.extopts.segmentation.WMHC = 1;
spmx.tools.cat.estwrite.extopts.segmentation.SLC = 0;
spmx.tools.cat.estwrite.extopts.segmentation.restypes.fixed = [1 0.1];
spmx.tools.cat.estwrite.extopts.registration.dartel.darteltpm = {'C:\Users\M\Desktop\AnsariEricLab\spm12\spm12\toolbox\cat12\templates_1.50mm\Template_1_IXI555_MNI152.nii'};
spmx.tools.cat.estwrite.extopts.vox = 1.5;
spmx.tools.cat.estwrite.extopts.surface.pbtres = 0.5;
spmx.tools.cat.estwrite.extopts.surface.scale_cortex = 0.7;
spmx.tools.cat.estwrite.extopts.surface.add_parahipp = 0.1;
spmx.tools.cat.estwrite.extopts.surface.close_parahipp = 0;
spmx.tools.cat.estwrite.extopts.admin.ignoreErrors = 0;
spmx.tools.cat.estwrite.extopts.admin.verb = 2;
spmx.tools.cat.estwrite.extopts.admin.print = 2;
spmx.tools.cat.estwrite.output.surface = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.cobra = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.hammers = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.ibsr = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.aal = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.mori = 1;
spmx.tools.cat.estwrite.output.ROImenu.atlases.anatomy = 1;
spmx.tools.cat.estwrite.output.GM.native = 1;
spmx.tools.cat.estwrite.output.GM.warped = 1;
spmx.tools.cat.estwrite.output.GM.mod = 1;
spmx.tools.cat.estwrite.output.GM.dartel = 2;
spmx.tools.cat.estwrite.output.WM.native = 0;
spmx.tools.cat.estwrite.output.WM.warped = 0;
spmx.tools.cat.estwrite.output.WM.mod = 1;
spmx.tools.cat.estwrite.output.WM.dartel = 0;
spmx.tools.cat.estwrite.output.CSF.native = 0;
spmx.tools.cat.estwrite.output.CSF.warped = 0;
spmx.tools.cat.estwrite.output.CSF.mod = 0;
spmx.tools.cat.estwrite.output.CSF.dartel = 0;
spmx.tools.cat.estwrite.output.WMH.native = 0;
spmx.tools.cat.estwrite.output.WMH.warped = 0;
spmx.tools.cat.estwrite.output.WMH.mod = 0;
spmx.tools.cat.estwrite.output.WMH.dartel = 0;
spmx.tools.cat.estwrite.output.SL.native = 0;
spmx.tools.cat.estwrite.output.SL.warped = 0;
spmx.tools.cat.estwrite.output.SL.mod = 0;
spmx.tools.cat.estwrite.output.SL.dartel = 0;
spmx.tools.cat.estwrite.output.atlas.native = 0;
spmx.tools.cat.estwrite.output.atlas.dartel = 0;
spmx.tools.cat.estwrite.output.label.native = 1;
spmx.tools.cat.estwrite.output.label.warped = 0;
spmx.tools.cat.estwrite.output.label.dartel = 0;
spmx.tools.cat.estwrite.output.bias.native = 0;
spmx.tools.cat.estwrite.output.bias.warped = 1;
spmx.tools.cat.estwrite.output.bias.dartel = 0;
spmx.tools.cat.estwrite.output.las.native = 0;
spmx.tools.cat.estwrite.output.las.warped = 0;
spmx.tools.cat.estwrite.output.las.dartel = 0;
spmx.tools.cat.estwrite.output.jacobianwarped = 1;
spmx.tools.cat.estwrite.output.warps = [0 0];

 Cat_Segment_Fixed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentation.m code, with some possible edits                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('cat','var'), clear cat; end
global cat

%SEGMENTATION%
cat.opts.tpm       = {fullfile(spm('dir'),'tpm','TPM.nii')};
cat.opts.ngaus     = [1 1 2 3 4 2];           % Gaussians per class #Dont touch
cat.opts.affreg    = 'mni';                   % Affine regularisation #Edit: mni; eastern; subj; none; rigid
cat.opts.accstr    = 1;                     % SPM preprocessing accuracy #Edit: 0 very low accuracy (fast); 1 very high accuracy (slow); value is continuous tho
cat.opts.biasstr   = 0.5;                     % Strength of the bias correction that controls the biasreg and biasfwhm parameter #Edit: 0 - use SPM parameter; eps - ultralight, 0.25, 0.5, 0.75, and 1 - heavy corrections

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
% More options
cat.output.jacobian.warped = 0;     % #Edit: dont change
cat.output.warps        = [0 0];    % #Edit: dont change
cat.extopts.segmentation.gcutstr = 2;       % Strength of skull-stripping:               0 - SPM approach; eps to 1  - gcut; 2 - new APRG approach; -1 - no skull-stripping (already skull-stripped); default = 2
cat.extopts.segmentation.APP = 1070;
cat.extopts.segmentation.NCstr = -Inf;
cat.extopts.segmentation.LASstr = 0.5;
cat.extopts.segmentation.gcutstr = 2;
cat.extopts.segmentation.cleanupstr = 0.5;
cat.extopts.segmentation.WMHC = 1;
cat.extopts.segmentation.SLC = 0;
cat.extopts.segmentation.restypes.fixed = [1 0.1];
cat.extopts.registration.dartel.darteltpm = {fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','Template_1_IXI555_MNI152.nii')};
cat.extopts.vox = 1.5;
cat.extopts.surface.pbtres = 0.5;
cat.extopts.surface.scale_cortex = 0.7;
cat.extopts.surface.add_parahipp = 0.1;
cat.extopts.surface.close_parahipp = 0;
cat.extopts.admin.ignoreErrors = 0;
cat.extopts.admin.verb = 2;
cat.extopts.admin.print = 2;
cat.output.ROImenu.atlases.neuromorphometrics = 1;
cat.output.ROImenu.atlases.lpba40 = 1;
cat.output.ROImenu.atlases.cobra = 1;
cat.output.ROImenu.atlases.hammers = 1;
cat.output.ROImenu.atlases.ibsr = 0;
cat.output.ROImenu.atlases.aal = 0;
cat.output.ROImenu.atlases.mori = 1;
cat.output.ROImenu.atlases.anatomy = 1; 
cat.output.atlas.native = 0;
cat.output.atlas.dartel = 0;