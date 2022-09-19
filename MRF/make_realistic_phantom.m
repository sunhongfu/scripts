clear 
clc
close all 



addpath(genpath('./MRF_bSSFP/'));

load('FAs.mat')
load('TRs.mat');



load('realistic_phantom.mat')

B0map = B0map * 1e-3; 

ind = 1;

img = zeros(318, 318, 1000);
img2 = zeros(318, 318, 1000);
SNR = 40;

for ii = 1 : 318
    disp(ii)
    for jj = 1 : 318
        if (T1map(ii, jj) ^2 + T2map(ii, jj) ^2 + B0map(ii, jj) ^2) < 1e-14
            img(ii, jj,:) = zeros(1, 1000);
        else
            tmp2 = makeMRFdictionary(FAs,TRs, T1map(ii, jj),T2map(ii, jj),B0map(ii, jj));
            
            tmp = zeros(1, size(tmp2,2)-3);
            tmp(:,  1:250 ) = tmp2(:,  1:250 );
            tmp(:,251:500 ) = tmp2(:,252:501 );
            tmp(:,501:750 ) = tmp2(:,503:752 );
            tmp(:,751:1000) = tmp2(:,754:1003);  
            
            tmp = tmp ./norm(tmp);
            
            img(ii, jj, :) = tmp;
            
            tmp_r = real(tmp);
            tmp_i = imag(tmp);
            tmp_r =  AddNoise(tmp_r,SNR);
            tmp_i =  AddNoise(tmp_i,SNR);
            
            tmp2 = tmp_r + 1j * tmp_i; 
            tmp2 = tmp2 ./ norm(tmp2); 
            img2(ii, jj, :) = tmp2; 
          
        end
    end
end

B0map = B0map * 1e3; 

save RealisticPhantom.mat T1map T2map B0map img img2;