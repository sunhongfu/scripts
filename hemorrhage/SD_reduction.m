% sus of non-hemo region
clear
load all_super
sus_super_nonhemo = sus_super_fix_lbv.*mask_noHemo_lbv;
sus_lbv_nohemo = sus_lbv.*mask_noHemo_lbv;

diff = sus_lbv_nohemo - sus_super_nonhemo;
tmp = diff(logical(mask_noHemo_lbv));
std(tmp(:))
max(tmp(:))
min(tmp(:))





nii = make_nii(sus_super_nonhemo,voxelSize);
save_nii(nii,'sus_super_nohemo.nii');

nii = make_nii(sus_lbv_nohemo,voxelSize);
save_nii(nii,'sus_lbv_nohemo.nii');


tmp1 = sus_super_nonhemo(logical(mask_noHemo_lbv));
std(tmp1(:))

tmp2 = sus_lbv_nohemo(logical(mask_noHemo_lbv));
std(tmp2(:))


