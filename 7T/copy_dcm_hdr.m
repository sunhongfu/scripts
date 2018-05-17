

clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/neutral/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/left/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/right/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/extension/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/04JG/flexion/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/neutral/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/left/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/right/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/extension/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/05SG/flexion/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/neutral/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/left/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/right/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/extension/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/06PS/flexion/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/neutral/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/left/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/right/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 




clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/extension/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





clear
cd /gpfs/M2Scratch/NCIgb5/hongfu/COSMOS/07JON/flexion/QSM_MEGE_7T
load('raw.mat','mag_corr','imsize','path_mag','mag_list')


% read in all the dicom headers
for i = 1:imsize(3)
    headers = dicominfo([path_mag,filesep,mag_list(i).name]);  
    headers.Width = headers.Width/6;
    header.Height = headers.Height/6;
    headers.Rows = headers.Rows/6;
    headers.Columns = headers.Columns/6;
    headers.ImagePositionPatient(1) = headers.ImagePositionPatient(1)/6;
    headers.ImagePositionPatient(2) = headers.ImagePositionPatient(2)/6;
    mag_headers(i) = headers;
end


% write dicoms of mag
mkdir src/mag_corr1_dicoms
for i =1:imsize(3)
	dicomwrite(permute((int16(mag_corr(:,:,i,1))),[2 1 3]),['src/mag_corr1_dicoms/mag_' num2str(i,'%03d')], mag_headers(i));
end

clear mag_corr

!/home/hongfu/bin/mricrogl_lx/dcm2niix -f mag_corr1_dicoms -o src src/mag_corr1_dicoms 





