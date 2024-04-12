clear
clc

datasize = 96 * 5 * 6 * 5;

QSM_Folder = 'qsm_training';
BKG_Folder = 'bkg_training';
Vox_Folder = 'vox_training';
zprjs_Folder = 'z_prjs_training';

mkdir(QSM_Folder)
mkdir(BKG_Folder)
mkdir(zprjs_Folder)
mkdir(Vox_Folder)

for FileNo = 1 : datasize

    vox = [1 1 1];
    z_prjs = [0 0 1];  % iQSM original data; 
    Gen_QSM_BKG_patch(FileNo, vox, z_prjs, QSM_Folder, BKG_Folder, Vox_Folder, zprjs_Folder)

end

for FileNo = (datasize + 1) : 2 * datasize

    vox = [1 1 1]; % fixed vox; 

    theta = pi / 2 * rand; %% theta between B0 and Fovz;
    phi = 2 * pi * rand; %% phi betwwen Fovx and B0;

    z_prjs = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)]; % random z_prjs;

    Gen_QSM_BKG_patch(FileNo, vox, z_prjs, QSM_Folder, BKG_Folder, Vox_Folder, zprjs_Folder)

end

for FileNo = (2 * datasize + 1) : 3 * datasize

    z_prjs = [0 0 1]; % pure axial zprjs; 

    hx = 1 * rand + 1; %% 1mm - 2mm;
    hy = 1 * rand + 1;
    hz = 1 * rand + 1;

    vox = [hx, hy, hz];  % random vox 1-2mm; 

    Gen_QSM_BKG_patch(FileNo, vox, z_prjs, QSM_Folder, BKG_Folder, Vox_Folder, zprjs_Folder)

end

for FileNo = (3 * datasize + 1) : 4 * datasize

    hx = 1 * rand + 1; %% 1mm - 2mm;
    hy = 1 * rand + 1;
    hz = 1 * rand + 1;

    vox = [hx, hy, hz];

    theta = pi / 2 * rand; %% theta between B0 and Fovz;
    phi = 2 * pi * rand; %% phi betwwen Fovx and B0;

    z_prjs = [sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta)]; % random z_prjs;
    Gen_QSM_BKG_patch(FileNo, vox, z_prjs, QSM_Folder, BKG_Folder, Vox_Folder, zprjs_Folder)

end





