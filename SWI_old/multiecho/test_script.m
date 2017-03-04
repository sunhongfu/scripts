matlabpool open;
parfor i = 1:size(img,4)
	phase_unwrap(:,:,:,i) = HS_prelude_unwrap(img(:,:,:,i),i);
end
matlabpool close;

phase_unwrap = reshape(phase_unwrap,np,nv,ns,ne,nrcvrs);

save('phase_unwrap','phase_unwrap','-v7.3');
