path_dcm_input = '/Users/uqhsun8/DATA/tumor/Sx_No1_Head - 340774/QSM_3d_6'

% read in all the dicom headers
% refer to the manual https://pdfs.semanticscholar.org/6bf8/cdbc4824b8097be864e4fe59c48c7381a8b2.pdf

dcm_list = dir(path_dcm_input);
dcm_list = dcm_list(~strncmpi('.', {dcm_list.name}, 1));

for i = 1:length(dcm_list)
    headers = dicominfo([path_dcm_input,filesep,dcm_list(i).name]); 
    headers.ProtocolName = 'HS_QSM';
    headers.SeriesDescription = 'HS_QSM';
    headers.EchoTime = 0;
    % m_c = headers.Columns;
    % m_r = headers.Rows;
    % n_c = m_c/6;
    % n_r = m_r/6;
    % r_x = headers.ImageOrientationPatient(1);
    % r_y = headers.ImageOrientationPatient(2);
    % r_z = headers.ImageOrientationPatient(3);
    % c_x = headers.ImageOrientationPatient(4);
    % c_y = headers.ImageOrientationPatient(5);
    % c_z = headers.ImageOrientationPatient(6);
    % v_r = headers.PixelSpacing(1);
    % v_c = headers.PixelSpacing(2);
    % x_m = headers.ImagePositionPatient(1);
    % y_m = headers.ImagePositionPatient(2);
    % z_m = headers.ImagePositionPatient(3);

    % headers.Width = headers.Width/6;
    % header.Height = headers.Height/6;
    % headers.Rows = headers.Rows/6;
    % headers.Columns = headers.Columns/6;

    % headers.ImagePositionPatient = [r_x*v_r c_x*v_c x_m; r_y*v_r c_y*v_c y_m; r_z*v_r c_z*v_c z_m]*single([(m_c-n_c)/2 (m_r-n_r)/2 1]');

    qsm_headers(i) = headers;
end

% load in qsm
nii = load_nii('/Users/uqhsun8/Desktop/prelude_lbv/LBV/sus_lbv_5e-4_nopoly.nii');
qsm = double(nii.img);

% write dicoms of qsm
mkdir qsm_dicoms
for i =1:length(dcm_list)
    dicomwrite(permute((int16(qsm(:,:,i,1)*1000)),[2 1 3]),['qsm_dicoms/qsm_' num2str(i,'%03d')], qsm_headers(i));
end
