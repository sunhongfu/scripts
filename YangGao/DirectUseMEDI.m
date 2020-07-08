	    %%%%% normalize signal intensity by noise to get SNR %%%
	    %%%% Generate the Magnitude image %%%%
        addpath(genpath('./'))
% 	    iMag = sqrt(sum(mag_corr.^2,4));
	    % [iFreq_raw N_std] = Fit_ppm_complex(ph_corr);
        imsize = size(V_Field);
        V_Field = V_Field .* mask; 
	    matrix_size = single(imsize(1:3));
        iMag = mask;
        % vox: spatial resolution, in mm per voxel. 
	    vox = [0.6, 0.6, 0.6]
        %vox = [1 1 1];
        voxel_size = vox;
	    delta_TE = 0.03;
        % B0_dir; B0 direction. 
	    B0_dir = [0 0 1]';
        B0 = 7; 
        % G* B0, resonance frequency, in Hz. 
        G = 42.576375;
	    CF = G * B0 *1e6;
	    iFreq = [];
	    N_std = 1;
        % V_Field: normalised loca Field map/ 
	    RDF = V_Field *2.675e8* B0 *delta_TE*1e-6;
        % Image Mask; 
	    Mask = mask;
	    save RDF.mat RDF iFreq iMag N_std Mask matrix_size...
	         voxel_size delta_TE CF B0_dir;
         disp('HI')
        tic
	    QSM = MEDI_L1('lambda',500);
        toc
	    nii = make_nii(QSM.*Mask,vox);
	    %save_nii(nii,['./MEDI1000_RESHARP_smvrad-nenwPH_nonoise' num2str(500) '.nii']);
        
        
        
