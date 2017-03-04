load all.mat

imsize = size(ph_corr);
% laplacian unwrapping keeping the skulls
mag1 = mag(:,:,:,1);
mask = (mag1 > 0.2*median(mag1(logical(mask(:)))));

for i = 1:8
	unph(:,:,:,i) = unwrapLaplacian(squeeze(ph_corr(:,:,:,i)), imsize(1:3), vox);
end


nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
if strcmpi('bipolar',readout)
    unph_diff = unph_diff/2;
end

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo);
end

[tfs, fit_residual] = echofit(unph,mag,TE,0); 

fit_thr = 10;

% extra filtering according to fitting residuals
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(1./vox)*2+1); 
    nii = make_nii(fit_residual_blur,vox);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end


tfs = -tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm


% % pad 10 zero slices at both sides
% tfs = padarray(tfs,size(tfs)/2);
% mask = padarray(mask,size(mask)/2);
% %mask_whole(:,:,end-5:end) = 0;
% %mask_whole = padarray(mask_whole,[0 0 10]);
% R = padarray(R,size(R)/2);

% total field inversion
Tik_weight = 5e-4;
TV_weight = 5e-4;
[chi, res] = tfi_nlcg(tfs.*mask.*R, mask.*R, vox, z_prjs, Tik_weight, TV_weight, 1000);
nii = make_nii(chi,vox);
save_nii(nii,['chi_brain_Tik_' num2str(Tik_weight) '_TV_' num2str(TV) '.nii']);





% complex fitting
img_corr = mag.*exp(1j*ph_corr);
[p1, dp1, relres, p0]=Fit_ppm_complex(img_corr);



% full brain mask including skull
mask_brain = zeros(size(unph_lap));
mask_brain(mag(:,:,:,1)>2000) = 1;
nii = make_nii(mask_brain,vox);
save_nii(nii,'mask_brain.nii');


unph_lap = unwrapLaplacian(p1, [256 256 128], vox);
tfs = unph_lap/((TE(2)-TE(1))*2.675e8*dicom_info.MagneticFieldStrength)*1e6;


mask_full = ones([256 256 128]);

disp('--> unwrap aliasing phase using bestpath...');
    mask_unwrp = uint8(abs(mask_full)*255);
    fid = fopen('mask_unwrp.dat','w');
    fwrite(fid,mask_unwrp,'uchar');
    fclose(fid);

    [pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
    setenv('pathstr',pathstr);
    setenv('nv',num2str(imsize(1)));
    setenv('np',num2str(imsize(2)));
    setenv('ns',num2str(imsize(3)));

    unph = zeros(imsize);

    for echo_num = 1
        setenv('echo_num',num2str(echo_num));
        fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
        fwrite(fid,p1(:,:,:,echo_num),'float');
        fclose(fid);

        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
            'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
        unix(bash_script) ;

        fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
        tmp = fread(fid,'float');
        % tmp = tmp - tmp(1);
        unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask_full==1))/(2*pi))*2*pi ,imsize(1:3)).*mask_full;
        fclose(fid);

        fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
        reliability_raw = fread(fid,'float');
        reliability_raw = reshape(reliability_raw,imsize(1:3));
        fclose(fid);

        nii = make_nii(reliability_raw.*mask_full,vox);
        save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
    end

    nii = make_nii(unph,vox);
    save_nii(nii,'unph_bestpath.nii');

tfs = unph/((TE(2)-TE(1))*2.675e8*dicom_info.MagneticFieldStrength)*1e6;




% only L2 norm
chi = tfi(tfs, mask_brain, vox, z_prjs, 0.005);
nii = make_nii(chi.*mask_brain,vox);
save_nii(nii,'chi_l2_complex_fit_best_0.005_200.nii');


