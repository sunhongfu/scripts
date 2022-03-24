%function dict=makeMRFdictionary(RFpulses ,TR ,T1, T2, df);
load('FA.mat') 
FAs = Expression1';
ph = (1 - (-1).^(1:1000))/2;
FAs = FAs.*exp(1i*pi*ph);

FAs = [FAs(1:250),0,FAs(251:500),0,FAs(501:750),0,FAs(751:1000)];
FAs = FAs(:);

load('TR.mat');
TRs = Expression1/1000 +10;
TRs = TRs';
TRs = [TRs(1:250),600,TRs(251:500),600,TRs(501:750),600,TRs(751:1000)];
TRs = TRs(:);

save('../TRs.mat','TRs');

save('../FAs.mat','FAs');