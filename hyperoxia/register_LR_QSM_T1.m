% register lowres QSM to lowres T1
% run on "sunwapta"

% interpolate images

nii = load_nii('T1_nifti.nii');
img = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);


img = flipdim(permute(img,[2 3 1]),1);
vox = permute(vox,[2 3 1]);
imsize = size(img);

nii = make_nii(img,vox);
save_nii(nii,'anatomical.nii');



% register highres QSM with highres T1
flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/lowres/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/25_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/25_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/lowres/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/25_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=25_6/QSM_25.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/lowres/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/50_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/50_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/lowres/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/50_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=50_10/QSM_50.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/lowres/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/75_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/75_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/lowres/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/75_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=75_13/QSM_75.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/lowres/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/100_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/100_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear

flirt -in /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/lowres/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/100_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/recon_QSM_O2=100_16/QSM_100.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/anatomical.nii

