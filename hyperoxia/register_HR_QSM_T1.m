% register highres QSM to highres T1
% run on "sunwapta"
% bottom part runs on office-fedora

% interpolate images

nii = load_nii('T1_nifti.nii');
img = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);


img = flipdim(permute(img,[2 3 1]),1);
vox = permute(vox,[2 3 1]);
imsize = size(img);

nii = make_nii(img,vox);
save_nii(nii,'anatomical.nii');

% zero padding the k-space
k = fftshift(fftshift(fftshift(fft(fft(fft(img,[],1),[],2),[],3),1),2),3);
k = padarray(k,double(imsize(1:3)/2));
img = ifft(ifft(ifft(ifftshift(ifftshift(ifftshift(k,1),2),3),[],1),[],2),[],3);
clear k;

imsize = size(img);
vox = vox/2;

nii = make_nii(abs(img),vox);
save_nii(nii,'T1_interp.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% register highres QSM with highres T1
flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=25_6/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/mag_25_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/25_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=25_6/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/25_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/QSM_25_to_T1.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii

#######################################################################################################################


% register highres QSM with highres T1
flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=50_10/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/mag_50_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/50_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=50_10/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/50_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/QSM_50_to_T1.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii


#######################################################################################################################


% register highres QSM with highres T1
flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=75_13/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/mag_75_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/75_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=75_13/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/75_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/QSM_75_to_T1.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii




#######################################################################################################################


% register highres QSM with highres T1
flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=100_16/combine/mag_cmb1.nii -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/mag_100_to_T1.nii -omat /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/100_to_T1.mat -bins 256 -cost corratio -searchrx -180 180 -searchry -180 180 -searchrz -180 180 -dof 6  -interp trilinear


flirt -in /media/data/Hongfu/Project_Hyperoxia/HR_recon_QSM_O2=100_16/RESHARP/sus_resharp_0.0008_500.nii -applyxfm -init /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/100_to_T1.mat -out /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/QSM_100_to_T1.nii -paddingsize 0.0 -interp trilinear -ref /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/T1_interp.nii



#######################################################################################################################
# segment WM GM CSF from highres T1
# first BET the highres T1

bet T1_interp.nii BET -f 0.2 -m -R

# segment with FAST
/usr/share/fsl/5.0/bin/fast -t 1 -n 3 -H 0.1 -I 4 -l 20.0 -o /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/BET /media/data/Hongfu/Project_Hyperoxia/HR_QSM_to_HR_T1/BET



% find the common areas of the 4 masks.
% load in the registered highres QSM
nii = load_nii('/mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/highres_QSM/highres_QSM_75/QSM_highres_75.nii')
QSM_highres_75 = double(nii.img);

nii = load_nii('/mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/highres_QSM/highres_QSM_50/QSM_highres_50.nii')
QSM_highres_50 = double(nii.img);

nii = load_nii('/mnt/DATA/QSM/Ethan_QSM_data/Hongfu_hyperoxia/Tluclu3R/study/highres_QSM/highres_QSM_25/QSM_highres_25.nii')
QSM_highres_25 = double(nii.img);

mask = QSM_highres_25 & QSM_highres_50 & QSM_highres_75;
