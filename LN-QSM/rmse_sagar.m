%% load Sagar's whole head susceptiblity phantom
s=load('3Dmodel_new.mat');
model=double(s.model);
%% load the mask
s=load('Brain_mask.mat');
mask_brain=double(s.brmask);
s=load('Head_mask.mat');
mask_head=double(s.headmask);
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


vox = [1 1 1];
z_prjs = [0 0 1];
imsize = size(model);

mask_tissue = ones(imsize);
mask_tissue(model == 9) =0;
mask_tissue(model == -3) =0;


ROI_skull = zeros(imsize);
ROI_skull(abs(model)<1e-6) = 1;
ROI_skull = logical(ROI_skull);

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


model_mean = model(logical(mask_tissue));
model_mean = mean(model_mean(:));

% nii = load_nii('TFI_tissue_ero0.nii');
nii = load_nii('TFI_brain_ero0.nii');
tfi = double(nii.img);
tfi_mean = tfi(logical(mask_tissue));
tfi_mean = mean(tfi_mean(:));
tfi_normalized = tfi - tfi_mean + model_mean;

cd TFS_TIK_PRE_ERO0
% calculate the RMSE of different parameters for sagar phantom
% TIKs={'10.0000e-006', '18.3298e-006', '33.5982e-006', '61.5848e-006', '112.8838e-006', '206.9138e-006', '379.2690e-006', '695.1928e-006', '1.2743e-003', '2.3357e-003', '4.2813e-003', '7.8476e-003', '14.3845e-003', '26.3665e-003', '48.3293e-003', '88.5867e-003', '162.3777e-003', '297.6351e-003', '545.5595e-003', '1.0000e+000'};
TIKs={'206.9138e-006'};
% TVs={'1e-4','2e-4','3e-4','4e-4','5e-4'};
TVs={'1e-4'};

rmse_tik = zeros(length(TVs),length(TIKs));
for i = 1:length(TVs)
	for j = 1:length(TIKs)
		nii = load_nii(['TIK_tissue_ero0_TV_' num2str(str2num(TVs{i})) '_Tik_' num2str(str2num(TIKs{j})) '_PRE_5000.nii']);
		tik = double(nii.img);
		tik_mean = tik(logical(mask_tissue));
		tik_mean = mean(tik_mean(:));
		err_tik = (tik - tik_mean - model + model_mean).*mask_tissue;
		TVs{i}
		TIKs{j}
		rmse_tik(i,j) = sqrt(sum(err_tik(:).^2)/sum(mask_tissue(:)));

		% plot the bar graphs
		tik_normalized = tik - tik_mean + model_mean;
		% y = [0 mean(tik_normalized(ROI_skull(:))); 1e-4 mean(tik_normalized(ROI_WM(:))); 0.02 mean(tik_normalized(ROI_GM(:))); -0.014 mean(tik_normalized(ROI_CSF(:))); 0.45 mean(tik_normalized(ROI_veins(:))); 0.09 mean(tik_normalized(ROI_PU(:))); 0.06 mean(tik_normalized(ROI_CN(:))); 0.18 mean(tik_normalized(ROI_GP(:))); 0.01 mean(tik_normalized(ROI_TH(:))); -3 mean(tik_normalized(ROI_teeth(:)))];
		y = [-0.014 mean(tik_normalized(ROI_CSF(:))) mean(tfi_normalized(ROI_CSF(:))); 1e-4 mean(tik_normalized(ROI_WM(:))) mean(tfi_normalized(ROI_WM(:))); 0.01 mean(tik_normalized(ROI_TH(:))) mean(tfi_normalized(ROI_TH(:))); 0.02 mean(tik_normalized(ROI_GM(:))) mean(tfi_normalized(ROI_GM(:))); 0.06 mean(tik_normalized(ROI_CN(:))) mean(tfi_normalized(ROI_CN(:))); 0.09 mean(tik_normalized(ROI_PU(:))) mean(tfi_normalized(ROI_PU(:))); 0.18 mean(tik_normalized(ROI_GP(:))) mean(tfi_normalized(ROI_GP(:))); 0.45 mean(tik_normalized(ROI_veins(:))) mean(tfi_normalized(ROI_veins(:))); ];
		yy = [0 std(tik_normalized(ROI_CSF(:))) std(tfi_normalized(ROI_CSF(:))); 0 std(tik_normalized(ROI_WM(:))) std(tfi_normalized(ROI_WM(:))); 0 std(tik_normalized(ROI_TH(:))) std(tfi_normalized(ROI_TH(:))); 0 std(tik_normalized(ROI_GM(:))) std(tfi_normalized(ROI_GM(:))); 0 std(tik_normalized(ROI_CN(:))) std(tfi_normalized(ROI_CN(:))); 0 std(tik_normalized(ROI_PU(:))) std(tfi_normalized(ROI_PU(:))); 0 std(tik_normalized(ROI_GP(:))) std(tfi_normalized(ROI_GP(:))); 0 std(tik_normalized(ROI_veins(:))) std(tfi_normalized(ROI_veins(:))); ];
		figure; hold on; bar(y); errorbar(y,yy)
	end
end
