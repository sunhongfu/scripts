load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_LEFT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_invmat.nii']);

% resize for testing
imsize = [48 48 48];
vox = [1 1 1];
[~, D, ~, ~] = forward_field_calc(ones(imsize), vox, z_prjs);
nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_resized_D.nii');
nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_resized_D_shift.nii');
% finish resize for testing

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_left_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_RIGHT/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_invmat.nii']);

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_right_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_FORWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_invmat.nii']);

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_forward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_BACKWARD/QSM_SPGR_GE/z_prjs.mat', 'z_prjs');

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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_invmat.nii']);

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_backward_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat', 'z_prjs');

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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_invmat.nii']);

imsize = [256 256 128];
vox = [1 1 1];
[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% rotate/reslice into coronal
load('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/all.mat', 'z_prjs');

z_prjs= [z_prjs(1), z_prjs(3), z_prjs(2)];
z_prjs(1) = -z_prjs(1);
imsize = [256 128 256];
vox = [1 1 1];


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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_invmat.nii']);


[~, D, dipole, ~] = forward_field_calc(ones(imsize), vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_permute132_dipole.nii');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% big angle from forward calc
nii = load_nii('/Volumes/LaCie/COSMOS_3T/RENZO_GE/QSM_SPGRE_CENTER/QSM_SPGR_GE/RESHARP/chi_iLSQR_smvrad1.nii');
chi = double(nii.img);
vox = nii.hdr.dime.pixdim(2:4);

z_prjs = [sqrt(2)/2, 0 , sqrt(2)/2];


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

nii = make_nii(U);
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_rotmat.nii']);
nii = make_nii(U');
save_nii(nii,['/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_invmat.nii']);


[~, D, dipole, ~] = forward_field_calc(chi, vox, z_prjs);

nii = make_nii(D,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_D.nii');

nii = make_nii(fftshift(D),vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_D_shift.nii');

nii = make_nii(dipole,vox);
save_nii(nii,'/Volumes/LaCie/CommQSM/invivo/testing/renzo/renzo_central_bigAngle_dipole.nii');