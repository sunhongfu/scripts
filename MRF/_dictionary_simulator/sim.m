clear all; close all; clc;

addpath(genpath('./_src'));

load('FAs.mat') 
load('TRs.mat');



T1range =  250:250:4000;%ms
T2range =   10:10:200; %ms
B0range = -0.1:0.005:0.1; %kilo (because simulation is in ms....)

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
 
 
 
 figure(1); plot(imag(dictionary.atoms)');
 
 save('../dictionary.mat','dictionary');
 