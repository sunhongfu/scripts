load all.mat

% laplacian unwrapping keeping the skulls
for i = 1:8
	unph_lap(:,:,:,i) = unwrapLaplacian(squeeze(ph_corr(:,:,:,i)), [256 256 128], vox);
end

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


