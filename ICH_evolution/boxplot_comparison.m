%%
% seems 'mean' is better than 'everything', fewer outliners
set(0, 'DefaultFigureColor', 'w');
set(0, 'DefaultAxesBox', 'on', 'DefaultAxesLineWidth', 2.0);
set(0, 'DefaultAxesFontSize', 20, 'DefaultAxesFontWeight', 'normal');
set(0, 'DefaultLineLineWidth', 2.0);
set(0, 'DefaultTextFontSize', 20, 'DefaultTextFontWeight', 'normal');
%% mag evolution

% (1) everything together
mag_d2 = mag_evo(:,1:3);
mag_d2 = mag_d2(:);
mag_d2(~mag_d2)=[];

mag_d7 = mag_evo(:,4:6);
mag_d7 = mag_d7(:);
mag_d7(~mag_d7)=[];

mag_d30 = mag_evo(:,7:9);
mag_d30 = mag_d30(:);
mag_d30(~mag_d30)=[];

% boxplot
figure; h = boxplot([mag_d2' mag_d7' mag_d30'],[ones(1,length(mag_d2)), 2*ones(1,length(mag_d7)), 3*ones(1,length(mag_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare Mag at different days (everything)');
set(h,{'linew'},{2});
ylabel('normalized magnitude (A.U.)');

% (2) average/mean
mag_d2 = mean(mag_evo(:,1:3),2);
mag_d2(~mag_d2)=[];

mag_d7 = mean(mag_evo(:,4:6),2);
mag_d7(~mag_d7)=[];

mag_d30 = mean(mag_evo(:,7:9),2);
mag_d30(~mag_d30)=[];

% boxplot
figure; h = boxplot([mag_d2' mag_d7' mag_d30'],[ones(1,length(mag_d2)), 2*ones(1,length(mag_d7)), 3*ones(1,length(mag_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare Mag at different days');
set(h,{'linew'},{2});
ylabel('normalized magnitude (A.U.)');

%% qsm_raw evolution

% (1) everything together
qsm_raw_d2 = qsm_raw_evo(:,1:3);
qsm_raw_d2 = qsm_raw_d2(:);
qsm_raw_d2(~qsm_raw_d2)=[];

qsm_raw_d7 = qsm_raw_evo(:,4:6);
qsm_raw_d7 = qsm_raw_d7(:);
qsm_raw_d7(~qsm_raw_d7)=[];

qsm_raw_d30 = qsm_raw_evo(:,7:9);
qsm_raw_d30 = qsm_raw_d30(:);
qsm_raw_d30(~qsm_raw_d30)=[];

% boxplot
figure; h = boxplot([qsm_raw_d2' qsm_raw_d7' qsm_raw_d30'],[ones(1,length(qsm_raw_d2)), 2*ones(1,length(qsm_raw_d7)), 3*ones(1,length(qsm_raw_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare QSM (raw) at different days (everything)');
set(h,{'linew'},{2});
ylabel('susceptibility (ppm)');

% (2) average/mean
qsm_raw_d2 = mean(qsm_raw_evo(:,1:3),2);
qsm_raw_d2(~qsm_raw_d2)=[];

qsm_raw_d7 = mean(qsm_raw_evo(:,4:6),2);
qsm_raw_d7(~qsm_raw_d7)=[];

qsm_raw_d30 = mean(qsm_raw_evo(:,7:9),2);
qsm_raw_d30(~qsm_raw_d30)=[];

% boxplot
figure; h = boxplot([qsm_raw_d2' qsm_raw_d7' qsm_raw_d30'],[ones(1,length(qsm_raw_d2)), 2*ones(1,length(qsm_raw_d7)), 3*ones(1,length(qsm_raw_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare QSM (raw) at different days (mean)');
set(h,{'linew'},{2});
ylabel('susceptibility (ppm)');

%% qsm_abs evolution

% (1) everything together
qsm_abs_d2 = qsm_abs_evo(:,1:3);
qsm_abs_d2 = qsm_abs_d2(:);
qsm_abs_d2(~qsm_abs_d2)=[];

qsm_abs_d7 = qsm_abs_evo(:,4:6);
qsm_abs_d7 = qsm_abs_d7(:);
qsm_abs_d7(~qsm_abs_d7)=[];

qsm_abs_d30 = qsm_abs_evo(:,7:9);
qsm_abs_d30 = qsm_abs_d30(:);
qsm_abs_d30(~qsm_abs_d30)=[];

% boxplot
figure; h = boxplot([qsm_abs_d2' qsm_abs_d7' qsm_abs_d30'],[ones(1,length(qsm_abs_d2)), 2*ones(1,length(qsm_abs_d7)), 3*ones(1,length(qsm_abs_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare QSM (abs) at different days (everything)');
set(h,{'linew'},{2});
ylabel('susceptibility (ppm)');

% (2) average/mean
qsm_abs_d2 = mean(qsm_abs_evo(:,1:3),2);
qsm_abs_d2(~qsm_abs_d2)=[];

qsm_abs_d7 = mean(qsm_abs_evo(:,4:6),2);
qsm_abs_d7(~qsm_abs_d7)=[];

qsm_abs_d30 = mean(qsm_abs_evo(:,7:9),2);
qsm_abs_d30(~qsm_abs_d30)=[];

% boxplot
figure; h = boxplot([qsm_abs_d2' qsm_abs_d7' qsm_abs_d30'],[ones(1,length(qsm_abs_d2)), 2*ones(1,length(qsm_abs_d7)), 3*ones(1,length(qsm_abs_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare QSM (abs) at different days');
set(h,{'linew'},{2});
ylabel('susceptibility (ppm)');


%% flair evolution

% (1) everything together
flair_d2 = flair_evo(:,1:3);
flair_d2 = flair_d2(:);
flair_d2(~flair_d2)=[];

flair_d7 = flair_evo(:,4:6);
flair_d7 = flair_d7(:);
flair_d7(~flair_d7)=[];

flair_d30 = flair_evo(:,7:9);
flair_d30 = flair_d30(:);
flair_d30(~flair_d30)=[];

% boxplot
figure; h = boxplot([flair_d2' flair_d7' flair_d30'],[ones(1,length(flair_d2)), 2*ones(1,length(flair_d7)), 3*ones(1,length(flair_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare FLAIR at different days (everything)');
set(h,{'linew'},{2});
ylabel('normalized FLAIR (A.U.)');

% (2) average/mean
flair_d2 = mean(flair_evo(:,1:3),2);
flair_d2(~flair_d2)=[];

flair_d7 = mean(flair_evo(:,4:6),2);
flair_d7(~flair_d7)=[];

flair_d30 = mean(flair_evo(:,7:9),2);
flair_d30(~flair_d30)=[];

% boxplot
figure; h = boxplot([flair_d2' flair_d7' flair_d30'],[ones(1,length(flair_d2)), 2*ones(1,length(flair_d7)), 3*ones(1,length(flair_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare FLAIR at different days');
set(h,{'linew'},{2});
ylabel('normalized FLAIR (A.U.)');


%% t1w evolution

% (1) everything together
t1w_d2 = t1w_evo(:,1:3);
t1w_d2 = t1w_d2(:);
t1w_d2(~t1w_d2)=[];

t1w_d7 = t1w_evo(:,4:6);
t1w_d7 = t1w_d7(:);
t1w_d7(~t1w_d7)=[];

t1w_d30 = t1w_evo(:,7:9);
t1w_d30 = t1w_d30(:);
t1w_d30(~t1w_d30)=[];

% boxplot
figure; h = boxplot([t1w_d2' t1w_d7' t1w_d30'],[ones(1,length(t1w_d2)), 2*ones(1,length(t1w_d7)), 3*ones(1,length(t1w_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare T1w at different days (everything)');
set(h,{'linew'},{2});
ylabel('normalized T1w (A.U.)');

% (2) average/mean
t1w_d2 = mean(t1w_evo(:,1:3),2);
t1w_d2(~t1w_d2)=[];

t1w_d7 = mean(t1w_evo(:,4:6),2);
t1w_d7(~t1w_d7)=[];

t1w_d30 = mean(t1w_evo(:,7:9),2);
t1w_d30(~t1w_d30)=[];

% boxplot
figure; h = boxplot([t1w_d2' t1w_d7' t1w_d30'],[ones(1,length(t1w_d2)), 2*ones(1,length(t1w_d7)), 3*ones(1,length(t1w_d30))],'Labels',{'Day 2','Day 7','Day 30'},'Whisker',1);
title('Compare T1w at different days');
set(h,{'linew'},{2});
ylabel('normalized T1w (A.U.)');
