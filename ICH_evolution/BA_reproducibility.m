BAinfo = {'RPC'};

% CT value intra reproducibility
CT_intra = value(:,[1,7]);
[row,~]=find(~CT_intra);
CT_intra(row,:,:)=[];
% h1 = figure;
BlandAltman(CT_intra(:,1), CT_intra(:,2),{'HS1','HS2','Hu'},'CT mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(CT_intra(:),25)
prctile(CT_intra(:),75)

% CT value inter reproducibility
CT_inter = [mean(value(:,[1,7]),2), value(:,13)];
[row,~]=find(~CT_inter);
CT_inter(row,:,:)=[];
BlandAltman(CT_inter(:,1), CT_inter(:,2),{'HS','AW','Hu'},'CT mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(CT_inter(:),25)
prctile(CT_inter(:),75)



% mag value intra reproducibility
mag_intra = value(:,[2,8]);
[row,~]=find(~mag_intra);
mag_intra(row,:,:)=[];
BlandAltman(mag_intra(:,1), mag_intra(:,2),{'HS1','HS2','A.U.'},'mag mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(mag_intra(:),25)
prctile(mag_intra(:),75)

% mag value inter reproducibility
mag_inter = [mean(value(:,[2,8]),2), value(:,14)];
[row,~]=find(~mag_inter);
mag_inter(row,:,:)=[];
BlandAltman(mag_inter(:,1), mag_inter(:,2),{'HS','AW','A.U.'},'mag mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(mag_inter(:),25)
prctile(mag_inter(:),75)



% qsm_raw value intra reproducibility
qsm_raw_intra = value(:,[3,9]);
[row,~]=find(~qsm_raw_intra);
qsm_raw_intra(row,:,:)=[];
BlandAltman(qsm_raw_intra(:,1), qsm_raw_intra(:,2),{'HS1','HS2','ppm'},'qsm raw mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');

% qsm_raw value inter reproducibility
qsm_raw_inter = [mean(value(:,[3,9]),2), value(:,15)];
[row,~]=find(~qsm_raw_inter);
qsm_raw_inter(row,:,:)=[];
BlandAltman(qsm_raw_inter(:,1), qsm_raw_inter(:,2),{'HS','AW','ppm'},'qsm raw mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');



% qsm_abs value intra reproducibility
qsm_abs_intra = value(:,[4,10]);
[row,~]=find(~qsm_abs_intra);
qsm_abs_intra(row,:,:)=[];
BlandAltman(qsm_abs_intra(:,1), qsm_abs_intra(:,2),{'HS1','HS2','ppm'},'qsm abs mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');

% qsm_abs value inter reproducibility
qsm_abs_inter = [mean(value(:,[4,10]),2), value(:,16)];
[row,~]=find(~qsm_abs_inter);
qsm_abs_inter(row,:,:)=[];
BlandAltman(qsm_abs_inter(:,1), qsm_abs_inter(:,2),{'HS','AW','ppm'},'qsm abs mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');



% flair value intra reproducibility
flair_intra = value(:,[5,11]);
[row,~]=find(~flair_intra);
flair_intra(row,:,:)=[];
BlandAltman(flair_intra(:,1), flair_intra(:,2),{'HS1','HS2','A.U.'},'FLAIR mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');

% flair value inter reproducibility
flair_inter = [mean(value(:,[5,11]),2), value(:,17)];
[row,~]=find(~flair_inter);
flair_inter(row,:,:)=[];
BlandAltman(flair_inter(:,1), flair_inter(:,2),{'HS','AW','A.U.'},'FLAIR mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');



% T1w value intra reproducibility
T1W_intra = value(:,[6,12]);
[row,~]=find(~T1W_intra);
T1W_intra(row,:,:)=[];
BlandAltman(T1W_intra(:,1), T1W_intra(:,2),{'HS1','HS2','ppm'},'T1w mean intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');


% T1w value inter reproducibility
T1W_inter = [mean(value(:,[6,12]),2), value(:,18)];
[row,~]=find(~T1W_inter);
T1W_inter(row,:,:)=[];
BlandAltman(T1W_inter(:,1), T1W_inter(:,2),{'HS1','HS2','ppm'},'T1w mean inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');




%%% reproducibility of area measurements
% CT area intra reproducibility
CT_area_intra = area(:,[1,4]);
[row,~]=find(~CT_area_intra);
CT_area_intra(row,:,:)=[];
BlandAltman(CT_area_intra(:,1), CT_area_intra(:,2),{'HS1','HS2','mm^2'},'CT area intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(CT_area_intra(:),25)
prctile(CT_area_intra(:),75)

% CT area inter reproducibility
CT_area_inter = [mean(area(:,[1,4]),2), area(:,7)];
[row,~]=find(~CT_area_inter);
CT_area_inter(row,:,:)=[];
BlandAltman(CT_area_inter(:,1), CT_area_inter(:,2),{'HS','AW','mm^2'},'CT area inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(CT_area_inter(:),25)
prctile(CT_area_inter(:),75)


% mag area intra reproducibility
mag_area_intra = area(:,[2,5]);
[row,~]=find(~mag_area_intra);
mag_area_intra(row,:,:)=[];
BlandAltman(mag_area_intra(:,1), mag_area_intra(:,2),{'HS1','HS2','mm^2'},'mag area intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(mag_area_intra(:),25)
prctile(mag_area_intra(:),75)

% mag area inter reproducibility
mag_area_inter = [mean(area(:,[2,5]),2), area(:,8)];
[row,~]=find(~mag_area_inter);
mag_area_inter(row,:,:)=[];
BlandAltman(mag_area_inter(:,1), mag_area_inter(:,2),{'HS','AW','mm^2'},'mag area inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(mag_area_inter(:),25)
prctile(mag_area_inter(:),75)



% qsm area intra reproducibility
qsm_area_intra = area(:,[3,6]);
[row,~]=find(~qsm_area_intra);
qsm_area_intra(row,:,:)=[];
BlandAltman(qsm_area_intra(:,1), qsm_area_intra(:,2),{'HS1','HS2','mm^2'},'qsm area intra repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(qsm_area_intra(:),25)
prctile(qsm_area_intra(:),75)

% qsm area inter reproducibility
qsm_area_inter = [mean(area(:,[3,6]),2), area(:,9)];
[row,~]=find(~qsm_area_inter);
qsm_area_inter(row,:,:)=[];
BlandAltman(qsm_area_inter(:,1), qsm_area_inter(:,2),{'HS','AW','mm^2'},'qsm area inter repoducibility',{},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits, 'showFitCI',' on');
prctile(qsm_area_inter(:),25)
prctile(qsm_area_inter(:),75)



