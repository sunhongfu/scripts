    for i = 1:9
        weights(:,:,:,i) = sinc(gx*te(i)) .* sinc(gy*te(i)) .* sinc(gz*te(i)); % All gradients
%         weights(:,:,:,i) = sinc(gz*te(i)); % Z-gradient only
        weights(weights < 0.125) = Inf;
        imgC(:,:,:,i) = img(:,:,:,i) ./ weights(:,:,:,i);
    end
    weights(weights == Inf) = 0;
end




%-- 11/11/2025 03:21 PM --%
load("/Volumes/LaCie_Bottom/MEMP2RAGE/1.10.3 7T Human Archive/1.10.3.524 2581-Wu/1.10.3.524.1.5 MBCIU PROTOCOLS - 7T-2018.005 COSMOS MEMP2RAGE/QSM_9ECHOES/QSM_MEGE_7T/raw.mat")
size(mag_all)
size(ph_corr)
edit gemsme3drec.m
nii = load_nii('/Volumes/LaCie_Bottom/MEMP2RAGE/1.10.3 7T Human Archive/1.10.3.524 2581-Wu/1.10.3.524.1.5 MBCIU PROTOCOLS - 7T-2018.005 COSMOS MEMP2RAGE/QSM_9ECHOES/QSM_MEGE_7T/tfs_0.nii');
tfs = double(nii.img);
size(tfs)
load("/Volumes/LaCie_Bottom/MEMP2RAGE/1.10.3 7T Human Archive/1.10.3.524 2581-Wu/1.10.3.524.1.5 MBCIU PROTOCOLS - 7T-2018.005 COSMOS MEMP2RAGE/QSM_9ECHOES/QSM_MEGE_7T/RDF.mat")
tfs_hertz = tfs*298.06;
[gx,gy,gz] = gradient(tfs_hertz);
gx(isnan(gx)) = 0;gy(isnan(gy)) = 0;gz(isnan(gz)) = 0;
size(mag_all)
size(mag_corr)
size(ph_corr)
weights = zeros(size(mag_corr));
size(weights)

te=TE;
for i = 1:9
weights(:,:,:,i) = sinc(gx*te(i)) .* sinc(gy*te(i)) .* sinc(gz*te(i)); % All gradients
%         weights(:,:,:,i) = sinc(gz*te(i)); % Z-gradient only
weights(weights < 0.125) = Inf;
imgC(:,:,:,i) = mag_corr(:,:,:,i) ./ weights(:,:,:,i);
end
weights(weights == Inf) = 0;
nii=make_nii(imgC); save_nii(nii,'imgC.nii')


nii = load_nii('/Volumes/LaCie_Bottom/MEMP2RAGE/1.10.3 7T Human Archive/1.10.3.524 2581-Wu/1.10.3.524.1.5 MBCIU PROTOCOLS - 7T-2018.005 COSMOS MEMP2RAGE/QSM_9ECHOES/QSM_MEGE_7T/unph_bestpath.nii');
unph = double(nii.img);
for i = 1:9
    [gx,gy,gz] = gradient(unph(:,:,:,i)/2/pi/te(i));
gx(isnan(gx)) = 0;gy(isnan(gy)) = 0;gz(isnan(gz)) = 0;

weights(:,:,:,i) = sinc(gx*te(i)) .* sinc(gy*te(i)) .* sinc(gz*te(i)); % All gradients
        % weights(:,:,:,i) = sinc(gz*te(i)); % Z-gradient only
% weights(weights < 0.125) = Inf;
imgC(:,:,:,i) = mag_corr(:,:,:,i) ./ weights(:,:,:,i);
end
nii=make_nii(imgC); save_nii(nii,'imgC.nii')
