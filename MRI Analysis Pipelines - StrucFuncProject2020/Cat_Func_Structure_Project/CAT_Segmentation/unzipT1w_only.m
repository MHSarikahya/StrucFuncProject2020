function unzipT1w_only(sub_raw, xsub, targetdir, reproc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CAT12 segmentation; surface param; and other stuff - does      %
%       everything up to the basic model (under construction)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off all


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks if T1w exists in the called folder; starts if yes, aborts, otherwise%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(sub_raw,'file')


sub_nii  = fullfile(targetdir, [xsub '.nii']);          %T1 file


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts .nii into the bootstrapped data dir%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~exist(sub_nii,'file')
    mkdir(targetdir);
        if strcmp(spm_file(sub_raw,'ext'),'gz')
            copyfile(sub_raw, fullfile(targetdir, [xsub '_acq-MPRAGE_run-01_T1w.nii.gz']));
            gunzip(fullfile(targetdir, [xsub '_acq-MPRAGE_run-01_T1w.nii.gz']));
            delete(fullfile(targetdir, [xsub '_acq-MPRAGE_run-01_T1w.nii.gz']));
        elseif strcmp(spm_file(sub_raw,'ext'),'_T1w.nii')
            copyfile(sub_raw, sub_nii);
        else
            return
        end

end
end