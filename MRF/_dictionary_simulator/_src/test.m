%function dict=makeMRFdictionary(RFpulses ,TR ,T1, T2, df);
load('FA.mat') 
FAs = Expression1';
ph = (1 - (-1).^(1:1000))/2;
FAs = FAs.*exp(1i*pi*ph);
angle(FAs)
load('TR.mat');
TRs = Expression1/1000 +10;
TRs = TRs';
TRs(250) = TRs(250)+600;
TRs(500) = TRs(500)+600;
TRs(750) = TRs(750)+600;
% max(TRs)
 dict = zeros(100,1000);
 look = zeros(100,3);
 
 index =1;
 for ii=1:10
     T1 = 250*ii;
     for jj=1:10
         T2 = 10*ii;
         look(index,1,1) = T1;
         look(index,1,2) = T2;
         look(index,1,3) = 0;
        dict(index,:) = makeMRFdictionary(FAs,TRs, T1,T2,0);
        index=index+1;
     end
 end
 
 figure(1); plot(imag(dict)');