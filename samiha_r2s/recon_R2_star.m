function recon_R2_star(subj_dir)


    TE = [3.2, 6.552, 9.904, 13.256, 16.608, 19.96, 23.312, 26.664]*0.001;
    vox = [1 1 1];
    cd('/QRISdata/Q1041/samiha/MS/QSM_recon')
    cd(subj_dir)

            echonum = 8
            mag = [];
            for i = 1:echonum
                nii = load_nii(['QSM_SPGR_GE/src/mag' num2str(i) '.nii']);
                mag(:,:,:,i) = double(nii.img);
            end

           

            nii = load_nii('R2s_SPGR_GE/R2s.nii');
            mask = double(nii.img~=0);

            [R2 T2 amp] = r2imgfit2(double(mag),TE,repmat(mask,[1 1 1 echonum]));
            nii = make_nii(R2,vox);
            save_nii(nii,'R2.nii');
            nii = make_nii(T2,vox);
            save_nii(nii,'T2.nii');
            nii = make_nii(amp,vox);
            save_nii(nii,'amp.nii');

