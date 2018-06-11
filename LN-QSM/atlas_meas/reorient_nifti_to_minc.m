
%% Previous analysis
% source_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/new/';
% dest_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/new/';
% mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
% 
% %subject_source_ID = {'11', '12', '13', '14', '15', 'hongfu', 'renzo'};
% %subject_source_dir= {'RESHARP_TIK_0', 'RESHARP_TIK_5E-4'};
% %subject_source_ID = {'renzo'};
% subject_source_ID = {'11', '12', '13', '14', '15', '16', '17'};
% subject_dest_ID = {'11', '12', '13', '14', '15', '16', '17'};
% 
% %subject_dest_ID = {'17'};
% 
% %susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full'};
% %susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'RESHARP_TIK_0/chi_resharp_ero5_Tik_0_TV_0.003_200', 'RESHARP_TIK_5E-4/chi_resharp_ero5_Tik_0_TV_0.003_200'};
% %susceptibility_maps_dest = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'resharp_ero5_0', 'resharp_ero5_5e-4'};
% %susceptibility_maps = {'TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000','iFreq_rawSS_QSM_000', 'TV_RESHARP_1e-6_ero3', 'MEDI_PDF_ero0', 'TFI_ero0','TFI_ero1'};
% susceptibility_maps = {'MEDI_RESHARP_1e-6_ero3'};
% 
% susceptibility_maps_dest=susceptibility_maps;


%% Revision 2 - subject 18 and 19

source_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
dest_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';

%subject_source_ID = {'11', '12', '13', '14', '15', 'hongfu', 'renzo'};
%subject_source_dir= {'RESHARP_TIK_0', 'RESHARP_TIK_5E-4'};
%subject_source_ID = {'renzo'};
subject_source_ID = {'18', '19'};
subject_mag_ID=subject_source_ID;
subject_dest_ID = {'18', '19'};

%subject_dest_ID = {'17'};

%susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full'};
%susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'RESHARP_TIK_0/chi_resharp_ero5_Tik_0_TV_0.003_200', 'RESHARP_TIK_5E-4/chi_resharp_ero5_Tik_0_TV_0.003_200'};
%susceptibility_maps_dest = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'resharp_ero5_0', 'resharp_ero5_5e-4'};
%susceptibility_maps = {'TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000','iFreq_rawSS_QSM_000', 'TV_RESHARP_1e-6_ero3', 'MEDI_PDF_ero0', 'TFI_ero0','TFI_ero1'};
susceptibility_maps = {'LN_ero0', 'LN_ero2'};
%susceptibility_maps = {'TFI_brain', 'LN_brain', 'iFreq_rawSS_QSM_new_000', 'MEDI_RESHARP_1e-6_ero2', 'MEDI_PDF_ero0'};
susceptibility_maps_dest=susceptibility_maps;

masks={'mask_ero0', 'mask_ero2'};
%masks={'mask_brain', 'mask_SS', 'mask_ero2', 'mask_ero0'};
masks_dest=masks;

%% Revision 2 subject 11 to 17

source_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
dest_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';

%subject_source_ID = {'11', '12', '13', '14', '15', 'hongfu', 'renzo'};
%subject_source_dir= {'RESHARP_TIK_0', 'RESHARP_TIK_5E-4'};
%subject_source_ID = {'renzo'};
subject_mag_ID={'11', '12', '13', '14', '15', '16', '17'};
subject_source_ID = {'11', '12', '13', '14', '15', '16', '17'};
subject_dest_ID = {'11', '12', '13', '14', '15', '16', '17'};

%subject_dest_ID = {'17'};

%susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full'};
%susceptibility_maps = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'RESHARP_TIK_0/chi_resharp_ero5_Tik_0_TV_0.003_200', 'RESHARP_TIK_5E-4/chi_resharp_ero5_Tik_0_TV_0.003_200'};
%susceptibility_maps_dest = {'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'resharp_ero5_0', 'resharp_ero5_5e-4'};
%susceptibility_maps = {'TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000','iFreq_rawSS_QSM_000', 'TV_RESHARP_1e-6_ero3', 'MEDI_PDF_ero0', 'TFI_ero0','TFI_ero1'};
%susceptibility_maps = {'MEDI_RESHARP_1e-6_ero3'};
susceptibility_maps = {'LN_ero0', 'LN_ero2'};
susceptibility_maps_dest=susceptibility_maps;

masks={'mask_ero0', 'mask_ero2'};
masks_dest=masks;


%% Revision 3 subject 11 to 17 March 2018
source_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
dest_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
subject_mag_ID={'11', '12', '13', '14', '15', '16', '17'};
subject_source_ID = {'11', '12', '13', '14', '15', '16', '17'};
subject_dest_ID = {'11', '12', '13', '14', '15', '16', '17'};

susceptibility_maps = {'chi_resharp_iLSQR_ero2'};
susceptibility_maps_dest=susceptibility_maps;
masks={'mask_ero2'};
masks_dest=masks;
%% Revision 3 - subject 18 and 19, March 2018
source_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
dest_dir = '/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
subject_mag_ID={'18', '19'};
subject_source_ID = {'18', '19'};
subject_dest_ID = {'18', '19'};

susceptibility_maps = {'chi_resharp_iLSQR_ero2'};
susceptibility_maps_dest=susceptibility_maps;
masks={'mask_ero2'};
masks_dest=masks;

%%
for ii = 1:length(subject_dest_ID)
   if (~exist( [dest_dir, subject_dest_ID{ii}, '/minc'], 'dir'))
       mkdir([dest_dir, subject_dest_ID{ii}, '/minc']);
   end
   fprintf([subject_dest_ID{ii}, '\n']);
   cd([dest_dir, subject_dest_ID{ii}, '/minc']);
   [hdr_mag, mag1_vol] = niak_read_minc([mag_dir, subject_mag_ID{ii}, '/mag1.mnc']);
   
   for jj = 1:length(susceptibility_maps)
      [hdr_nii, suscep_vol] = niak_read_nifti([source_dir,subject_source_ID{ii}, '/', susceptibility_maps{jj}, '.nii']);
      
      suscep_vol = flipdim(suscep_vol,2);
      hdr_mag.file_name = [susceptibility_maps_dest{jj}, '.mnc'];
      niak_write_minc(hdr_mag, suscep_vol);


      
       
   end
    
    
end

%% Not necessary if masks are already generated, didn't run this part for revision 3

for ii = 1:length(subject_dest_ID)
   if (~exist( [dest_dir, subject_dest_ID{ii}, '/minc'], 'dir'))
       mkdir([dest_dir, subject_dest_ID{ii}]);
   end
   fprintf([subject_dest_ID{ii}, '\n']);
   cd([dest_dir, subject_dest_ID{ii}, '/minc']);
   [hdr_mag, mag1_vol] = niak_read_minc([mag_dir, subject_mag_ID{ii}, '/mag1.mnc']);
   
   for jj = 1:length(masks)
       cd([dest_dir, subject_dest_ID{ii}, '/minc']);
      [hdr_nii, mask_vol] = niak_read_nifti([source_dir,subject_source_ID{ii}, '/', masks{jj}, '.nii']);
      
      mask_vol = flipdim(mask_vol,2);
      hdr_mag.file_name = [masks_dest{jj}, '_.mnc'];
      niak_write_minc(hdr_mag, mask_vol);
%       
      cd([dest_dir, subject_dest_ID{ii}]);
      if (~exist( [dest_dir, subject_dest_ID{ii}, '/nifti'], 'dir'))
          mkdir('nifti');
      end

        system(['mnc2nii_opt.pl ', 'minc/', masks_dest{jj}, '_.mnc ', 'nifti/', masks_dest{jj},'.nii']);
      
       
   end
    
    
end
