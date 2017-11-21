set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesBox', 'on', 'DefaultAxesLineWidth', 2.0);
set(0, 'DefaultAxesFontSize', 20, 'DefaultAxesFontWeight', 'normal');
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultTextFontSize', 20, 'DefaultTextFontWeight', 'normal');

% remove all the zero rows
[row,~]=find(~area);
area(row,:,:)=[];

CT_area = area(:,[1,4,7]);
MAG_area = area(:,[2,5,8]);
QSM_area = area(:,[3,6,9]);

corrinfo = {'r2','eq'}; % stats to display of correlation scatter plot
BAinfo = {'LOA(%)'}; % stats to display on Bland-ALtman plot
limits = 'auto'; % how to set the axes limits
if 1 % colors for the data sets may be set as:
	colors = 'red';      % character codes
else
	% colors = [0 0 1;... % or RGB triplets
	% 	      1 0 0];
	colors = cbrewer('qual','Set1',3);
end

BlandAltman(CT_area, MAG_area,{'CT area','MAG area','mm^2'},'MAG vs. CT area',{'HS1','HS2','AW'},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits,'showFitCI',' on');
BlandAltman(CT_area, QSM_area,{'CT area','QSM area','mm^2'},'QSM vs. CT area',{'HS1','HS2','AW'},'corrInfo',corrinfo,'baInfo',BAinfo,'axesLimits',limits,'showFitCI',' on');


% remove all the zero rows
% (1) magnitude
value_mag = value(:,[1,2,7,8,13,14]);
[row,~]=find(~value_mag);
value_mag(row,:,:)=[];
CT_value = value_mag(:,[1,3,5]);
MAG_value = value_mag(:,[2,4,6]);
Corr_plot(CT_value, MAG_value,{'CT value (Hu)','MAG value'},'MAG vs. CT value',{'HS1','HS2','AW'},'corrInfo',corrinfo,'axesLimits',limits);

% (2) QSM
value_qsm = value(:,[1,4,7,10,13,16]);
[row,~]=find(~value_qsm);
value_qsm(row,:,:)=[];
CT_value = value_qsm(:,[1,3,5]);
QSM_value = value_qsm(:,[2,4,6]);
Corr_plot(CT_value, QSM_value,{'CT value (Hu)','QSM value (ppm)'},'QSM vs. CT value',{'HS1','HS2','AW'},'corrInfo',corrinfo,'axesLimits',limits);


% value_qsm_raw = value(:,[1,3,7,9,13,15]);
% [row,~]=find(~value_qsm_raw);
% value_qsm_raw(row,:,:)=[];
% CT_value = value_qsm_raw(:,[1,3,5]);
% QSM_value = value_qsm_raw(:,[2,4,6]);
% Corr_plot(CT_value, QSM_value,{'CT value (Hu)','QSM raw value (ppm)'},'QSM raw vs. CT value',{'HS1','HS2','AW'},'corrInfo',corrinfo,'axesLimits',limits);



% (3) FLAIR
value_flair = value(:,[1,5,7,11,13,17]);
[row,~]=find(~value_flair);
value_flair(row,:,:)=[];
CT_value = value_flair(:,[1,3,5]);
FLAIR_value = value_flair(:,[2,4,6]);
Corr_plot(CT_value, FLAIR_value,{'CT value (Hu)','FLAIR value'},'FLAIR vs. CT value',{'HS1','HS2','AW'},'corrInfo',corrinfo,'axesLimits',limits);

% (4) T1w
value_t1w = value(:,[1,6,7,12,13,18]);
[row,~]=find(~value_t1w);
value_t1w(row,:,:)=[];
CT_value = value_t1w(:,[1,3,5]);
T1w_value = value_t1w(:,[2,4,6]);
Corr_plot(CT_value, T1w_value,{'CT value (Hu)','T1w value'},'T1w vs. CT value',{'HS1','HS2','AW'},'corrInfo',corrinfo,'axesLimits',limits);
