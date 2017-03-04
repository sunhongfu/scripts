load all.mat

% try total field inversion on regular mask, regular prelude
Tik_weight = 0.05;
TV_weight = 1e-3;

% pad zeros
tfs = padarray(tfs,[0 0 20]);
mask = padarray(mask,[0 0 20]);

[chi, res] = tfi(tfs, mask.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000_poly.nii']);



% erode the original mask 2 voxels
r = 2;

[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask);
mask_tmp = convn(mask,ker,'same');
mask_ero = zeros(imsize);
mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance


[chi, res] = tfi(tfs, mask_ero.*R, 1, mask_ero.*R, mask_ero.*R, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_brain_ero_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000_poly.nii']);



tfs_pad = padarray(tfs,[0 0 10]);
mask_pad = padarray(mask,[0 0 10]);
R_pad = padarray(R,[0 0 10]);

[chi_pad, res_pad] = tfi_nlcg(tfs_pad, mask_pad.*R_pad, 1, mask_pad.*R_pad, vox, z_prjs, Tik_weight, TV_weight, 1000);
chi = chi_pad(:,:,11:end-10);
nii = make_nii(chi.*mask.*R,vox);
save_nii(nii,['chi_pad_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% try whole brain total inversion on whole brain, laplacian unwrapping
imsize = size(ph_corr);
mag1 = mag(:,:,:,1);
mask_b = (mag1 > 0.5*median(mag1(logical(mask(:)))));
mask_b = double(mask_b);

%%% important %%%
mask_b = double(mask_b | mask);

for i = 1:8
	unph(:,:,:,i) = unwrapLaplacian(squeeze(ph_corr(:,:,:,i)), imsize(1:3), vox);
end


% nii = load_nii('unph_diff.nii');
% unph_diff = double(nii.img);
% if strcmpi('bipolar',readout)
%     unph_diff = unph_diff/2;
% end

% for echo = 2:imsize(4)
%     meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
%     meandiff = meandiff(mask==1);
%     meandiff = mean(meandiff(:));
%     njump = round(meandiff/(2*pi));
%     disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
%     unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
%     unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
% end

[tfs, fit_residual] = echofit(unph,mag,TE,0); 

fit_thr = 10;

% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    % fit_residual_blur = smooth3(fit_residual,'box',round(1./vox)*2+1); 
    % nii = make_nii(fit_residual_blur,vox);
    % save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual));
    R(fit_residual >= fit_thr) = 0;
else
    R = 1;
end


tfs = -tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm

% fill in the holes of head mask
mask_h = MaskFilling(mask_b, 12);


% mask_h = mask_h(:,:,3:143);
% tfs = tfs(:,:,3:143);
% mask_b = mask_b(:,:,3:143);
% R = R(:,:,3:143);
% mask = mask(:,:,3:143);

% total field inversion
Tik_weight = 5e-4;
TV_weight = 5e-4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this is the best one so far!!!
[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b, 1, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_Mb_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% padding 20 slices each direction
tfs_pad = padarray(tfs,[0 0 20]);
mask_b_pad = padarray(mask_b,[0 0 20]);
R_pad = padarray(R,[0 0 20]);

[chi_pad, res_pad] = tfi_nlcg(tfs_pad, mask_b_pad.*R_pad, 1, mask_b_pad, mask_b_pad, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi_pad,vox);
save_nii(nii,['chi_pad_MbxR_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

[chi_pad, res_pad] = tfi_nlcg(tfs_pad, mask_b_pad, 1, mask_b_pad, mask_b_pad, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi_pad,vox);
save_nii(nii,['chi_pad_Mb_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% !!!! seems like truncate the first and last two slices is a better idea than padding !!!
mask_h = mask_h(:,:,3:143);
tfs = tfs(:,:,3:143);
mask_b = mask_b(:,:,3:143);
R = R(:,:,3:143);
mask = mask(:,:,3:143);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_trunc_MbxR_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b, 1, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_trunc_Mb_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 


[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask_b.*R, mask_b.*R, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_MbxR_MbxR_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);


[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_MxR_MxR_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask.*R, mask_h, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_MxR_Mh_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, mask_b.*R, mask_h, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_MbxR_Mh_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, 1, 0, mask_h, 0, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_1_MbxR_Mh_Tik_' num2str(0) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_h, 1, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_Mh_1_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% force susceptibility sources to be inside of the head mask_h
mask_h = mask_h(:,:,3:143);
tfs = tfs(:,:,3:143);
mask_b = mask_b(:,:,3:143);
R = R(:,:,3:143);
mask = mask(:,:,3:143);

Tik_weight = 5e-4;
TV_weight = 5e-4;

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_trunc_MbxR_Mh_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b, mask_h, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 2000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_trunc_Mb_Mh_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '_2000.nii']);





[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask_b.*R, mask_b.*R, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_MbxR_MbxR_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask.*R, mask.*R, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_MxR_MxR_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask.*R, mask_h, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_MxR_Mh_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, mask_b.*R, mask_h, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_MbxR_Mh_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_b.*R, mask_h, 0, mask_h, 0, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_MbxR_Mh_MbxR_Mh_Tik_' num2str(0) '_TV_' num2str(TV_weight) '.nii']);

[chi, res] = tfi_nlcg(tfs, mask_h, mask_h, mask_b, mask_b, Tik_weight, TV_weight, vox, z_prjs, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_Mh_Mh_Mb_Mb_Tik_' num2str(Tik_weight) '_TV_' num2str(TV_weight) '.nii']);

