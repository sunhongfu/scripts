

clear 
clc 

DataObj = matfile('k_full.mat');

for FileNo = 1 : 2
    dataFolder = ['/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00277_FID15747_wip925b_TI2_EC2_VC_CS8_p75iso/inv', num2str(FileNo)];
    mkdir(dataFolder)
    for echo = 1 : 4 
        raw_ksp = squeeze(DataObj.k_full(:, :, :, echo, :, FileNo));
        new_ksp = fftshift(fft(fftshift(raw_ksp, 1), [], 1), 1);
        for sliceNo = 161 : 480
            ksp_1slice = squeeze(new_ksp(sliceNo, :, :, :)); 
            data_path = sprintf('%s/ksp_echo%d_slice%d.mat', dataFolder,... 
                        echo, sliceNo);
            disp(sliceNo)
            save(data_path, 'ksp_1slice')
        end
    end 
end