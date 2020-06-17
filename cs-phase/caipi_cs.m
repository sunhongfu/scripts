
odd = zeros(1,256);
odd(1:4:end) = 1;

% even = circshift(odd, 2);
% % even2 = circshift(even, 2);
% even2 = zeros(1,256);
% % even3 = circshift(even2, 2);
% even3 = zeros(1,256);
% even4 = circshift(even3, 2);
% % even5 = circshift(even4, 2);
% even5 = zeros(1,256);
% % even6 = circshift(even5, 2);
% even6 = zeros(1,256);
% even7 = circshift(even6, 2);
% 
% 


even = zeros(1,256);
even2 = circshift(odd, 2);
even3 = zeros(1,256);


odd_even = [odd;even;even2;even3];

caipi = repmat(odd_even,[64,1]);
imagesc(caipi); colormap gray; axis equal tight; axis off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Pa = 10;
Pb = 1;

nx = 256;
ny = 256;

x = -nx/2:nx/2-1;
y = -ny/2:ny/2-1;
[X,Y] = ndgrid(x,y);

SP = exp(-Pa*((sqrt(X.^2/nx^2 + Y.^2/ny^2)).^Pb));

AF = 4;
SP_normalized = SP/(sum(SP(:))/(nx*ny/AF));

% generate for each pixel
mask = zeros(nx,ny);
for x = 1: nx
    for y = 1:ny
        if(rand < SP_normalized(x,y))
            mask(x,y) = 1;
        end
    end
end

figure; imagesc(mask);

%%%%%
caipi_masked = caipi.*mask;
        
imagesc(caipi_masked); colormap gray; axis equal tight; axis off

figure;imagesc(caipi(2:64,2:64)); colormap gray; axis equal tight; axis off
figure;imagesc(caipi(2:8,2:8)); colormap gray; axis equal tight; axis off