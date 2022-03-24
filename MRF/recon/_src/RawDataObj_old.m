classdef RawDataObj < handle

  properties
    data
    noise
    invNoiseCov
    angles

    softwareVersion
    file_name
    file_path
    Dim
    kShift
    bIsCompressed
  end

  methods
    %% ---------------------------------------------------------------------------
    %% Constructor
    %% ---------------------------------------------------------------------------
    function obj = RawDataObj(input_remove_os, input_file_path, input_file_name)

      switch nargin
        case 3
          gbc.remove_os = input_remove_os;
          obj.file_path = input_file_path;
          obj.file_name = input_file_name;
        
        case 1
          gbc.remove_os = input_remove_os;
          [obj.file_name, obj.file_path] = uigetfile('*.dat','Select a IRFF raw data file:');
          
        otherwise
          gbc.remove_os = false;
          [obj.file_name, obj.file_path] = uigetfile('*.dat','Select a IRFF raw data file:');
      end

      % load data
      gbc.ima_obj        = mapVBVD([obj.file_path, obj.file_name]);

      % Multi Raid excpetion
      if(size(gbc.ima_obj, 2) > 1)
        disp('-----------------------------------------------------------');
        disp('     (Multi Raid File Detected: extracting last object)');
        disp('------------------------------------------------------------');
             %-----------------------------|------------------------------
        gbc.ima_obj        = gbc.ima_obj{1,size(gbc.ima_obj,2)};
      else
%         disp('------------------------------------------------------------');
%         disp('                (Single Raid File Detected)');
%         disp('------------------------------------------------------------');
      end

      % Extract software version
      obj.softwareVersion = gbc.ima_obj.image.softwareVersion;

      % Extract kspace data
      gbc.ima_obj.image.flagRemoveOS = gbc.remove_os;
      obj.data = single(gbc.ima_obj.image());

      obj.Dim.nRe = size(obj.data,1);
      obj.Dim.nCh = size(obj.data,2);
      obj.Dim.nLi = size(obj.data,3);
      obj.Dim.nSl = size(obj.data,5);
      obj.Dim.nEc = size(obj.data,8);
      obj.Dim.nSe = size(obj.data,10);

      % Reshape kspace data
      obj.data = reshape(obj.data, cell2mat(struct2cell(obj.Dim)).');

      % Reorder: echo slice recieve_channel reaout spoke set
      obj.data = permute(obj.data, [5,4,2,1,3,6]);
      obj.Dim  = orderfields(obj.Dim,{'nEc', 'nSl', 'nCh', 'nRe', 'nLi', 'nSe'});

      % Extract the free ice parameters
      if(obj.softwareVersion == 'vd')
        gbc.freeParamOffset = 4;
        gbc.mdhFreeParam = permute(gbc.ima_obj.image.iceParam, [2,1]);
      else
        gbc.freeParamOffset = 0;
        gbc.mdhFreeParam = permute(gbc.ima_obj.image.freeParam, [2,1]);
      end

      % Extract the indexes correspodning to the free ice parameters
      gbc.mdhLine = gbc.ima_obj.image.Lin;
      gbc.mdhSet  = gbc.ima_obj.image.Set;
      gbc.mdhEco  = gbc.ima_obj.image.Eco;

      % Extract the line angles & compression indexes
      obj.angles  = zeros(obj.Dim.nEc, obj.Dim.nLi, obj.Dim.nSe); % Spoke Angle
 
      for ii=1:size(gbc.mdhFreeParam,1)
          gbc.ang = gbc.mdhFreeParam(ii,1+gbc.freeParamOffset)*10000;
          gbc.ang = gbc.ang + gbc.mdhFreeParam(ii,2+gbc.freeParamOffset);

          obj.angles (gbc.mdhEco(ii),gbc.mdhLine(ii), gbc.mdhSet(ii)) = gbc.ang/(10000*10000);
      end

      clear gbc; % GarBage Collector

    end % /constructor

    
    % ---------------------------------------------------------------------------
    % set slice range
    % ---------------------------------------------------------------------------
    function obj = setSliceRange(obj, slice_range)
        obj.data = obj.data(:,slice_range,:,:,:,:);
        obj.Dim.nSl = size(obj.data,2);
    end
    
    % ---------------------------------------------------------------------------
    % extract noise scans
    % ---------------------------------------------------------------------------
    function obj = extractNoiseScan(obj,bExtract)
        if bExtract
         obj.noise   = obj.data(:,:,:,:,1,:);
         obj.data    = obj.data(:,:,:,:,2:end,:);
         obj.angles  = obj.angles (:,2:end, :);
         obj.Dim.nLi = obj.Dim.nLi -1;         
         
         tmp = abs(squeeze(obj.noise(:,1,1,:,:,:)));
         tLim = max(tmp(:));
         figure; imshow(tmp, [0 tLim]); title('noise measurment data: rx1');
         
         % ---------------------------------------------------------------------------
         % get noise covarience matrix
         % ---------------------------------------------------------------------------
         if obj.Dim.nCh == 1
             obj.invNoiseCov = 1;
         else
             nCh = obj.Dim.nCh;
             noisecov = zeros(nCh);
             
             noi = squeeze(obj.noise(1,1,:,:));
             for iCh = 1:nCh
                for jCh = 1:nCh
                    noisecov(iCh,jCh) = sum(squeeze(noi(iCh,:).*conj(noi(jCh,:))));
                end
             end
             lim = max(abs(noisecov(:)));
             figure(99); imshow(abs(noisecov),[0,lim]);
             
             %noisecov = noisecov/(obj.Dim.nLi*obj.Dim.nSe);
             obj.invNoiseCov = inv(noisecov);
             obj.invNoiseCov = obj.invNoiseCov/norm(obj.invNoiseCov);
             disp('Noise covarience matrix found!');
             
             
         end
         
        else
         obj.noise = 0;
         obj.invNoiseCov = eye(obj.Dim.nCh);
        end
        
    end    
    
    % ---------------------------------------------------------------------------
    % set kspace shift
    % ---------------------------------------------------------------------------
    function obj = setKSpaceShift(obj, kspaceShift)
             obj.kShift = kspaceShift;  
    end
    
    % ---------------------------------------------------------------------------
    % Get k space trajectory
    % ---------------------------------------------------------------------------
    function trj = get_trajectory(obj)

      gbc.x = zeros(obj.Dim.nEc, obj.Dim.nRe, obj.Dim.nLi, obj.Dim.nSe);
      gbc.y = zeros(obj.Dim.nEc, obj.Dim.nRe, obj.Dim.nLi, obj.Dim.nSe);

      gbc.rho = 1:obj.Dim.nRe;
      gbc.rho = gbc.rho - (obj.Dim.nRe+1)/2 + obj.kShift;
      gbc.rho = gbc.rho/obj.Dim.nRe;
      
      for ec=1:obj.Dim.nEc
        for re=1:obj.Dim.nRe
          for li=1:obj.Dim.nLi
            for se=1:obj.Dim.nSe
                gbc.x(ec,re,li,se)=gbc.rho(re)*sin(obj.angles(ec, li, se));
                gbc.y(ec,re,li,se)=gbc.rho(re)*cos(obj.angles(ec, li, se));
            end
          end
        end
      end

      trj.k = gbc.x+1i*gbc.y;
      trj.w = sqrt(gbc.x.^2+gbc.y.^2);
      trj.w = trj.w/(max(trj.w(:)));

      clear gbc; % GarBage Collector
    end
  
    
    
   % ---------------------------------------------------------------------------
    % Apply an arbitrary compression 
    % ---------------------------------------------------------------------------
    function obj = applyCompression(obj, U)
        
    if(obj.bIsCompressed)
       return
    end
        
    dataT = zeros(obj.Dim.nEc,obj.Dim.nSl,obj.Dim.nCh,obj.Dim.nRe,obj.Dim.nLi*obj.Dim.nSe,size(U,2));

    for i=1:size(U,2)
        u = squeeze(permute(repmat(U(:,i),[1,obj.Dim.nRe,obj.Dim.nLi]),[2,3,1])); % readout spokes k-data
        for ec=1:obj.Dim.nEc
            for sl=1:obj.Dim.nSl
                for ch=1:obj.Dim.nCh
                    tmp = squeeze(obj.data(ec,sl,ch,:,:,:)).*u;
                    dataT(ec,sl,ch,:,:,i) = tmp(:,:);
                end
            end    
        end
    end

    obj.data = dataT;
    clear('dataT');
    
    obj.angles = obj.angles(:, :);
    obj.angles = repmat(obj.angles,1,1,size(U,2));
    
    obj.Dim.nLi = obj.Dim.nLi*obj.Dim.nSe;
    obj.Dim.nSe = size(U,2);
        
    obj.bIsCompressed = true;
    
    end

  end % /methods

end % /class
