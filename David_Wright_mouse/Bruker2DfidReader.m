
%
%
% For Hongfu's QSM processing
%
% Written by David Wright
%
% Reads in & Reco's 2D Bruker fid
%
%

    
directory = '....Point to directory containing fid file....';

 
% Eg: directory = '6';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%         load kSpace (Bruker fid)             %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

infile=[directory,'/fid'];
infid=fopen(infile,'r','ieee-le');
[buf,count] = fread(infid,'int32');

dim_x  = 160;
dim_y  = 160;
slices  = 64;
echoes = 8;
coils  = 4;

kspace=zeros(dim_x,coils,echoes,slices,dim_y);
kspace(:)=complex(buf(1:2:count),buf(2:2:count));
kspace=permute(kspace,[1,5,4,3,2]);

clear buf directory infid infile count;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%           Adjust for phase offset            %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phoffset=-0.199999999999998;
fovphase=2.88;

kspace=reshape(kspace,[dim_x,dim_y,(4*echoes*slices)]);

for z=1:length(kspace)
    for k=1:dim_y
        kspace(:,k,z)=kspace(:,k,z)*exp(-1i*pi*2*phoffset*k/(fovphase*10));
    end
end

clear phoffset fovphase k z;

kspace=reshape(kspace,[dim_x,dim_y,slices,echoes,coils]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%            Reconstruct Image                 %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

image=zeros(dim_x,dim_y,slices,echoes,coils);

for coil=1:coils
    for echo=1:echoes
       for slice=1:slices
           imagetemp(:,:)=fftshift(fft2(fftshift(kspace(:,:,slice,echo,coil))));
           image(:,:,slice,echo,coil)=imagetemp;
       end
    end
end

clear imagetemp kspace coil echo slice;


