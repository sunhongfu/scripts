meas_in = '2014.10.30-14.04.27-epi_333_TR3_72vol_visual_meas.out';

if ~ exist('meas_in','var') || isempty(meas_in)
    listing = dir([pwd '/*.out']);
    if ~isempty(listing)
        filename = listing(1).name;
        pathstr = pwd;
    else
        error('cannot find meas file');
    end
elseif exist(meas_in,'dir')
    listing = dir([meas_in '/*.out']);
    if ~isempty(listing)
        pathstr = cd(cd(meas_in));
        filename = listing(1).name;
    else
        error('cannot find meas file');
    end
elseif exist(meas_in,'file')
    [pathstr,name,ext] = fileparts(meas_in);
    if isempty(pathstr)
        pathstr = pwd;
    end
    pathstr = cd(cd(pathstr));
    filename = [name ext];
else
    error('cannot find meas file');
end

if ~ exist('path_out','var') || isempty(path_out)
    path_out = pathstr;
end

if ~ exist('options','var') || isempty(options)
    options = [];
end

if ~ isfield(options,'ph_corr')
    options.ph_corr = 3;
    % 1: linear
    % 2: non-linear
    % 3: MTF
end

if ~ isfield(options,'ref_coi')
    options.ref_coi = 8;
end

if ~ isfield(options,'eig_rad')
    options.eig_rad = 5;
end

if ~ isfield(options,'bet_thr')
    options.bet_thr = 0.4;
end

if ~ isfield(options,'smv_rad')
    options.smv_rad = 6;
end

if ~ isfield(options,'tik_reg')
    options.tik_reg = 5e-4;
end

if ~ isfield(options,'tv_reg')
    options.tv_reg = 1e-4;
end

if ~ isfield(options,'tvdi_n')
    options.tvdi_n = 200;
end

if ~ isfield(options,'sav_all')
    options.sav_all = 0;
end

ph_corr = options.ph_corr;
ref_coi = options.ref_coi;
eig_rad = options.eig_rad;
bet_thr = options.bet_thr;
smv_rad = options.smv_rad;
tik_reg = options.tik_reg;
tv_reg  = options.tv_reg;
tvdi_n  = options.tvdi_n;
sav_all = options.sav_all;


% define directories
[~,name] = fileparts(filename);
% path_qsm = [path_out, filesep, strrep(name,' ','_') '_QSM_EPI15_v200'];
path_qsm = [path_out, filesep, 'QSM_' name];
mkdir(path_qsm);
init_dir = pwd;
cd(path_qsm);
disp(['Start recon of ' filename]);


%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
rawfile = '/media/data/Hongfu/fQSM/ZD_RAW/2014.10.30-13.20.25-epi_333_TR3_meas.out';
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[pathstr, name, ext] = fileparts(rawfile);
mrdata = siem_read_v2({[pathstr,filesep],[name,ext]});
params = mrdata.params;
clear mrdata;


rawfile = [pathstr,filesep,filename];

[data, phascor1d] = read_meas_dat(rawfile);
datasize = size(data);
phascor1dsize = size(phascor1d);

data_all = data;
phascor1d_all = phascor1d;

%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
img_all = zeros([88 88 48 72]);
%++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
for timeSeries = 1:datasize(7)

	data = permute(reshape(data_all(:,:,:,:,:,:,timeSeries,:,:,:),[datasize(1), datasize(2), datasize(3), datasize(8), datasize(10)]),[2 1 5 3 4]);
	k = sum(data,5); % PC x RO x NS x RV

	phascor1d = permute(reshape(phascor1d_all(:,:,:,:,:,:,timeSeries,:,:,:),[phascor1dsize(1), phascor1dsize(2), phascor1dsize(3), phascor1dsize(8), phascor1dsize(10)]),[2 1 5 3 4]);
	ref = sum(phascor1d,5); % 3 PC lines of ref scan





	% phase correction (N/2 ghost)
	switch ph_corr

	    case 1
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	        % linear phase correction
	        % find the peak of each readout line
	        [PC, RO, NS, RV] = size(k);

	        ref_f = fftshift(fft(fftshift(ref,2),[],2),2);
	        odd_ref_f = (ref_f(1,:,:,:) + ref_f(3,:,:,:))/2;
	        odd_ref = squeeze(ifftshift(ifft(ifftshift(odd_ref_f,2),[],2),2));

	        [C,J] =  max(abs(odd_ref));
	        I = zeros(1,NS,RV);
	        A = zeros(1,NS,RV);

	        % parabola fit 
	        for i = 1:NS
	            for j = 1:RV
	                P = polyfit(J(1,i,j)-2:J(1,i,j)+2,abs(odd_ref(J(1,i,j)-2:J(1,i,j)+2,i,j))',2);
	                I(1,i,j) = -P(2)/(2*P(1));
	                % Q = polyfit(J(1,i,j)-2:J(1,i,j)+2,angle(odd_ref(J(1,i,j)-2:J(1,i,j)+2,i,j))',1);
	                % A(1,i,j) = Q(1)*I(1,i,j)+Q(2);
	            end
	        end

	        IS = RO/2 + 1 - I; % vox shifted

	        % F_odd = exp(-1i*repmat(A,[RO 1 1])).*...
	            % exp(-1i*2*pi*repmat(IS,[RO 1 1]).*repmat((-1/2:1/RO:1/2-1/RO)',[1 NS RV]));
	        F_odd = exp(-1i*2*pi*repmat(IS,[RO 1 1]).*repmat((-1/2:1/RO:1/2-1/RO)',[1 NS RV]));


	        even_ref = squeeze(ref(2,:,:,:));
	        [C,J] = max(abs(even_ref));

	        for i = 1:NS
	            for j = 1:RV
	                P = polyfit(J(1,i,j)-2:J(1,i,j)+2,abs(even_ref(J(1,i,j)-2:J(1,i,j)+2,i,j))',2);
	                I(1,i,j) = -P(2)/(2*P(1));
	                % Q = polyfit(J(1,i,j)-2:J(1,i,j)+2,angle(even_ref(J(1,i,j)-2:J(1,i,j)+2,i,j))',1);
	                % A(1,i,j) = Q(1)*I(1,i,j)+Q(2);
	            end
	        end


	        IS = RO/2 + 1 - I; % vox shifted

	        % F_even = exp(-1i*repmat(A,[RO 1 1])).*...
	            % exp(-1i*2*pi*repmat(IS,[RO 1 1]).*repmat((-1/2:1/RO:1/2-1/RO)',[1 NS RV]));
	        F_even = exp(-1i*2*pi*repmat(IS,[RO 1 1]).*repmat((-1/2:1/RO:1/2-1/RO)',[1 NS RV]));


	        %   Apply phase shift to data in hybrid space
	        k = fftshift(fft(fftshift(k,2),[],2),2);
	        for i = 2:2:112
	            k(i,:,:,:) = k(i,:,:,:) .* reshape(F_odd,[1 RO NS RV]);
	        end
	        for i = 1:2:112
	            k(i,:,:,:) = k(i,:,:,:) .* reshape(F_even,[1 RO NS RV]);
	        end
	        k = ifftshift(ifft(ifftshift(k,2),[],2),2);
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	    case 2
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	        % % non-linear phase correction
	        k = fftshift(fft(fftshift(k,2),[],2),2);

	        ref_f = fftshift(fft(fftshift(ref,2),[],2),2);
	        odd_ref_f = ref_f(1,:,:,:) + ref_f(3,:,:,:);
	        even_ref_f = ref_f(2,:,:,:);

	        for i = 2:2:112 % start from the bottom
	            k(i,:,:,:) = k(i,:,:,:).*exp(-1i*angle(odd_ref_f));
	        end
	        for i = 1:2:112
	            k(i,:,:,:) = k(i,:,:,:).*exp(-1i*angle(even_ref_f));
	        end
	        k = ifftshift(ifft(ifftshift(k,2),[],2),2);
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	    case 3
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	        % linear MTF correction
	        ref_f = fftshift(fft(fftshift(ref,2),[],2),2);
	        temp1 = ref_f(1,:,:,:)./ref_f(2,:,:,:);
	        temp2 = ref_f(3,:,:,:)./ref_f(2,:,:,:);
	        phrmp = angle(temp1+temp2);

	        % linear fit of phrmp (only ROI)
	        % find the edge of signal
	        std_ref = zeros(1,datasize(1)-10,datasize(10),datasize(3));
	        ROI_a = zeros(datasize(10),datasize(3));
	        ROI_b = ROI_a;

	        diff = phrmp(:,[2:datasize(1),end],:,:) - phrmp;

	        for m = 1:datasize(3)
	            for j = 1:datasize(10)
	                for i = 1:datasize(1)-10
	                    std_ref(1,i,j,m) = std(diff(1,i:i+10,j,m));
	                end
	                
	                ROI_a(j,m) = find(std_ref(1,:,j,m)<0.1,1,'first');
	                ROI_b(j,m) = find(std_ref(1,:,j,m)<0.1,1,'last') + 10;
	            end
	        end

	        phrmp_fit = zeros(1,datasize(1),datasize(10),datasize(3));
	        % linear fit phrmp
	        for j = 1:datasize(10)
	            for m = 1:datasize(3)
	                p = polyfit(ROI_a(j,m):ROI_b(j,m), phrmp(1,ROI_a(j,m):ROI_b(j,m),j,m), 1);
	                phrmp_fit(1,:,j,m) = p(1)*(1:datasize(1)) + p(2);
	            end
	        end


	        kr = fftshift(fft(fftshift(k,2),[],2),2);
	        for i = 1:2:datasize(2)
	            kr(i,:,:,:) = kr(i,:,:,:).*exp(1i*phrmp_fit/2);
	            % kr(i,:,:,:) = kr(i,:,:,:).*exp(1i*phrmp/2);

	        end
	        for i = 2:2:datasize(2)
	            kr(i,:,:,:) = kr(i,:,:,:).*exp(-1i*phrmp_fit/2);
	            % kr(i,:,:,:) = kr(i,:,:,:).*exp(-1i*phrmp/2);
	        end

	        kr = ifftshift(ifft(ifftshift(kr,2),[],2),2);
	        k = kr;
	        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	end



	% regridding the k-space in readout
	if (params.protocol_header.m_alRegridMode(1) == 2) % 2 = REGRID_TRAPEZOIDAL

	    [PC, RO, NS, RV] = size(k);
	    k = reshape(permute(k,[2 1 3 4]),RO,[]); % RO x []

	    RampupTime = params.protocol_header.m_alRegridRampupTime(1);
	    FlattopTime = params.protocol_header.m_alRegridFlattopTime(1);
	    RampdownTime = params.protocol_header.m_alRegridRampdownTime(1);
	    DelaySamplesTime = params.protocol_header.m_alRegridDelaySamplesTime(1);
	    ADCDuration = params.protocol_header.m_aflRegridADCDuration(1);
	    DestSamples = params.protocol_header.m_alRegridDestSamples(1);


	    % build the trapezoidal waveform
	    rotrap = ones(1,RampupTime+FlattopTime+RampdownTime,'single');
	    roramp = single(0:1/(RampupTime-1):1);
	    rotrap(1:RampupTime)= roramp;
	    rotrap(RampupTime+FlattopTime+1:end) = fliplr(roramp);

	    % cut off the unused parts
	    rotrap = rotrap(DelaySamplesTime+1:end);
	    rotrap = rotrap(1:floor(ADCDuration)); % eja: floor added for VD11

	    % integrate
	    trapint = zeros(size(rotrap,2),1,'single');
	    for z=1:size(rotrap,2)
	        trapint(z) = sum(rotrap(1:z));
	    end

	    % assemble the desired k-space trajectory
	    % add a point on the beginning and end since otherwise the
	    %     interp1 function goes wacko
	    destTraj = single(0:sum(rotrap)/(DestSamples+1):sum(rotrap));


	    % interpolate 
	    nSamples = size(k,1);
	    actualDwell = ADCDuration/nSamples;
	    actTraj = interp1(1:size(trapint,1),trapint,1:actualDwell:ADCDuration,'linear').';

	    for i = 1:size(k,2)
	        ctrc = k(:,i);

	        filterf = (cumsum(destTraj(2:end-1)) - cumsum(actTraj'));
	        filterf = filterf / sqrt(1/size(ctrc,1) * sum( abs(filterf).^2) );

	        ctrc = interp1(actTraj,ctrc.*filterf',destTraj,'linear');
	        % ctrc = interp1(actTraj,ctrc,destTraj.','linear');

	        ctrc = ctrc(2:end-1);
	        ctrc(isnan(ctrc)) = 0;
	        k(:,i) = ctrc;

	    end

	    k = permute(reshape(k,[RO, PC, NS, RV]),[2 1 3 4]);
	end



	% partial fourier
	sz = size(k);
	pf = nan;
	flag = params.protocol_header.sKSpace.ucPhasePartialFourier;
	flag(isspace(flag))=[];
	switch (flag)
	    case {'0x1', 1}  % PF_HALF
	        disp('Half fourier is unhandled :(')
	    case {'0x2', 2}  % PF_5_8
	        pf = 5/8;
	    case {'0x4', 4}  % PF_6_8
	        pf = 6/8;
	    case {'0x8', 8}  % PF_7_8
	        pf = 7/8;
	    case {'0x10', 10} % PF_OFF
	    case {'0x20', 20} % PF_AUTO
	    case {'0x16', 16} % "none" in VD??
	end
	if ~isnan(pf)
	    disp(sprintf('Partial Fourier: %d/8', pf*8));
	    k = padarray(k, round(sz(1)*(1/(pf)-1)), 'pre');
	end


	% POCS
	[im, kspFull] = pocs(permute(k,[4 1 2 3]),200);
	k = permute(kspFull,[2 3 4 1]);


	% phase resolution
	if (params.protocol_header.sKSpace.dPhaseResolution ~= 1)
	    disp(sprintf('Phase Resolution: %1.2f', params.protocol_header.sKSpace.dPhaseResolution));
	    sz = size(k);
	    k = padarray(k, round((sz(1)-1)*(1/params.protocol_header.sKSpace.dPhaseResolution-1)/2));
	end


	% Asymmetric echo 
	sz = size(k);
	pad = params.protocol_header.sKSpace.lBaseResolution - sz(2)/2;
	if pad
	    disp(sprintf('Asymmetric echo: adding %d lines', pad*2));
	    k = padarray(k, [0 pad*2], 'pre');
	end


	% 2D low-pass hann filter
	% generate a 2d hamming low-pass filter
	Nro = size(k,2);
	Npe = size(k,1);
	fw = 0.125;

	x = hann(round(fw*Nro/2)*2);
	x1 = [x(1:length(x)/2); ones([Nro-length(x),1]); x(length(x)/2+1:end)];
	y = hann(round(fw*Npe/2)*2);
	y1 = [y(1:length(y)/2); ones([Npe-length(y),1]); y(length(y)/2+1:end)];
	        
	[X,Y] = meshgrid(x1,y1);
	Z = X.*Y;
	Z = repmat(Z,[1 1 datasize(10) datasize(3)]);

	k = k.*Z;



	% fft to image space and remove oversampling
	img = zeros(size(k));
	for i = 1:size(k,3)*size(k,4)
	    tmp = k(:,:,i);
	    img(:,:,i) = fftshift(fft2(fftshift(tmp)));
	end

	img = img(:,size(k,2)/4+1:size(k,2)/4*3,:,:);


	% permute the matrix first two dimensions (EPI acquisition)
	img = permute(img,[2 1 3 4]);
	% flip the readout to match qsm_swi15 results
	img = flipdim(img,1);


	img_all(:,:,:,timeSeries) = img;
end



for timeSeries = 1:size(img_all,4)
    img = img_all(:,:,:,timeSeries);

	% zero-interpolation
	k = ifftshift(ifftn(ifftshift(img)));
	k_pad = padarray(k,size(k)/2);

	% low pass filter to reduce gibbs-ringing
	% 3D low-pass hann filter
	Nro = size(k,1);
	Npe = size(k,2);
	Ns = size(k,3);
	fw = 0.75;

	x = hann(round(fw*Nro/2)*2);
	x1 = [x(1:length(x)/2); ones([Nro-length(x),1]); x(length(x)/2+1:end)];
	y = hann(round(fw*Npe/2)*2);
	y1 = [y(1:length(y)/2); ones([Npe-length(y),1]); y(length(y)/2+1:end)];
	z = hann(round(fw*Ns/2)*2);
	z1 = [z(1:length(z)/2); ones([Ns-length(z),1]); z(length(z)/2+1:end)];
	        
	[X,Y,Z] = ndgrid(x1,y1,z1);
	F = X.*Y.*Z;
	F = padarray(F,size(k)/2);
	F = repmat(F,[1 1 1 size(k,4)]);

	k_pad = k_pad.*F;

	img = fftshift(fftn(fftshift(k_pad)));


	% size and resolution
	[Nro,Npe,~,~] = size(img);
	FOV = params.protocol_header.sSliceArray.asSlice{1};
	voxelSize = [FOV.dReadoutFOV/Nro, FOV.dPhaseFOV/Npe,  FOV.dThickness*size(k,3)/size(k_pad,3)];


	% combine RF coils
	disp('--> combine RF rcvrs ...');
	if size(img,4)>1
	    img_cmb = sense_se(img,voxelSize,ref_coi,eig_rad);
	else
	    img_cmb = img;
	end

	mkdir('combine');
	nii = make_nii(abs(img_cmb),voxelSize);
	save_nii(nii,['combine/mag_cmb' num2str(timeSeries) '.nii']);
	nii = make_nii(angle(img_cmb),voxelSize);
	save_nii(nii,['combine/ph_cmb' num2str(timeSeries) '.nii']);



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% % combine coils
	% % 
	% img_cmb = zeros(Nro,Npe,Ns);
	% matlabpool open
	% parfor i = 1:Ns
	%     img_cmb(:,:,i) = coilCombinePar(img(:,:,i,:));
	% end
	% matlabpool close
	% nii = make_nii(abs(img_cmb),voxelSize);
	% save_nii(nii,'mag.nii');
	% nii = make_nii(angle(img_cmb),voxelSize);
	% save_nii(nii,'ph.nii');
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


	% generate brain mask
	disp('--> extract brain volume and generate mask ...');
	setenv('bet_thr',num2str(bet_thr));
	setenv('timeSeries',num2str(timeSeries));
	unix('bet combine/mag_cmb${timeSeries}.nii BET${timeSeries} -f ${bet_thr} -m -R');
	unix('gunzip -f BET${timeSeries}.nii.gz');
	unix('gunzip -f BET${timeSeries}_mask.nii.gz');
	nii = load_nii(['BET' num2str(timeSeries) '_mask.nii']);
	mask = double(nii.img);


	% unwrap combined phase with PRELUDE
	disp('--> unwrap aliasing phase ...');
	unix('prelude -a combine/mag_cmb${timeSeries}.nii -p combine/ph_cmb${timeSeries}.nii -u unph${timeSeries}.nii -m BET${timeSeries}_mask.nii -n 8');
	unix('gunzip -f unph${timeSeries}.nii.gz');
	nii = load_nii(['unph' num2str(timeSeries) '.nii']);
	unph = double(nii.img);

	% unwrap with Laplacian based method
	% unph = unwrapLaplacian(angle(img_cmb), size(img_cmb), voxelSize);
	% nii = make_nii(unph, voxelSize);
	% save_nii(nii,'unph_lap.nii');


	% background field removal

	% % (1) PDF to remove air
	% sNormal = params.protocol_header.sSliceArray.asSlice{1}.sNormal;
	% if ~ isfield(sNormal,'dSag')
	%     sNormal.dSag = 0;
	% end
	% if ischar(sNormal.dSag)
	%     sNormal.dSag = 0;
	% end
	% if ~ isfield(sNormal,'dCor')
	%     sNormal.dCor = 0;
	% end
	% if ischar(sNormal.dCor)
	%     sNormal.dCor = 0;
	% end
	% if ~ isfield(sNormal,'dTra')
	%     sNormal.dTra = 0;
	% end
	% if ischar(sNormal.dTra)
	%     sNormal.dTra = 0;
	% end
	% z_prjs = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra];

	% weights = mask.*abs(img_cmb);
	% [lfs_pdf,mask_pdf] = pdf(unph,mask,voxelSize,smv_rad,weights,z_prjs);
	% % nii = make_nii(lfs_pdf_noAir.*mask_pdf_ero.*hemo_mask,voxelSize);
	% nii = make_nii(lfs_pdf,voxelSize);
	% save_nii(nii,'lfs_pdf.nii');
	% nii = make_nii(mask_pdf,voxelSize);
	% save_nii(nii,'mask_pdf.nii');




	disp('--> RESHARP to remove background field ...');
	mkdir('RESHARP');
	[lph_resharp,mask_resharp] = resharp(unph,mask,voxelSize,smv_rad,tik_reg);

	% normalize to ppm unit
	TE = params.protocol_header.alTE{1}/1e6;
	B_0 = params.protocol_header.m_flMagneticFieldStrength;
	gamma = 2.675222e8;
	lfs_resharp = lph_resharp/(gamma*TE*B_0)*1e6; % unit ppm

	nii = make_nii(lfs_resharp,voxelSize);
	save_nii(nii,['RESHARP/lfs_resharp' num2str(timeSeries) '.nii']);


	% susceptibility inversion
	disp('--> TV susceptibility inversion ...');
	% account for oblique slicing (head tilted)
	% theta = -acos(params.protocol_header.sSliceArray.asSlice{1}.sNormal.dTra);
	sNormal = params.protocol_header.sSliceArray.asSlice{1}.sNormal;
	if ~ isfield(sNormal,'dSag')
	    sNormal.dSag = 0;
	end
	if ischar(sNormal.dSag)
	    sNormal.dSag = 0;
	end
	if ~ isfield(sNormal,'dCor')
	    sNormal.dCor = 0;
	end
	if ischar(sNormal.dCor)
	    sNormal.dCor = 0;
	end
	if ~ isfield(sNormal,'dTra')
	    sNormal.dTra = 0;
	end
	if ischar(sNormal.dTra)
	    sNormal.dTra = 0;
	end
	nor_vec = [-sNormal.dSag, -sNormal.dCor, sNormal.dTra]

	% sus_resharp = tvdi(lfs_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb),theta,tvdi_n);
	[sus_resharp,residual] = tvdi(lfs_resharp,mask_resharp,voxelSize,tv_reg,abs(img_cmb),nor_vec,tvdi_n);
	nii = make_nii(sus_resharp.*mask_resharp,voxelSize);
	save_nii(nii,['RESHARP/sus_resharp' num2str(timeSeries) '.nii']);

end

