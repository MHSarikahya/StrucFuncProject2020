
%problem with concatenation? Regen designs???


%-----------------------------------------------------%
% This function defines contrasts                     %
% and sends the resulting vector to SPM for           %
% estimation as a t-contrast.                         %
%-----------------------------------------------------%

function [] = step4_for_odds()

clear;
curdir = pwd;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1: Define variables %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ROOTDIR = '/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Analysis/1stLevel/DesignEstimate/';

subjects = dir(ROOTDIR);
subjects = {subjects.name};
subjects = subjects(~ismember(subjects, {'.','..', '.DS_Store'}));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 2: List SPM.mat files %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SPM_files = cell(1,size(subjects,2));

for i = 1:size(subjects,2)
    SPM_files{1,i} = strcat(ROOTDIR, subjects{i}, '/', 'SPM.mat'); 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 3: Name and define contrasts %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

names = cell(1,1);
contrastVectors = cell(1,1); %need to edit

for i = 1:size(subjects,2)


spmfile = strcat(ROOTDIR, subjects{i}, '/', 'SPM.mat');  %maybe add a * incase no pickup
load(spmfile, 'SPM')
listPredictors = SPM.xX.name;


%% Arithmetic
% % % % 
% % % % predictors{1} = 'small*bf(1)';  %includes both run 1 and run 2
% % % % predictors{2} = 'large*bf(1)';
% % % % predictors{3} = 'plus1*bf(1)';
% % % % predictors{4} = 'incorrect*bf(1)';
% % % % 
% % % % 
% % % % 
% % % % % Loop defines contrast for (small+large > plus1)
% % % % 
% % % % names{1,1} = 'SLvP1'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % for j = 1:size(listPredictors,2)
% % % %     tempPred = listPredictors{j};
% % % %     tempPred = tempPred(7:end);
% % % %   if length(listPredictors) == 24
% % % %     if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})
% % % %         convec_temp(1,j) = 0.5;
% % % %     elseif strcmp(tempPred, predictors{3})
% % % %         convec_temp(1,j) = -1;
% % % %     end
% % % %   elseif length(listPredictors) == 11 %need another iften loop to select for incorrect missing vs other predictors....
% % % %     if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})
% % % %         convec_temp(1,j) = 0.5;
% % % %     elseif strcmp(tempPred, predictors{3})
% % % %         convec_temp(1,j) = -1;
% % % %     end
% % % %   end  
% % % % end
% % % % 
% % % % contrastVectors{i,1} = convec_temp;
% % % % 
% % % % 
% % % % % Loop defines contrast for (small, large, plus1 > baseline)
% % % % 
% % % % names{1,2} = 'SLP1vB'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % 
% % % % for j = 1:size(listPredictors,2)
% % % %             tempPred = listPredictors{j};
% % % %             tempPred = tempPred(7:end);
% % % %       if length(listPredictors) == 24
% % % %         if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})  || strcmp(tempPred, predictors{3}) 
% % % %             convec_temp(1,j) = 1; 
% % % %         end
% % % %      elseif length(listPredictors) == 11
% % % %          if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})  || strcmp(tempPred, predictors{3}) 
% % % %             convec_temp(1,j) = 1; 
% % % %         end
% % % %     end
% % % % end    
% % % %     
% % % % contrastVectors{i,2} = convec_temp;
% % % % 
% % % % % Loop defines contrast for (Incorrect > baseline)
% % % % 
% % % % names{1,3} = 'IvB'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % for j = 1:size(listPredictors,2)
% % % %             tempPred = listPredictors{j};
% % % %             tempPred = tempPred(7:end);
% % % %         if length(listPredictors) == 24
% % % %             if strcmp(tempPred, predictors{4})
% % % %                 convec_temp(1,j) = 1;
% % % %             end
% % % %           elseif length(listPredictors) == 11
% % % %             if strcmp(tempPred, predictors{4})
% % % %                 convec_temp(1,j) = 1;
% % % %             end
% % % %         end
% % % % end
% % % % contrastVectors{i,3} = convec_temp;
% % % % 
% % % % 
% % % % % Loop defines contrast for (small > baseline)
% % % % 
% % % % names{1,4} = 'SvB'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % 
% % % % for j = 1:size(listPredictors,2)
% % % %         tempPred = listPredictors{j};
% % % %         tempPred = tempPred(7:end);
% % % %     if length(listPredictors) == 24    
% % % %         if strcmp(tempPred, predictors{1})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %     elseif length(listPredictors) == 11
% % % %          if strcmp(tempPred, predictors{1})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %     end
% % % % end
% % % % contrastVectors{i,4} = convec_temp;
% % % % 
% % % % 
% % % % 
% % % % % Loop defines contrast for (large > baseline)
% % % % 
% % % % names{1,5} = 'LvB'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % 
% % % % for j = 1:size(listPredictors,2)
% % % %         tempPred = listPredictors{j};
% % % %         tempPred = tempPred(7:end);
% % % %     if length(listPredictors) ==24
% % % %         if strcmp(tempPred, predictors{2})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %     elseif length(listPredictors) == 11
% % % %         if strcmp(tempPred, predictors{2})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %     end
% % % % end
% % % % contrastVectors{i,5} = convec_temp;
% % % % 
% % % % 
% % % % % Loop defines contrast for (Plus1 > baseline)
% % % % 
% % % % names{1,6} = 'P1vB'; %change name to something relevant
% % % % convec_temp = zeros(1,size(listPredictors,2));
% % % % 
% % % % 
% % % %  for j = 1:size(listPredictors,2)
% % % %         tempPred = listPredictors{j};
% % % %         tempPred = tempPred(7:end);
% % % %     if length(listPredictors) ==24
% % % %         if strcmp(tempPred, predictors{3})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %   elseif length(listPredictors) == 11
% % % %         if strcmp(tempPred, predictors{3})
% % % %             convec_temp(1,j) = 1;
% % % %         end
% % % %     end
% % % % end
% % % %     
% % % % contrastVectors{i,6} = convec_temp;
% % % % 
% % % % end


%% Matching

predictors{1} = 'number*bf(1)';  %includes both run 1 and run 2
predictors{2} = 'shape*bf(1)';
predictors{3} = 'incorrect*bf(1)';

% Loop defines contrast for (number > shape)

names{1,1} = 'NvS'; %change name to something relevant
convec_temp = zeros(1,size(listPredictors,2));

for j = 1:size(listPredictors,2)
    tempPred = listPredictors{j};
    tempPred = tempPred(7:end);
    if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})
        convec_temp(1,j) = 1;
    end
end

contrastVectors{i,1} = convec_temp;

% Loop defines contrast for (number+shape > baseline)

names{1,2} = 'NSvB'; %change name to something relevant
convec_temp = zeros(1,size(listPredictors,2));

for j = 1:size(listPredictors,2)
    tempPred = listPredictors{j};
    tempPred = tempPred(7:end);
    if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})
        convec_temp(1,j) = 1;
    elseif strcmp(tempPred, predictors{3})
        convec_temp(1,j) = 0;
    end
end

contrastVectors{i,2} = convec_temp;

% Loop defines contrast for (number > shape)

names{1,3} = 'IvB'; %change name to something relevant
convec_temp = zeros(1,size(listPredictors,2));

for j = 1:size(listPredictors,2)
    tempPred = listPredictors{j};
    tempPred = tempPred(7:end);
    if strcmp(tempPred, predictors{3})
        convec_temp(1,j) = 1;
    end 
end

contrastVectors{i,3} = convec_temp;


% Loop defines contrast for (number > baseline)

names{1,4} = 'NvB'; %change name to something relevant
convec_temp = zeros(1,size(listPredictors,2));

for j = 1:size(listPredictors,2)
    tempPred = listPredictors{j};
    tempPred = tempPred(7:end);
    if strcmp(tempPred, predictors{1})
        convec_temp(1,j) = 1;
    end 
end

contrastVectors{i,4} = convec_temp;

% Loop defines contrast for (shape > baseline)

names{1,5} = 'SvB'; %change name to something relevant
convec_temp = zeros(1,size(listPredictors,2));

for j = 1:size(listPredictors,2)
    tempPred = listPredictors{j};
    tempPred = tempPred(7:end);
    if strcmp(tempPred, predictors{2})
        convec_temp(1,j) = 1;
    end 
end

contrastVectors{i,5} = convec_temp;
end


%% VSWM
% % 
% % predictors{1} = 'con2*bf(1)';  %includes both run 1 and run 2
% % predictors{2} = 'con4*bf(1)';
% % predictors{3} = 'stm2*bf(1)';
% % predictors{4} = 'stm4*bf(1)';
% % predictors{5} = 'incorrect*bf(1)';
% % 
% % % Loop defines contrast for (stm2+stm4 > con2+con4)
% % 
% % names{1,1} = 'SSvCC'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if length(listPredictors) == 14
% %         if strcmp(tempPred, predictors{3}) || strcmp(tempPred, predictors{4}) % stm2+stm4
% %             convec_temp(1,j) = 0.5;
% %         elseif strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2}) %con2+con5
% %             convec_temp(1,j) = -0.5;
% %         end
% %      elseif length(listPredictors) == 13
% %         if strcmp(tempPred, predictors{3}) || strcmp(tempPred, predictors{4}) % stm2+stm4
% %             convec_temp(1,j) = 0.5;
% %         elseif strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2}) %con2+con5
% %             convec_temp(1,j) = -0.5;
% %         end
% %     elseif length(listPredictors) == 24
% %         if strcmp(tempPred, predictors{3}) || strcmp(tempPred, predictors{4}) % stm2+stm4
% %             convec_temp(1,j) = 0.5;
% %         elseif strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2}) %con2+con5
% %             convec_temp(1,j) = -0.5;
% %         end
% %     end
% % end
% % 
% % %   if length(listPredictors) == 24
% % %     if strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2})
% % %         convec_temp(1,j) = 0.5;
% % %     elseif strcmp(tempPred, predictors{3})
% % %         convec_temp(1,j) = -1;
% % %     end
% % 
% % 
% % 
% % 
% % 
% % 
% % contrastVectors{i,1} = convec_temp;
% % 
% % 
% % % %Loop defines contrast for (stm2+stm4+con2+con4 > baseline) - not sure if
% % % %this is vs baseline
% % 
% % names{1,2} = 'SSCCvB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if strcmp(tempPred, predictors{3}) || strcmp(tempPred, predictors{4}) % stm2+stm4
% %         convec_temp(1,j) = 1;
% %     elseif strcmp(tempPred, predictors{1}) || strcmp(tempPred, predictors{2}) %con2+con5
% %         convec_temp(1,j) = 1;
% %     end
% % end
% % contrastVectors{i,2} = convec_temp;
% % 
% % % Loop defines contrast for (incorrect > baseline) 
% % 
% % names{1,3} = 'IvB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if length(listPredictors) == 13
% %         if strcmp(tempPred, predictors{5})
% %             convec_temp(1,j) = 1;
% %         end
% %     elseif length(listPredictors) == 24
% %         if strcmp(tempPred, predictors{5})
% %             convec_temp(1,j) = 1;
% %         end
% %     end
% % end
% % contrastVectors{i,3} = convec_temp;
% % 
% % 
% % % Loop defines contrast for (con2 > baseline) 
% % 
% % names{1,4} = 'C2vB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if strcmp(tempPred, predictors{1})
% %         convec_temp(1,j) = 1;
% %     end
% % end
% % contrastVectors{i,4} = convec_temp;
% % 
% % % Loop defines contrast for (Con4 > baseline) 
% % 
% % names{1,5} = 'C4vB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if strcmp(tempPred, predictors{2})
% %         convec_temp(1,j) = 1;
% %     end
% % end
% % contrastVectors{i,5} = convec_temp;
% % 
% % % Loop defines contrast for (STM2 > baseline) 
% % 
% % names{1,6} = 'S2vB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if strcmp(tempPred, predictors{3})
% %         convec_temp(1,j) = 1;
% %     end
% % end
% % contrastVectors{i,6} = convec_temp;
% % 
% % 
% % % Loop defines contrast for (STM4 > baseline) 
% % 
% % names{1,7} = 'S4vB'; %change name to something relevant
% % convec_temp = zeros(1,size(listPredictors,2));
% % 
% % for j = 1:size(listPredictors,2)
% %     tempPred = listPredictors{j};
% %     tempPred = tempPred(7:end);
% %     if strcmp(tempPred, predictors{4})
% %         convec_temp(1,j) = 1;
% %     end
% % end
% % contrastVectors{i,7} = convec_temp;
% % 
% % end
% % 

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create structure for SUBFUNCTION          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i = 1:size(subjects,2)
    
    a.DesignDir = strcat(ROOTDIR, subjects{i});
    a.SPM = SPM_files{1,i};
    a.cName1 = names{1,1};
    a.cName2 = names{1,2};
    a.cName3 = names{1,3};
    a.cName4 = names{1,4};
    a.cName5 = names{1,5};
%     a.cName6 = names{1,6};
%     a.cName7 = names{1,7};
    a.vector1 = [contrastVectors{1,1}];
    a.vector2 = contrastVectors{1,2};
    a.vector3 = contrastVectors{1,3};
    a.vector4 = contrastVectors{1,4};
    a.vector5 = contrastVectors{1,5};
%     a.vector6 = contrastVectors{1,6};
%     a.vector7 = contrastVectors{1,7};


%     
    matlabbatch = contrast_job(a);
         
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

%%%%%%%%%%%%%%%
% SUBFUNCTION %
%%%%%%%%%%%%%%%

function [matlabbatch] = contrast_job(a)

matlabbatch{1}.spm.stats.con.spmmat = {a.SPM};

matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = a.cName1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = a.vector1;
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = a.cName2;
matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = a.vector2;
matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = a.cName3;
matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = a.vector3;
matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'none';

matlabbatch{1}.spm.stats.con.consess{4}.tcon.name = a.cName4;
matlabbatch{1}.spm.stats.con.consess{4}.tcon.weights = a.vector4;
matlabbatch{1}.spm.stats.con.consess{4}.tcon.sessrep = 'none';


matlabbatch{1}.spm.stats.con.consess{5}.tcon.name = a.cName5;
matlabbatch{1}.spm.stats.con.consess{5}.tcon.weights = a.vector5;
matlabbatch{1}.spm.stats.con.consess{5}.tcon.sessrep = 'none';


% matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = a.cName6;
% matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = a.vector6;
% matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'none';


% matlabbatch{1}.spm.stats.con.consess{7}.tcon.name = a.cName7;
% matlabbatch{1}.spm.stats.con.consess{7}.tcon.weights = a.vector7;
% matlabbatch{1}.spm.stats.con.consess{7}.tcon.sessrep = 'none';


% % % matlabbatch{1}.spm.stats.con.spmmat = {'/Users/Mohammed/Documents/StructureFunction/Derivatives/Function_Preproc/Analysis/1stLevel/DesignEstimate/sub-002/SPM.mat'};
% % % matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'Test22';
% % % matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1 1 -2 0 0 0 0 0 0 0 0 1 1 -2 0 0 0 0 0 0 0 0 0 0];
% % % matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% % % matlabbatch{1}.spm.stats.con.delete = 0;


matlabbatch{1}.spm.stats.con.delete = 1;

end
end
