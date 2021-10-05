function CS_Recon_4D_MC(echoNo, datapath, nW)
%CS_RECON_4D_MC Summary of this function goes here
%   Detailed explanation goes here
%% CS_RECON_4D: reconstruct the full 4-D MRI data:
% inputs: 1. datapath: kspace data path;
%         2. maskpath: subsampling maskpat;
%         3. nW: number of workers;

if nargin < 2
    datapath = '/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54';
    % maskpath = '/gpfs1/scratch/30days/uqygao10/MultiChannel_CSPC/Scannermask_AF4.mat';
    nW = 0;
end


LASTN = maxNumCompThreads(10)

%% addpath for necessary packages.

addpath(genpath('/home/uqhsun8/Documents/MATLAB/functions/phase_cycling-master'))
% addpath('./irt');
% setup; % set up the irt package


% recs_pc = zeros(320, 192, 320);

tic


nii = load_nii('/QRISdata/Q1041/CSMEMP2RAGE/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54/offsets_smooth.nii');
maps = single(nii.img);


for invNo = 1 : 2
    rec_path = ['/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54/rec', num2str(invNo)];
    mkdir(rec_path);
    
    for echo = echoNo :  echoNo
        
        new_path = sprintf('%s/echo%d/', rec_path, echo);
        mkdir(new_path);
        
        for slice = 1 : 320 %only do recon for the middle 320 slices;
            
            dataPath = sprintf('%s/inv%d/ksp_echo%d_slice%d.mat', datapath, invNo, echo, slice)
            load(dataPath);
            
            mask = ksp_1slice ~= 0;
            
            disp(slice)
            % img_pc = CS_Recon_2D_MC(ksp_1slice, mask);
            img_pc = CS_Recon_2D_MC(ksp_1slice, mask, squeeze(maps(slice,:,:,:)));
            
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
end

