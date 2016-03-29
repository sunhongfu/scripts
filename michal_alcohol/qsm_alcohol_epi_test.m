opt = EPIopt(1);
% opt.only_first = 1; % only recon the first run/volume
% recon all the time series (volumes)

% [par,img] = EPIrecon_CAB(pwd,opt);
[par,img] = EPIrecon_CAB(pwd,opt);





%% important %%
% http://dicomiseasy.blogspot.ca/2013/06/getting-oriented-using-image-plane.html
% DICOM defines a term: "Reference Coordinates System" or RCS.  
% The RCS is a very intuitive coordinate system of the patient body: X direction is from Right to Left. 
% So if the patient is standing in front of you with the arm raised to the sides, 
% then X direction is from the right hand to the left hand.
% Y direction is from front to back or medical-wise from Anterior to Posterior 
% so if the patient is standing in front of you so you see him/her from his/her left side, 
% then Y goes from your left to your right.
% Z direction goes from Feet to Head. At least this is simple to explain.

% Now that we know the directions, there are letters assigned to the ends of each direction:
% [R] - Right - The direction in which X decreases. 
% [L] - Left - The direction in which X increases. 
% [A] - Anterior - The direction in which Y decreases. 
% [P] - Posterior - The direction in which Y increases. 
% [F] - Feet - The direction in which Z decreases. 
% [H] - Head - The direction in which Z increases.

% x: facing the patient, from patient's right to left hand.
% y: front to back, anterior to Posterior
% z: feet to Head

% flip dimensions into RCS
% the first two dimensions need to be permuted (switch)
% y-direction is good
% z-direction need to be flipped
% not sure about x-direction!!! NEEDS validation!



% img = flipdim(flipdim(img,3),2);  % rotate along the x-axis for 180 degree
voxelSize = par.voxsize;


img_all = img;
for i = size(img_all,4) % all 320 time series
	img = img_all(:,:,:,i);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% img = flipdim(flipdim(img,3),2);  % rotate along the x-axis for 180 degree
% voxelSize = par.voxsize;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mkdir('combine');
nii = make_nii(abs(img),voxelSize);
save_nii(nii,['combine/mag_cmb' num2str(i) '.nii']);
nii = make_nii(angle(img),voxelSize);
save_nii(nii,['combine/ph_cmb' num2str(i) '.nii']);


bet_thr = 0.3;
disp('--> extract brain volume and generate mask ...');
setenv('bet_thr',num2str(bet_thr));
setenv('time_series',num2str(i));
unix('bet combine/mag_cmb${time_series}.nii BET${time_series} -f ${bet_thr} -m -Z');
unix('gunzip -f BET${time_series}.nii.gz');
unix('gunzip -f BET${time_series}_mask.nii.gz');
nii = load_nii(['BET' num2str(i) '_mask.nii']);
mask = double(nii.img);



% unph = unwrapLaplacian(angle(img), size(img), voxelSize);
% nii = make_nii(unph, voxelSize);
% save_nii(nii,'unph_lap.nii');

Options.voxelSize = voxelSize;
unph = lapunwrap(angle(img), Options);
nii = make_nii(unph, voxelSize);
save_nii(nii,'unph_lap.nii');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unwrap combined phase with PRELUDE
disp('--> unwrap aliasing phase ...');
unix('prelude -a combine/mag_cmb${time_series}.nii -p combine/ph_cmb${time_series}.nii -u unph${time_series}.nii -m BET${time_series}_mask.nii -n 8');
unix('gunzip -f unph${time_series}.nii.gz');
nii = load_nii(['unph' num2str(i) '.nii']);
unph = double(nii.img);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



smv_rad = 6;
tik_reg = 0.001;
% background field removal
disp('--> RESHARP to remove background field ...');
mkdir('RESHARP');
[lph_resharp,mask_resharp] = resharp(unph,mask,voxelSize,smv_rad,tik_reg);
lfs_resharp = -lph_resharp/(2.675e8*par.te*4.7)*1e6;
nii = make_nii(lfs_resharp,voxelSize);
save_nii(nii,'RESHARP/lfs_resharp.nii');

lfs_poly = zeros(size(lfs_resharp));
for sl = 1:size(lfs_resharp,3)
	lfs_poly(:,:,sl) = poly2d(lfs_resharp(:,:,sl),mask_resharp(:,:,sl));
end

nii = make_nii(lfs_poly,voxelSize);
save_nii(nii,'RESHARP/lfs_resharp_poly.nii');

phi = par.phi/180*pi;
psi = par.psi/180*pi;
theta = par.theta/180*pi;
nor_vec = [sin(psi)*sin(theta), -cos(psi)*sin(theta), cos(theta)]
if ~ isequal(nor_vec,[0 0 1])
	disp('This is angled slicing');
	pwd
end

tvdi_n = 20;
tv_reg = 0.0001;

lfs_poly_flip = flipdim(flipdim(permute(lfs_poly,[2 1 3]),2),3);
mask_resharp_flip = flipdim(flipdim(permute(mask_resharp,[2 1 3]),2),3);
img_flip = flipdim(flipdim(permute(img,[2 1 3]),2),3);
disp('--> TV susceptibility inversion ...');
sus_resharp_flip = tvdi(lfs_poly_flip,mask_resharp_flip,voxelSize,tv_reg,abs(img_flip),nor_vec,tvdi_n);
nii = make_nii(sus_resharp_flip.*mask_resharp_flip,voxelSize);
save_nii(nii,'RESHARP/sus_resharp_flip.nii');


disp('--> TV susceptibility inversion ...');
sus_resharp = tvdi(lfs_poly,mask_resharp,voxelSize,tv_reg,abs(img),nor_vec,tvdi_n);
nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
save_nii(nii,'RESHARP/sus_resharp.nii');

nii = make_nii(flipdim(permute(sus_resharp.*mask_resharp,[2 1 3]),1)); % clockwise rotate the nifti 90 degree
save_nii(nii,'RESHARP/sus_resharp_rotated.nii');
save all