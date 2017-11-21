function [Res_term, TV_term, Tik_term] = lcurve(qsm_folder,TV_weight,Tik_weight,outputName)

qsm_folder
cd(qsm_folder)
% data = load([qsm_folder 'all.mat'],'-mat');

s = load([qsm_folder 'all.mat'],'-mat','tfs','mask','R','vox','z_prjs');
tfs = s.tfs;
mask = s.mask;
R = s.R;
vox = s.vox;
z_prjs = s.z_prjs;

mkdir('L-curve');

TV_weight = str2num(TV_weight);
Tik_weight = str2num(Tik_weight);

% TV_weight = [0, 1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 5e-4, 1e-3, 5e-3, 1e-2, 5e-2, 0.1, 0.5, 1, 5, 10];
% % Tik_weight = [0, 1e-6, 5e-6, 1e-5, 5e-5, 1e-4, 5e-4, 1e-3, 5e-3, 1e-2, 5e-2, 0.1, 0.5, 1, 5, 10];
% Tik_weight = [0, 1e-6, 5e-6, 1e-5];

Res_term = zeros(length(TV_weight),length(Tik_weight));
TV_term = zeros(length(TV_weight),length(Tik_weight));
Tik_term = zeros(length(TV_weight),length(Tik_weight));

%c = parcluster
% parpool(4)
for i = 1:length(TV_weight)
	Res_term0 = zeros(1,length(Tik_weight));
	TV_term0 = zeros(1,length(Tik_weight));
	Tik_term0 = zeros(1,length(Tik_weight));
	for j = 1:length(Tik_weight)
		[chi, Res_term0(j), TV_term0(j), Tik_term0(j)] = tikhonov_qsm(tfs, mask.*R, 1, mask.*R, mask.*R, TV_weight(i), Tik_weight(j), vox, z_prjs, 5000);
		nii = make_nii(chi.*mask.*R,vox);
		save_nii(nii,['L-curve/chi_brain_TV_' num2str(TV_weight(j)) '_Tik_' num2str(Tik_weight(i)) '_2000.nii']);
	end
	Res_term(i,:) = Res_term0 
	TV_term(i,:) = TV_term0
	Tik_term(i,:) = Tik_term0

end


save([qsm_folder outputName]);
