%function multiEchoRecon

fw = 0.25;

% %recon the raw img first
% %[par,img] = genereateRawImg();
 load img.mat img;
 load par.mat par;

%filter the phaseaimg
phase = phaseFilter(img,'hann',fw);

%combile 4 channels first, weighted by magnitude
phase_w = sum(phase.*abs(img),5)./sum(abs(img),5);
%clear phase;


%to combine multiechoes, first divided by te and then weighted by magnitude
mag_w = sqrt(sum((real(img).^2+imag(img).^2),5));
%clear img;

te = par.te + (0:par.ne-1)*par.esp;
%for i = 1:size(phase_w,4)
%    phase_w(:,:,:,i) = phase_w(:,:,:,i)/te(i);
%end
%lfs = phase_w; clear phase_w;
[d1 d2 d3 d4] = size(phase_w);

phase_w = permute(phase_w,[4 1 2 3]);
phase_w = reshape(phase_w,size(phase_w,1),[]);
mag_w = permute(mag_w,[4 1 2 3]);
mag_w = reshape(mag_w,size(mag_w,1),[]);

lfs_w = zeros(1,size(phase_w,2));

matlabpool;
parfor i = 1:size(phase_w,2)
	lfs_w(i) = lscov(te', phase_w(:,i), mag_w(:,i));
end
matlabpool close;

%clear phase_w mag_w;
lfs_w = reshape(lfs_w,[d1 d2 d3]);
phase_w =reshape(phase_w,[d4 d1 d2 d3]);

%save('LFS.mat','lfs_w','-v7.3');
matlabpool open 6;
generateDicoms(par,lfs_w,[pwd '/LFS_fitting']);
generateDicoms(par,squeeze(phase_w(1,:,:,:)/te(1)),[pwd '/lfs_1']);
generateDicoms(par,squeeze(phase_w(2,:,:,:)/te(2)),[pwd '/lfs_2']);
generateDicoms(par,squeeze(phase_w(3,:,:,:)/te(3)),[pwd '/lfs_3']);
generateDicoms(par,squeeze(phase_w(4,:,:,:)/te(4)),[pwd '/lfs_4']);
generateDicoms(par,squeeze(phase_w(5,:,:,:)/te(5)),[pwd '/lfs_5']);
