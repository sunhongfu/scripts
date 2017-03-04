nii=load_nii('mask_ero3.nii');
mask_ero3=double(nii.img);

nii=load_nii('TFS_TIK_PRE_ERO0/TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero0=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO1/TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero1=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO2/TIK_ero2_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero2=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO3/TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero3=double(nii.img);

diff_ero0=(tik_ero0-tik_ero3).*mask_ero3;
diff_ero1=(tik_ero1-tik_ero3).*mask_ero3;
diff_ero2=(tik_ero2-tik_ero3).*mask_ero3;

rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(mask_ero3(:)))
rmse_ero1= sqrt(sum(diff_ero1(:).^2)/sum(mask_ero3(:)))
rmse_ero2= sqrt(sum(diff_ero2(:).^2)/sum(mask_ero3(:)))


nii = load_nii('cosmos_5_resharp1e-6.nii');
chi_cosmos = double(nii.img);
mask_comos = ones(size(chi_cosmos));
mask_comos(chi_cosmos==0) = 0;

nii = load_nii('mask_ero3.nii');
mask_ero3 = double(nii.img);
mask_ero3 = mask_ero3 & mask_comos;

nii=load_nii('TFS_TIK_PRE_ERO0/TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero0=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO1/TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero1=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO2/TIK_ero2_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero2=double(nii.img);
nii=load_nii('TFS_TIK_PRE_ERO3/TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000.nii');
tik_ero3=double(nii.img);


diff_ero0=(tik_ero0-chi_cosmos).*mask_ero3;
diff_ero1=(tik_ero1-chi_cosmos).*mask_ero3;
diff_ero2=(tik_ero2-chi_cosmos).*mask_ero3;
diff_ero3=(tik_ero3-chi_cosmos).*mask_ero3;

rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(mask_ero3(:)))
rmse_ero1= sqrt(sum(diff_ero1(:).^2)/sum(mask_ero3(:)))
rmse_ero2= sqrt(sum(diff_ero2(:).^2)/sum(mask_ero3(:)))
rmse_ero3= sqrt(sum(diff_ero3(:).^2)/sum(mask_ero3(:)))


nii=load_nii('TFS_TFI_ERO0/TFI_ero0.nii');
tfi_ero0=double(nii.img);
nii=load_nii('TFS_TFI_ERO1/TFI_ero1.nii');
tfi_ero1=double(nii.img);
nii=load_nii('TFS_TFI_ERO2/TFI_ero2.nii');
tfi_ero2=double(nii.img);
nii=load_nii('TFS_TFI_ERO3/TFI_ero3.nii');
tfi_ero3=double(nii.img);


diff_ero0=(tfi_ero0-chi_cosmos).*mask_ero3;
diff_ero1=(tfi_ero1-chi_cosmos).*mask_ero3;
diff_ero2=(tfi_ero2-chi_cosmos).*mask_ero3;
diff_ero3=(tfi_ero3-chi_cosmos).*mask_ero3;

rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(mask_ero3(:)))
rmse_ero1= sqrt(sum(diff_ero1(:).^2)/sum(mask_ero3(:)))
rmse_ero2= sqrt(sum(diff_ero2(:).^2)/sum(mask_ero3(:)))
rmse_ero3= sqrt(sum(diff_ero3(:).^2)/sum(mask_ero3(:)))



nii=load_nii('TFS_PDF_ERO0/MEDI_PDF_ero0.nii');
pdf_ero0=double(nii.img);
nii=load_nii('TFS_PDF_ERO1/MEDI_PDF_ero1.nii');
pdf_ero1=double(nii.img);
nii=load_nii('TFS_PDF_ERO2/MEDI_PDF_ero2.nii');
pdf_ero2=double(nii.img);
nii=load_nii('TFS_PDF_ERO3/MEDI_PDF_ero3.nii');
pdf_ero3=double(nii.img);


diff_ero0=(pdf_ero0-chi_cosmos).*mask_ero3;
diff_ero1=(pdf_ero1-chi_cosmos).*mask_ero3;
diff_ero2=(pdf_ero2-chi_cosmos).*mask_ero3;
diff_ero3=(pdf_ero3-chi_cosmos).*mask_ero3;

rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(mask_ero3(:)))
rmse_ero1= sqrt(sum(diff_ero1(:).^2)/sum(mask_ero3(:)))
rmse_ero2= sqrt(sum(diff_ero2(:).^2)/sum(mask_ero3(:)))
rmse_ero3= sqrt(sum(diff_ero3(:).^2)/sum(mask_ero3(:)))




nii=load_nii('TFS_RESHARP_ERO3/MEDI_RESHARP_1e-6_ero3.nii');
resharp_ero0=double(nii.img);
diff_ero0=(resharp_ero0-chi_cosmos).*mask_ero3;
rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(mask_ero3(:)))

cd SS
nii=load_nii('iFreq_rawSS_QSM_000.nii');
ss_ero0=double(nii.img);
nii=load_nii('mask_SS.nii');
ss_mask=double(nii.img);
ss_mask = ss_mask & mask_comos & mask_ero3;
diff_ero0=(ss_ero0-chi_cosmos).*ss_mask;
rmse_ero0= sqrt(sum(diff_ero0(:).^2)/sum(ss_mask(:)))



