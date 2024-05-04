clear, clc; warning off all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       CAT12 house-keeping and send job to CAT12subfunc_fixed.m      %
%                                                                     %
%                                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define sample and whether or not to reprocess%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sample = 'StructureFunctionBids';  %Our data
		            %this is just the name of the sample folders name; must be done before anything else
reproc = 0;  %reprocess of already ready subs, 0 is NOT reprocess



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Call slurm and set max ram and clock time; also call matlab.exe w/ settings%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

call_slurm = ['srun -p large -N 1 -n 1 --mem-per-cpu=5500 --time=9:00:00 --job-name=' sample]; %copy-pasted defaults; increase on iMAC
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
                if exist(fullfile(subdir, 'anat'),'dir')
                    fil = dir(fullfile(subdir, 'anat', '*T1w.nii*'));
                    if numel(fil) > 0
                        xsubs{cnt} = DtempStruct(i).name;
                        sub_raw{cnt} = fullfile(subdir, 'anat', fil(1).name);
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
if reproc
    proc = 1 : numel(xsubs);
else
    for sub = 1:numel(xsubs)
        if exist(sub_raw{sub}, 'file') && ...
                (~exist(fullfile(targetdir{sub}, 'surf', ['s8.lh.thickness.resampled.' xsubs{sub} '.gii']),'file') || ...
                            ~exist(fullfile(targetdir{sub}, ['SPM' xsubs{sub} '.mat']),'file'))            %edit these in oprder to prevent 
                                                                                                            %re-segmentation/length amount of time/for testing cod

            i = i + 1;
            proc(i) = sub;
        end
    end
end
if numel(proc) == 0
    fprintf('No subs to process, closing.'); return;
else
    fprintf('Found %i unprocessed of %i subs..\n', numel(proc), numel(xsubs));
end
sub_raw = sub_raw(proc);
targetdir = targetdir(proc);
xsubs = xsubs(proc);
pause

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Submit the job to the other .m files for proc%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for sub = 1:numel(xsubs)
 fprintf('Sent to unzipT1w_only, subject %s \n', xsubs{sub});
   system([ call_matlab ' "unzipT1w_only(''' sub_raw{sub} ''' ,' '''' ...
       xsubs{sub} ''' ,' '''' targetdir{sub} ''' ,' '' num2str(reproc) ' )" &' ],'-echo');
end


% for sub = 1:numel(xsubs)
%     fprintf('Sent to CAT12subfunc, subject %s \n', xsubs{sub});
%     CAT12subfunc_Slow(sub_raw{sub}(:,:), xsubs{sub}(:,:), targetdir{sub}(:,:), reproc);
% end
    