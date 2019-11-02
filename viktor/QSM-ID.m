nii = load_nii('/Users/uqhsun8/Desktop/RFID_2/ID/GRE/PHASE/PHASE_gre_20190926130811_7_ph.nii');
ph = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);
imsize = size(ph);
% scale ph back to -pi to pi
ph = ph/4095*2*pi - pi;

% generate the mask by thresholding
nii = load_nii('/Users/uqhsun8/Desktop/RFID_2/ID/GRE/MAGN/MAGN_gre_20190926130811_6.nii');
mag = double(nii.img);
mask = ones(imsize);
mask(mag<50) = 0;
% fill in the holes
% mask_filled = MaskFilling(mask, 5);
% nii = make_nii(mask_filled,vox);
% save_nii(nii,'mask_filled.nii');
for i = 1:imsize(2)
    mask(:,i,:) = imfill(squeeze(mask(:,i,:)), 'holes');
end

nii = make_nii(mask,vox);
save_nii(nii,'mask.nii');


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

for echo_num = 1
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph(:,:,:,echo_num),'float');
    fclose(fid);
    if isdeployed
        bash_script = ['~/bin/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    else    
        bash_script = ['${pathstr}/3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    end
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

% laplacian unwrapping
Options.voxelSize = vox;
iFreq_lap = lapunwrap(ph.*mask, Options);

% to scale with TE and field strength
tfs = iFreq_lap/(2.675e8*3*0.015*1e-6);
nii = make_nii(tfs,vox);
save_nii(nii,'tfs.nii');

% backgrond field removal
[lfs_resharp, mask_resharp] = resharp(tfs,mask,vox,2,1e-4,200);
nii = make_nii(lfs_resharp,vox);
save_nii(nii,'lfs_resharp.nii');

% LBV background field removal
lfs_lbv = LBV(tfs,mask,imsize(1:3),vox,1e-4,0); % strip 2 layers
mask_lbv = ones(imsize(1:3));
mask_lbv(lfs_lbv==0) = 0;
nii = make_nii(lfs_lbv,vox);
save_nii(nii,'lfs_lbv.nii');


% (2) magnitude threshold weighted
thr = 0.1;
img_smooth = smooth3(mag,'gaussian',[5,3,5],2);
% calculate the median value of magnitude
tmp = img_smooth(logical(mask_lbv));
size(tmp)
median(tmp(:))
hemo_mask = mask_lbv;
hemo_mask((img_smooth<=thr*median(tmp(:)))) = 0;
nii = make_nii(hemo_mask,vox);
save_nii(nii,['hemo_mask_' num2str(thr) '.nii']);

weights = mag./max(mag(:)).*hemo_mask;

weights = smooth3(weights,'gaussian',[5,3,5],2);

nii = make_nii(weights,vox);
save_nii(nii,'weights.nii');



% inversion of susceptibility 
disp('--> TV susceptibility inversion on lbv...');
sus_lbv = tvdi(lfs_lbv,mask_lbv,vox,1e-4, ...
    weights,[0 0 1],200);   

% save nifti
nii = make_nii(sus_lbv.*mask_lbv,vox);
save_nii(nii,'sus_lbv_masked.nii');



% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_lbv*(2.675e8*3)/1e6,mask_lbv,'H',[0 0 1],'voxelsize',vox,'niter',50,'TE',1000,'B0',3);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_iLSQR.nii']);



% iLSQR
chi_iLSQR = QSM_iLSQR(lfs_resharp*(2.675e8*3)/1e6,mask_resharp,'H',[0 0 1],'voxelsize',vox,'niter',50,'TE',1000,'B0',3);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,['chi_iLSQR.nii']);


% MEDI
%%%%% normalize signal intensity by noise to get SNR %%%
%%%% Generate the Magnitude image %%%%
iMag = sqrt(sum(mag.^2,4));
% [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
matrix_size = single(imsize(1:3));
voxel_size = vox;
delta_TE = 0.015;
B0_dir = [0 0 1]';
CF = 123.229536 *1e6;
iFreq = [];
N_std = 1;
RDF = lfs_resharp*2.675e8*3*delta_TE*1e-6;
Mask = mask_resharp;
save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
        voxel_size delta_TE CF B0_dir;
QSM = MEDI_L1('lambda',1000);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,['MEDI1000_RESHARP.nii']);

QSM = MEDI_L1('lambda',100);
nii = make_nii(QSM.*Mask,vox);
save_nii(nii,['MEDI100_RESHARP.nii']);



sudo cp /Applications/MATLAB_R2019a.app/bin/maci64/libmex.dylib /usr/lib/