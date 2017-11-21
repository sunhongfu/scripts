function [Res_term,TV_term,Tik_term] = phantom_lcurve(mask_tissue, field)

TIKs={'10.0000e-006', '18.3298e-006', '33.5982e-006', '61.5848e-006', '112.8838e-006', '206.9138e-006', '379.2690e-006', '695.1928e-006', '1.2743e-003', '2.3357e-003', '4.2813e-003', '7.8476e-003', '14.3845e-003', '26.3665e-003', '48.3293e-003', '88.5867e-003', '162.3777e-003', '297.6351e-003', '545.5595e-003', '1.0000e+000'};
% TIKs={'206.9138e-006'};
% TVs={'1e-4','2e-4','3e-4','4e-4','5e-4'};
TVs={'1e-4'};




% rmse_tik = zeros(length(TVs),length(TIKs));
for i = 1:length(TVs)
	for j = 1:length(TIKs)
		nii = load_nii(['TIK_tissue_ero0_TV_' num2str(str2num(TVs{i})) '_Tik_' num2str(str2num(TIKs{j})) '_PRE_5000.nii']);
		tik = double(nii.img);


vox = [1 1 1];
z_prjs = [0 0 1]
% create K-space filter kernel D
%%%%% make this a seperate function in the future
[Nx, Ny, Nz] = size(tik);
FOV  = vox.*[Nx, Ny, Nz];
FOVx = FOV(1);
FOVy = FOV(2);
FOVz = FOV(3);

x = -Nx/2:Nx/2-1;
y = -Ny/2:Ny/2-1;
z = -Nz/2:Nz/2-1;

[kx, ky, kz] = ndgrid(x/FOVx,y/FOVy,z/FOVz);
D = 1/3 - (kx.*z_prjs(1) + ky.*z_prjs(2) + kz.*z_prjs(3)).^2 ./ (kx.^2 + ky.^2 + kz.^2);
D(floor(Nx/2+1), floor(Ny/2+1), floor(Nz/2+1)) = 0;
D = fftshift(D);

% parameter structures for inversion
% data consistancy and TV term objects
params.FT               = cls_dipconv([Nx, Ny, Nz], D); % class for dipole kernel convolution
params.TV               = cls_tv; 						% class for TV operation

params.Tik_mask         = mask_tissue; 
params.TV_mask          = mask_tissue; 
params.sus_mask         = mask_tissue;
params.Res_wt           = mask_tissue;

params.P                = 1;
params.data             = field;

[Res_term(i,j),TV_term(i,j),Tik_term(i,j)] = objFunc(tik, params);


		% tik_mean = tik(logical(mask_tissue));
		% tik_mean = mean(tik_mean(:));
		% err_tik = (tik - tik_mean - model + model_mean).*mask_tissue;
		% TVs{i}
		% TIKs{j}
		% rmse_tik(i,j) = sqrt(sum(err_tik(:).^2)/sum(mask_tissue(:)));

		% % plot the bar graphs
		% tik_normalized = tik - tik_mean + model_mean;
		% % y = [0 mean(tik_normalized(ROI_skull(:))); 1e-4 mean(tik_normalized(ROI_WM(:))); 0.02 mean(tik_normalized(ROI_GM(:))); -0.014 mean(tik_normalized(ROI_CSF(:))); 0.45 mean(tik_normalized(ROI_veins(:))); 0.09 mean(tik_normalized(ROI_PU(:))); 0.06 mean(tik_normalized(ROI_CN(:))); 0.18 mean(tik_normalized(ROI_GP(:))); 0.01 mean(tik_normalized(ROI_TH(:))); -3 mean(tik_normalized(ROI_teeth(:)))];
		% y = [-0.014 mean(tik_normalized(ROI_CSF(:))) mean(tfi_normalized(ROI_CSF(:))); 1e-4 mean(tik_normalized(ROI_WM(:))) mean(tfi_normalized(ROI_WM(:))); 0.01 mean(tik_normalized(ROI_TH(:))) mean(tfi_normalized(ROI_TH(:))); 0.02 mean(tik_normalized(ROI_GM(:))) mean(tfi_normalized(ROI_GM(:))); 0.06 mean(tik_normalized(ROI_CN(:))) mean(tfi_normalized(ROI_CN(:))); 0.09 mean(tik_normalized(ROI_PU(:))) mean(tfi_normalized(ROI_PU(:))); 0.18 mean(tik_normalized(ROI_GP(:))) mean(tfi_normalized(ROI_GP(:))); 0.45 mean(tik_normalized(ROI_veins(:))) mean(tfi_normalized(ROI_veins(:))); ];
		% yy = [0 std(tik_normalized(ROI_CSF(:))) std(tfi_normalized(ROI_CSF(:))); 0 std(tik_normalized(ROI_WM(:))) std(tfi_normalized(ROI_WM(:))); 0 std(tik_normalized(ROI_TH(:))) std(tfi_normalized(ROI_TH(:))); 0 std(tik_normalized(ROI_GM(:))) std(tfi_normalized(ROI_GM(:))); 0 std(tik_normalized(ROI_CN(:))) std(tfi_normalized(ROI_CN(:))); 0 std(tik_normalized(ROI_PU(:))) std(tfi_normalized(ROI_PU(:))); 0 std(tik_normalized(ROI_GP(:))) std(tfi_normalized(ROI_GP(:))); 0 std(tik_normalized(ROI_veins(:))) std(tfi_normalized(ROI_veins(:))); ];
		% figure; hold on; bar(y); errorbar(y,yy)
	end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function [Res_term,TV_term,Tik_term] = objFunc(m, params)
p = 1;

w2 = params.TV*(params.P.*m.*params.TV_mask);
TV = (w2.*conj(w2)+eps).^(p/2);
TV_term = sum(TV(:));

Res_term = params.FT*(params.P.*m.*params.sus_mask) - params.data;
Res_term = (params.Res_wt(:).*Res_term(:))'*(params.Res_wt(:).*Res_term(:));

Tik_term = (params.P(:).*params.Tik_mask(:).*m(:))'*(params.P(:).*params.Tik_mask(:).*m(:));








