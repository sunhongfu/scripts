function [Q_pre] = MyPredict(V)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
imSize= size(V); 

%% load Net; 
load BFR_L2_64_24BS_45Epo_4Pool.mat; 

newInput = image3dInputLayer(imSize,...
    'Name','ImageInputLayer', 'Normalization', 'none');

L1Net = net; 

L1Net = replaceLayer(layerGraph(L1Net),'ImageInputLayer',newInput);
L1Net = assembleNetwork(L1Net);

clear net; 
%% prediction

Q_pre = predict(L1Net, V, 'ExecutionEnvironment', 'cpu'); 

end