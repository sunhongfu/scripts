% reshape 4D into 3D mosaic
% load in the offsets_smooth
nii = load_nii('even_gaussian/offsets_smooth.nii');
offsets = single(nii.img);

pha_offsets_corr = exp(1j.*ph_all_i2(:,:,:,4,:))./exp(1j.*offsets);
pha_offsets_corr = angle(pha_offsets_corr);
pha_offsets_corr(:,:,:,:,33:36) = 0;


pha_offsets_corr_mosaic = zeros(1908,1908,192);

for j = 1:6
	for i = 1:6
		pha_offsets_corr_mosaic(1+318*(i-1):318*i, 1+318*(j-1):318*j, :) = pha_offsets_corr(:,:,:,i + (j-1)*6).*mask;
	end
end

nii = make_nii(pha_offsets_corr_mosaic);
save_nii(nii,'pha_offsets_corr_mosaic.nii');