classdef IRFF_DictionaryObj

  properties
    atoms
    lookup
    
    header

    file_file
    file_path

  end

  methods
    %% ---------------------------------------------------------------------------
    %% Constructor
    %% ---------------------------------------------------------------------------
    function obj = IRFF_DictionaryObj(input_file_path, input_file_name)

      switch nargin
        case 2
          obj.file_path = input_file_path;
          obj.file_file = input_file_name;
        otherwise
          [obj.file_file, obj.file_path] = uigetfile('*.float','Select a IRFF dictionary file:');
      end

      % load lookup
        %% write lookup table
        fid = fopen([obj.file_path '/irff_lookup_table.bin'],'r');
        %header
        iTot   = fread(fid, 1, 'int64');         %libary total length
        iPar   = fread(fid, 1, 'int64');         %number of maps
        iSets  = fread(fid, 1, 'int64');         %MRF data points for the library
        
        fTR    = fread(fid, 1, 'single');        %Simulation TR
        fTBW   = fread(fid, 1, 'single');        %Simulation RF Time Bandwith

        dim    = fread(fid, 5,'int64');          %steps of a given dim
        minV   = fread(fid, 5,'single');         %min values for the maps
        maxV   = fread(fid, 5,'single');         %max values for the maps

        
        nSize  = fread(fid, 5,'int32');
        
        names  = fread(fid, 5*100, 'char');          %names of the maps (e.g., T2)
        names  = reshape(names, 100,5);

        obj.lookup = fread(fid, iPar*iTot, 'single');
        fclose(fid);
        
        obj.header.names = names;
        obj.header.dim   = dim;
        obj.header.TBW   = fTBW;
        obj.header.TR    = fTR;
        
        for i=1:iPar
            if dim(i)==0 
                dim(i)=1;
            end
        end
  
        fid = fopen([obj.file_path obj.file_file],'r');
        obj.atoms = fread(fid, iSets*iTot, 'single');
        fclose(fid);

        
%         print_summary(obj);
        
        
        obj.lookup = reshape(obj.lookup,iPar ,iTot);
        obj.atoms  = reshape(obj.atoms ,iSets,iTot);
        
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
    end


  end % /methods

end % /class
