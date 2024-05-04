
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CAT12 segmentation; surface param; and other stuff - does      %
%       everything up to the basic model (under construction)          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

warning off all


sample = 'StructureFunctionBids';  %Our data
		            %this is just the name of the sample folders name; must be done before anything else
reproc = 0;  %reprocess of already ready subs, 0 is NOT reprocess



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call slurm and set max ram and clock time; also call matlab.exe w/ settings%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%call_slurm = ['srun -p large -N 1 -n 1 --mem-per-cpu=5500 --time=9:00:00 --job-name=' sample]; %copy-pasted defaults; increase on iMAC
call_matlab = '/Applications/MATLAB_R2017b.app/bin/matlab -nodesktop -nosplash -singleCompThread -r';  % Remove the singleCompThread on the iMAC, since it limits core usage
%call Matlab needs to go to the directory with the matlab.exe


%%%%%%%%%%%%
% Set subs %
%%%%%%%%%%%%

%fid = fopen('_path2data','r'); datadir = fgetl(fid); fclose(fid); %alt way %of grabbing subs; might not work
Dirs = fullfile('/Users/Mohammed/Documents/StructureFunction/DATA/', sample); %raw data folder
target = fullfile('/Users/Mohammed/Documents/Derivatives/', sample); %output


tempStruct = dir(fullfile(Dirs,'*')); 
tempStruct = tempStruct([tempStruct.isdir]); 
tempStruct = tempStruct(3:end);

if strfind(tempStruct(1).name,'sub')
    DtempStruct = tempStruct;
    fprintf('Sample "%s" contains ~%d subjects \n', sample, size(DtempStruct,1));
    cnt=1;
    for i=1:size(DtempStruct,1)
        if strfind(DtempStruct(i).name,'sub')
            subdir = fullfile(Dirs, DtempStruct(i).name);
            Ditempstruct = dir(fullfile(subdir,'*'));
            try Ditempstruct = Ditempstruct([Ditempstruct.isdir]); Ditempstruct = Ditempstruct(3:end); end
                if exist(fullfile(subdir, 'func'),'dir')
                    fil = dir(fullfile(subdir, 'func', '*bold.nii*'));
                    if numel(fil) > 0
                        xsubs{cnt} = DtempStruct(i).name;
                        sub_raw{cnt} = fullfile(subdir, 'func', fil(1).name);
                        targetdir{cnt} = fullfile(target, DtempStruct(i).name);
                        cnt=cnt+1;
                    end
                end
            end
        end
    end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if already processed subs; also for skipping re-segmentation         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

proc= []; i=0;


sub_raw = sub_raw(proc);
targetdir = targetdir(proc);
xsubs = xsubs(proc);
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Checks if T1w exists in the called folder; starts if yes, aborts, otherwise%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(sub_raw,'file')


sub_nii  = fullfile(targetdir, [xsub '.nii']);          %T1 file



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extracts .nii into the bootstrapped data dir%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        if strcmp(spm_file(sub_raw,'ext'),'gz')
            copyfile(sub_raw, fullfile(targetdir, [xsub '.nii.gz']));
            gunzip(fullfile(targetdir, [xsub '.nii.gz']));
            delete(fullfile(targetdir, [xsub '.nii.gz']));
        elseif strcmp(spm_file(sub_raw,'ext'),'nii')
            copyfile(sub_raw, sub_nii);
        else
            return
        end


    
end

