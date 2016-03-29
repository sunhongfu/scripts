load('rmseMasks.mat')
load('data_simulation.mat')
load('reference_field.mat')


brain_field = brain_field(145:305,125:325,145:305);
brain_mask = single(brain_mask(145:305,125:325,145:305));
reference_field = reference_field(145:305,125:325,145:305);
rmseMasks = rmseMasks(145:305,125:325,145:305,:);


vox = [1,1,1];

regParams = 0;
rmse = zeros(numel(regParams),size(rmseMasks,4));


smv_rad = 2
for i = 1:numel(smv_rad)



for jParam = 1:numel(regParams)

    [result_phase, result_mask] = resharp(brain_field,brain_mask,vox,smv_rad(i),regParams(jParam));
    % result_phase is the background corrected phase image
    % result_mask is a mask indicating which values are supposed to be reliable (in SHARP this is the eroded brain mask)
    
    differ = result_phase - reference_field;
    for jDist = 1:size(rmseMasks,4)
        totalMask = rmseMasks(:,:,:,jDist) & logical(result_mask);
        meanVal = mean(differ(totalMask));
        rmse(jParam,jDist) = sqrt(sum((differ(totalMask)-meanVal).^2)/nnz(totalMask));
    end
end

figure;plot(1:33,rmse);

rmse(isnan(rmse)) = 0;
areaCurve = sum(rmse,2)./sum(rmse > 0,2)
% figure;plot(regParams,areaCurve)

% [areaMin,idxMin]=  min(areaCurve);
% regParams(idxMin)
% areaMin




end


result_phase = padarray(result_phase,[144,124,144],'pre');
result_phase = padarray(result_phase,[146,126,146],'post');

result_mask = padarray(result_mask,[144,124,144],'pre');
result_mask = padarray(result_mask,[146,126,146],'post');

save('result.mat','result_phase','result_mask','-v7.3')
