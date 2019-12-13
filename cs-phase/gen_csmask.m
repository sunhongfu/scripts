% generate CS sampling mask with varied density
Pa = 12;
Pb = 1.8;

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

