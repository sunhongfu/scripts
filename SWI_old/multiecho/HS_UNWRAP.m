load /media/data/Hongfu/data/unwrap/rawdata;

method = 'laplacian';


[np nv ns ne nrcvrs] = size(img);

img = reshape(img,np,nv,ns,[]);
phase_unwrap = img;  % to initialize sizeof phase_unwrap for the forloop below

switch lower(method)

    case 'prelude'
        % to generate a mask based on magnitude
        mag = sum(abs(img).^2,4);
        nii = make_nii(mag);
        save_nii(nii,'mag');
        unix('bet mag brain_BET -m -f 0.1'); 

        matlabpool open;
        parfor i = 1:size(img,4)
            phase_unwrap(:,:,:,i) = HS_PRELUDE_UNWRAP(img(:,:,:,i),i);
        end
        matlabpool close;

        phase_unwrap = reshape(phase_unwrap,np,nv,ns,ne,nrcvrs);

        save('phase_unwrap','phase_unwrap','-v7.3');


    case 'laplacian'
   
        for i = 1:size(img,4)
            phase_unwrap(:,:,:,i) = HS_LAPLACIAN_UNWRAP(img(:,:,:,i));
        end

    otherwise
        disp('Unknown method');

end