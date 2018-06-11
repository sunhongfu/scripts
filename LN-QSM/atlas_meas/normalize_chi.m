function normalize_chi(seg_dir, chi, refregion)

%seg_dir = [master_dir, subjectID, '/QSM_baseline/', 'seg/'];
[chi_dir, chi_filename, chi_file_ext] = fileparts(chi);

defineMasks;
if (strcmp(refregion, 'dwm'))
    chi_dir = [chi_dir, '/chi_dwm_ref'];    
    if (~exist(chi_dir, 'dir'))
        mkdir(chi_dir);
    end
    chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
    cd(chi_dir)
    diary('log_dwm_stats');
    ref_mask = [seg_dir, 'DWM_mask_erode2v.mnc'];
    %ref_mask_sus = -0.03;
    ref_mask_sus = 0.0;
    display(['Referened mask used is ', ref_mask]);

    [hdr_chi, chi_vol] = niak_read_minc(chi);
    [hdr_tmp, ref_mask_vol] = niak_read_minc(ref_mask);
    [chi_abs_vol, std_ref] = getAbsSuscWithRef(chi_vol, ref_mask_vol, ref_mask_sus);
    hdr_chi.file_name = chi_abs;
    niak_write_minc(hdr_chi, chi_abs_vol);
    save([chi_filename, '_chi_ref.mat'], 'chi_abs_vol', 'std_ref');
    diary off;
elseif (strcmp(refregion, 'pic'))
    
    chi_dir = [chi_dir, '/chi_pic_ref'];
    if (~exist(chi_dir, 'dir'))
        mkdir(chi_dir);
    end
    
    chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
    cd(chi_dir)
    diary('log_pic_stats');
    ref_mask = [seg_dir, 'PIC_mask_erode2v.mnc'];
    ref_mask_sus = -0.05;
    display(['Referened mask used is ', ref_mask]);

    [hdr_chi, chi_vol] = niak_read_minc(chi);
    [hdr_tmp, ref_mask_vol] = niak_read_minc(ref_mask);
    [chi_abs_vol, std_ref] = getAbsSuscWithRef(chi_vol, ref_mask_vol, ref_mask_sus);
    hdr_chi.file_name = chi_abs;
    niak_write_minc(hdr_chi, chi_abs_vol);
    save([chi_filename, '_chi_ref.mat'], 'chi_abs_vol', 'std_ref');

elseif (strcmp(refregion, 'csf'))
    chi_dir = [chi_dir, '/chi_csf_ref'];
    if (~exist(chi_dir, 'dir'))
        mkdir(chi_dir);
    end
    
    chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
    cd(chi_dir)
    diary('log_csf_stats');
     
    ref_mask = [seg_dir, 'csf_ant_mask.mnc'];
    ref_mask_sus = 0;
    display(['Referened mask used is ', ref_mask]);
    [hdr_chi, chi_vol] = niak_read_minc(chi);
    [hdr_tmp, ref_mask_vol] = niak_read_minc(ref_mask);
    [chi_abs_vol, std_ref] = getAbsSuscWithRef(chi_vol, ref_mask_vol, ref_mask_sus);
    hdr_chi.file_name = chi_abs;
    niak_write_minc(hdr_chi, chi_abs_vol);
    save([chi_filename, '_chi_ref.mat'], 'chi_abs_vol', 'std_ref');
       
elseif (strcmp(refregion, 'none'))
    chi_dir = [chi_dir, '/chi_none_ref'];
    if (~exist(chi_dir, 'dir'))
        mkdir(chi_dir);
    end
    
    cd(chi_dir);
    chi_abs = [chi_dir, '/',chi_filename, '_abs', chi_file_ext];
    [hdr_tmp, chi_abs_vol]=niak_read_minc(chi);
    hdr_chi.file_name = chi_abs;
    niak_write_minc(hdr_chi, chi_abs_vol);
    
    std_ref = 0;
    cd(chi_dir);
    save([chi_filename, '_chi_ref'], 'chi_abs_vol', 'std_ref'); 
    
    
end

%plotWMhistorgram(chi, seg_dir, mask_names);

end
%%
function   [chi_abs_vol, std_chi_masked] = getAbsSuscWithRef(chi_vol, ref_mask_vol, ref_mask_sus)

% use the average susceptibility in ref_mask as a reference

mask = logical(ref_mask_vol);
chi_masked = chi_vol(mask);

avg_chi_masked = mean(chi_masked);
std_chi_masked = std(chi_masked);

chi_abs_vol = chi_vol - (avg_chi_masked - ref_mask_sus);
fprintf('The susceptibility offset of the masked structure is %.5f ppm, the std is %.5f ppm \n', (avg_chi_masked - ref_mask_sus), std_chi_masked);




end

%%
function plotWMhistorgram(chi, seg_dir, mask_names)

[chi_dir, chi_filename, chi_file_ext] = fileparts(chi);

cd(chi_dir);
result_dir = 'chi_in_struct';
if ~(exist(result_dir, 'dir'))
    mkdir(result_dir);
end
cd(result_dir);
close all;
set_figure_defaults;
hfig=figure(100),
for ii=1:(length(mask_names)-9) %only wm structures here
    if(exist([result_dir, chi_filename, '_', mask_names{ii}, '_chi.mat'], 'file'))
        load([result_dir, chi_filename, '_', mask_names{ii}, '_chi']);
    else
        segmented_mask=[mask_names{ii},'_mask.mnc'];
        eroded_mask=[mask_names{ii},'_mask_eroded.mnc'];
        system(['mincmorph -clob -successive E ', seg_dir, segmented_mask, ' ', seg_dir, eroded_mask]);
        clear avg_chi;
        clear std_chi;
        clear chi_struct;
        [avg_chi, std_chi, chi_struct] = calc_avg_std_w_mask(chi, [seg_dir, eroded_mask]);
        
        save([chi_filename, '_', mask_names{ii}, '_chi'], 'avg_chi', 'std_chi', 'chi_struct');
    end
    subplot(3,4, ii), h=histogram(chi_struct);
    title(sprintf([mask_names{ii}, ' %3.1f +/- %3.1f ppb'], avg_chi*1000,std_chi*1000), 'FontSize', 10);
    xlim([-0.1 0.1]);
    hold on;
end

savefig(hfig, [chi_filename, '_', 'wm_struct_hist.fig']);
close all;

end

