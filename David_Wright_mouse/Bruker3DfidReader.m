
%
%
% For Hongfu's QSM processing
%
% Written by David Wright
%
%
    
% file=strcat('....Point to directory containing fid file....');
file = pwd;

% Eg: file=strcat('20171201_142410_I_1_1/7');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%          load kspace (fid file)              %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

infile=[file,'/fid'];
infid=fopen(infile,'r','ieee-le');
[buf,count] = fread(infid,'int32');
raw=complex(buf(1:2:count),buf(2:2:count));

dim_x  = 176;
dim_y  = 128;
dim_z  = 70;
echoes = 20;
coils  = 4;

raw=reshape(raw,[768,length(raw)/768]); % 192*4 {Each channel zero filled}
kspace=raw(1:(dim_x*coils),:);          % Get rid of zeros

kspace=reshape(kspace,[dim_x,coils,echoes,dim_y,dim_z]);
kspace=permute(kspace,[1,4,5,3,2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%           Adjust for phase offset            %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

phoffset=0.665136984271868;
fovphase=1.92;


kspace=reshape(kspace,[dim_x,dim_y,(4*echoes*dim_z)]);

for z=1:length(kspace)
    for k=1:dim_y
        kspace(:,k,z)=kspace(:,k,z)*exp(-1i*pi*2*phoffset*k/(fovphase*10));
    end
end

kspace=reshape(kspace,[dim_x,dim_y,dim_z,echoes,coils]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                              % 
%            Reconstruct Image                 %
%                                              %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hongfu add
kspace = fftshift(kspace,1);
kspace = fftshift(kspace,2);
kspace = fftshift(kspace,3);

image=zeros(dim_x,dim_y,dim_z,echoes,coils);
for coil = 1:coils
	for echo = 1:echoes
		image(:,:,:,echo,coil) = fftn(squeeze(kspace(:,:,:,echo,coil)));
	end
end


image = fftshift(image,1);
image = fftshift(image,2);

[iField voxel_size matrix_size TE delta_TE CF Affine3D B0_dir TR NumEcho] = Read_Bruker_raw_sun(pwd);

iField = image;

% kspace=fftshift(fft(kspace(:,:,:,:,:),[],3));

% image=zeros(dim_x,dim_y,dim_z,echoes,coils);

% for coil=1:coils
%     for echo=1:echoes
%        for slice=1:dim_z
%            imagetemp(:,:)=fftshift(fft2(kspace(:,:,slice,echo,coil)));
%            image(:,:,slice,echo,coil)=imagetemp;
%        end
%     end
% end

% clear imagetemp kspace;

% image=circshift(image,[0 0 dim_z/2 echoes/2]);  % Might need tweaking

