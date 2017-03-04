function [mag, phase, swi, phase_unwrap] = HS_SWIProc(img, par)
% swi2d sequence processing, input reconstructed complex img and output mag, phase and swi

%% Process and combine magnitude images
% Marc's phase sensitive combining method
mag_uncombined = abs(img);
if par.nrcvrs >1
    mag = arrayrec(coilnorm(img), 0.4);
else
    mag = coilrec(img, 0.4);
end
% Amir's sum of squares combining method
% mag_uncombined = abs(img);
% if par.nrcvrs > 1
%     % multiply each receiver's output by its weighting factor
%     mag_uncombined(:,:,:,2) = mag_uncombined(:,:,:,2) * 0.97;
%     mag_uncombined(:,:,:,3) = mag_uncombined(:,:,:,3) * 1.01;
%     mag_uncombined(:,:,:,4) = mag_uncombined(:,:,:,4) * 1.12;
% end
% mag = sqrt(sum(mag_uncombined.^2, 4));

%% Process and combine the phase images
% PRELUDE to unwrap phase
    disp('PRELUDE phase unwrapping... may take sometime...');
% % generate mask/shape based on magnitude
    nii = make_nii(mag);
    save_nii(nii,'mag');
    unix('bet mag brain_BET -m -f 0.1');
% % 3D PRELUDE unwrapping
    phase_unwrap = img; % initial size
    if (par.nrcvrs > 1)
        matlabpool open;
    end
    
    parfor i = 1:par.nrcvrs
        setenv('order',num2str(i));
        nii = make_nii(abs(img(:,:,:,i)));
        save_nii(nii,['data_abs' num2str(i)]);
        nii = make_nii(angle(img(:,:,:,i)));
        save_nii(nii,['data_phase' num2str(i)]);
        unix('prelude -s -a data_abs${order} -p data_phase${order} -u prelude_result${order} -m brain_BET_mask.nii.gz');
        unix('gunzip -f prelude_result${order}.nii.gz');
        result = load_nii(['prelude_result' num2str(i) '.nii']);
        phase_unwrap(:,:,:,i) = result.img;
    end
    if (matlabpool('size') > 1)
        matlabpool close;
    end

% normal high-pass filter
disp('Filtering Phase Images');
phase_uncombined = HS_SWIPhase(img, par, 'hann', 0.125);
% Amir's weighting by magnitude square method
phase = sum(phase_uncombined.*mag_uncombined.^2,4)./sum(mag_uncombined.^2,4);
% Marc is weighting the magnitude only
    % phase = sum(phase_uncombined.*mag_uncombined,4)./sum(mag_uncombined,4);

%% Generate phase masks and SWI(??? How about generate SWI for individual channel and then combine???)
disp('Generating and Applying masks');
mask = phase;
mask(mask>0) = 1;
mask(mask<0) = 1+mask(mask<0)/pi;
mask = mask.^4;
swi = mag.*mask;
