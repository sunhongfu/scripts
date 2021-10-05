clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/neutral/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]); 

    m_c = headers.Columns;
    m_r = headers.Rows;
    n_c = m_c/6;
    n_r = m_r/6;
    r_x = headers.ImageOrientationPatient(1);
	r_y = headers.ImageOrientationPatient(2);
	r_z = headers.ImageOrientationPatient(3);
	c_x = headers.ImageOrientationPatient(4);
	c_y = headers.ImageOrientationPatient(5);
	c_z = headers.ImageOrientationPatient(6);
    v_r = headers.PixelSpacing(1);
    v_c = headers.PixelSpacing(2);
    x_m = headers.ImagePositionPatient(1);
    y_m = headers.ImagePositionPatient(2);
    z_m = headers.ImagePositionPatient(3);

    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;

    headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr
!rm src/mag_corr1_dicoms*.nii src/mag_corr1_dicoms*.json
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 






clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/left/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]); 

    m_c = headers.Columns;
    m_r = headers.Rows;
    n_c = m_c/6;
    n_r = m_r/6;
    r_x = headers.ImageOrientationPatient(1);
	r_y = headers.ImageOrientationPatient(2);
	r_z = headers.ImageOrientationPatient(3);
	c_x = headers.ImageOrientationPatient(4);
	c_y = headers.ImageOrientationPatient(5);
	c_z = headers.ImageOrientationPatient(6);
    v_r = headers.PixelSpacing(1);
    v_c = headers.PixelSpacing(2);
    x_m = headers.ImagePositionPatient(1);
    y_m = headers.ImagePositionPatient(2);
    z_m = headers.ImagePositionPatient(3);

    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;

    headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr
!rm src/mag_corr1_dicoms*.nii src/mag_corr1_dicoms*.json
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/right/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]); 

    m_c = headers.Columns;
    m_r = headers.Rows;
    n_c = m_c/6;
    n_r = m_r/6;
    r_x = headers.ImageOrientationPatient(1);
	r_y = headers.ImageOrientationPatient(2);
	r_z = headers.ImageOrientationPatient(3);
	c_x = headers.ImageOrientationPatient(4);
	c_y = headers.ImageOrientationPatient(5);
	c_z = headers.ImageOrientationPatient(6);
    v_r = headers.PixelSpacing(1);
    v_c = headers.PixelSpacing(2);
    x_m = headers.ImagePositionPatient(1);
    y_m = headers.ImagePositionPatient(2);
    z_m = headers.ImagePositionPatient(3);

    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;

    headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr
!rm src/mag_corr1_dicoms*.nii src/mag_corr1_dicoms*.json
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 






clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/extension/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]); 

    m_c = headers.Columns;
    m_r = headers.Rows;
    n_c = m_c/6;
    n_r = m_r/6;
    r_x = headers.ImageOrientationPatient(1);
	r_y = headers.ImageOrientationPatient(2);
	r_z = headers.ImageOrientationPatient(3);
	c_x = headers.ImageOrientationPatient(4);
	c_y = headers.ImageOrientationPatient(5);
	c_z = headers.ImageOrientationPatient(6);
    v_r = headers.PixelSpacing(1);
    v_c = headers.PixelSpacing(2);
    x_m = headers.ImagePositionPatient(1);
    y_m = headers.ImagePositionPatient(2);
    z_m = headers.ImagePositionPatient(3);

    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;

    headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr
!rm src/mag_corr1_dicoms*.nii src/mag_corr1_dicoms*.json
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 






clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/flexion/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]); 

    m_c = headers.Columns;
    m_r = headers.Rows;
    n_c = m_c/6;
    n_r = m_r/6;
    r_x = headers.ImageOrientationPatient(1);
	r_y = headers.ImageOrientationPatient(2);
	r_z = headers.ImageOrientationPatient(3);
	c_x = headers.ImageOrientationPatient(4);
	c_y = headers.ImageOrientationPatient(5);
	c_z = headers.ImageOrientationPatient(6);
    v_r = headers.PixelSpacing(1);
    v_c = headers.PixelSpacing(2);
    x_m = headers.ImagePositionPatient(1);
    y_m = headers.ImagePositionPatient(2);
    z_m = headers.ImagePositionPatient(3);

    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;

    headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr
!rm src/mag_corr1_dicoms*.nii src/mag_corr1_dicoms*.json
!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 








