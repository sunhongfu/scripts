

    addpath(genpath('/Users/uqhsun8/Documents/MATLAB/functions/phase_cycling-master'))
    % addpath('./irt');
    % setup; % set up the irt package
    
    
    % recs_pc = zeros(320, 192, 320);
    

    
    
    % nii = load_nii('/QRISdata/Q1041/CSMEMP2RAGE/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/offsets_smooth.nii');
    % maps = single(nii.img);
    
    
    datapath = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso';

    for invNo = 2
    % for invNo = 1 : 2
        rec_path = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/rec_nocompression_ref1_inv', num2str(invNo)];
        mkdir(rec_path);
        
        for echo = 1
            
            new_path = sprintf('%s/echo%d/', rec_path, echo);
            mkdir(new_path);
            
            for slice = 161 : 480 %only do recon for the middle 320 slices;
                
                dataPath = sprintf('%s/inv%d/ksp_echo%d_slice%d.mat', datapath, invNo, echo, slice)
                load(dataPath);
                
                mask = ksp_1slice ~= 0;
                
                disp(slice)
                img_pc = CS_Recon_2D_MC(ksp_1slice, mask);
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
    
    
    