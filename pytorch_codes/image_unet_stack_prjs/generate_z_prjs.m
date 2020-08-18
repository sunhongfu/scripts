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


fileID = fopen('z_prjs.txt','w');
for i = 1:5:15000
    for j = 1:5
        test_ID = [num2str(i) '-' num2str(j)];
        fprintf(fileID,'%s %f %f %f\n',test_ID, z_prjs_all(j,:) );
    end
end

fclose(fileID);