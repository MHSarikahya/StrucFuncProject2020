%% CREATE VECTOR WITH OUTLYING VOLUMES BASED ON CONN TOOLBOX

%% Change the subject id for each individual subject
subid = 1;

%% Don't change this 
%cd(['C:\fmriprep\sub-0' num2str(subid) '\func'])
nruns = 2;

for i=1:nruns

    %% load file
    load(['art_regression_outliers_and_movement_ausub-00' num2str(subid) '_task-math_run-0' num2str(i) '_bold.mat'])

    %% delete final 7 columns from the file (not problematic volumes but overall motion parameters)
    A = size(R);
    R(:,(A(2)-6):A(2)) = [];

    %% create a single column vector with values
    vols = sum(R,2);
    B(i)= sum(vols);

    %% save volumes to problematicvolumes.txt
    dlmwrite(['problematicvolumes_arithmetic_run' num2str(i) '.txt'], vols);

end

sum(B)/(A(1)*nruns)
