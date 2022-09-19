clear all; close all; clc;

addpath(genpath('./_src'));

load('FAs.mat');
load('TRs.mat');



% T1range =  250:250:4000;%ms
% T2range =   10:10:200; %ms
% B0range = -0.1:0.005:0.1; %kilo (because simulation is in ms....)


% % hongfu edit big dictionary

% T1range =  100:100:4000;%ms
% T2range =   10:10:400; %ms
% B0range = -0.2:0.005:0.2; %kilo (because simulation is in ms....)



% hongfu edit even bigger dictionary

T1range =  100:100:4000;%ms
T2range =   10:10:800; %ms
B0range = -0.2:0.002:0.2; %kilo (because simulation is in ms....)






mem = size(T1range,2)*size(T2range,2)*size(B0range,2);
disp(mem);

dictionary.atoms = zeros(mem,size(FAs,1));
dictionary.lookup = zeros(mem,4);
dictionary.chuck = size(T1range,2)*size(T2range,2);

 index =1;
 for T1=T1range
     disp([num2str(100*index/mem),' % ']);
     for T2 = T2range
         for b0 = B0range
            dictionary.lookup(index,1) =  0;   %PD (calculated after compression)
            dictionary.lookup(index,2) = T1;   %ms
            dictionary.lookup(index,3) = T2;   %ms
            dictionary.lookup(index,4) = b0*1000; %save in Hz   
            dictionary.atoms(index,:) = makeMRFdictionary(FAs,TRs, T1,T2,b0);
            index=index+1;
         end
     end
 end
 
 


 % hongfu edit to remove the three points and norm vectors

%remove delay's
tmp = zeros(size(dictionary.atoms,1),size(dictionary.atoms,2)-3);
tmp(:,  1:250 ) = dictionary.atoms(:,  1:250 );
tmp(:,251:500 ) = dictionary.atoms(:,252:501 );
tmp(:,501:750 ) = dictionary.atoms(:,503:752 );
tmp(:,751:1000) = dictionary.atoms(:,754:1003);

dictionary.atoms  = tmp.';
dictionary.lookup = dictionary.lookup.'; 
clear('tmp');

for i=1:size(dictionary.atoms,2)
    dictionary.atoms(:,i)= dictionary.atoms(:,i)/norm(dictionary.atoms(:,i));
    dictionary.lookup(1,i) = norm(dictionary.atoms(:,i));
end

%  figure(1); plot(imag(dictionary.atoms)');
 
%  save('../dictionary.mat','dictionary');

 save('../dictionary_largedict2_normed.mat','dictionary','-v7.3');
