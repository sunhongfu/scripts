

clear 
clc 

img_all = zeros([320,320,192]);
mag = zeros([320,320,192]);
ph = zeros([320,320,192]);


for invNo = 2
% for invNo = 1 : 2
        rec_path = ['/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/rec_eig32_4D_ref1_inv', num2str(invNo)];
    % for echo = 1 : 4 
    for echo = 1 
        new_path = sprintf('%s/echo%d/', rec_path, echo);
        for sliceNo = 1 : 320 
            fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo);
            % fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo+160);
            load(fpath); 
            img_all(sliceNo,:,:) = img_pc;
            mag(sliceNo,:,:) = abs(img_pc);
            ph(sliceNo,:,:) = angle(img_pc); 
        end
        save(sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/img_echo%d_inv%d.mat', echo, invNo),'img_all');
        niftiwrite(mag, sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/mag_echo%d_inv%d.nii', echo, invNo))
        niftiwrite(ph, sprintf('/Volumes/LaCie_Top/CSMEMP2RAGE/CS_MP2RAGE_19Aug21/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/ph_echo%d_inv%d.nii', echo, invNo))
    end 
end
