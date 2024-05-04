function [] = Cat12_segmentation_and_QC ()

clear;
curdir = pwd; % Run function at top of directory structure


%%Start of code%%
%Define variables

DATADIR = '/Users/Mohammed/Documents/StructureFunction/DATA/StructureFunctionBids/'; %change to MacOSX file version

subjects=dir(DATADIR);
subjects={subjects.name};
subjects=subjects(~ismember(subjects,{'.','..','.DS_Store'}));  % if it doesnt work then {'.', '..', '__MACOSX','.DS_Store'}));

Dirs = {'anat'}; %add fmap


% Create lists of files

files = cell(size(subjects,2),size(Dirs,2));

for i=1:size(subjects,1)
    for j=1:size(Dirs,1)
        
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

            matlabbatch = preprocessT1(c);

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

% Estimate Total Intracranial Volumes (TIV)  ------ IN PROGRESS DO NOT RUN ------

% data=dir(['/Users/numcoglab/Documents/MATLAB/x/x','/*.xml']);
%    for j=1:size(data)
%        xml_file = {i,1}=[data(j).folder, '/', data(j).name];
	
%	matlabbatch = TIVest(d)
%	 %run matlabbatch job
%            cd(b.dataDir);
%               try
%                   spm_jobman('initcfg') %change for cat12...
%                    spm('defaults', 'FMRI');
%                    spm_jobman('serial', matlabbatch);
%                catch
%                    cd(curdir);
%                    continue;
%                end
%                cd(curdir);
%	end
%end

%%%Subfunction%%% 
% -- Preprocessing - Segementation --%

function [matlabbatch]= preprocessT1(c)

matlabbatch{1}.spm.tools.cat.estwrite.data = {c.files};
matlabbatch{1}.spm.tools.cat.estwrite.nproc = 4; %change to number of cores available
matlabbatch{1}.spm.tools.cat.estwrite.opts.tpm = {'/Users/eric/spm12/tpm/TPM.nii'};  %change to MacOSX file version
matlabbatch{1}.spm.tools.cat.estwrite.opts.affreg = 'mni';
matlabbatch{1}.spm.tools.cat.estwrite.opts.biasstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.opts.accstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.APP = 1070;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.LASstr = 0.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.gcutstr = 2;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.registration.dartel.darteltpm = {'/Users/eric/spm12/toolbox/cat12/templates_1.50mm/Template_1_IXI555_MNI152.nii'}; %change to MacOSX file version
matlabbatch{1}.spm.tools.cat.estwrite.extopts.vox = 1.5;
matlabbatch{1}.spm.tools.cat.estwrite.extopts.restypes.fixed = [1 0.1];
matlabbatch{1}.spm.tools.cat.estwrite.output.surface = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.neuromorphometrics = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.lpba40 = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.cobra = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.ROImenu.atlases.hammers = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.native = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.GM.dartel = 2;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.native = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.mod = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.WM.dartel = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.labelnative = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.bias.warped = 1;
matlabbatch{1}.spm.tools.cat.estwrite.output.jacobianwarped = 0;
matlabbatch{1}.spm.tools.cat.estwrite.output.warps = [0 0];

end


% -- TIV --%

function [matlabbatch]= TIVest(d)

matlabbatch{1}.spm.tools.cat.tools.calcvol.data_xml = 'xml_file';
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_TIV = 1;
matlabbatch{1}.spm.tools.cat.tools.calcvol.calcvol_name = 'TIV.txt';




end
