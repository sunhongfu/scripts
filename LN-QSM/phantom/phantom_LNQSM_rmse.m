
%% load Sagar's whole head susceptiblity phantom
s=load('model/3Dmodel_new.mat');
model=s.model;
%% load the mask
s=load('model/Brain_mask.mat');
mask_brain=s.brmask;
s=load('model/Head_mask.mat');
mask_head=s.headmask;
clear s

%%%%%%
% undersample it to 128*128*128!
% otherwise too big!
model = downsample(model,4);
model = downsample(permute(model,[2 1 3]),4);
model = downsample(permute(model,[3 2 1]),4);
model = permute(model,[2 3 1]);

mask_brain = downsample(mask_brain,4);
mask_brain = downsample(permute(mask_brain,[2 1 3]),4);
mask_brain = downsample(permute(mask_brain,[3 2 1]),4);
mask_brain = permute(mask_brain,[2 3 1]);

mask_head = downsample(mask_head,4);
mask_head = downsample(permute(mask_head,[2 1 3]),4);
mask_head = downsample(permute(mask_head,[3 2 1]),4);
mask_head = permute(mask_head,[2 3 1]);


%%%%%%
% add a layer of skull bone (susceptiblity = -2ppm)
r = 4;
[X,Y,Z] = ndgrid(-r:r,-r:r,-r:r);
h = (X.^2/r^2 + Y.^2/r^2 + Z.^2/r^2 <= 1);
ker = h/sum(h(:));
imsize = size(mask_brain);
mask_tmp = convn(mask_brain,ker,'same');
mask_exp = zeros(imsize);
mask_exp(mask_tmp > 0) = 1; % no error tolerance

mask_skull = (mask_exp - mask_brain > 0) & (model == 0);
model(mask_skull) = -2;
%%%%%%%%%%%%


vox = [1 1 1];
z_prjs = [0 0 1];
imsize = size(model);

mask_tissue = ones(imsize);
mask_tissue(model == 9) =0;
mask_tissue(model == -3) =0;
mask_tissue(model == -2) =0;


% ROIs
ROI_base = zeros(imsize);
ROI_base(abs(model)<1e-6) = 1;
ROI_base = logical(ROI_base);

ROI_WM = zeros(imsize);
ROI_WM(abs(model-1e-4)<1e-6) = 1;
ROI_WM = logical(ROI_WM);

ROI_GM = zeros(imsize);
ROI_GM(abs(model-0.02)<1e-6) = 1;
ROI_GM = logical(ROI_GM);

ROI_CSF = zeros(imsize);
ROI_CSF(abs(model+0.014)<1e-6) = 1;
ROI_CSF = logical(ROI_CSF);

ROI_veins = zeros(imsize);
ROI_veins(abs(model-0.45)<1e-6) = 1;
ROI_veins = logical(ROI_veins);

ROI_PU = zeros(imsize);
ROI_PU(abs(model-0.09)<1e-6) = 1;
ROI_PU = logical(ROI_PU);

ROI_CN = zeros(imsize);
ROI_CN(abs(model-0.06)<1e-6) = 1;
ROI_CN = logical(ROI_CN);

ROI_GP = zeros(imsize);
ROI_GP(abs(model-0.18)<1e-6) = 1;
ROI_GP = logical(ROI_GP);

ROI_TH = zeros(imsize);
ROI_TH(abs(model-0.01)<1e-6) = 1;
ROI_TH = logical(ROI_TH);

ROI_SN = zeros(imsize);
ROI_SN(abs(model-0.13)<1e-6) = 1;
ROI_SN = logical(ROI_SN);

ROI_RN = zeros(imsize);
ROI_RN(abs(model-0.08)<1e-6) = 1;
ROI_RN = logical(ROI_RN);

ROI_teeth = zeros(imsize);
ROI_teeth(abs(model+3)<1e-6) = 1;
ROI_teeth = logical(ROI_teeth);

ROI_skull = zeros(imsize);
ROI_skull(abs(model+2)<1e-6) = 1;
ROI_skull = logical(ROI_skull);

ROI_air = zeros(imsize);
ROI_air(abs(model-9)<1e-6) = 1;
ROI_air = logical(ROI_air);



% reference to CSF
chi = model;

% load in TFI results
nii = load_nii('TFI/TFI_head.nii');
TFI_head = double(nii.img);

nii = load_nii('TFI/TFI_tissue.nii');
TFI_tissue = double(nii.img);


% for i = 10:10:100
% 	nii = load_nii(['TFI/TFI_head_' num2str(i) '.nii']);
% 	TFI_head = double(nii.img);


% set CSF = -0.014
chi_TFI = TFI_head - mean(TFI_head(ROI_CSF>0)) - 0.014;
% chi_TFI = TFI_tissue - mean(TFI_tissue(ROI_CSF>0)) - 0.014;
nii = make_nii(chi_TFI,vox);
save_nii(nii,'TFI/chi_TFI.nii');


diff = chi_TFI - chi;
diff_brain = diff(mask_brain>0);
diff_tissue = diff(mask_tissue>0);
diff_head = diff(mask_head>0);

rmse_brain = sqrt(sum(diff_brain(:).^2)/sum(mask_brain(:)))
rmse_tissue = sqrt(sum(diff_tissue(:).^2)/sum(mask_tissue(:)))
rmse_head = sqrt(sum(diff_head(:).^2)/sum(mask_head(:)))




Tik_weights = {'10.0000e-006', '18.3298e-006', '33.5982e-006', '61.5848e-006', '112.8838e-006', '206.9138e-006', '379.2690e-006', '695.1928e-006', '1.2743e-003', '2.3357e-003', '4.2813e-003', '7.8476e-003', '14.3845e-003', '26.3665e-003', '48.3293e-003', '88.5867e-003', '162.3777e-003', '297.6351e-003', '545.5595e-003', '1.0000e+000'};

TV_weights = {'1e-4','2e-4','3e-4','4e-4','5e-4'};


% TV_weights = {'1e-4','2e-4','3e-4','4e-4','5e-4'};
% Tik_weights = {'1.2743e-003'};


rmse_brain = zeros(length(Tik_weights),length(TV_weights));
rmse_tissue = zeros(length(Tik_weights),length(TV_weights));
rmse_head = zeros(length(Tik_weights),length(TV_weights));

for i = 1:length(Tik_weights)
	for j = 1: length(TV_weights)
		Tik = str2num(Tik_weights{i});
		TV = str2num(TV_weights{j});
		nii = load_nii(['TIK_hs_TV_' num2str(TV) '_Tik_' num2str(Tik) '_P30_5000_maskTV.nii']);
		chi_LN = double(nii.img);

		% set CSF = -0.014
		chi_LN = chi_LN - mean(chi_LN(ROI_CSF>0)) - 0.014;

		nii = make_nii(chi_LN);
		save_nii(nii,['TIK_hs_TV_' num2str(TV) '_Tik_' num2str(Tik) '_P30_5000_maskTV_CSF.nii'])

		diff = chi_LN - chi;
		diff_brain = diff(mask_brain>0);
		diff_tissue = diff(mask_tissue>0);
		diff_head = diff(mask_head>0);

		rmse_brain(i,j) = sqrt(sum(diff_brain(:).^2)/sum(mask_brain(:)));
		rmse_tissue(i,j) = sqrt(sum(diff_tissue(:).^2)/sum(mask_tissue(:)));
		rmse_head(i,j) = sqrt(sum(diff_head(:).^2)/sum(mask_head(:)));

		% y = [-0.014 mean(chi_LN(ROI_CSF(:))) mean(tfi_normalized(ROI_CSF(:))); 1e-4 mean(chi_LN(ROI_WM(:))) mean(tfi_normalized(ROI_WM(:))); 0.01 mean(chi_LN(ROI_TH(:))) mean(tfi_normalized(ROI_TH(:))); 0.02 mean(chi_LN(ROI_GM(:))) mean(tfi_normalized(ROI_GM(:))); 0.06 mean(chi_LN(ROI_CN(:))) mean(tfi_normalized(ROI_CN(:))); 0.09 mean(chi_LN(ROI_PU(:))) mean(tfi_normalized(ROI_PU(:))); 0.18 mean(chi_LN(ROI_GP(:))) mean(tfi_normalized(ROI_GP(:))); 0.45 mean(chi_LN(ROI_veins(:))) mean(tfi_normalized(ROI_veins(:))); ];
		% yy = [0 std(chi_LN(ROI_CSF(:))) std(tfi_normalized(ROI_CSF(:))); 0 std(chi_LN(ROI_WM(:))) std(tfi_normalized(ROI_WM(:))); 0 std(chi_LN(ROI_TH(:))) std(tfi_normalized(ROI_TH(:))); 0 std(chi_LN(ROI_GM(:))) std(tfi_normalized(ROI_GM(:))); 0 std(chi_LN(ROI_CN(:))) std(tfi_normalized(ROI_CN(:))); 0 std(chi_LN(ROI_PU(:))) std(tfi_normalized(ROI_PU(:))); 0 std(chi_LN(ROI_GP(:))) std(tfi_normalized(ROI_GP(:))); 0 std(chi_LN(ROI_veins(:))) std(tfi_normalized(ROI_veins(:))); ];
		% figure; hold on; bar(y); errorbar(y,yy)
	end
end

