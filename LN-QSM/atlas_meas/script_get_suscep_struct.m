% script: script_get_suscep_struct_hf.m
%% previous analysis
% clear all;
% mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
% master_dir ='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/new/';
% seg_master_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
% subjectIDAll = {'11', '12', '13', '14', '15', '16', '17'};
% 
% %subjectIDAll = {'17'};
% t1_file = 't1.mnc';
% model_dir = ['/media/yma2/DATA/work/Data/QSM_HO/models/standard/'];
% %recons = {'TIK_ero0_TV_0.0004_Tik_0.001_PRE_5000', 'TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000','TIK_ero3_TV_0.0004_Tik_0.001_PRE_5000','iFreq_rawSS_QSM_000', 'TV_RESHARP_1e-6_ero3', 'MEDI_PDF_ero0', 'MEDI_PDF_ero1', 'TFI_ero0', 'TFI_ero1'};
% %recons = {'TIK_ero1_TV_0.0004_Tik_0.001_PRE_5000', 'TFI_ero1', 'MEDI_PDF_ero1'};
% recons = {'MEDI_RESHARP_1e-6_ero3'};
% 
% %recons={'pdf_full_force', 'pdf_full','resharp_ero5', 'resharp_ero5_force', 'tfi_ero5', 'tfi_full', 'resharp_ero5_0', 'resharp_ero5_5e-4'};
% %recons={'pdf_full_force'};

%% Paper revision 2 - December 2017 %% revision 2 subject 11 to 17
clear all;
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
master_dir ='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
seg_master_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
subjectIDAll = {'11', '12', '13', '14', '15', '16', '17'};

%subjectIDAll = {'11'};
t1_file = 't1.mnc';
model_dir = ['/media/yma2/DATA/work/Data/QSM_HO/models/standard/'];
fastFlag=false;
%recons = {'TFI_brain', 'LN_brain', 'iFreq_rawSS_QSM_new_000', 'MEDI_RESHARP_1e-6_ero2', 'MEDI_PDF_ero0'};
recons = {'LN_ero0', 'LN_ero2'};

%% revision 2 subject 18 19
clear all;
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
master_dir ='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
seg_master_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
subjectIDAll = {'18', '19'};

t1_file = 't1.mnc';
model_dir = ['/media/yma2/DATA/work/Data/QSM_HO/models/standard/'];
fastFlag=false;
%recons = {'TFI_brain', 'LN_brain', 'iFreq_rawSS_QSM_new_000', 'MEDI_RESHARP_1e-6_ero2', 'MEDI_PDF_ero0'};
recons= {'LN_ero0', 'LN_ero2'};
%% revision 3 subject 11 to 17 - March 2018
clear all;
%
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
master_dir ='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
seg_master_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/';
subjectIDAll = {'11', '12', '13', '14', '15', '16', '17'};

%subjectIDAll = {'11'};
t1_file = 't1.mnc';
model_dir = ['/media/yma2/DATA/work/Data/QSM_HO/models/standard/'];
fastFlag=false;
%recons = {'TFI_brain', 'LN_brain', 'iFreq_rawSS_QSM_new_000', 'MEDI_RESHARP_1e-6_ero2', 'MEDI_PDF_ero0'};
recons = {'chi_resharp_iLSQR_ero2'};

%% revision 3 subject 18 to 19 - March 2018
clear all;
mag_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
master_dir ='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
seg_master_dir='/media/yma2/DATA/AcademicFS/Pikelab/Yuhan/Hongfu_QSM/atlas/revision/';
subjectIDAll = {'18', '19'};

%subjectIDAll = {'11'};
t1_file = 't1.mnc';
model_dir = ['/media/yma2/DATA/work/Data/QSM_HO/models/standard/'];
fastFlag=false;
%recons = {'TFI_brain', 'LN_brain', 'iFreq_rawSS_QSM_new_000', 'MEDI_RESHARP_1e-6_ero2', 'MEDI_PDF_ero0'};
recons = {'chi_resharp_iLSQR_ero2'};

%% clear old analysis
for ii = 1:length(subjectIDAll)
     subjectID = subjectIDAll{ii};
     cd([master_dir, subjectID]);
%     %system(['rm -r seg']);
%     %system(['rm -r transformations']);
%     system(['rm -r chi_in_struct']);
     system(['sudo rm -r chi_in_dgm_struct_no_ref']);
%     system(['rm -r *abs.mnc']);
%     system(['rm -r *abs_std.mnc']);
end
%% Create native masks
for ii = 1:length(subjectIDAll)
    fprintf(['Creating masks for subject ', num2str(ii), '... \n']);
    subjectID = subjectIDAll{ii};
    gre_template=[mag_dir, subjectID, '/mag1.mnc'];
    chi_dir = [master_dir, subjectID, '/'];
    create_native_masks_hongfu(seg_master_dir, subjectID, gre_template, model_dir, 0);
    

    
end
%% Normalize chi maps
for ii = 1:length(subjectIDAll)
        
    fprintf(['Normalizing QSM for subject ', num2str(ii), '... \n']);
    subjectID = subjectIDAll{ii};
    gre_template=[mag_dir, subjectID, '/mag1.mnc'];
    chi_dir = [master_dir, subjectID, '/'];
    
    cd(chi_dir)
    for jj = 1:(length(recons))
        
        fprintf(['For QSM recon method ', recons{jj}, '... \n']);
        curr_chi = [chi_dir, '/minc/',recons{jj}, '.mnc'];
        seg_dir=[seg_master_dir, subjectID, '/seg/'];
%         normalize_chi(seg_dir, curr_chi, 'none');
%         normalize_chi(seg_dir, curr_chi, 'pic');
        normalize_chi(seg_dir, curr_chi, 'dwm');
    end
    
end
%% Measure susceptibilities in deep gray matter structures

for ii = 1:length(subjectIDAll)
%for ii = 2
    
    fprintf(['Measuring DGM susceptibility for subject ', num2str(ii), '... \n']);
    subjectID = subjectIDAll{ii};
    gre_template=[master_dir, subjectID, '/mag1.mnc'];
    chi_dir = [master_dir, subjectID, '/'];
    
    for jj = 1:length(recons)
        
        fprintf(['For QSM recon method ', recons{jj}, '... \n']);
        curr_chi = [chi_dir, '/minc/', recons{jj}, '.mnc'];
        seg_dir=[seg_master_dir, subjectID, '/seg/'];
        get_suscep_struct_hongfu(seg_dir, curr_chi, 'dwm', fastFlag);
%         get_suscep_struct_hongfu(seg_dir, curr_chi, 'pic', fastFlag);
    end
    
end


%% Group level analysis
% two goals:
% 1. for each recon method, calculate average susceptibility for
% all subjects
% 2. create an average susceptibility map in standard space

subjectIDAll={'11', '12', '13', '14', '15', '16', '17', '18', '19'}
group_dir=[master_dir, 'group_avg'];

if (~exist(group_dir, 'dir'))
    mkdir(group_dir);
end

for ii = 1:length(recons)
    fprintf([recons{ii}, '\n']);
    for jj = 1:length(subjectIDAll)
        
        subjectID = subjectIDAll{jj};
        fprintf([subjectID, '\n']);
        curr_dir = [master_dir, subjectID, '/minc/', 'chi_in_dgm_struct_dwm_ref/'];
        filename = [curr_dir, recons{ii}, '_chi_in_dgm_structures_dwm_ref.txt'];
        % start reading the file at row 2, column 2 (no text)
        M = dlmread(filename, '\t', 1, 1);
        % get rid of zero columns
        M(:, all(~M, 1))=[];
        chi_in_struct(:,:,jj) = M;
        
%         source_chi = [master_dir, subjectID, '/', recons{ii}, '_abs.mnc'];
%         dest_chi = [master_dir, subjectID, '/', recons{ii}, '_abs_std.mnc'];
%         dest_template = [master_dir, subjectID, '/icbm/output_stx.mnc'];
        
%         tfm_dir= [master_dir, subjectID, '/', 'transformations/'];
%         stx_to_gre_tfm =  [tfm_dir, 'stx_to_gre.xfm'];
%         gre_to_stx_tfm =  [tfm_dir, 'gre_to_stx.xfm'];
%         system(['xfminvert ',stx_to_gre_tfm, ' ', gre_to_stx_tfm]);
%         resampleMasks(source_chi, dest_chi, gre_to_stx_tfm, dest_template);
%         [hdr(jj), sus(:,:,:,jj)] = niak_read_minc(dest_chi);
        
    end
    group_file = [group_dir, '/', recons{ii}, '_avg.txt'];
    % calculate average susceptibility and CNR
    avg_chi_in_struct = mean(chi_in_struct(:,1:2:3,:),3);
    
    mask_names = {'CC'; 'CP'; 'CR'; 'AIC'; 'PIC'; 'PTR'; 'SLF'; 'SFOF'; 'GCC'; ...
        'BCC'; 'SCC'; 'DWM'; 'RN';'SN'; 'STR'; 'GPe'; 'GPi'; 'putamen'; 'gp'; 'caudate'; 'thalamus';'wm';'gm';'csf'};
    
    mask_tissue_type = {'wm'; 'wm'; 'wm'; 'wm';   'wm';  'wm';  'wm';   'wm';  ...
        'wm'; 'wm';  'wm';  'wm'; 'gm';'gm';  'gm'; 'gm';  'gm'  ; 'gm'  ;    'gm'  ; 'gm' ; 'gm'  };
    
    
    fileID = fopen([group_dir, '/', recons{ii}, '_chi_in_structures_dwm_ref_avg.txt'], 'w');
    
    fprintf(fileID, 'structures\t\t\tsusceptibility (ppm)\t\tstandard deviation (ppm)\t\tCNR  \t\t      std CNR\n');
    
    

    
    for row = 1:size(chi_in_struct,1)
        chi_all = squeeze(chi_in_struct(row,1,:));
        cnr_all = squeeze(chi_in_struct(row,3,:));
        
        mean_chi(row) = mean(chi_all);
        mean_cnr(row) = mean(cnr_all);
        stddev_chi(row) = std(chi_all);
        stddev_cnr(row) = std(cnr_all);
        
        %calculate average susceptibility in each mask
        
        fprintf(fileID, [mask_names{row}, '\t\t\t\t%12.4f\t\t\t%12.4f\t\t\t%12.4f\t\t%12.4f\n'], mean_chi(row), stddev_chi(row),    mean_cnr(row),    stddev_cnr(row));;
        
        
        
        
    end
%     stddev_chi_in_struct = std(chi_in_struct,3);
%     sus_avg = mean(sus, 4);
%     hdr(1).file_name = [group_dir, '/', recons{ii}, '_chi_abs_avg.mnc'];
%     niak_write_minc(hdr(1), sus_avg);
%     clear sus;
%     clear hdr;
%     
%     dlmwrite(group_file, avg_chi_in_struct, '\t', 1, 1);
end

%%

