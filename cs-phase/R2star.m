
% all_dirs = {'/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF4_001/CSPC_recon_lamda_003_005/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF4_001/CSPC_recon_lamda_01_015/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF4_002/CSPC_recon_lamda_003_005/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF4_002/CSPC_recon_lamda_01_015/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF8_001/CSPC_recon_lamda_003_005/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF8_001/CSPC_recon_lamda_01_015/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF8_002/CSPC_recon_lamda_003_005/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/07_June_CSPC/AF8_002/CSPC_recon_lamda_01_015/cspc_HScoils', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/DCRNet_sim_recon_dc_AF4/new-coil', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/DCRNet_sim_recon_dc_AF8/new-coil', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/full', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/GRAPPA2X2', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/GRAPPA3X3', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/zf_AF4', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_001/zf_AF8', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/DCRNet_sim_recon_dc_AF4/new-coil', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/DCRNet_sim_recon_dc_AF8/new-coil', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/full', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/zf_AF4', '/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/zf_AF8'}

all_dirs = {'/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/GRAPPA2X2','/Volumes/LaCie_Top/CS-phase/invivo/2021_06_04_CS_QSM_002/GRAPPA2X2_reg','/Volumes/LaCie_Top/CS-phase/invivo/11_June_DCRNet/AF4_001/CANet_sim_recon_dc_AF4/new-coil','/Volumes/LaCie_Top/CS-phase/invivo/11_June_DCRNet/AF4_002/CANet_sim_recon_dc_AF4/new-coil','/Volumes/LaCie_Top/CS-phase/invivo/11_June_DCRNet/AF8_001/CANet_sim_recon_dc_AF8/new-coil','/Volumes/LaCie_Top/CS-phase/invivo/11_June_DCRNet/AF8_002/CANet_sim_recon_dc_AF8/new-coil'}


for i = 1:6
    cd(all_dirs{i})


            echonum = 8
            mag = [];
            for i = 1:echonum
                nii = load_nii(['src/mag_corr' num2str(i) '.nii']);
                mag(:,:,:,i) = double(nii.img);
            end

            TE = [0.0034    0.0069    0.0104    0.0139    0.0174    0.0209    0.0244    0.0279];
            vox = [1 1 1];

            nii = load_nii('RESHARP/chi_iLSQR_smvrad3.nii');
            mask = double(nii.img~=0);

            [R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 echonum]));
            nii = make_nii(R2,vox);
            save_nii(nii,'R2.nii');
            nii = make_nii(T2,vox);
            save_nii(nii,'T2.nii');
            nii = make_nii(amp,vox);
            save_nii(nii,'amp.nii');

end