function Gen_QSM_BKG_patch(FileNo, vox, z_prjs, QSM_Folder, BKG_Folder, Vox_Folder, zprjs_Folder)
%GEN_QSM_BKG_PATCH Summary of this function goes here
%   Detailed explanation goes here

if norm(z_prjs) > 1 + 0.00000000001
    error('wrong zprjs');
end

if norm(vox) < 1
    error('wrong vox');
end

SubjNo = mod(FileNo, 96) + 1

tmp_chi = niftiread(['./QSM_full_cropped/chi_', num2str(SubjNo),'.nii']);
tmp_bkg = niftiread(['./BKG_full_cropped/bkg_', num2str(SubjNo),'.nii']);

BET_mask = single(tmp_chi ~= 0);

if ~abs(sum(vox - [ 1 1 1]))
    imsize = size(tmp_chi);
    newSize = round(imsize ./ vox);

    BET_mask = imresize3(BET_mask, newSize);
    BET_mask = single(BET_mask > 0.5);

    chi_anio = imresize3(tmp_chi, newSize);
    chi_anio = chi_anio .* BET_mask;  %% resized qsm (local)

    bkg_anio = imresize3(tmp_bkg, newSize);
    bkg_anio = bkg_anio .* (1 - BET_mask);  % resized bkg source (local)
else
    chi_anio = tmp_chi .* BET_mask;
    bkg_anio = tmp_bkg .* (1 - BET_mask);
end

[pad_bkg, pos] = ZeroPadding(bkg_anio, 16);
bkg_field = forward_field_calc(pad_bkg, vox, z_prjs, 1); % bkg field (global)
bkg_field = ZeroRemoving(bkg_field, pos);

bkg_field = bkg_field .* BET_mask;  % masked bkg field; 

if sum(size(bkg_field) - size(chi_anio))
    error('wrong data size.')
end 

[Nx, Ny, Nz] = size(chi_anio);

tmp_idxx = randperm(Nx - 63); 
tmp_idxy = randperm(Ny - 63);
tmp_idxz = randperm(Nz - 63);

idx = tmp_idxx(1);
idy = tmp_idxy(1);
idz = tmp_idxz(1);

disp([idx, idy, idz])

chi_patch = chi_anio(idx: idx+63, idy:idy + 63, idz : idz+63);
bkg_patch = bkg_anio(idx: idx+63, idy:idy + 63, idz : idz+63);

save(sprintf('./%s/chi_patch_%d', QSM_Folder, FileNo), 'chi_patch');
save(sprintf('./%s/bkg_patch_%d', BKG_Folder, FileNo), 'bkg_patch');

save(sprintf('./%s/vox_patch_%d', Vox_Folder, FileNo), 'vox');
save(sprintf('./%s/z_prjs_%d.mat', zprjs_Folder, FileNo), 'z_prjs');

end

