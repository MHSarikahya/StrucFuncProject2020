function Cat_Segment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Segmentation.m code, with some possible edits                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist('spmx','var'), clear spmx; end
global spmx
cat.extopts.expertgui = 1;
spmx.tools.cat.estwrite.nproc = 2;
spmx.tools.cat.estwrite.opts.tpm = {fullfile(spm('dir'),'tpm','TPM.nii')};
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
spmx.tools.cat.estwrite.extopts.registration.dartel.darteltpm = {fullfile(spm('dir'),'toolbox','cat12','templates_1.50mm','Template_1_IXI555_MNI152.nii')};
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
spmx.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.cobra = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.hammers = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.ibsr = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.aal = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.mori = 0;
spmx.tools.cat.estwrite.output.ROImenu.atlases.anatomy = 0;
spmx.tools.cat.estwrite.output.GM.native = 1;
spmx.tools.cat.estwrite.output.GM.warped = 1;
spmx.tools.cat.estwrite.output.GM.mod = 2;
spmx.tools.cat.estwrite.output.GM.dartel = 3;
spmx.tools.cat.estwrite.output.WM.native = 1;
spmx.tools.cat.estwrite.output.WM.warped = 1;
spmx.tools.cat.estwrite.output.WM.mod = 2;
spmx.tools.cat.estwrite.output.WM.dartel = 3;
spmx.tools.cat.estwrite.output.CSF.native = 1;
spmx.tools.cat.estwrite.output.CSF.warped = 1;
spmx.tools.cat.estwrite.output.CSF.mod = 2;
spmx.tools.cat.estwrite.output.CSF.dartel = 3;
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
spmx.tools.cat.estwrite.output.label.warped = 1;
spmx.tools.cat.estwrite.output.label.dartel = 3;
spmx.tools.cat.estwrite.output.bias.native = 1;
spmx.tools.cat.estwrite.output.bias.warped = 1;
spmx.tools.cat.estwrite.output.bias.dartel = 0;
spmx.tools.cat.estwrite.output.las.native = 1;
spmx.tools.cat.estwrite.output.las.warped = 1;
spmx.tools.cat.estwrite.output.las.dartel = 3;
spmx.tools.cat.estwrite.output.jacobianwarped = 1;
spmx.tools.cat.estwrite.output.warps = [1 1];


