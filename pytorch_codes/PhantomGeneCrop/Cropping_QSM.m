Iteration = 96;
path_qsm = '/Volumes/LaCie/CommQSM/invivo/Phantoms144192128';
% path_tfs = 'F:/Temp/tfs';
batch_size = 64;
crop_step = [20;32;16];
randomN = 25;
% 
%% Random Cropping
for itrC =1:1:Iteration
    lfsP_N = [path_qsm,'/' num2str(itrC),'.nii']; % Remember to alter name here /XYZ
    lfs_nii = load_untouch_nii(lfsP_N); lfs = lfs_nii.img;
    % tfsP_N = [path_tfs,'/tfs',num2str(itrC),'.nii']; % Remember to alter name here /XYZ
    % tfs_nii = load_untouch_nii(tfsP_N); tfs = tfs_nii.img;
    
    size_lfs = size(lfs);
    size_x = size_lfs(1); size_y = size_lfs(2); size_z = size_lfs(3);
    crop_stepX = crop_step(1);crop_stepY = crop_step(2);crop_stepZ = crop_step(3);
    
        for i0 = 1:1:randomN
    
            coorX = round(rand(1)*(size_x-batch_size)+1);
            coorY = round(rand(1)*(size_y-batch_size)+1);
            coorZ = round(rand(1)*(size_z-batch_size)+1);
    
            labelRandom = lfs(coorX:coorX+batch_size-1,coorY:coorY+batch_size-1,coorZ:coorZ+batch_size-1);

            labelStep_N = [path_qsm,'/Label/qsm_',num2str(randomN*(itrC-1)+i0),'.nii']; % Remember to alter name here /XYZ
            labelStep_nii = make_nii(double(labelRandom)); save_nii(labelStep_nii,labelStep_N);
    
        end
end
    
for iterS = 1:1:Iteration
    %% Marching Type
    for k2 = 1:1:(size_z - batch_size)/crop_stepZ+1
        for j2 = 1:1:(size_y - batch_size)/crop_stepY+1
            for i2 = 1:1:(size_x - batch_size)/crop_stepX+1
                
                labelStep = lfs((i2-1)*crop_stepX+1:(i2-1)*crop_stepX+batch_size,(j2-1)*crop_stepY+1:(j2-1)*crop_stepY+batch_size,(k2-1)*crop_stepZ+1:(k2-1)*crop_stepZ+batch_size);
                
                Step_number = i2+(j2-1)*((size_y - batch_size)/crop_stepY+1)+(k2-1)*((size_y - batch_size)/crop_stepY+1)*((size_x - batch_size)/crop_stepX+1);
                SinIteNum = ((size_z-batch_size)/crop_stepZ+1)*((size_y-batch_size)/crop_stepY+1)*((size_x-batch_size)/crop_stepX+1);
                TotalNumber = Step_number+SinIteNum*(iterS-1)+randomN*Iteration;
                
                labelStep_N = [path_qsm,'/Label/qsm_',num2str(TotalNumber),'.nii']; % Remember to alter name here /XYZ
                labelStep_nii = make_nii(double(labelStep)); save_nii(labelStep_nii,labelStep_N);
            end
        end
    end
end