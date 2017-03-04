function phase = HS_multiecho_phase(img)

te1 = 4.65;
te2 = 4.65+7.54;


mag = abs(img);
matlabpool open;
parfor i = 1:size(img,4)
	img(:,:,:,i) = HS_prelude_unwrap(img(:,:,:,i),i);
end
matlabpool close;
phase_unwrap = img;
clear img;

[d1 d2 d3 d4] =  size(phase_unwrap);
phase_unwrap = reshape(phase_unwrap,d1,d2,d3,2,[]);


phase_offset = (te1*phase_unwrap(:,:,:,2,:) - te2*phase_unwrap(:,:,:,1,:))/(te1 - te2);

phase_rm_offset = phase_unwrap(:,:,:,2,:) - phase_offset;

% combining channels for phase(weighted by magnitude)
phase = sum(phase_rm_offset.*mag(:,:,:,2,:),5)./sum(mag(:,:,:,2,:),5);

% unwrap again

