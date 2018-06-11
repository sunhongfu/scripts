function get_suscep_struct(seg_dir, chi, refregion, fastFlag)
display(['Running get_suscep_struct for ', chi, ' with ref ', refregion]);
% function get_suscep_struct(master_dir, subjectID, chi, refregion)
% Inputs:
% master_dir
% subjectID
% chi: current susceptibility map file
% refregion (string), the type of reference region for QSM. Right now three
% options: dwm, pic, or none (raw images)

%seg_dir = [master_dir, subjectID, '/QSM_baseline/', 'seg/'];
[chi_main_dir, chi_filename, chi_file_ext] = fileparts(chi);

% if (strcmp(refregion, 'dwm'))
%     chi_dir = [chi_main_dir, '/chi_dwm_ref'];
%     chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
%     result_dir = 'chi_in_dgm_struct_dwm_ref';
%     fileID = fopen([chi_filename, '_chi_in_dgm_structures_dwm_ref.txt'], 'w');
%
% elseif (strcmp(refregion, 'pic'))
%
%     chi_dir = [chi_main_dir, '/chi_pic_ref'];
%     chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
%     result_dir = 'chi_in_dgm_struct_pic_ref';
%     fileID = fopen([chi_filename, '_chi_in_dgm_structures_pic_ref.txt'], 'w');
%
% elseif (strcmp(refregion, 'csf'))
%
%     chi_dir = [chi_main_dir, '/chi_csf_ref'];
%     chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
%     result_dir = 'chi_in_dgm_struct_csf_ref';
%     fileID = fopen([chi_filename, '_chi_in_dgm_structures_csf_ref.txt'], 'w');
% end

if (strcmp(refregion, 'none'))
    
    chi_dir = [chi_main_dir, '/chi_none_ref'];
    chi_abs = chi;
    result_dir = 'chi_in_dgm_struct_no_ref';
    filename = [chi_filename, '_chi_in_dgm_structures_no_ref.txt'];
else
    chi_dir = [chi_main_dir, '/chi_', refregion,'_ref'];
    chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
    result_dir = ['chi_in_dgm_struct_', refregion,'_ref'];
    filename = [chi_filename, '_chi_in_dgm_structures_', refregion,'_ref.txt'];

end


%defineMasks;

cd(chi_dir);
load([chi_filename, '_chi_ref.mat']);

cd(chi_main_dir);

if (~exist(result_dir, 'dir'))
    mkdir(result_dir);
end


% mask_names = {'CC'; 'CP'; 'CR'; 'AIC'; 'PIC'; 'PTR'; 'SLF'; 'SFOF'; 'GCC'; ...
%     'BCC'; 'SCC'; 'DWM'; 'RN';'SN'; 'STR'; 'GPe'; 'GPi'; 'putamen'; 'gp'; 'caudate'; 'thalamus';'csf_ant';'wm';'gm';'csf'};
mask_names = {'CC'; 'CP'; 'CR'; 'AIC'; 'PIC'; 'PTR'; 'SLF'; 'SFOF'; 'GCC'; ...
    'BCC'; 'SCC'; 'DWM'; 'RN';'SN'; 'STR'; 'GPe'; 'GPi'; 'putamen'; 'gp'; 'caudate'; 'thalamus';'wm';'gm';'csf'};

cd(seg_dir);
system(['rm wm_mask.mnc']);
system(['rm gm_mask.mnc']);
system(['rm csf_mask.mnc']);

%     system(['cp wm_mask_reg_tmp.mnc wm_mask.mnc']);
%     system(['cp gm_mask_reg_tmp.mnc gm_mask.mnc']);
%     system(['cp csf_mask_reg_tmp.mnc csf_mask.mnc']);

if fastFlag 
    system(['nii2mnc wm_fast_mask.nii wm_mask.mnc']);
    system(['nii2mnc gm_fast_mask.nii gm_mask.mnc']);
    system(['nii2mnc csf_fast_mask.nii csf_mask.mnc']);
  
%     system(['volflip -clobber -x wm_mask.mnc wm_mask.mnc']);
%     system(['volflip -clobber -y wm_mask.mnc wm_mask.mnc']);
%     
%     system(['volflip -clobber -x gm_mask.mnc gm_mask.mnc']);
%     system(['volflip -clobber -y gm_mask.mnc gm_mask.mnc']);
%     
%     system(['volflip -clobber -x csf_mask.mnc csf_mask.mnc']);
%     system(['volflip -clobber -y csf_mask.mnc csf_mask.mnc']);

else
    system(['cp wm_mask_reg_tmp.mnc wm_mask.mnc']);
    system(['cp gm_mask_reg_tmp.mnc gm_mask.mnc']);
    system(['cp csf_mask_reg_tmp.mnc csf_mask.mnc']);

end


for ii = 1:length(mask_names)
    %     if (ii>=1 && ii<=3)
    %         mask_files{ii}=[mask_names{ii}, '_mask_reg_tmp.mnc'];
    %     elseif(ii>=4 && ii<=(length(mask_names) -9))
    
    
    
    if (ii<=(length(mask_names) -12))
        mask_files{ii}=[mask_names{ii}, '_mask_erode2v.mnc'];
        
    else
        mask_files{ii}=[mask_names{ii}, '_mask.mnc'];
    end
end
cd([chi_main_dir, '/', result_dir]);
fileID = fopen(filename, 'w');
fprintf(fileID, 'structures\t\t\tsusceptibility (ppm)\t\tstandard deviation (ppm)\t\tCNR  \t\t      std CNR\n');


for ii = 1:length(mask_names)
    %calculate average susceptibility in each mask
    %[avg_sus(ii), std_sus(ii)] = calc_avg_std_w_mask(chi_abs, [seg_dir, mask_files{ii}]);
    [hdr, mask] = niak_read_minc([seg_dir, mask_files{ii}]);
    mask = logical(mask);
    
    if fastFlag
        if strcmp(mask_names{ii}, 'wm') | strcmp(mask_names{ii}, 'gm') | strcmp(mask_names{ii}, 'csf')
            mask=flip(mask,1);
            mask=flip(mask,2);
            
        end
    end
          
    [hdr, chi] = niak_read_minc(chi_abs);
    
    avg_sus(ii)=mean(chi(mask));
    std_sus(ii)=std(chi(mask));
    
    fprintf(fileID, [mask_names{ii}, '\t\t\t\t%12.4f\t\t\t%12.4f\t\t\t%12.4f\t\t%12.4f\n'], avg_sus(ii), std_sus(ii),    avg_sus(ii)/std_sus(ii),    std_sus(ii)/std_ref);
    
    
end




end
