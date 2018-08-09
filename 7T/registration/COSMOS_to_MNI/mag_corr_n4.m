cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T
for echo = 1:4
    % nii = make_nii(mag_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    % nii = make_nii(ph_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/left/QSM_MEGE_7T
for echo = 1:4
    % nii = make_nii(mag_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    % nii = make_nii(ph_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/right/QSM_MEGE_7T
for echo = 1:4
    % nii = make_nii(mag_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    % nii = make_nii(ph_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/extension/QSM_MEGE_7T
for echo = 1:4
    % nii = make_nii(mag_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    % nii = make_nii(ph_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/flexion/QSM_MEGE_7T
for echo = 1:4
    % nii = make_nii(mag_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/mag_corr' num2str(echo) '.nii']);

    setenv('echo',num2str(echo));
    unix('N4BiasFieldCorrection -i src/mag_corr${echo}.nii -o src/mag_corr${echo}_n4.nii');

    % nii = make_nii(ph_corr(:,:,:,echo),vox);
    % save_nii(nii,['src/ph_corr' num2str(echo) '.nii']);
end


