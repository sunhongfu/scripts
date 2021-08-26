function img_rot = rotate(img, z_prjs)

    rot_mat = RotMat([0;0;1], z_prjs');
    imsize = size(img);
    [X, Y, Z] = ndgrid(-imsize(1)/2:imsize(1)/2-1,-imsize(2)/2:imsize(2)/2-1,-imsize(3)/2:imsize(3)/2-1);
    new_coords = rot_mat * [X(:),Y(:),Z(:)]';
    new_coords = reshape(new_coords,[3, imsize(1), imsize(2), imsize(3)]);
    x = squeeze(new_coords(1,:,:,:));
    y = squeeze(new_coords(2,:,:,:));
    z = squeeze(new_coords(3,:,:,:));
    img_rot = interpn(X,Y,Z, img, x,y,z);

end