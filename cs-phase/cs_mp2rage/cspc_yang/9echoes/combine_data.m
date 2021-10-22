

clear 
clc 

img_all = zeros([320,320,192]);
mag = zeros([320,320,192]);
ph = zeros([320,320,192]);


for invNo = 1 : 2
    rec_path = ['/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54/rec', num2str(invNo)];
    for echo = 1 : 4 
        new_path = sprintf('%s/echo%d/', rec_path, echo);
        for sliceNo = 1 : 320 
            fpath = sprintf('%s/rec_CSPC_slice%d.mat', new_path, sliceNo);
            load(fpath); 
            img_all(sliceNo,:,:) = img_pc;
            mag(sliceNo,:,:) = abs(img_pc);
            ph(sliceNo,:,:) = angle(img_pc); 
        end
        save(sprintf('img_echo%d_inv%d.mat', echo, invNo),'img_all');
        niftiwrite(mag, sprintf('mag_echo%d_inv%d.nii', echo, invNo))
        niftiwrite(ph, sprintf('ph_echo%d_inv%d.nii', echo, invNo))
    end 
end