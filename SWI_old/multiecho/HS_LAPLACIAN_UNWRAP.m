function phase_uwp = HS_LAPLACIAN_UNWRAP(phase)

dim = size(phase);
phase_uwp = lap_unwrap(phase);


function[K2]=makeK2(dim) % produces 3D array of k-space coordinates^2
        % K2(kx,ky,kz)=[kx*kx + ky*ky + kz*kz]
        
        %-------Vectors of k-space coordinates
        dk = 2*pi/(dim(1));
        if dim(1)/2 ~=round(dim(1)/2)
            ky = fftshift([ ( 0:dk:pi-dk/2)   (-pi + dk/2 : dk : -dk ) ]);
        else
            ky = fftshift([ ( 0:dk:pi)   (-(dim(1)/2 - 1)*dk : dk : -dk ) ]);
        end
        dk = 2*pi/(dim(2));
        if dim(2)/2 ~=round(dim(2)/2)
            kx = fftshift([ ( 0:dk:pi-dk/2)   (-pi + dk/2 : dk : -dk ) ]);
        else
            kx = fftshift([ ( 0:dk:pi)   (-(dim(2)/2 - 1)*dk : dk : -dk ) ]);
        end
        dk = 2*pi/(dim(3));
        if dim(3)/2 ~=round(dim(3)/2)
            kz = fftshift([ ( 0:dk:pi-dk/2)   (-pi + dk/2 : dk : -dk ) ]);
        else
            kz = fftshift([ ( 0:dk:pi)   (-(dim(3)/2 - 1)*dk : dk : -dk ) ]);
        end
        [k1,k2,k3]=ndgrid(ky,kx,kz);
        K2=k1.*k1 + k2.*k2 + k3.*k3;
        K2=ifftshift(ifftshift(ifftshift(K2,3),2),1);
end

function[UWP]=lap_unwrap(Phi) %unwrapping using laplace operator
        temp=zeros(2*dim);
        K2=makeK2(2*dim);
        temp(1:dim(1),1:dim(2),1:dim(3))=Phi;
        temp(1:dim(1),dim(2)+1:2*dim(2),1:dim(3))=flipdim(Phi,2);
        temp(1:dim(1),1:dim(2),dim(3)+1:2*dim(3))=flipdim(Phi,3);
        temp(1:dim(1),dim(2)+1:2*dim(2),dim(3)+1:2*dim(3))=flipdim(flipdim(Phi,2),3);
        temp(dim(1)+1:2*dim(1),dim(2)+1:2*dim(2),dim(3)+1:2*dim(3))=flipdim(flipdim(flipdim(Phi,1),2),3);
        temp(dim(1)+1:2*dim(1),dim(2)+1:2*dim(2),1:dim(3))=flipdim(flipdim(Phi,1),2);
        temp(dim(1)+1:2*dim(1),1:dim(2),dim(3)+1:2*dim(3))=flipdim(flipdim(Phi,1),3);
        temp(dim(1)+1:2*dim(1),1:dim(2),1:dim(3))=flipdim(Phi,1);
        
        Phi=temp; clear temp;
        Phi=fftn(cos(Phi).*ifftn(K2.*fftn(sin(Phi)))-sin(Phi).*ifftn(K2.*fftn(cos(Phi))))./K2;
        Phi(1,1,1)=0;
        Phi=real(ifftn(Phi));
        UWP=Phi(1:dim(1),1:dim(2),1:dim(3));
        
%        UWP=real(ifftn(fftn(Phi,dim+[s s s_z])));

end

end