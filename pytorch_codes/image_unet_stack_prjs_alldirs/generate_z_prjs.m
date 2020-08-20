z_prjs_all = [];

load('/Volumes/LaCie/COSMOS_7T/01EG/left/QSM_MEGE_7T/all_new.mat','z_prjs')
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_7T/01EG/right/QSM_MEGE_7T/all_new.mat','z_prjs')
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_7T/01EG/neutral/QSM_MEGE_7T/all_new.mat','z_prjs')
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_7T/01EG/flexion/QSM_MEGE_7T/all_new.mat','z_prjs')
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_7T/01EG/extension/QSM_MEGE_7T/all_new.mat','z_prjs')
z_prjs_all = [z_prjs_all; z_prjs];


fileID = fopen('/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/image_unet_stack_prjs/z_prjs.txt','w');
for i = 1:5:15000
    for j = 1:5
        test_ID = [num2str(i) '-' num2str(j)];
        fprintf(fileID,'%s %f %f %f\n',test_ID, z_prjs_all(j,:) );
    end
end

fclose(fileID);







z_prjs_all = [];
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat');
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat');
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat');
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat');
z_prjs_all = [z_prjs_all; z_prjs];
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat','z_prjs');
z_prjs_all = [z_prjs_all; z_prjs];

z_prjs_central_permute132 = permute(z_prjs', [1 3 2]);
z_prjs_central_permute132(1) = -z_prjs_central_permute132(1);
z_prjs_all = [z_prjs_all; z_prjs_central_permute132'];


fileID = fopen('/Users/uqhsun8/Documents/MATLAB/scripts/pytorch_codes/image_unet_stack_prjs/z_prjs_testdata.txt','w');
test_ID = {'left', 'right', 'forward', 'backward', 'central', 'central_permute132'};

for j = 1:6 
    fprintf(fileID,'%s %f %f %f\n',test_ID{j}, z_prjs_all(j,:) );
end

fclose(fileID);