%--------------------------------------------------------------------------
%% load mprage: 
%--------------------------------------------------------------------------

data_path = '/autofs/space/marduk_001/users/berkin/2021_09_14_hongfu_grappa/';

filename1 = 'meas_MID00273_FID15743_wip925b_TI2_EC2_VC_PAT3_p75iso.dat';

% dt1 = mapVBVD2([data_path, filename1], 'removeOS');
dt1 = mapVBVD([data_path, filename1], 'removeOS');

res1 = dt1.image();     
 
ref = dt1.refscan();


%--------------------------------------------------------------------------
%% parse
%--------------------------------------------------------------------------

kspace = sq(res1); 
kspace_ref = sq(ref); 

ti_use = 2;
te_use = 1;

kspace = kspace(:,:,:,:,te_use,ti_use);
kspace_ref = kspace_ref(:,:,:,:,te_use,ti_use);

kspace = permute(kspace, [1,3,4,2]);    %252x240x144x32
kspace_ref = permute(kspace_ref, [1,3,4,2]);    %252x24x144x32

img_hybrid = ifftc(kspace,1);
img_ref_hybrid = ifftc(kspace_ref,1);

%--------------------------------------------------------------------------
%% select single slice 
%--------------------------------------------------------------------------

slc_select = 150;

kspace_slice = sq(img_hybrid(slc_select,:,:,:));
img_slice = ifft2call(kspace_slice);

kspace_ref_slice = sq(img_ref_hybrid(slc_select,:,:,:));
img_ref_slice = ifft2call(kspace_ref_slice);


mosaic(rsos(img_slice,3),1,1,11,'',[0,3e-4])
mosaic(rsos(kspace_slice,3).^.5,1,1,12,'',[0,.02]), setGcf(.5)

mosaic(rsos(img_ref_slice,3),1,1,21,'',[0,3e-3])
mosaic(rsos(kspace_ref_slice,3).^.5,1,1,22,'',[0,.02]), setGcf(.5)


Kspace_Sampled = kspace_slice;

nACS = size(kspace_ref_slice,1);
Kspace_Acs = zeross(size(Kspace_Sampled));
Kspace_Acs(1+end/2-nACS/2:end/2+nACS/2,:,:) = kspace_ref_slice;


[eN(1), eN(2), num_chan, num_echo] = size(Kspace_Sampled)

mosaic( rsos(Kspace_Acs,3), 1, 1, 1, 'acs', [0,1e-4] ), setGcf(0.2)
mosaic( rsos(Kspace_Sampled, 3), 1, 1, 2, 'acq', [0,1e-4] ), setGcf(0.2)


%--------------------------------------------------------------------------
%% grappa: recon single slice
%--------------------------------------------------------------------------
  
num_eco = 1;
substitute_acs = 0;

Rx = 3;
Ry = 1;

delx = 2*ones(num_chan,1);        % starting index of ky lines
dely = 0*ones(num_chan,1);

lambda_percent = eps;       % percentage of sigma_min to use as regularizer

% num_acs = [eN(1), nACS]-2;        % size reduced due to 1 voxel circshift
num_acs = [nACS, eN(2)]-2;        % size reduced due to 1 voxel circshift
kernel_size = [3,3];        % odd kernel size


Img_Grappa = zeros([eN(1:2), num_chan, num_eco]);


for t = 1:num_eco
    Img_Grappa(:,:,:,t) = grappa_gfactor_2d_jvc3( Kspace_Sampled(:,:,:,t), Kspace_Acs, Rx, Ry, num_acs, kernel_size, lambda_percent, substitute_acs, delx, dely );
end


mosaic(rsos(Img_Grappa, 3), 1, num_eco, 11, 'pat', [0,1e-3], -90)
mosaic(rsos(fft2call(Img_Grappa),3), 1, num_eco, 12, 'pat', [0,1e-4], 0)


%--------------------------------------------------------------------------
%% loop over slices
%--------------------------------------------------------------------------
 
delete(gcp('nocreate'))
c = parcluster('local');    % build the 'local' cluster object

total_cores = c.NumWorkers; % 48 cores for marduk
parpool(ceil(total_cores/2))


num_eco = 1;
substitute_acs = 0;

N = size(img_hybrid(:,:,:,1,1,1));
eN = N(2:3);

Rx = 3;
Ry = 1;

delx = 2*ones(num_chan,1);        % starting index of ky lines
dely = 0*ones(num_chan,1);

lambda_percent = eps;       % percentage of sigma_min to use as regularizer

       
Img_Res = zeross([N,num_chan,num_eco]);

tic
parfor slc_select = 1:N(1)
    slc_select

    kspace_slice = sq(img_hybrid(slc_select,:,:,:));
    img_slice = ifft2call(kspace_slice);

    kspace_ref_slice = sq(img_ref_hybrid(slc_select,:,:,:));
    img_ref_slice = ifft2call(kspace_ref_slice);

    Kspace_Sampled = kspace_slice;

    nACS = size(kspace_ref_slice,1);
    Kspace_Acs = zeross(size(Kspace_Sampled));
    Kspace_Acs(1+end/2-nACS/2:end/2+nACS/2,:,:) = kspace_ref_slice;

    num_acs = [nACS, eN(2)]-2;        % size reduced due to 1 voxel circshift
    kernel_size = [3,3];        % odd kernel size

    Img_Grappa = zeros([eN(1:2), num_chan, num_eco]);

    for t = 1:num_eco
        Img_Grappa(:,:,:,t) = grappa_gfactor_2d_jvc3( Kspace_Sampled(:,:,:,t), Kspace_Acs, Rx, Ry, num_acs, kernel_size, lambda_percent, substitute_acs, delx, dely );
    end

    Img_Res(slc_select,:,:,:,:) = Img_Grappa; 
end
toc

delete(gcp('nocreate'))


% mosaic(rsos(Img_Res(slc_select,:,:,:), 4), 1, num_eco, 11, 'pat', [0,5e-4], 0)

imagesc3d2(rsos(Img_Res,4), s(Img_Res)/2, 22, [0,180,180], [0.,3e-4]),

% genNii(rsos(Img_Res,4), [1,1,1], [data_path, 'Img_Grappa_rsos_invivo_Hongfu.nii'])

 