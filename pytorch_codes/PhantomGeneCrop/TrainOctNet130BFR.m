

%% intialize my Unet
volReader = @(x) matRead(x);
inputs = imageDatastore('/scratch/itee/xyPytorch/Phantoms144192128/tfs/Input/*.nii', ...
'FileExtensions','.nii','ReadFcn',volReader);
labels = imageDatastore('/scratch/itee/xyPytorch/Phantoms144192128/lfs/Label/*.nii', ...
'FileExtensions','.nii','ReadFcn',volReader);

%% re-sort. 
disp('Data Length: ')
disp(length(labels.Files))
disp(length(inputs.Files))

disp('Input Files');
inputs
disp('Label Files')
labels

%% 
patchSize = [64, 64, 64];
patchPerImage = 1;


miniBatchSize = 24;
patchds = randomPatchExtractionDatastore(inputs,labels,patchSize, ...
    'PatchesPerImage',patchPerImage);
patchds.MiniBatchSize = miniBatchSize;

%% 
disp('3D Octave  08 SEP, - L2 loss - 45 EPO');
[myUnet , info_net] = create3DOctNet130BN([64, 64, 64]);
disp(myUnet.Layers)
% %% training set data;

%% training optins 
initialLearningRate = 0.001;
maxEpochs = 45;
minibatchSize = miniBatchSize
l2reg = 0.00000;

options = trainingOptions('adam',...
    'L2Regularization',l2reg,...
    'MaxEpochs',maxEpochs,...
    'MiniBatchSize',minibatchSize,...
    'VerboseFrequency',20,...  
    'Shuffle','every-epoch',...
    'ExecutionEnvironment','multi-gpu');
%% training function;
% parpool(2);
[net, info] = trainNetwork(patchds, myUnet, options);
%% 
disp('save trainning results')
save Oct_L2_64_24BS_45Epo_4pooling.mat net; 
disp('saving complete!');



