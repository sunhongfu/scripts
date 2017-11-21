%Tik-QSM helix script
function tik_qsm_helix(data_path,erosion)
	erosion = str2num(erosion);
	cd(data_path);

	load('all.mat','mask','R','matrix_size','voxel_size','delta_TE','B0_dir','CF','iMag','N_std','iFreq','tfs','vox','dicom_info','z_prjs');
	% apply R
	mask = mask.*R;
	% mask_erosion
	r = 1; 
	[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
	h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
	ker = h/sum(h(:));
	imsize = size(mask);
	mask_tmp = convn(mask,ker,'same');
	mask_ero1 = zeros(imsize);
	mask_ero1(mask_tmp > 0.999999) = 1; % no error tolerance
	r = 2; 
	[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
	h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
	ker = h/sum(h(:));
	imsize = size(mask);
	mask_tmp = convn(mask,ker,'same');
	mask_ero2 = zeros(imsize);
	mask_ero2(mask_tmp > 0.999999) = 1; % no error tolerance
	r = 3; 
	[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
	h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
	ker = h/sum(h(:));
	imsize = size(mask);
	mask_tmp = convn(mask,ker,'same');
	mask_ero3 = zeros(imsize);
	mask_ero3(mask_tmp > 0.999999) = 1; % no error tolerance

	nii = make_nii(mask,vox);
	save_nii(nii,'mask_ero0.nii');
	nii = make_nii(mask_ero1,vox);
	save_nii(nii,'mask_ero1.nii');
	nii = make_nii(mask_ero2,vox);
	save_nii(nii,'mask_ero2.nii');
	nii = make_nii(mask_ero3,vox);
	save_nii(nii,'mask_ero3.nii');

	% or from traditional tfs (prelude+fitting)
	iFreq = tfs*2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6;

switch erosion
case 0
	mkdir TFS_TIK_PRE_ERO0
	cd TFS_TIK_PRE_ERO0
	tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
	mask_pad = padarray(mask,[0 0 20]);
	% R_pad = padarray(R,[0 0 20]);
	r=0;
	Tik_weight = [1e-3];
	TV_weight = 4e-4;
	for i = 1:length(Tik_weight)
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
		chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
		nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
	end
	cd ..
case 1
	mkdir TFS_TIK_PRE_ERO1
	cd TFS_TIK_PRE_ERO1
	tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
	mask_pad = padarray(mask_ero1,[0 0 20]);
	% R_pad = padarray(R,[0 0 20]);
	r=1;
	Tik_weight = [1e-3];
	TV_weight = 4e-4;
	for i = 1:length(Tik_weight)
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
		chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
		nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
	end
	cd ..
case 2
	mkdir TFS_TIK_PRE_ERO2
	cd TFS_TIK_PRE_ERO2
	tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
	mask_pad = padarray(mask_ero2,[0 0 20]);
	% R_pad = padarray(R,[0 0 20]);
	r=2;
	Tik_weight = [1e-3];
	TV_weight = 4e-4;
	for i = 1:length(Tik_weight)
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
		chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
		nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
	end
	cd ..
case 3
	mkdir TFS_TIK_PRE_ERO3
	cd TFS_TIK_PRE_ERO3
	tfs_pad = padarray(iFreq/(2.675e8*dicom_info.MagneticFieldStrength*delta_TE*1e-6),[0 0 20]);
	mask_pad = padarray(mask_ero3,[0 0 20]);
	% R_pad = padarray(R,[0 0 20]);
	r=3;
	Tik_weight = [1e-3];
	TV_weight = 4e-4;
	for i = 1:length(Tik_weight)
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 200);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_200.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 500);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_500.nii']);
		% chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 2000);
		% nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		% save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_2000.nii']);
		chi = tikhonov_qsm(tfs_pad, mask_pad, 1, mask_pad, mask_pad, TV_weight, Tik_weight(i), vox, z_prjs, 5000);
		nii = make_nii(chi(:,:,21:end-20).*mask_pad(:,:,21:end-20),vox);
		save_nii(nii,['TIK_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight(i)) '_PRE_5000.nii']);
	end
	cd ..
otherwise
        warning('Unexpected value')
end



