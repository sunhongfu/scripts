
% if have NO calibration scan p-file or prefer to not use ASSET recon

% (1) recon p-file and output uncombine coils
pfilePath = '/Users/uqhsun8/DATA/MEBRAVO/Subject7/p-files/P39936.7';
% kacq_file = 'kacq_yz.txt.1024150629';
outputDir = '/Users/uqhsun8/DATA/MEBRAVO/Subject7/recon_uncombined';
recon_arc(pfilePath, [], outputDir);

% (2) generate QSM
realDicomsDir = [outputDir '/DICOMs_real_uncombined'];
imagDicomsDir = [outputDir '/DICOMs_imag_uncombined'];
path_out = outputDir;

options.orien = 'sagittal';
options.readout = 'unipolar';

% qsm_bravo_uncombined(realDicomsDir, imagDicomsDir, path_out, [], QSM_SPGR_GE_Dir);
% if no SPGR scan then
qsm_bravo_uncombined(realDicomsDir, imagDicomsDir, path_out, options);

