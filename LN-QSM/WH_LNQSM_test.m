
mag1 = mag(:,:,:,1);
% mask_soft = (mag1 > 500);
% mag1 = sqrt(sum(mag.^2,4));
mask_soft = (mag1 > 2000);
mask_soft = double(mask_soft);
 

% pad 40 zeros
tfs_pad = padarray(tfs,[0 0 40]);
mask_soft_pad = padarray(mask_soft, [0 0 40]);


 P = mask_soft_pad+ 30*(1 - mask_soft_pad);

 chi_air20_P30 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 20);
 nii = make_nii(chi_air20_P30,vox);
 save_nii(nii,['air_outside_30_20.nii']);

 chi_air50_P30 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 50);
 nii = make_nii(chi_air50_P30,vox);
 save_nii(nii,['air_outside_30_50.nii']);

 chi_air100_P30 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 100);
 nii = make_nii(chi_air100_P30,vox);
 save_nii(nii,['air_outside_30_100.nii']);

 % chi_air300_P30 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 300);
 % nii = make_nii(chi_air300_P30,vox);
 % save_nii(nii,['air_outside_30_300.nii']);



 P = mask_soft_pad+ 60*(1 - mask_soft_pad);

 chi_air20_P60 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 20);
 nii = make_nii(chi_air20_P60,vox);
 save_nii(nii,['air_outside_60_20.nii']);

 chi_air50_P60 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 50);
 nii = make_nii(chi_air50_P60,vox);
 save_nii(nii,['air_outside_60_50.nii']);

 chi_air100_P60 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 100);
 nii = make_nii(chi_air100_P60,vox);
 save_nii(nii,['air_outside_60_100.nii']);

 % chi_air300_P60 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 300);
 % nii = make_nii(chi_air300_P60,vox);
 % save_nii(nii,['air_outside_60_300.nii']);



 P = mask_soft_pad+ 100*(1 - mask_soft_pad);

 chi_air20_P100 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 20);
 nii = make_nii(chi_air20_P100,vox);
 save_nii(nii,['air_outside_100_20.nii']);

 chi_air50_P100 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 50);
 nii = make_nii(chi_air50_P100,vox);
 save_nii(nii,['air_outside_100_50.nii']);

 chi_air100_P100 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 100);
 nii = make_nii(chi_air100_P100,vox);
 save_nii(nii,['air_outside_100_100.nii']);

 % chi_air300_P100 = tikhonov_qsm(tfs_pad, mask_soft_pad, 1 - mask_soft_pad, 0, 0, 0, 0, 0, 0, vox, P, z_prjs, 300);
 % nii = make_nii(chi_air300_P100,vox);
 % save_nii(nii,['air_outside_100_300.nii']);





 % foward calculation  
 % create K-space filter kernel D
 %%%%% make this a seperate function in the future
 [Nx, Ny, Nz] = size(chi);
 FOV  = vox.*[Nx, Ny, Nz];
 FOVx = FOV(1);
 FOVy = FOV(2);
 FOVz = FOV(3);

 x = -Nx/2:Nx/2-1;
 y = -Ny/2:Ny/2-1;
 z = -Nz/2:Nz/2-1;

 [kx, ky, kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
 D = 1/3 - (kx.*z_prjs(1) + ky.*z_prjs(2) + kz.*z_prjs(3)).^2 ./ (kx.^2 + ky.^2 + kz.^2);
 D(floor(Nx/2+1), floor(Ny/2+1), floor(Nz/2+1)) = 0;
 D = fftshift(D);


 data_air20_P30 = (tfs_pad - real(ifftn(D.*fftn(chi_air20_P30)))).*mask_soft_pad;
 nii = make_nii(data_air20_P30,vox);
 save_nii(nii,'data_air20_P30.nii');

 data_air50_P30 = (tfs_pad - real(ifftn(D.*fftn(chi_air50_P30)))).*mask_soft_pad;
 nii = make_nii(data_air50_P30,vox);
 save_nii(nii,'data_air50_P30.nii');

 data_air100_P30 = (tfs_pad - real(ifftn(D.*fftn(chi_air100_P30)))).*mask_soft_pad;
 nii = make_nii(data_air100_P30,vox);
 save_nii(nii,'data_air100_P30.nii');


 data_air20_P60 = (tfs_pad - real(ifftn(D.*fftn(chi_air20_P60)))).*mask_soft_pad;
 nii = make_nii(data_air20_P60,vox);
 save_nii(nii,'data_air20_P60.nii');

 data_air50_P60 = (tfs_pad - real(ifftn(D.*fftn(chi_air50_P60)))).*mask_soft_pad;
 nii = make_nii(data_air50_P60,vox);
 save_nii(nii,'data_air50_P60.nii');

 data_air100_P60 = (tfs_pad - real(ifftn(D.*fftn(chi_air100_P60)))).*mask_soft_pad;
 nii = make_nii(data_air100_P60,vox);
 save_nii(nii,'data_air100_P60.nii');


 data_air20_P100 = (tfs_pad - real(ifftn(D.*fftn(chi_air20_P100)))).*mask_soft_pad;
 nii = make_nii(data_air20_P100,vox);
 save_nii(nii,'data_air20_P100.nii');

 data_air50_P100 = (tfs_pad - real(ifftn(D.*fftn(chi_air50_P100)))).*mask_soft_pad;
 nii = make_nii(data_air50_P100,vox);
 save_nii(nii,'data_air50_P100.nii');

 data_air100_P100 = (tfs_pad - real(ifftn(D.*fftn(chi_air100_P100)))).*mask_soft_pad;
 nii = make_nii(data_air100_P100,vox);
 save_nii(nii,'data_air100_P100.nii');


% ?????????????
% ?????????????
% ?????????????
% tweak TV and TIK mask, maybe use the BET mask??????????????
% tweak the P as well!!!!
 mask_pad = padarray(mask,[0 0 40]);

 P = mask_soft_pad+ 30*(1 - mask_soft_pad);

 chi50_P30_ss = tikhonov_qsm(data_air50_P30, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 50);
 nii = make_nii(chi50_P30_ss,vox);
 save_nii(nii,['chi50_P30_ss.nii']);

 chi50_P30_mm = tikhonov_qsm(data_air50_P30, mask_soft_pad, 1, mask_pad, mask_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 50);
 nii = make_nii(chi50_P30_ss,vox);
 save_nii(nii,['chi50_P30_mm.nii']);

 % chi50_P30_hh = tikhonov_qsm(data_air50_P30, mask_soft_pad, 1, mask_head_pad, mask_head_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 50);
 % nii = make_nii(chi50_P30_hh,vox);
 % save_nii(nii,['chi50_P30_hh.nii']);


 P = 1;

 % chi50_P30_ss_P1 = tikhonov_qsm(data_air50_P30, mask_soft_pad, 1, mask_soft_pad, mask_soft_pad, 0, 5e-4, 2e-3, 0, vox, P, z_prjs, 50);
 % nii = make_nii(chi50_P30_ss_P1,vox);
 % save_nii(nii,['chi50_P30_ss_P1.nii']);

 chi50_P30_mm_P1 = tikhonov_qsm(data_air50_P30, mask_soft_pad, 1, mask_pad, mask_pad, mask_soft_pad - mask_pad, 5e-4, 2e-3, 0.01, vox, P, z_prjs, 50);
 nii = make_nii(chi50_P30_mm_P1,vox);
 save_nii(nii,['chi50_P30_mm_P1.nii']);



chi_total50_P30_ss = chi50_P30_ss + chi_air50_P30;
chi_total50_P30_mm = chi50_P30_mm + chi_air50_P30;
chi_total50_P1_ss = chi50_P30_ss_P1 + chi_air50_P30;
chi_total50_P1_mm = chi50_P30_mm_P1 + chi_air50_P30;
chi_total50_P1_mm = chi50_P30_mm_P1.*mask_soft_pad + chi_air50_P30;

nii = make_nii(chi_total50_P30_ss,vox);
save_nii(nii,'chi_total50_P30_ss.nii');
nii = make_nii(chi_total50_P30_mm,vox);
save_nii(nii,'chi_total50_P30_mm.nii');
nii = make_nii(chi_total50_P1_ss,vox);
save_nii(nii,'chi_total50_P1_ss.nii');
nii = make_nii(chi_total50_P1_mm,vox);
save_nii(nii,'chi_total50_P1_mm.nii');



