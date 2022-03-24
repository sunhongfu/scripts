classdef SVD_DictionaryObj

  properties
    atoms
    lookup
    U
    names
    
    header

    file_file
    file_path

  end

  methods
    %% ---------------------------------------------------------------------------
    %% Constructor
    %% ---------------------------------------------------------------------------
    function obj = SVD_DictionaryObj(input_file_path, input_file_name)

      switch nargin
        case 2
          obj.file_path = input_file_path;
          obj.file_file = input_file_name;
        otherwise
          [obj.file_file, obj.file_path] = uigetfile('*.float','Select a SVD dictionary file:');
      end

     % load lookup
        %% read lookup table
        disp([obj.file_path obj.file_file]);
        fid = fopen([obj.file_path obj.file_file],'r');
        %header
        iTot   = fread(fid, 1, 'int64');         %libary total length
        iPar   = fread(fid, 1, 'int64');         %number of maps
        iSet   = fread(fid, 1, 'int64');         %MRF data points for the library
        iRAW   = fread(fid, 1, 'int64');         %MRF data points for the data
        
        
        fTR    = fread(fid, 1, 'single');        %Simulation TR
        fTBW   = fread(fid, 1, 'single');        %Simulation RF Time Bandwith
        fDelay = fread(fid, 1, 'single');        %Repetition delay in ms

        dim    = fread(fid, 5,'int64');          %steps of a given dim
        minV   = fread(fid, 5,'single');         %min values for the maps
        maxV   = fread(fid, 5,'single');         %max values for the maps

        
        nSize  = fread(fid, 5,'int32');        
        names  = fread(fid, 5*100, 'char');          %names of the maps (e.g., T2)
        obj.names  = reshape(names, 100,5);

        
        obj.U      = fread(fid, iSet*iRAW, 'single');
        obj.lookup = fread(fid, iPar*iTot, 'single');
        obj.atoms  = fread(fid, iSet*iTot, 'single');
        fclose(fid);
        
        for i=1:iPar
            if dim(i)==0 
                dim(i)=1;
            end
        end
        
        obj.header.names = names;
        obj.header.dim   = dim;
        obj.header.TBW   = fTBW;
        obj.header.TR    = fTR;
        obj.header.delay = fDelay;
        
        
         print_summary(obj);
        
        obj.U      = reshape(obj.U     ,iRAW, iSet);
        obj.lookup = single(reshape(obj.lookup,iPar ,iTot));
        obj.atoms  = single(reshape(obj.atoms ,iSet ,iTot));
        
%         if(iPar==5)
%             obj.lookup = reshape(obj.lookup,dim(1),dim(2),dim(3),dim(4),dim(5));
%             obj.atoms  = reshape(obj.atoms,iSets,dim(1),dim(2),dim(3),dim(4),dim(5));
%         end
    end % /constructor



    %% ---------------------------------------------------------------------------
    %% print summary
    %% ---------------------------------------------------------------------------
    function print_summary(obj)
      clc;
      for i=1:size(obj.header.dim)
        disp(['dimension ' num2str(i) ' : ' num2str(obj.header.dim(i)) ]);
      end
      disp(['sim TR:        ' num2str(obj.header.TR)] );
      disp(['sim TBW:       ' num2str(obj.header.TBW)]);
      disp(['sim Delay:     ' num2str(obj.header.delay)]);
    end


  end % /methods

end % /class
