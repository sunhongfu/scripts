Iteration = 96;
path_lfs = 'F:/Temp/lfs';
path_tfs = 'F:/Temp/tfs';
batch_size = 64;
crop_step = [20;32;16];
randomN = 25;
% 
[inputStep_nii,labelStep_nii]=BFRtrainingSet(path_lfs,path_tfs,batch_size,crop_step,randomN,Iteration);