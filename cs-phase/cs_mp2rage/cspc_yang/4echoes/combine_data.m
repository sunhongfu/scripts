

clear 
clc 

img_all = zeros([320,320,192]);
mag = zeros([320,320,192]);
ph = zeros([320,320,192]);


for invNo = 1 : 2
    rec_path = ['/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/rec', num2str(invNo)];
    for echo = 1 : 4 
        new_path = sprintf('%s/echo%d/', rec_path, echo);
        for sliceNo = 161 : 480 
            fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo);
            load(fpath); 
            img_all(sliceNo-160,:,:) = img_pc;
            mag(sliceNo-160,:,:) = abs(img_pc);
            ph(sliceNo-160,:,:) = angle(img_pc); 
        end
        save(sprintf('/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/img_echo%d_inv%d.mat', echo, invNo),'img_all');
        niftiwrite(mag, sprintf('/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/mag_echo%d_inv%d.nii', echo, invNo))
        niftiwrite(ph, sprintf('/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/ph_echo%d_inv%d.nii', echo, invNo))
    end 
end