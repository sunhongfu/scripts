load z_prjs.mat
nii = load_nii('cosmos_5_6DOF_resharp_1e-6.nii');
cosmos = double(nii.img);
mask = cosmos~=0;
mask = double(mask);
vox = [1 1 1];
field = forward_field_calc(cosmos,vox,z_prjs).*mask;
nii = make_nii(field, vox);
save_nii(nii,'field.nii');
imsize = size(field);

% rotation matrix from [0, *, z_prjs(3)] to [0, 0, 1]
B = [0 0 1]';
A = z_prjs';

if A==B
    U = eye(3);
else
    % rotation from unit vector A to B; 
    % return rotation matrix U such that UA = B;
    % and ||U||_2 = 1
    GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;
                    norm(cross(A,B)) dot(A,B)  0;
                    0              0           1];

    FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];
    UU = @(Fi,G) Fi*G*(Fi\eye(3));      
    U = UU(FFi(A,B), GG(A,B));
end


% new coordinates X,Y,Z (i.e., scanner) to old coordinates x,y,z (i.e., FOV acquisition)
[X, Y, Z] = ndgrid(-imsize(1)/2:imsize(1)/2-1,-imsize(2)/2:imsize(2)/2-1,-imsize(3)/2:imsize(3)/2-1);
old_coord = U\[X(:),Y(:),Z(:)]';
old_coord = reshape(old_coord,[3, imsize(1), imsize(2), imsize(3)]);
x = squeeze(old_coord(1,:,:,:));
y = squeeze(old_coord(2,:,:,:));
z = squeeze(old_coord(3,:,:,:));
field_rot = interpn(X,Y,Z, field, x,y,z);
field_rot(isnan(field_rot))=0;
nii = make_nii(field_rot,vox);
save_nii(nii,'field_rot.nii');
mask_rot = interpn(X,Y,Z, mask, x,y,z);
mask_rot(isnan(mask_rot))=0;
mask_rot = double(mask_rot>0.8);
nii = make_nii(mask_rot,vox);
save_nii(nii,'mask_rot.nii');

% run iLSQR [0,0,1] on field_rot
chi_iLSQR = QSM_iLSQR(field_rot*(2.675e8*3)/1e6,mask_rot,'H',[0 0 1],'voxelsize',vox,'niter',50,'TE',1000,'B0',3);
nii = make_nii(chi_iLSQR,vox);
save_nii(nii,'chi_iLSQR.nii');
