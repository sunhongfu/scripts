

clear 
clc 

for echo = 1 : 9 

    DataObj = matfile(['/QRISdata/Q1041/CSMEMP2RAGE/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54/k_full_echo' num2str(echo) '.mat']);

    for FileNo = 1 : 2
        dataFolder = ['/scratch/user/uqhsun8/CSPC_CSMP2RAGE/meas_MID00274_FID15744_wip925b_TI2_ECHO9_VC_CS9_SAM54/inv', num2str(FileNo)];
        mkdir(dataFolder)
        raw_ksp = DataObj.kData(:, :, :, :, FileNo);
        raw_ksp = fftshift(fft(fftshift(raw_ksp, 1), [], 1), 1);
        % raw_ksp = raw_ksp(161:480,:,:,:);
        for sliceNo = 161:480
            ksp_1slice = squeeze(raw_ksp(sliceNo, :, :, :)); 
            data_path = sprintf('%s/ksp_echo%d_slice%d.mat', dataFolder,... 
                        echo, sliceNo-160);
            disp(sliceNo)
            save(data_path, 'ksp_1slice')
        end 
        clear raw_ksp
    end

    clear DataObj

end