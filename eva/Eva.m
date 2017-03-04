load vol_nlm.mat
mag = double(vol_nlm);
% flip dim
mag = flipdim(mag,2);
vox = hdr_nlm.info.voxel_size;

nii = make_nii(mag,vox);
save_nii(nii,'mag.nii');

load vol.mat
ph = double(vol/4096*pi);
ph = flipdim(ph,2);

nii = make_nii(ph,vox);
save_nii(nii,'ph.nii');

TE1= 2.4;
ES = 1.2;

TE = TE1 + (0:63)*ES;
TE = TE/1000;
imsize = size(mag);

dicom_info = dicominfo('MR.1.3.12.2.1107.5.2.32.35056.2016101113331840104215330.dcm');

% angles!!!
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
%Zz = sqrt(1 - Xz^2 - Yz^2);
Zxyz = cross(dicom_info.ImageOrientationPatient(1:3),dicom_info.ImageOrientationPatient(4:6));
Zz = Zxyz(3);
z_prjs = [Xz, Yz, Zz];

% save magnitude and raw phase niftis for each echo
mkdir('src')
for echo = 1:imsize(4)
    nii = make_nii(mag(:,:,:,echo),vox);
    save_nii(nii,['src/mag' num2str(echo) '.nii']);
    nii = make_nii(ph(:,:,:,echo),vox);
    save_nii(nii,['src/ph' num2str(echo) '.nii']);
end

bet_smooth = 1;
bet_thr = 0.4;
% brain extraction
% generate mask from magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('bet_smooth',num2str(bet_smooth));
[status,cmdout] = unix('rm BET*');
unix('bet2 src/mag1.nii BET -f ${bet_thr} -m -w ${bet_smooth}');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


readout = 'bipolar'
% phase offset correction
% if unipolar
if strcmpi('unipolar',readout)
    ph_corr = geme_cmb(mag.*exp(1j*ph),vox,TE,mask);
% if bipolar
elseif strcmpi('bipolar',readout)
    ph_corr = zeros(imsize);
    ph_corr(:,:,:,1:2:end) = geme_cmb(mag(:,:,:,1:2:end).*exp(1j*ph(:,:,:,1:2:end)),vox,TE(1:2:end),mask);
    ph_corr(:,:,:,2:2:end) = geme_cmb(mag(:,:,:,2:2:end).*exp(1j*ph(:,:,:,2:2:end)),vox,TE(2:2:end),mask);
else
    error('is the sequence unipolar or bipolar readout?')
end

% save offset corrected phase niftis
for echo = 1:imsize(4)
    nii = make_nii(ph_corr(:,:,:,echo),vox);
    save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end



% unwrap phase from each echo
if strcmpi('prelude',ph_unwrap)
    disp('--> unwrap aliasing phase for all TEs using prelude...');
    setenv('echo_num',num2str(imsize(4)));
    bash_command = sprintf(['for ph in src/ph_corr*.nii\n' ...
    'do\n' ...
    '   base=`basename $ph`;\n' ...
    '   dir=`dirname $ph`;\n' ...
    '   mag=$dir/"mag"${base:7};\n' ...
    '   unph="unph"${base:7};\n' ...
    '   prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
    'done\n' ...
    'wait\n' ...
    'gunzip -f unph*.gz\n']);
    unix(bash_command);

    unph = zeros(imsize);
    for echo = 1:imsize(4)
        nii = load_nii(['unph' num2str(echo) '.nii']);
        unph(:,:,:,echo) = double(nii.img);
    end
end

% unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

[pathstr, ~, ~] = fileparts(which('3DSRNCP.m'));
setenv('pathstr',pathstr);
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph = zeros(imsize);

for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph_corr(:,:,:,echo_num),'float');
    fclose(fid);

    bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,vox);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

nii = make_nii(unph,vox);
save_nii(nii,'unph_bestpath.nii');


% 2pi jumps correction
nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);
unph_diff = unph_diff/2;

for echo = 2:imsize(4)
    meandiff = unph(:,:,:,echo)-unph(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:));
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph(:,:,:,echo) = unph(:,:,:,echo) - njump*2*pi;
    unph(:,:,:,echo) = unph(:,:,:,echo).*mask;
end



% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph,mag,TE,0); 


% % extra filtering according to fitting residuals
% fit_thr = 200;
% % generate reliability map
% fit_residual_blur = smooth3(fit_residual,'box',round(1./vox)*2+1); 
% nii = make_nii(fit_residual_blur,vox);
% save_nii(nii,'fit_residual_blur.nii');
% R = ones(size(fit_residual_blur));
% R(fit_residual_blur >= fit_thr) = 0;

% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 4.7T
tfs = tfs/(2.675e8*3)*1e6; % unit ppm

nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');


% generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(1./vox)*2+1); 
    nii = make_nii(fit_residual_blur,vox);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= 100) = 0;


% LBV
lbv_tol = 0.01;
lbv_peel = 0;
tv_reg = 5e-4;
inv_num = 500;
% if sum(strcmpi('lbv',bkg_rm))
    disp('--> LBV to remove background field ...');
    lfs_lbv = LBV(tfs,mask,imsize(1:3),vox,lbv_tol,lbv_peel); % strip 2 layers
    mask_lbv = ones(imsize(1:3));
    mask_lbv(lfs_lbv==0) = 0;
    % 3D 2nd order polyfit to remove any residual background
    lfs_lbv= lfs_lbv - poly3d(lfs_lbv,mask_lbv);

    % save nifti
    mkdir('LBV');
    nii = make_nii(lfs_lbv.*mask_lbv,vox);
    save_nii(nii,'LBV/lfs_lbv.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on lbv...');
    sus_lbv = tvdi(lfs_lbv,mask_lbv,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num);   

    % save nifti
    nii = make_nii(sus_lbv.*mask_lbv,vox);
    save_nii(nii,['LBV/sus_lbv_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);
% end


if sum(strcmpi('pdf',bkg_rm))
    disp('--> PDF to remove background field ...');
    [lfs_pdf,mask_pdf] = projectionontodipolefields(tfs,mask,vox,mag(:,:,:,end),z_prjs);
    % 3D 2nd order polyfit to remove any residual background
    % lfs_pdf= lfs_pdf - poly3d(lfs_pdf,mask_pdf);

    % save nifti
    [status,message,messageid] = mkdir('PDF');
    nii = make_nii(lfs_pdf,vox);
    save_nii(nii,'PDF/lfs_trunc_pdf.nii');

    % inversion of susceptibility 
    disp('--> TV susceptibility inversion on PDF...');
    sus_pdf = tvdi(lfs_pdf,mask_pdf,vox,tv_reg,mag(:,:,:,end),z_prjs,inv_num); 

    % save nifti
    nii = make_nii(sus_pdf.*mask_pdf,vox);
    save_nii(nii,['PDF/sus_trunc_pdf_tv_', num2str(tv_reg), '_num_', num2str(inv_num), '.nii']);
end



% Tik-QSM

% pad zeros
tfs = padarray(tfs,[0 0 20]);
mask = padarray(mask.*R,[0 0 20]);

% try total field inversion on regular mask, regular prelude
    Tik_weight = 0.005;
    TV_weight = 0.003;
    r = 0;
    [chi, res] = tikhonov_qsm(tfs, mask, 1, mask, mask, TV_weight, Tik_weight, vox, z_prjs, 200);
    nii = make_nii(chi(:,:,21:end-20).*mask(:,:,21:end-20),vox);
    save_nii(nii,['chi_brain_pad20_R_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_2000.nii']);



for r = [1 2 3] 

    [X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
    h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
    ker = h/sum(h(:));
    imsize = size(mask);
    mask_tmp = convn(mask.*R,ker,'same');
    mask_ero = zeros(imsize);
    mask_ero(mask_tmp > 1-1/sum(h(:))) = 1; % no error tolerance

    % try total field inversion on regular mask, regular prelude
    Tik_weight = 0.005;
    TV_weight = 0.003;
    [chi, res] = tikhonov_qsm(tfs, mask_ero, 1, mask_ero, mask_ero, TV_weight, Tik_weight, vox, z_prjs, 2000);
    nii = make_nii(chi(:,:,21:end-20).*mask_ero(:,:,21:end-20),vox);
    save_nii(nii,['chi_brain_pad20_ero' num2str(r) '_TV_' num2str(TV_weight) '_Tik_' num2str(Tik_weight) '_2000.nii']);

end