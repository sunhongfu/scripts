function mean_roi_data = get_avgROI_data(roi_vol, data_vol, data_dim)

slices = data_dim(1,3);
height = data_dim(1,1);
width = data_dim(1,2);
voxels = height*width;

if size(data_dim,2) < 4
    num_echoes = 1;
else
    num_echoes = data_dim(1,4);
end

% apply ROI mask to the data
for slice = 1:slices
    for frame = 1:num_echoes 
        roi_data(:,:,slice,frame) = data_vol(:,:,slice,frame).*roi_vol(:,:,slice);
    end
end    

roi_data = double(reshape(roi_data, voxels, slices, num_echoes));
mean_roi_data = zeros(slices,num_echoes);

for slice = 1:slices
    for frame = 1:num_echoes      
        % calculate the average signal in the ROI for each frame
        mean_roi_data(slice,frame) = mean(nonzeros(roi_data(:,slice,frame)));
        if isnan(mean_roi_data(slice,frame)) == 1
            mean_roi_data(slice,frame) = 0;
        end
    end
end

        
end