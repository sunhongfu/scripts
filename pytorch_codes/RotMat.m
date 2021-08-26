function [U] = RotMat(A, B)
    % rotation from unit vector A to B;
    % return rotation matrix U such that UA = B;
    % and ||U||_2 = 1
        if A == B
            U = [[1, 0, 0]
                 [0, 1, 0]
                 [0, 0, 1]];

        else
            GG = @(A,B) [ dot(A,B) -norm(cross(A,B)) 0;
                          norm(cross(A,B)) dot(A,B)  0;
                          0              0           1];

            FFi = @(A,B) [ A (B-dot(A,B)*A)/norm(B-dot(A,B)*A) cross(B,A) ];

            UU = @(Fi,G) Fi*G*inv(Fi);


            U = UU(FFi(A,B), GG(A,B));
        end
    end