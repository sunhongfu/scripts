% read in MESPGR dicoms (multi-echo gradient-echo)
dicom_all='QSM_O2=100_16';

dicom_all = cd(cd(dicom_all));
dicom_all_list = dir(dicom_all);

dicom_info = dicominfo([dicom_all,filesep,dicom_all_list(3).name]);
dicom_info.EchoTrainLength = 8;

imsize = [dicom_info.Width, dicom_info.Height, (length(dicom_all_list)-2)/dicom_info.EchoTrainLength/4, ...
			 dicom_info.EchoTrainLength];
vox = [dicom_info.PixelSpacing(1), dicom_info.PixelSpacing(2), dicom_info.SliceThickness];


chopper = double(mod(1:imsize(3),2)) ;
chopper( chopper < 1 ) = -1 ;

Counter = 1;
for zCount = 1 : imsize(3)
    for echoCount = 1 : imsize(4)

		%tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        theReal = ...
            permute(chopper(zCount)*double( dicomread( [dicom_all,filesep,dicom_all_list(Counter+2).name] ) ),[2 1]) ;
        dicom_info = dicominfo([dicom_all,filesep,dicom_all_list(Counter+2).name]);
	    TE(dicom_info.EchoNumber) = dicom_info.EchoTime*1e-3;
		Counter = Counter + 1 ;
        
        %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
        theImag = ...
            permute(chopper(zCount)*double( dicomread( [dicom_all,filesep,dicom_all_list(Counter+2).name] ) ),[2 1]) ;    
        Counter = Counter + 1 ;
        
        img(:,:,zCount,echoCount) = theReal ...
            + 1j * theImag ;

	end

end

mkdir('recon_QSM_O2=100_16');
cd recon_QSM_O2=100_16;

img = single(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zero padding the k-space
k = fftshift(fftshift(fftshift(fft(fft(fft(img,[],1),[],2),[],3),1),2),3);
k = padarray(k,double(imsize(1:3)/2));
img = ifft(ifft(ifft(ifftshift(ifftshift(ifftshift(k,1),2),3),[],1),[],2),[],3);
clear k;

imsize = size(img);
vox = vox/2;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% save niftis for each echotime
mkdir('combine');
for echo = 1:imsize(4)
    nii = make_nii(abs(img(:,:,:,echo)),vox);
    save_nii(nii,['combine/mag_cmb' num2str(echo) '.nii']);
end

bet_thr = 0.4;
% generate mask from combined magnitude of the 1th echo
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
[status,cmdout] = unix('rm BET*');
unix('bet combine/mag_cmb1.nii BET -f ${bet_thr} -m -R');
unix('gunzip -f BET.nii.gz');
unix('gunzip -f BET_mask.nii.gz');
nii = load_nii('BET_mask.nii');
mask = double(nii.img);


mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

unix('cp /home/hsun/Documents/MATLAB/3DSRNCP 3DSRNCP');
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

ph_cmb = geme_cmb(img,vox,TE,mask);

% save niftis for each echotime
mkdir('combine');
for echo = 1:imsize(4)
    nii = make_nii((ph_cmb(:,:,:,echo)),vox);
    save_nii(nii,['combine/ph_cmb' num2str(echo) '.nii']);
end


% angles!!!
Xz = dicom_info.ImageOrientationPatient(3);
Yz = dicom_info.ImageOrientationPatient(6);
Zz = sqrt(1 - Xz^2 - Yz^2);
z_prjs = [Xz, Yz, Zz];


% % unwrap phase from each echo
% disp('--> unwrap aliasing phase for all TEs using prelude...');

% setenv('echo_num',num2str(imsize(4)));
% bash_command = sprintf(['for ph in combine/ph_cmb[1-$echo_num].nii\n' ...
% 'do\n' ...
% '	base=`basename $ph`;\n' ...
% '	dir=`dirname $ph`;\n' ...
% '	mag=$dir/"mag"${base:2};\n' ...
% '	unph="unph"${base:2};\n' ...
% '	prelude -a $mag -p $ph -u $unph -m BET_mask.nii -n 12&\n' ...
% 'done\n' ...
% 'wait\n' ...
% 'gunzip -f unph*.gz\n']);

% unix(bash_command);

% unph_cmb = zeros(imsize);
% for echo = 1:imsize(4)
%     nii = load_nii(['unph_cmb' num2str(echo) '.nii']);
%     unph_cmb(:,:,:,echo) = double(nii.img);
% end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap the phase using best path
disp('--> unwrap aliasing phase using bestpath...');
    % mask_unwrp = uint8(hemo_mask.*255);
mask_unwrp = uint8(abs(mask)*255);
fid = fopen('mask_unwrp.dat','w');
fwrite(fid,mask_unwrp,'uchar');
fclose(fid);

unix('cp /home/hsun/Documents/MATLAB/3DSRNCP 3DSRNCP');
setenv('nv',num2str(imsize(1)));
setenv('np',num2str(imsize(2)));
setenv('ns',num2str(imsize(3)));

unph_cmb = zeros(imsize);

for echo_num = 1:imsize(4)
    setenv('echo_num',num2str(echo_num));
    fid = fopen(['wrapped_phase' num2str(echo_num) '.dat'],'w');
    fwrite(fid,ph_cmb(:,:,:,echo_num),'float');
    fclose(fid);

    bash_script = ['./3DSRNCP wrapped_phase${echo_num}.dat mask_unwrp.dat ' ...
        'unwrapped_phase${echo_num}.dat $nv $np $ns reliability${echo_num}.dat'];
    unix(bash_script) ;

    fid = fopen(['unwrapped_phase' num2str(echo_num) '.dat'],'r');
    tmp = fread(fid,'float');
    % tmp = tmp - tmp(1);
    unph_cmb(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(mask==1))/(2*pi))*2*pi ,imsize(1:3)).*mask;
    fclose(fid);

    fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
    reliability_raw = fread(fid,'float');
    reliability_raw = reshape(reliability_raw,imsize(1:3));
    fclose(fid);

    nii = make_nii(reliability_raw.*mask,vox);
    save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
end

nii = make_nii(unph_cmb,vox);
save_nii(nii,'unph_cmb.nii');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




% check and correct for 2pi jump between echoes
disp('--> correct for potential 2pi jumps between TEs ...')

nii = load_nii('unph_diff.nii');
unph_diff = double(nii.img);

for echo = 2:imsize(4)
    meandiff = unph_cmb(:,:,:,echo)-unph_cmb(:,:,:,1)-double(echo-1)*unph_diff;
    meandiff = meandiff(mask==1);
    meandiff = mean(meandiff(:))
    njump = round(meandiff/(2*pi));
    disp(['    ' num2str(njump) ' 2pi jumps for TE' num2str(echo)]);
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo) - njump*2*pi;
    unph_cmb(:,:,:,echo) = unph_cmb(:,:,:,echo).*mask;
end


% fit phase images with echo times
disp('--> magnitude weighted LS fit of phase to TE ...');
[tfs, fit_residual] = echofit(unph_cmb,abs(img),TE); 

r_mask = 1;
% fit_thr = 10;
fit_thr = 30;
if r_mask
    % generate reliability map
    fit_residual_blur = smooth3(fit_residual,'box',round(2./vox/2)*2+1); 
    nii = make_nii(fit_residual_blur,vox);
    save_nii(nii,'fit_residual_blur.nii');
    R = ones(size(fit_residual_blur));
    R(fit_residual_blur >= fit_thr) = 0;
else
    R = 1;
end


% normalize to main field
% ph = gamma*dB*TE
% dB/B = ph/(gamma*TE*B0)
% units: TE s, gamma 2.675e8 rad/(sT), B0 3T
tfs = -tfs/(2.675e8*dicom_info.MagneticFieldStrength)*1e6; % unit ppm


smv_rad = 4;
tik_reg = 1e-3;
tv_reg = 5e-4;
inv_num = 500;
cgs_num = 500;

disp('--> RESHARP to remove background field ...');
[lfs_resharp, mask_resharp] = resharp(tfs,mask.*R,vox,smv_rad,tik_reg,cgs_num);

% save nifti
mkdir('RESHARP');
nii = make_nii(lfs_resharp,vox);
save_nii(nii,['RESHARP/lfs_resharp_' num2str(tik_reg) '.nii']);

% inversion of susceptibility 
disp('--> TV susceptibility inversion on RESHARP...');
sus_resharp = tvdi(lfs_resharp, mask_resharp, vox, tv_reg, ...
    abs(img(:,:,:,end)), z_prjs, inv_num); 


% save nifti
nii = make_nii(sus_resharp.*mask_resharp,vox);
save_nii(nii,['RESHARP/sus_resharp_' num2str(tv_reg) '_' num2str(inv_num) '.nii']);

save('all.mat','-v7.3');



