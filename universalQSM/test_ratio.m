

clear 
clc 


%% HS implementation; 
for i = 1 : 15000
    vox(:,i) = 0.5 + 1.5 * rand(3, 1); 
end

ratio_max_min = max(vox) ./ min(vox); 


%% YG implementation
maxNum = 100; 

max_vox = 2; 
min_vox = 0.5; 

for i = 1 : 15000
% %     p = randperm(maxNum, 3);
    tmp1 = (max_vox - min_vox) /(maxNum - 1) * (randperm(maxNum, 1) - 1 ) + min_vox;
    tmp2 = (max_vox - min_vox) /(maxNum - 1) * (randperm(maxNum, 1) - 1 ) + min_vox;
    tmp3 = (max_vox - min_vox) /(maxNum - 1) * (randperm(maxNum, 1) - 1 ) +  min_vox;
    vox(:,i) = [tmp1, tmp2, tmp3]; 
    
end

ratio_max_min2 = max(vox) ./ min(vox); 


%% YG implementation2
maxNum = 100; 

max_vox = 2; 
min_vox = 0.5; 

for i = 1 : 15000
% %     p = randperm(maxNum, 3);
    tmp1 = -(max_vox - min_vox) / (maxNum - 1)^2 * (randperm(maxNum, 1) - maxNum) ^ 2 + max_vox;
    tmp2 = -(max_vox - min_vox) / (maxNum - 1)^2 * (randperm(maxNum, 1) - maxNum) ^ 2 + max_vox;
    tmp3 = -(max_vox - min_vox) / (maxNum - 1)^2 * (randperm(maxNum, 1) - maxNum) ^ 2 + max_vox;
    vox(:,i) = [tmp1, tmp2, tmp3]; 
    
end

ratio_max_min3 = max(vox) ./ min(vox); 


%% YG implementation3
maxNum = 200; 

max_vox = 2; 
min_vox = 0.5; 

max_power = 3; 

for i = 1 : 15000
% %     p = randperm(maxNum, 3);
    tmp1 = (max_vox - min_vox) / (maxNum - 1)^max_power  * (randperm(maxNum, 1) - 1) ^ max_power  + min_vox;
    tmp2 = (max_vox - min_vox) / (maxNum - 1)^max_power  * (randperm(maxNum, 1) - 1) ^ max_power  + min_vox;
    tmp3 = (max_vox - min_vox) / (maxNum - 1)^max_power  * (randperm(maxNum, 1) - 1) ^ max_power  + min_vox;
    vox(:,i) = [tmp1, tmp2, tmp3]; 
    
end

ratio_max_min4 = max(vox) ./ min(vox); 
figure; histogram(ratio_max_min4, 100)


figure 

subplot(211)
histogram(ratio_max_min, 100)

% subplot(222)
% histogram(ratio_max_min2, 100)
% 
% subplot(223)
% histogram(ratio_max_min3, 100)

subplot(212)
histogram(ratio_max_min4, 100)











for i = 1:15000
    ratio_max_min(i) = 1 + 3.*rand(1,1);
    vox_min(i) = 2/(1+ratio_max_min(i));
    vox_mid(i) = 1;
    vox_max(i) = 2*ratio_max_min(i)/(1+ratio_max_min(i));    
    vox_temp = [vox_min(i) vox_mid(i) vox_max(i)];
    vox(:,i) = vox_temp(randperm(3));
end

ratio_max_min_plot = max(vox)./min(vox);
hist(ratio_max_min,100)
vox(:,300:320)

