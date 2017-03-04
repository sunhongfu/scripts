function phase_unwrap = HS_PRELUDE(img,order)
% mask should be generated with combined magnitudes images
order = num2str(order);
setenv('order',order); %to pass the MATLAB variables to bash

nii = make_nii(abs(img));
save_nii(nii,['data_abs' order]);
nii = make_nii(angle(img));
save_nii(nii,['data_phase' order]);


unix('prelude -a data_abs${order} -p data_phase${order} -u prelude_result${order} -m brain_BET_mask.nii.gz');
unix('gunzip -f prelude_result${order}.nii.gz');

result = load_nii(['prelude_result' order '.nii']);
phase_unwrap = double(result.img);
