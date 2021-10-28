datapath = '/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54';
readout = 'monopolar'
EchoMax = 9
SliceMax = 320

%% addpath for necessary packages.
addpath(genpath('/home/uqhsun8/Documents/MATLAB/functions/phase_cycling-master'))
addpath(genpath('/Users/uqhsun8/Documents/MATLAB/scripts/cs-phase/cs_mp2rage/cspc_yang'))
% addpath('./irt');
% setup; % set up the irt package


% split the slices
for invNo = 2
    dataFolder = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/inv', num2str(invNo)];
    mkdir(dataFolder)

    for echoNo = 1:EchoMax
        DataObj = matfile(['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/ksp_echo' num2str(echoNo) '_inv' num2str(invNo) '.mat']);
        raw_ksp = squeeze(DataObj.ksp);
        new_ksp = fftshift(fft(fftshift(raw_ksp, 1), [], 1), 1);
        clear raw_ksp

        for sliceNo = 1 : size(new_ksp,1)
            ksp_1slice = squeeze(new_ksp(sliceNo, :, :, :)); 
            data_path = sprintf('%s/ksp_echo%d_slice%d.mat', dataFolder, echoNo, sliceNo);
            disp(sliceNo)
            save(data_path, 'ksp_1slice')
        end

    end 

end


% CSPC recon
for invNo = 2
    dataFolder = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/inv', num2str(invNo)];
    inv_rec_path = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/cspc_inv', num2str(invNo)];
    mkdir(inv_rec_path);

    for echoNo = 1:EchoMax
        echo_rec_path = sprintf('%s/echo%d/', inv_rec_path, echoNo);
        mkdir(echo_rec_path);

        if strcmpi('bipolar',readout)
            if mod(echoNo,2) == 1
                nii = load_nii('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/QSM_ZF_lr/odd_box3d_12_8/offsets_smooth.nii');
                maps = squeeze(single(nii.img));
            else
                nii = load_nii('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/QSM_ZF_lr/even_box3d_12_8/offsets_smooth.nii');
                maps = squeeze(single(nii.img));            
            end
        else
            nii = load_nii('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/QSM_ZF_lr/offsets_smooth.nii');
            maps = squeeze(single(nii.img));
        end

        
        maps = flip(flip(flip(maps,2),3),1);



        for sliceNo = 1 : size(maps,1) %only do recon for the middle SliceMax slices;
            
            data_path = sprintf('%s/ksp_echo%d_slice%d.mat', dataFolder, echoNo, sliceNo);
            load(data_path);
            
            mask = ksp_1slice ~= 0;
            
            disp(sliceNo)
            % img_pc = CS_Recon_2D_MC(ksp_1slice, mask);
            img_pc = cspc_HScoils_2D_MC(ksp_1slice, mask, squeeze(maps(sliceNo,:,:,:)));
            
            if max(abs(img_pc)) == 0
                error('Wrong Reconstruction');
            end

            %% save data
            save(sprintf('%s/rec_CSPC_slice%d.mat', echo_rec_path, sliceNo), 'img_pc');
        end
        
    end

end




% combine recon data

for invNo = 2
    % for invNo = 1 : 2
    inv_rec_path = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/cspc_inv', num2str(invNo)];
    for echoNo = 1 : EchoMax
        new_path = sprintf('%s/echo%d/', inv_rec_path, echoNo);
        for sliceNo = 1 : SliceMax 
            fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo);
            % fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo+160);
            load(fpath); 
            img_all(sliceNo,:,:) = img_pc;
            mag(sliceNo,:,:) = abs(img_pc);
            ph(sliceNo,:,:) = angle(img_pc); 
        end
        save(sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/img_echo%d_inv%d.mat', echoNo, invNo),'img_all');
        niftiwrite(mag, sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/mag_echo%d_inv%d.nii', echoNo, invNo))
        niftiwrite(ph, sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_24Sep21/meas_MID00351_FID05065_wip925b_TI2_ECHO2_VC_CS9_SAM54/ph_echo%d_inv%d.nii', echoNo, invNo))
    end 
end
    