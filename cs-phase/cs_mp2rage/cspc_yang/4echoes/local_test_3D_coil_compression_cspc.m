

    addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/phase_cycling-master'))
    % addpath('./irt');
    % setup; % set up the irt package
    
    
    % recs_pc = zeros(320, 192, 320);
    

    
    
    % nii = load_nii('/QRISdata/Q1041/CSMEMP2RAGE/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/offsets_smooth.nii');
    % maps = single(nii.img);
    
    
    datapath = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso';

    invNo = 2

    echo = 4

    for slice = 161 : 480 %only do recon for the middle 320 slices;
                
        dataPath = sprintf('%s/inv%d/ksp_echo%d_slice%d.mat', datapath, invNo, echo, slice)
        load(dataPath);
        ksp(slice-160,:,:,:)=ksp_1slice;
    end


%% SVD coil compression:
% the first eigenmode has smooth phase devoid of singularities at 3T
% this can be used as phase reference to remove anatomical phase from coil 
% sensitivities without introducing singularities
%--------------------------------------------------------------------------
num_svd = 32;                   % no of SVD channels for compression (num_svd = 16 works well for 32 chan array)
[sx, sy,sz, nc] = size(ksp);
N = [sx, sy, sz]
temp = reshape(ksp, [prod(N), nc]);
[V,D] = eig(temp'*temp);
V = flip(V,2);
% coil compressed image, where 1st chan is the virtual body coil to be used as phase reference:
ksp = reshape(temp * V(:,1:num_svd), [N, num_svd]);



    for invNo = 2
    % for invNo = 1 : 2
        rec_path = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/rec_eig32_ref1_inv', num2str(invNo)];
        mkdir(rec_path);
        
        for echo = 4
            
            new_path = sprintf('%s/echo%d/', rec_path, echo);
            mkdir(new_path);
            
            for slice = 1 : 320 %only do recon for the middle 320 slices;
                
                ksp_1slice = squeeze(ksp(slice,:,:,:));
                
                mask = ksp_1slice ~= 0;
                
                disp(slice)
                img_pc = CS_Recon_2D_MC_ref1_eig32(ksp_1slice, mask);
                % img_pc = CS_Recon_2D_MC(ksp_1slice, mask, squeeze(maps(slice-160,:,:,:)));
                
                if max(abs(img_pc)) == 0
                    error('Wrong Reconstruction');
                end
                %%recs_pc(:,:,slice - 160) = img_pc;
    
                %% save data
                save(sprintf('%s/rec_CSPC_slice%d.mat', new_path, slice), 'img_pc');
            end
            toc
    
        end

    end


    
    
    