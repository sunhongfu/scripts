load('/media/data/QSM_challenge/20170327_qsm2016_recon_challenge/data/phs_wrap')
load('/media/data/QSM_challenge/20170327_qsm2016_recon_challenge/data/phs_unwrap')
load('/media/data/QSM_challenge/20170327_qsm2016_recon_challenge/data/msk')
load('/media/data/QSM_challenge/20170327_qsm2016_recon_challenge/data/magn')
load('/media/data/QSM_challenge/20170327_qsm2016_recon_challenge/data/spatial_res')

% unwrap the phase
imsize = size(magn);

%% 1 best path
% unwrap the phase using best path
    disp('--> unwrap aliasing phase using bestpath...');
    mask_unwrp = uint8(abs(msk)*255);
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
        fwrite(fid,phs_wrap(:,:,:,echo_num),'float');
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
        unph(:,:,:,echo_num) = reshape(tmp - round(mean(tmp(msk==1))/(2*pi))*2*pi ,imsize(1:3)).*msk;
        fclose(fid);

        fid = fopen(['reliability' num2str(echo_num) '.dat'],'r');
        reliability_raw = fread(fid,'float');
        reliability_raw = reshape(reliability_raw,imsize(1:3));
        fclose(fid);

        nii = make_nii(reliability_raw.*msk,spatial_res);
        save_nii(nii,['reliability_raw' num2str(echo_num) '.nii']);
    end

    nii = make_nii(unph,spatial_res);
    save_nii(nii,'unph_bestpath.nii');


% polyfit on laplacian
phs_unwrap_poly1 = (phs_unwrap - poly3d(phs_unwrap,msk,1)).*msk;
nii = make_nii(phs_unwrap_poly1,spatial_res);
save_nii(nii,'phs_unwrap_poly1.nii')

phs_unwrap_poly2 = (phs_unwrap - poly3d(phs_unwrap,msk,2)).*msk;
nii = make_nii(phs_unwrap_poly2,spatial_res);
save_nii(nii,'phs_unwrap_poly2.nii')

phs_unwrap_poly3 = (phs_unwrap - poly3d(phs_unwrap,msk,3)).*msk;
nii = make_nii(phs_unwrap_poly3,spatial_res);
save_nii(nii,'phs_unwrap_poly3.nii')

phs_unwrap_poly4 = (phs_unwrap - poly3d(phs_unwrap,msk,4)).*msk;
nii = make_nii(phs_unwrap_poly4,spatial_res);
save_nii(nii,'phs_unwrap_poly4.nii')


phs_unwrap_poly_all = cat(4, phs_unwrap_poly1, phs_unwrap_poly2, phs_unwrap_poly3, phs_unwrap_poly4);
%% TFI of the whole head

for i = 1:4
	iFreq = phs_unwrap_poly_all(:,:,:,i);

	delta_TE = 25e-3;
	matrix_size = size(magn);
	% CF = 1/(2*pi)*1e6;
	CF = 42.58*3e6;
	Mask = msk;
	iMag = magn;
	% iMag = Mask.*model;
	N_std = 1;
	voxel_size = spatial_res;
	B0_dir = [0 0 1];

	mkdir TFI
	cd TFI
	% (1) TFI of 0 voxel erosion
	% only brain tissue, need whole head later
	P_B = 30;
	P = 1 * Mask + P_B * (1-Mask);
	% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
	Mask_G = Mask;
	RDF = 0;

	save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
	QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 400);
	nii = make_nii(QSM.*Mask,voxel_size);
	save_nii(nii,['TFI_tissue_400_phs_unwrap_poly' num2str(i) '.nii']);
end



% polyfit on laplacian
unph_poly1 = (unph - poly3d(unph,msk,1)).*msk;
nii = make_nii(unph_poly1,spatial_res);
save_nii(nii,'unph_poly1.nii')

unph_poly2 = (unph - poly3d(unph,msk,2)).*msk;
nii = make_nii(unph_poly2,spatial_res);
save_nii(nii,'unph_poly2.nii')

unph_poly3 = (unph - poly3d(unph,msk,3)).*msk;
nii = make_nii(unph_poly3,spatial_res);
save_nii(nii,'unph_poly3.nii')

unph_poly4 = (unph - poly3d(unph,msk,4)).*msk;
nii = make_nii(unph_poly4,spatial_res);
save_nii(nii,'unph_poly4.nii')


unph_poly_all = cat(4, unph_poly1, unph_poly2, unph_poly3, unph_poly4);
%% TFI of the whole head

for i = 1:4
	iFreq = unph_poly_all(:,:,:,i);

	delta_TE = 25e-3;
	matrix_size = size(magn);
	% CF = 1/(2*pi)*1e6;
	CF = 42.58*3e6;
	Mask = msk;
	iMag = magn;
	% iMag = Mask.*model;
	N_std = 1;
	voxel_size = spatial_res;
	B0_dir = [0 0 1];

	mkdir TFI
	cd TFI
	% (1) TFI of 0 voxel erosion
	% only brain tissue, need whole head later
	P_B = 30;
	P = 1 * Mask + P_B * (1-Mask);
	% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
	Mask_G = Mask;
	RDF = 0;

	save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
	QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 400);
	nii = make_nii(QSM.*Mask,voxel_size);
	save_nii(nii,['TFI_tissue_400_unph_poly' num2str(i) '.nii']);
end





delta_TE = 25e-3;
matrix_size = size(magn);
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
Mask = msk;
iMag = magn;
% iMag = Mask.*model;
N_std = 1;
voxel_size = spatial_res;
B0_dir = [0 0 1];

mkdir TFI
cd TFI
% (1) TFI of 0 voxel erosion
% only brain tissue, need whole head later
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
Mask_G = Mask;
RDF = 0;
% wG = 1;
mkdir lap4
cd lap4
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1400);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_lap_1400.nii');
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1500);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_lap_1500.nii');
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 1600);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_lap_1600.nii');
cd ..



%% TFI of the whole head
iFreq = unph;
% iFreq = unph_poly;

delta_TE = 25e-3;
matrix_size = size(magn);
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
Mask = msk;
iMag = magn;
% iMag = Mask.*model;
N_std = 1;
voxel_size = spatial_res;
B0_dir = [0 0 1];

mkdir TFI
cd TFI
% (1) TFI of 0 voxel erosion
% only brain tissue, need whole head later
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
Mask_G = Mask;
RDF = 0;
% wG = 1;
mkdir prelude
cd prelude
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_prelude_600.nii');
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2*600);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_prelude_1200.nii');
cd ..


%% TFI of the whole head
iFreq = unph_poly;
% iFreq = unph_poly;

delta_TE = 25e-3;
matrix_size = size(magn);
% CF = 1/(2*pi)*1e6;
CF = 42.58*3e6;
Mask = msk;
iMag = magn;
% iMag = Mask.*model;
N_std = 1;
voxel_size = spatial_res;
B0_dir = [0 0 1];

mkdir TFI
cd TFI
% (1) TFI of 0 voxel erosion
% only brain tissue, need whole head later
P_B = 30;
P = 1 * Mask + P_B * (1-Mask);
% Mask_G = 1 * Mask + 1/P_B * (~Mask & mask_head);
Mask_G = Mask;
RDF = 0;
% wG = 1;
mkdir prelude_poly
cd prelude_poly
save RDF_brain.mat matrix_size voxel_size delta_TE B0_dir CF iMag N_std iFreq Mask Mask_G P RDF
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 600);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_prelude_poly_600.nii');
QSM = TFI_L1('filename', 'RDF_brain.mat', 'lambda', 2*600);
nii = make_nii(QSM.*Mask,voxel_size);
save_nii(nii,'TFI_tissue_prelude_poly_1200.nii');
cd ..



%%%% TIK-QSM
mkdir LN-QSM
cd LN-QSM
% tfs_pad = padarray(field,[0 0 20]);
% mask_pad = padarray(mask_tissue,[0 0 20]);
% mask_head_pad = padarray(mask_head,[0 0 20]);
% mask_brain_pad = padarray(mask_brain,[0 0 20]);

tfs = iFreq/(2*pi*42.58*3*25e-3);
tfs_pad = padarray(tfs,[20 20 20]);
mask_tissue_pad = padarray(msk,[20 20 20]);;

P_pad = 1 * mask_tissue_pad + 30 * (1 - mask_tissue_pad);

Tik_weight = [0, 5e-4, 1e-3];
% Tik_weight = [1e-3, 0];
TV_weight = [1e-4, 2e-4, 5e-4];
for i = 1:length(Tik_weight)
	for j = 1:length(TV_weight)
		chi = tikhonov_qsm(tfs_pad, mask_tissue_pad, 1, mask_tissue_pad, mask_tissue_pad, 0, TV_weight(j), Tik_weight(i), 0, vox, P_pad, z_prjs, 2000);
		nii = make_nii(chi(21:end-20,21:end-20,21:end-20),vox);
		% nii = make_nii(chi,vox);
		save_nii(nii,['TIK_ss_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_P30_2000.nii']);
	end
end
cd ..


