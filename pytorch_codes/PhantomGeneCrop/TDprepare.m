folder = 'F:/Temp/';
R = 30; Number = 150; Iteration = 96;

for itr = 1:1:Iteration
load_path = [folder,num2str(itr),'.nii']; 
save_path_lfs = [folder,'/lfs/lfs',num2str(itr),'.nii'];
save_path_tfs = [folder,'/tfs/tfs',num2str(itr),'.nii'];

nii_QSM = load_untouch_nii(load_path);
QSM = nii_QSM.img; matrix = QSM; 

[bkg,~,~,~,~] = PhanGene(matrix,R,Number);

mask = QSM ~= 0;
maskA = ~mask;
bkg_msk = bkg.*maskA;
QSM_N = QSM + bkg_msk;

lfs = forward_field_calc(QSM); lfs_msk = lfs.* mask;
tfs = forward_field_calc(QSM_N); tfs_msk = tfs .* mask;

lfs_nii = make_nii(double(lfs_msk)); save_nii(lfs_nii, save_path_lfs);
tfs_nii = make_nii(double(tfs_msk)); save_nii(tfs_nii, save_path_tfs);
end

