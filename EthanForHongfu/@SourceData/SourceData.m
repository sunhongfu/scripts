classdef SourceData
    %SourceData - Opens various types of dicom source data directories
    %
    %   This class is used for most operations. It has a series of
    %   functions to open directories full of dicom files. This pointer for
    %   this class is then sent to a other classes for processing.
    
    properties (SetAccess = public)
              
        dicomHeaderData
        
        % dimensions
        xLength
        yLength
        zLength
        numTimePts
        numVolumes = 5 ; 
        imageVolume
        
        numB1images
        numCoils
        TE_FGRE1
        TE_FGRE2
        TR_B1Map1
        TR_B1Map2
        TR_SPGR
        numEchoesSPGR
        zLengthMESPGR
        METE
        TE
        
        % volume data
        volDicomStack
        volFastGRE1
        volFastGRE2
        volSumOfSquares
        volB1map1
        volB1map2
        volSPGR1
        volSPGR2
        volSSFP1
        volSSFP2
        volMESPGR
        volBolusPassage
        volTOF
        volASL_CBF
        volASL_RAW
        volASL_M0
        volDTI
        volFLAIR
        volBOLD
        volBOLDcomplex
        volCOLD
        volMTR_pulseOn
        volMTR_pulseOff
        volT1anat
        volMS
        volMS_vascular
        volMontage
        volQMTsource
        volQMTsourceSorted
        volQMTreference
        volQMTreferenceSorted
        
        % phase constrat Specific
        HR_venc
        LR_venc
        tissueThreshold ; % in Percent (%) of max
        velocityThreshold ; % in cm/s
        
        HR_magVol
        HR_tissueVol
        HR_vectVol
        HR_mask
        
        HR_SliceThickness ;
        HR_Zposition ;
        HR_XacqRes ;
        HR_YacqRes ;
        
        LR_Nz ;
        LR_Nx ;
        LR_Ny ;
                        
        LR_SliceThickness ;
        LR_Zposition ;
        LR_XacqRes ;
        LR_YacqRes ;
            
        LR_magVol ;
        LR_vectVol ;
        LR_tissueVol ;
        
        qMT_data_table 
        qMT_observations
        qMT_unqiue_offset_freq
        qMT_unique_qMTflip
        qMT_unique_tr_and_flip_angle_combinations
        qMT_num_unique_offset_freq
        qMT_num_unique_qMTflip
        qMT_num_unique_tr_and_flip_angle_combinations 
        qMT_num_vols
        qMT_num_ref_volumes  
        qMT_num_unique_references
        
        % figure handle
        figure_handle
        
        UseHR_PC = 0 ;
        top_to_bottom = false ;
        
        
    end
    
    properties (SetAccess = private)
        
    end
    
    methods (Static)
        
    end
    
    methods (Access = public)
        
        function [ obj ] = SourceData( doDisplay )
            if( doDisplay )
                obj.figure_handle = figure ;
            end
        end
        
        function [ obj ] = fOpenDicomStack( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.stack_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;

            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = length( imagelist ) - 2 ;
            
            obj.volDicomStack = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volDicomStack( :, :, count ) = ...
                    double( dicomread( imagelist( count+2 ).name ) );
            end

            %go back to project root directory
            cd( pathObj.source_code_pathway );
            
            %display            
            if( doDisplay == 1 )
                
                FourDviewer( obj.volDicomStack ) ;
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpen4DDicomStack( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.stack_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
            
            %get the image list
            imagelist = dir ;
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;

            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            %obj.zLength = length( imagelist ) - 2 ;
            
            obj.volDicomStack = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.numTimePts ) ;
            
            %open all the dicoms and put them in the right space
            ImageCounter = 3 ; 
            for tCount = 1 : obj.numTimePts
            for zCount = 1 : obj.zLength
                obj.volDicomStack( :, :, zCount, tCount ) = ...
                    double( dicomread( imagelist( ImageCounter ).name ) );
                ImageCounter = ImageCounter +1 ;
            end
            end

            %go back to project root directory
            cd( pathObj.source_code_pathway );
            
            %display            
            if( doDisplay == 1 )
                
                FourDviewer( obj.volDicomStack ) ;
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpenGenericDicom( obj, pathObj, doDisplay ) 
           
%             xLength
%             yLength
%             zLength
%             numTimePts
%             numVolumes = 5 ;
            
            obj.imageVolume = squeeze( dicomread( pathObj.pathToFile ) ) ;
            
            if( doDisplay == 1 ) 
               
                displayMontage( obj.imageVolume, [] ) ;
                
            end
            
        end
        
        %open complex GRE images to calculate B0, QSM
        function [ obj ] = fOpenGREcomplexImages( obj, pathObj, doDisplay ) 
                 
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.FGRE_1_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;
 
%             %calculate the phase correction matrices
%             % Compute phaser
%             FOVy = 22 ;
%             nShift = 0.75 ;
%             Ny     = 256;
%             dk     = 1;
%             Kext   = Ny * dk;
%             dy     = 1 / Kext;
%             FOVy   = Ny * dy;
%             r      = -FOVy/2:dy:FOVy/2-dy;
%             shift  = nShift * dk;
%             tmp_ph = exp(-i*2*pi*shift*r);
%             phaser = tmp_ph' * ones( 1, Ny );
%             
%             a = imag( exp( -i*0.75*[1:256] ) ) ;
%             realCorr = a' * ones(1,256) ;
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;

            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 ) / ( obj.numCoils + 1 ) / 4 ;
            
            obj.volFastGRE1 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.numCoils ) ;
            
            %open all the dicoms and put them in the right space
            Counter = 1 ;
            for count = 1 : obj.zLength
                
                %loop through coils
                for coilCount = 1 : obj.numCoils

                    %read in mag image              
                    %
                    Counter = Counter + 1 ;

                    %read in phase image       
                    %
                    Counter = Counter + 1 ;

                    %read in real image
                    theReal = ...
                        double( dicomread( imagelist( Counter+2 ).name ) );
                    Counter = Counter + 1 ;

                    %read in imaginary image
                    theImag = ...
                        double( dicomread( imagelist( Counter+2 ).name ) );
                    Counter = Counter + 1 ;
                    
                    %fix the phase shift - comment out if required
%                     shiftedImageData = theReal + i * theImag ;
%                     phaseWrapped = fft( shiftedImageData ) ;
%                     FourierData = ...
%                         [ phaseWrapped((32*3+1):256,:) ; phaseWrapped(1:32*3,:)] ;
%                     ImageData = ifft( fftshift( FourierData ) ) ;
%                     ImageData = [ ImageData(:,129:256) ImageData(:,1:128) ] ;
                    
                    ImageData =  theReal + i * theImag ;

                    obj.volFastGRE1( :, :, count, coilCount ) = ImageData ;
                end
                
                %skip over the full recon images
                Counter = Counter + 4 ; 
                
            end

% No longer collecting second FGRE scan in quantification protocol
%
%             %change directory
%             cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
%                 pathObj.FGRE_2_subdir ] ) ;
% 
%             %get the image list
%             imagelist = dir ;
% 
%             %open all the dicoms and put them in the right space
%             Counter = 1 ;
%             for count = 1 : obj.zLength
%                 
%                 %loop through coils
%                 for coilCount = 1 : obj.numCoils
% 
%                     %read in mag image              
%                     %
%                     Counter = Counter + 1 ;
% 
%                     %read in phase image       
%                     %
%                     Counter = Counter + 1 ;
% 
%                     %read in real image
%                     theReal = ...
%                         double( dicomread( imagelist( Counter+2 ).name ) );
%                     Counter = Counter + 1 ;
% 
%                     %read in imaginary image
%                     theImag = ...
%                         double( dicomread( imagelist( Counter+2 ).name ) );
%                     Counter = Counter + 1 ;
%                     
%                     %fix the phase shift - comment out if required
% %                     shiftedImageData = theReal + i * theImag ;
% %                     phaseWrapped = fft( shiftedImageData ) ;
% %                     FourierData = ...
% %                         [ phaseWrapped((32*3+1):256,:) ; phaseWrapped(1:32*3,:)] ;
% %                     ImageData = ifft( fftshift( FourierData ) ) ;
% %                     ImageData = [ ImageData(:,129:256) ImageData(:,1:128) ] ;
%                     ImageData = theReal + i * theImag ;
% 
%                     obj.volFastGRE2( :, :, count, coilCount ) = ...
%                         ImageData ;       
%                 end
%                 
%                 %skip over the full recon images
%                 Counter = Counter + 4 ; 
%                 
%             end
           
            %go back to project root directory
            cd( pathObj.source_code_pathway );
            
            %display            
            if( doDisplay == 1 )
                
                %loop through the 4 types of images
                for imageTypeCount = 1 : 2
                    
                    %loop through each of the coils
                    for coilCount = 1 : obj.numCoils

                        %declare the display array
                        displayArray = zeros( obj.xLength, obj.yLength,...
                            1, obj.zLength ) ;

                        %copy 3d Data into montage format for display
                        for count = 1 : obj.zLength
                            
                            if( imageTypeCount == 1 )
                                displayArray(:,:,1,count) = ...
                                    real( obj.volFastGRE1(:,:,count,coilCount) );
                            end
                            if( imageTypeCount == 2 )
                                displayArray(:,:,1,count) = ...
                                    real( obj.volFastGRE1(:,:,count,coilCount) );
                            end
                            if( imageTypeCount == 3 )
                                displayArray(:,:,1,count) = ...
                                    obj.volFastGRE2real(:,:,count,coilCount);
                            end
                            if( imageTypeCount == 4 )
                                displayArray(:,:,1,count) = ...
                                    obj.volFastGRE2imag(:,:,count,coilCount);
                            end
                            
                        end

                        %display the montage
                        figure(obj.figure_handle) ; 
                        montage( displayArray , 'DisplayRange', [  ] ) ;
                        %set(obj.figure_handle,'position',[100 100 400 400]);                        
                        colorbar ;
                        if( imageTypeCount == 1 )                            
                            title( strcat( 'Seq 1 Real ; ', ' ; CoilCount = ',...
                                int2str( coilCount ) ) );                            
                        end
                        if( imageTypeCount == 2 )
                            title( strcat( 'Seq 1 Imag ; ', ' ; CoilCount = ',...
                                int2str( coilCount ) ) );                             
                        end
                        if( imageTypeCount == 3 )
                            title( strcat( 'Seq 2 Real ; ', ' ; CoilCount = ',...
                                int2str( coilCount ) ) );                             
                        end
                        if( imageTypeCount == 4 )
                            title( strcat( 'Seq 2 Imag ; ', ' ; CoilCount = ',...
                                int2str( coilCount ) ) );                             
                        end
                        drawnow;
                        snapnow;
                        
                        %displayArray
                        %max(max(max(max( displayArray ))))
                        
                    end %for coilCount = 1 : obj.numCoils
                    
                end %for imageTypeCount = 1 : 4
                
            end %if(doDisplay==1)
            
        end
        
        %open interleaved TR B1 mapping volume
        function [ obj ] = fOpenB1mappingSourceImages( obj, pathObj, doDisplay ) 
        
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.B1_mapping_subdir ] ) ;
            !rm .DS_Store
            
            %initialize the image volume
            imagelist = dir ;
            obj.numB1images = ( length( imagelist ) - 2 ) / 2 ;
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 ) / 2 ; % as there are two volumes
            
            %init the volume
            obj.volB1map1 = zeros( obj.xLength, obj.yLength, ...
                obj.numB1images ) ;
            obj.volB1map2 = zeros( obj.xLength, obj.yLength, ...
                obj.numB1images ) ;
            
            %open first half of the dicoms and put them in the right space
            Counter1 = 1 ;
            Counter2 = 1 ;
            for count = 1 : 2*obj.numB1images
                
                if( mod(count,2) == 0 )
                    obj.volB1map1(:,:,Counter1) = ...
                        double(dicomread(imagelist(count+2).name));
                    Counter1 = Counter1 + 1 ;
                end
                if( mod(count,2) == 1 )
                    obj.volB1map2(:,:,Counter2) = ...
                        double(dicomread(imagelist(count+2).name));
                    Counter2 = Counter2 + 1 ;
                end
                
            end
            
            cd([ pathObj.source_code_pathway ])
            
            %display            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.numB1images ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.numB1images
                    displayArray(:,:,1,count) = ...
                        obj.volB1map1(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'Interleaved TR, 1 (TR short)' ); 
                drawnow;snapnow;
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.numB1images ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.numB1images
                    displayArray(:,:,1,count) = ...
                        obj.volB1map2(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'Interleaved TR, 2 (TR long)' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
            
        end
        
        %open up the SPGR sequence data to calculate DESPOT1
        function [ obj ] = fOpenSPGRimages( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.SPGR_1_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 ) ; 
            
            %init the volume
            obj.volSPGR1 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            obj.volSPGR2 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volSPGR1(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.SPGR_2_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength                
                obj.volSPGR2(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );                
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            %display            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSPGR1(:,:,count);
                end

                %display the montage
                figure(obj.figure_handle) ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;snapnow;
                                                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSPGR2(:,:,count);
                end
                
                %display the montage
                figure(obj.figure_handle) ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;snapnow;
                                        
            end %if(doDisplay==1)
            
        end 
        
        %open up the SPGR sequence data to calculate DESPOT1
        function [ obj ] = fOpenDESPOT1images( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.DESPOT1_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 )/2 ; 
            
            %init the volume
            obj.volSPGR1 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            obj.volSPGR2 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            
            imageCounter = 3 ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volSPGR1(:,:,count) = ...
                    double( dicomread( imagelist(imageCounter).name ) );
                imageCounter = imageCounter + 1 ;
            end

            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volSPGR2(:,:,count) = ...
                    double( dicomread( imagelist(imageCounter).name ) );
                imageCounter = imageCounter + 1 ;
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            %display            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSPGR1(:,:,count);
                end

                %display the montage
                figure(obj.figure_handle) ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;snapnow;
                                                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSPGR2(:,:,count);
                end
                
                %display the montage
                figure(obj.figure_handle) ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;snapnow;
                                        
            end %if(doDisplay==1)
            
        end 
        
        %open SSFP sequence data to calculate DESPOT2
        function [ obj ] = fOpenSSFPimages( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.Fiesta_1_suddir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 ) ; 
            
            %init the volume
            obj.volSSFP1 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            obj.volSSFP2 = zeros( obj.xLength, obj.yLength, ...
                obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volSSFP1(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end
            
            %initialize the image volume
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.Fiesta_2_suddir ] ) ;
            !rm .DS_Store
                        
            %get the image list
            imagelist = dir ;

            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength                
                obj.volSSFP2(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            %display            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSSFP1(:,:,count);
                end

                %display the montage
                figure ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;
                snapnow;
                                                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volSSFP2(:,:,count);
                end

                %display the montage
                figure ;
                montage( displayArray, 'DisplayRange', [ ]  ) ;
                drawnow;
                snapnow;
                                        
            end %if(doDisplay==1)
            
        end
        
        %open multi echo SPGR images
        function [ obj ] = fOpenMechoSPGR( obj,  pathObj, doDisplay ) 
             
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.ME_SPGR_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
                        
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            obj.zLength = ( length( imagelist ) - 2 ) / obj.numEchoesSPGR / 4 ; 
            
            %init the volume
            obj.volMESPGR = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.numEchoesSPGR ) ;
            
            chopper = mod(1:obj.zLength,2) ;
            chopper( chopper == 0 ) = -1 ;
            
            %open all the dicoms and put them in the right space
            Counter = 1 ;
            for zCount = 1 : obj.zLength
                for echoCount = 1 : obj.numEchoesSPGR

                    %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
                    Counter = Counter + 1 ;
                    
                    %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
                    Counter = Counter + 1 ;
                    
                    %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
                    theReal = ...
                        chopper(zCount)*double( dicomread( imagelist(Counter+2).name ) ) ; 
                    Counter = Counter + 1 ;
                    
                    %tmpHeaders{Counter} = dicominfo( imagelist( Counter+2 ).name ) ;
                    theImag = ...
                        chopper(zCount)*double( dicomread( imagelist(Counter+2).name ) ) ;    
                    Counter = Counter + 1 ;
                    
                    obj.volMESPGR(:,:,zCount,echoCount) = theReal ...
                        + i * theImag ;
                    
                end
                %Counter = Counter + 4 ;                
            end
            %obj.numTimePts = tmpHeaders;
            
            %go back to the sequence directory
            cd( pathObj.source_code_pathway ) ;
                                 
            %display
            if( doDisplay == 1 )
                
                %loop through all the echos
                for echoCount = 1 : obj.numEchoesSPGR

                    %declare the display array
                    displayArray = zeros( obj.xLength, obj.yLength, ...
                                          1, obj.zLength ) ;

                    %copy 3d Data into montage format for display
                    for count = 1 : obj.zLength
                        displayArray(:,:,1,count) = ...
                            real( obj.volMESPGR( :, :, count, echoCount ) ) ;
                    end

                    %display the montage
                    figure ;
                    montage( displayArray , 'DisplayRange', [ ] ) ;
                    colorbar ;
                    title(['Multi Echo SPGR, Echo = ' int2str(echoCount)]); 
                    drawnow ;
                    snapnow ;
                    
                    %declare the display array
                    displayArray = zeros( obj.xLength, obj.yLength, ...
                                          1, obj.zLength ) ;

                    %copy 3d Data into montage format for display
                    for count = 1 : obj.zLength
                        displayArray(:,:,1,count) = ...
                            imag( obj.volMESPGR( :, :, count, echoCount ) ) ;
                    end

                    %display the montage
                    figure ;
                    montage( displayArray , 'DisplayRange', [ ] ) ;
                    colorbar ;
                    title(['Multi Echo SPGR, Echo = ' int2str(echoCount)]); 
                    drawnow ;
                    snapnow ;
                    
                end
                
            end %if(doDisplay==1)
            
        end
        
        %open dynamic susceptability contrast bolus passage images
        function [ obj ] = fOpenBolusPassageDSC( obj, pathObj, doDisplay ) 
           
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.DSC_Perfusion ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist) - 2 ) / obj.numTimePts ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            obj.dicomHeaderData = dicominfo( imagelist(3).name ) ;
            clear tmpImage ;
            
            obj.volBolusPassage = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.numTimePts ) ;
            
            %open all the dicoms and put them in the right space
            count = 1 ;
            for timeCount = 1 : obj.numTimePts
            for zCount = 1 : obj.zLength
                
                obj.volBolusPassage(:,:,zCount,timeCount) = ...
                    double( dicomread( imagelist(count+2).name ) );
                count = count + 1 ; 
                
            end
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ]) ;
            
            % display
            if( doDisplay == 1 )
                
                sliceLoc = round( obj.zLength / 2 ) ;
                    
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.numTimePts ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.numTimePts
                    displayArray(:,:,1,count) = ...
                        obj.volBolusPassage(:,:,sliceLoc,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'Bolus Passage Time Series of Mid Volume Slice' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
        
        %open dynamic contrast enhanced bolus passage image
        function [ obj ] = fOpenBolusPassageDCE( obj, pathObj, doDisplay )

            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.DCE_Perfusion ] ) ;
            !rm .DS_Store

            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;

            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.DCE_Perfusion ] ) ;

            %get the image list
            imagelist = dir ;

            totalImages = ( length(imagelist) - 2 );
            obj.numTimePts = totalImages / obj.zLength;

            obj.volBolusPassage = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.numTimePts, 'single' ) ;

            %open all the dicoms and put them in the right space
             h = waitbar(0,'Completion', 'Name','Reading Gd images...',...
                'CreateCancelBtn',...
                'setappdata(gcbf,''canceling'',1)');
                setappdata(h,'canceling',0)

            % read in all images into volumes of different phases
            sliceCount = 1;  
            phaseCount = 1; 

            for imageCount = 1 : totalImages

                obj.volBolusPassage( :, :, sliceCount, phaseCount) = ...
                  single( dicomread( imagelist( imageCount + 2 ).name ) ); 

                sliceCount = sliceCount + 1; 

                % reset slice count, increment phase count for every volume
                if sliceCount > obj.zLength
                     sliceCount = 1;
                     phaseCount = phaseCount + 1; 
                end

                waitbar( imageCount/( totalImages ));

            end % end for   
              
            delete( h );
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])

%             % display
%             if( doDisplay == 1 )
%                 
%                 sliceLoc = round( obj.zLength / 2 ) ;
%                     
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.numTimePts, 'single' ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.numTimePts
%                     displayArray(:,:,1,count) = ...
%                         obj.volBolusPassage(:,:,sliceLoc,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 montage( displayArray, 'DisplayRange', [ 0 4000 ] ) ;
%                 colorbar ;
%                 title( 'Bolus Passage Time Series of Mid Volume Slice', 'fontsize', 20 ); 
%                 drawnow;snapnow;
%                 
%             end %if(doDisplay==1)
            
        end
        
        %open 3D Phase contrast data
        function [ obj ] = fOpenPC3D( obj, pathObj, doDisplay ) 
           
            if( obj.UseHR_PC == 1 )
              cd( [pathObj.root_data_pathway pathObj.subject_directories{1} ...
                 pathObj.Phase_Contrast_3D_hr_subdir ] ) ;
            else    
              cd( [pathObj.root_data_pathway pathObj.subject_directories{1} ...
                 pathObj.Phase_Contrast_3D_subdir ] ) ;
            end
            !rm .DS_Store
            
            % determine image volume size
            fileNames = dir ;
            tmpImage = dicomread( fileNames(3).name ) ;
            obj.zLength = ( length(fileNames(:)) - 2 ) / obj.numVolumes ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            obj.dicomHeaderData = dicominfo( fileNames(3).name ) ;
            clear tmpImage ;
            
            % obtain useful header info
            tmpHeader = dicominfo( fileNames(3).name ) ;
            obj.HR_SliceThickness = tmpHeader.SliceThickness ;
            obj.HR_Zposition = [ tmpHeader.Private_0019_1019 tmpHeader.Private_0019_101b ] ;
            obj.HR_XacqRes = tmpHeader.Private_0027_1060 ;
            obj.HR_YacqRes = tmpHeader.Private_0027_1061 ;
            %obj.HR_Yposition = tmpHeader.SliceThickness ;
            %obj.HR_Xposition = tmpHeader.SliceThickness ;
            %add venc readout here
            %add more header data here, considering adding this to other
            % sourceData types as well
            
            obj.dicomHeaderData = dicominfo( fileNames( 4 ).name ) ;
            obj.HR_venc = double( obj.dicomHeaderData.Private_0019_10cc ) ...
                / 10 ; % divid by 10 to get to cm/s
            
            %read in files and mask data
            obj.HR_magVol = single( zeros( obj.xLength, obj.yLength, obj.zLength ) ) ;
            for stackCount = 1 : obj.zLength
               obj.HR_magVol( :, :, stackCount ) = obj.HR_venc / (4*3141) * double( dicomread(fileNames(stackCount+2).name) ) ;  
            end
            imageCount = 1+2+1/obj.numVolumes*(length(fileNames(:))-2) ;
            for stackCount = 1 : obj.zLength
                obj.HR_tissueVol( :, :, stackCount ) = obj.HR_venc / (4*3141) * double( dicomread(fileNames(imageCount).name) ) ;  
                imageCount = imageCount + 1 ;
            end
            obj.HR_mask = single( zeros( size(obj.HR_magVol) ) ) ;
            obj.HR_mask( obj.HR_tissueVol(:) > obj.tissueThreshold * max(obj.HR_tissueVol(:)) ...
                & obj.HR_magVol(:) > obj.velocityThreshold ) = 1 ;
            %mask( :, 1:32, : ) = zeros( size( mask( :,1:32,:) ) ) ;
            %mask( :, 256-32:256, : ) = zeros( size( mask( :,256-32:256,:) ) ) ;
            obj.HR_vectVol = single( zeros( obj.xLength, obj.yLength, obj.zLength, 3 ) ) ;
            
            if( obj.numVolumes == 4 )
                imageCount = 1+2+1/obj.numVolumes*(length(fileNames(:))-2) ;
            elseif( obj.numVolumes == 5 )
                imageCount = 1+2+2/obj.numVolumes*(length(fileNames(:))-2) ;
            else
                disp( 'WARNING: unexpected number of volumes' ) ;
            end
            
            for dimCount = 1 : 3
                for stackCount = 1 : obj.zLength
                    if( dimCount == 3 )
                        obj.HR_vectVol(:,:,stackCount,dimCount) = - obj.HR_venc / (4*3141) * double( dicomread(fileNames(imageCount).name) ) ;
                        imageCount=imageCount+1;
                    else
                        obj.HR_vectVol(:,:,stackCount,dimCount) = obj.HR_venc / (4*3141) * double( dicomread(fileNames(imageCount).name) ) ;
                        imageCount=imageCount+1;
                    end
                    % figure(fig1);imagesc(vol(:,:,stackCount,dimCount));
                end
                obj.HR_vectVol(:,:,:,dimCount) = obj.HR_mask .* obj.HR_vectVol(:,:,:,dimCount) ;
            end      
            obj.HR_magVol = obj.HR_magVol .* obj.HR_mask ; 
            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, 1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = obj.HR_mask(:,:,count) ;
                end

                %display the montage
                figure ;
                montage( displayArray, 'DisplayRange', [  ] ) ;
                colorbar ;
                title( '3D Phase Contrast , Mask Volume ' ) ; 
                drawnow;snapnow;
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, 1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = obj.HR_tissueVol(:,:,count) ;
                end

                %display the montage
                figure ;
                montage( displayArray, 'DisplayRange', [  ] ) ;
                colorbar ;
                title( '3D Phase Contrast , Tissue Volume ' ) ; 
                drawnow;snapnow;


                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, 1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = obj.HR_magVol(:,:,count) ;
                end

                %display the montage
                figure ;
                montage( displayArray, 'DisplayRange', [  ] ) ;
                colorbar ;
                title( '3D Phase Contrast , Mag Volume ' ) ; 
                drawnow;snapnow;
                
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = obj.HR_vectVol(:,:,count,1) ;
%                 end
% 
%                 %display the montage
%                 figure ;
%                 montage( displayArray, 'DisplayRange', [  ] ) ;
%                 colorbar ;
%                 title( '3D Phase Contrast , X Vect Volume ' ) ; 
%                 drawnow;snapnow;
%        
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = obj.HR_vectVol(:,:,count,2) ;
%                 end
% 
%                 %display the montage
%                 figure ;
%                 montage( displayArray, 'DisplayRange', [  ] ) ;
%                 colorbar ;
%                 title( '3D Phase Contrast , Y Vect Volume ' ) ; 
%                 drawnow;snapnow;
%                               
%                 
% 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = obj.HR_vectVol(:,:,count,3) ;
%                 end
% 
%                 %display the montage
%                 figure ;
%                 montage( displayArray, 'DisplayRange', [  ] ) ;
%                 colorbar ;
%                 title( '3D Phase Contrast , Z Vect Volume ' ) ; 
%                 drawnow;snapnow;
                
            end
            
            cd( [ pathObj.source_code_pathway ] ) ;
            
        end
        
        %open 4D Phase contrast data
        function [ obj ] = fOpenPC4D( obj, pathObj, doDisplay ) 
           
            cd( [pathObj.root_data_pathway pathObj.subject_directories{1} ...
                 pathObj.Phase_Contrast_4D_subdir ] ) ;
            !rm .DS_Store
            
            % obtain size of 7D volume
            dirNames = dir ;
            if( obj.top_to_bottom )
                tmpDir = dirNames(3).name ;
            else
                tmpDir = dirNames(end).name ;
            end
            system( ['rm ' tmpDir '/.DS_Store'] ) ;
            tmpImage = dicomread( [ tmpDir '/IM-00' tmpDir(end-1:end) '-0001.dcm' ] ) ;
            obj.LR_Nz = length(dirNames) - 2 ;
            obj.LR_Nx = size( tmpImage, 1 ) ;
            obj.LR_Ny = size( tmpImage, 2 ) ;
            clear tmpImage ;
            
            % extract useful header information
            obj.dicomHeaderData = dicominfo( [ tmpDir '/IM-00' tmpDir(end-1:end) '-0001.dcm' ] ) ;
            obj.LR_venc = double( obj.dicomHeaderData.Private_0019_10cc ) ...
                / 10 ; % divid by 10 to get to cm/s
            obj.LR_SliceThickness = obj.dicomHeaderData.SliceThickness ;
            obj.LR_Zposition = [ obj.dicomHeaderData.Private_0019_1019 obj.dicomHeaderData.Private_0019_101b ] ;
            obj.LR_XacqRes = obj.dicomHeaderData.Private_0027_1060 ;
            obj.LR_YacqRes = obj.dicomHeaderData.Private_0027_1061 ;
            
            obj.LR_magVol = zeros( obj.LR_Nx, obj.LR_Ny, obj.LR_Nz, obj.numTimePts ) ;
            obj.LR_vectVol = zeros( obj.LR_Nx, obj.LR_Ny, obj.LR_Nz, 3, obj.numTimePts ) ;
            tmp = zeros( obj.LR_Nx, obj.LR_Ny, obj.LR_Nz, 3, obj.numTimePts ) ;
            
            for stackCount = 1 : obj.LR_Nz
                
                if( obj.top_to_bottom ) % if one, reverse stack ordering 
                    disp( [ 'reading : ' dirNames(2+stackCount).name ] ) ;
                    cd( dirNames(2+stackCount).name ) ;
                else
                    disp( [ 'reading : ' dirNames(obj.LR_Nz-stackCount+3).name ] ) ;
                    cd( dirNames(obj.LR_Nz-stackCount+3).name ) ;
                end
                
                fileNames = dir ;
                for phaseCount = 1 : obj.numTimePts

                    try
                    obj.LR_magVol( :, :, stackCount, phaseCount ) = ...
                        obj.LR_venc / (4*3141) * double( dicomread( fileNames(phaseCount+2).name ) ) ; 
                    catch err
                        keyboard
                    end
                end
                cd ..
            end
            
            obj.LR_tissueVol = zeros( obj.LR_Nx, obj.LR_Ny, obj.LR_Nz, obj.numTimePts ) ;
            for stackCount = 1 : obj.LR_Nz
                cd( dirNames(2+stackCount).name ) ;
                fileNames = dir ;
                for phaseCount = 1 : obj.numTimePts

                    obj.LR_tissueVol( :, :, stackCount, phaseCount ) = ...
                        obj.LR_venc / (2*3141) * ...
                        double( dicomread( fileNames(phaseCount+2+obj.numTimePts).name ) ) ; 

                end
                cd ..
            end
            mask = zeros( size( obj.LR_magVol(:,:,:,1) ) ) ;
            tmp = obj.LR_tissueVol(:,:,:,2:5) ;
            mask( mean( obj.LR_tissueVol(:,:,:,2:5), 4 ) >= obj.tissueThreshold * max(tmp(:)) & ...
                mean( obj.LR_magVol(:,:,:,2:5), 4 ) >= obj.velocityThreshold ) = 1 ;
            %mask = ones( size( obj.LR_magVol ) ) ;
            
            for stackCount = 1 : obj.LR_Nz
                
                if( obj.top_to_bottom ) % if one, reverse stack ordering 
                    disp( [ 'reading : ' dirNames(2+stackCount).name ] ) ;
                    cd( dirNames(2+stackCount).name ) ;
                else
                    disp( [ 'reading : ' dirNames(obj.LR_Nz-stackCount+3).name ] ) ;
                    cd( dirNames(obj.LR_Nz-stackCount+3).name ) ;
                end
                
                fileNames = dir ;
                imageCount = 1+2+2/5*(length(fileNames(:))-2) ;
                
                for dimCount = 1 : 3
                for phaseCount = 1 : obj.numTimePts
                    
                    if( dimCount == 3 )
                        tmp( :, :, stackCount, dimCount, phaseCount ) = ...
                            - obj.LR_venc / (4*3141) * ...
                            mask( :, :, stackCount ) .* ...
                            double( dicomread( fileNames(imageCount).name ) ) ; 
                    else
                        tmp( :, :, stackCount, dimCount, phaseCount ) = ...
                            obj.LR_venc / (4*3141) * ...
                            mask( :, :, stackCount ) .* ...
                            double( dicomread( fileNames(imageCount).name ) ) ; 
                    end
                    imageCount = imageCount +1 ;
                    
                end
                end
                cd ..
                
            end
            obj.LR_vectVol = tmp ;
            
            if( doDisplay == 1 )
            
%                 %declare the display array
%                 displayArray = zeros( obj.LR_Nx, obj.LR_Ny, 1, obj.LR_Nz ) ;
%                 
%                 for phaseCount = 1 : obj.numCardicPhases
%                 
%                     %copy 3d Data into montage format for display
%                     for count = 1 : obj.LR_Nz
%                         displayArray(:,:,1,count) = ...
%                             squeeze( obj.LR_magVol(:,:,count,phaseCount) ) ;
%                     end
% 
%                     %display the montage
%                     figure ;
%                     montage( displayArray, 'DisplayRange', [  ] ) ;
%                     colorbar ;
%                     title( ['MagVolume, Phase ' int2str(phaseCount) ] ) ; 
%                     drawnow;snapnow;
%                 
%                 end
                
                %declare the display array
                displayArray = zeros( obj.LR_Nx, obj.LR_Ny, 1, obj.LR_Nz ) ;
                
                for phaseCount = 1 : obj.numTimePts
                
                    %copy 3d Data into montage format for display
                    for count = 1 : obj.LR_Nz
                        displayArray(:,:,1,count) = ...
                            squeeze( obj.LR_magVol(:,:,count,phaseCount) ) ;
                    end

                    %display the montage
                    figure ;
                    montage( displayArray, 'DisplayRange', [  ] ) ;
                    colorbar ;
                    title( ['MagVolume, Phase ' int2str(phaseCount) ] ) ; 
                    drawnow;snapnow;
                
                end
            end
            

%             % prep stack
%             volVTK6 = WriteVTKvolume() ;
%             volVTK6.Nx = 256 ; volVTK6.Ny = 256 ; volVTK6.numTimePts = 1 ;
%             cd Data/Phase_Contrast_4 ;
%             fileNames = dir ;
%             volVTK6.Nz = (length(fileNames)-2)/4 ;
%             vol = zeros( volVTK6.Nx, volVTK6.Ny, volVTK6.Nz , 3 ) ;
%             magVol = zeros( volVTK6.Nx, volVTK6.Ny, volVTK6.Nz ) ;
%             for stackCount = 1 : (length(fileNames)-2)/4
%                magVol( :, :, stackCount ) = venc / (2*3141) * double( dicomread(fileNames(stackCount+2).name) ) ;  
%             end
%             mask = zeros( size(magVol) ) ;
%             mask( magVol >= 7 ) = 1 ;
%             mask( :, 1:32, : ) = zeros( size( mask( :,1:32,:) ) ) ;
%             mask( :, 256-32:256, : ) = zeros( size( mask( :,256-32:256,:) ) ) ;
% 
%             %get dicom header info and venc
%             headerData = dicominfo( fileNames(3).name ) ;
% 
%             %fig1=figure;
%             imageCount = 1+2+1/4*(length(fileNames)-2) ;
%             % prep volume
%             for dimCount = 1 : 3
%                 for stackCount = 1 : (length(fileNames)-2)/4
%                     if( dimCount ==3 )
%                         vol(:,:,stackCount,dimCount) = - venc / (2*3141) * double( dicomread(fileNames(imageCount).name) ) ;
%                         imageCount=imageCount+1;
%                     else
%                         vol(:,:,stackCount,dimCount) = venc / (2*3141) * double( dicomread(fileNames(imageCount).name) ) ;
%                         imageCount=imageCount+1;
%                     end
%                     %figure(fig1);imagesc(vol(:,:,stackCount,dimCount));
%                 end
%                 vol(:,:,:,dimCount) = mask .* vol(:,:,:,dimCount) ;
%             end
%             cd ../../
            
            cd( [ pathObj.source_code_pathway ] ) ;

%             % display
%             if( doDisplay == 1 )
%                 
%                 sliceLoc = round( obj.zLength / 2 ) ;
%                     
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.numTimePts ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.numB1images
%                     displayArray(:,:,1,count) = ...
%                         obj.volBolusPassage(:,:,sliceLoc,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'Bolus Passage Time Series of Mid Volume Slice' ); 
%                 drawnow;snapnow;
%                 
%             end %if(doDisplay==1)
            
        end
        
        %open Arterial Spin Labelling Images
        function [ obj ] = fOpenASL( obj, pathObj, doDisplay )
            
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.ASL_RAW_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist) - 2 )/2 ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volASL_RAW = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            obj.volASL_M0 = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength                
                obj.volASL_RAW(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );                
            end

            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength                
                obj.volASL_M0(:,:,count) = ...
                    double( dicomread( imagelist(count+2+obj.zLength).name ) );                
            end

            if( exist( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.ASL_CBF_subdir ] ) ) 
            
            obj.volASL_CBF = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.ASL_CBF_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;            
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volASL_CBF(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
                        
            % display
            if( doDisplay == 1 )
                
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volASL_RAW(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'ASL RAW' ); 
                drawnow;snapnow;

                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;

                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volASL_M0(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'ASL M0' ); 
                drawnow;snapnow;

                if( exist( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                    pathObj.ASL_CBF_subdir ] ) ) 

                    %declare the display array
                    displayArray = zeros( obj.xLength, obj.yLength, ...
                        1, obj.zLength ) ;

                    %copy 3d Data into montage format for display
                    for count = 1 : obj.zLength
                        displayArray(:,:,1,count) = ...
                            obj.volASL_CBF(:,:,count);
                    end

                    %display the montage
                    figure ;
                    temp = abs( displayArray ) ;
                    montage( temp, 'DisplayRange', [ ] ) ;
                    colorbar ;
                    title( 'ASL CBF' ); 
                    drawnow;snapnow;

                end
                
            end %if(doDisplay==1)
            
        end
        
        %open Diffusion Tensor Images
        function [ obj ] = fOpenDTI( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.DTI_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist) - 2 ) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volDTI = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volDTI(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volDTI(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'DTI IMAGES' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
        
        %open Fluid Attenuate Inversion Recovery Images
        function [ obj ] = fOpenFLAIR( obj, pathObj, doDisplay )
            
            %init the volumes
            obj.volFLAIR = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.FLAIR_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist(:)) - 2 ) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volFLAIR(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volFLAIR(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'FLAIR IMAGES' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
        
        %open time of flight images
        function [ obj ] = fOpenTOF( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.TOF_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist(:)) - 2 ) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volTOF = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volTOF(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volTOF(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'TOF IMAGES' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
        
        %open Magnetization Transfer Ratio Images
        function [ obj ] = fOpenMTRimages( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.MTR_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.zLength = ( length(imagelist) - 2 )/2 ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volMTR_pulseOn = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            obj.volMTR_pulseOff = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            imageCounter = 1 +2;
            for count = 1 : obj.zLength
                obj.volMTR_pulseOn(:,:,count) = ...
                    double( dicomread( imagelist(imageCounter).name ) );
                imageCounter = imageCounter + 1 ;
            end
            for count = 1 : obj.zLength
                obj.volMTR_pulseOff(:,:,count) = ...
                    double( dicomread( imagelist(imageCounter).name ) );
                imageCounter = imageCounter + 1 ;
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ]);
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volMTR_pulseOn(:,:,count) ;
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'MTR Pulse On' ) ; 
                drawnow ; snapnow ;
                
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volMTR_pulseOff(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'MTR Pulse Off' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
        
        %open sorted 7T raw data from Siemens magent (yucky, not sure why 
        %                           anyone thought they were better than GE)
        %
        %  Note: requires randall's preprocessing
        %
        function [ obj ] = fOpenSiemensRawData( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.SeimensRaw_subdir ] ) ;
            !rm .DS_Store
            
            %get the folder list
            folderlist = dir ;

            %obj.dicomHeaderData = dicominfo( folderlist( 3 ).name ) ;
            
            tmpImage = dicomread( folderlist(3).name ) ;
            obj.zLength = ( length(folderlist(:)) - 2 ) ; 
            
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volTOF = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            for count = 1 : obj.zLength
                obj.volTOF(:,:,count) = ...
                    double( dicomread( imagelist(count+2).name ) );
            end

            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volTOF(:,:,count);
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'TOF IMAGES' ); 
                drawnow;snapnow;
                
            end %if(doDisplay==1)
            
        end
         
        function [ obj ] = fOpenBOLD( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.QSM_BOLD_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist(3).name ) ;
            
            % note- that zLength must be set
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.numVolumes = ( length(imagelist) - 2 )/(obj.zLength) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            %obj.numVolumes = 50 ; 
            
            tmpHeader = dicominfo( imagelist(3).name ) ;
            obj.TE = tmpHeader.EchoTime ;
            
            %init the volumes
            obj.volBOLD = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            %obj.volBOLDcomplex = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            
            % resort the image name list if the number of images is over 10k
            ImageList = cell( 1, length( imagelist ) ) ;
            ImageRecounter = 1 ;
            if( length( imagelist ) > 10000 )
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 17 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            else
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            end
            
            %open all the dicoms and put them in the right space
            imageCounter = 1 ;
            for volCount = 1 : obj.numVolumes
            for zCount = 1 : obj.zLength
            %for imageTypeCounter = 1 : 3   % magnitude, phase, real & imaginary    
               
%                if( imageTypeCounter == 1 ) 
                    obj.volBOLD(:,:,zCount,volCount) = ...
                        double( dicomread( ImageList{imageCounter+2} ) );
                    
                    imageCounter = imageCounter + 1 ; 
%                end
%                 if( imageTypeCounter == 2 ) 
%                     
%                     imageCounter = imageCounter + 1 ; 
%                 end
%                 if( imageTypeCounter == 3 ) 
%                     obj.volBOLDcomplex(:,:,zCount,volCount) = ...
%                         double( dicomread( ImageList{imageCounter+2} ) ) + ...
%                      i* double( dicomread( ImageList{imageCounter+3} ) ) ; 
%                  
%                     imageCounter = imageCounter + 2 ; 
%                 end
                
            %end
            end
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )

%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_RAW(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL RAW' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_M0(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL M0' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_CBF(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL CBF' ); 
%                 drawnow;snapnow;
                
                
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpenQSM_BOLD( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.QSM_BOLD_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist(3).name ) ;
            
            % note- that zLength must be set
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.numVolumes = ( length(imagelist) - 2 )/(4*obj.zLength) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            %obj.numVolumes = 50 ; 
            
            tmpHeader = dicominfo( imagelist(3).name ) ;
            obj.TE = tmpHeader.EchoTime ;
            
            %init the volumes
            obj.volBOLD = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            obj.volBOLDcomplex = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            
            % resort the image name list if the number of images is over 10k
            ImageList = cell( 1, length( imagelist ) ) ;
            ImageRecounter = 1 ;
            if( length( imagelist ) > 10000 )
                for imageCounter = 1 : obj.numVolumes * obj.zLength * 4
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
                for imageCounter = 1 : obj.numVolumes * obj.zLength * 4
                    if( length( imagelist(imageCounter+2).name ) == 17 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            else
                for imageCounter = 1 : obj.numVolumes * obj.zLength * 4
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            end
            
            %open all the dicoms and put them in the right space
            imageCounter = 1 ;
            for volCount = 1 : obj.numVolumes
            for zCount = 1 : obj.zLength
            for imageTypeCounter = 1 : 3   % magnitude, phase, real & imaginary    
               
                if( imageTypeCounter == 1 ) 
                    obj.volBOLD(:,:,zCount,volCount) = ...
                        double( dicomread( ImageList{imageCounter+2} ) );
                    
                    imageCounter = imageCounter + 1 ; 
                end
                if( imageTypeCounter == 2 ) 
                    
                    imageCounter = imageCounter + 1 ; 
                end
                if( imageTypeCounter == 3 ) 
                    obj.volBOLDcomplex(:,:,zCount,volCount) = ...
                        double( dicomread( ImageList{imageCounter+2} ) ) + ...
                     i* double( dicomread( ImageList{imageCounter+3} ) ) ; 
                 
                    imageCounter = imageCounter + 2 ; 
                end
                
            end
            end
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )

%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_RAW(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL RAW' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_M0(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL M0' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_CBF(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL CBF' ); 
%                 drawnow;snapnow;
                
                
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpen_COLD( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.COLD_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist(3).name ) ;
            
            % note- that zLength must be set
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.numVolumes = ( length(imagelist) - 2 )/(obj.zLength) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.yLength = size( tmpImage, 2 ) ;
            %obj.numVolumes = 50 ; 

%             tmpHeader = dicominfo( imagelist(3).name ) ;
%             obj.TE = tmpHeader.EchoTime ;
            
            %init the volumes
            obj.volCOLD = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            
            % resort the image name list if the number of images is over 10k
            ImageList = cell( 1, length( imagelist ) ) ;
            ImageRecounter = 1 ;
            if( length( imagelist ) > 10000 )
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 17 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            else
                for imageCounter = 1 : obj.numVolumes * obj.zLength
                    if( length( imagelist(imageCounter+2).name ) == 16 )
                        %disp( imagelist(imageCounter+2).name ) ;
                        ImageList{ImageRecounter+2} = imagelist(imageCounter+2).name ; 
                        ImageRecounter = ImageRecounter + 1 ; 
                    end
                end
            end
            
            %open all the dicoms and put them in the right space
            imageCounter = 1 ;
            for volCount = 1 : obj.numVolumes
            for zCount = 1 : obj.zLength
            %for imageTypeCounter = 1 : 3   % magnitude, phase, real & imaginary    
               
                obj.volCOLD(:,:,zCount,volCount) = ...
                    double( dicomread( ImageList{imageCounter+2} ) );

                imageCounter = imageCounter + 1 ; 
                
            %end
            end
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )

%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_RAW(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL RAW' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_M0(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL M0' ); 
%                 drawnow;snapnow;
%                 
%                 
%                 %declare the display array
%                 displayArray = zeros( obj.xLength, obj.yLength, ...
%                     1, obj.zLength ) ;
%                 
%                 %copy 3d Data into montage format for display
%                 for count = 1 : obj.zLength
%                     displayArray(:,:,1,count) = ...
%                         obj.volASL_CBF(:,:,count);
%                 end
% 
%                 %display the montage
%                 figure ;
%                 temp = abs( displayArray ) ;
%                 montage( temp, 'DisplayRange', [ ] ) ;
%                 colorbar ;
%                 title( 'ASL CBF' ); 
%                 drawnow;snapnow;
                
                
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpenT1anat( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.T1anat_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;
            
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.yLength = ( length(imagelist) - 2 ) ; 
            obj.xLength = size( tmpImage, 1 ) ;
            obj.zLength = size( tmpImage, 2 ) ;
            
            %init the volumes
            obj.volT1anat = zeros( obj.xLength, obj.yLength, obj.zLength ) ;
            
            %open all the dicoms and put them in the right space
            imageCounter = 1 +2;
            for count = 1 : obj.yLength
                obj.volT1anat(:,count,:) = ...
                    ( double( dicomread( imagelist(imageCounter).name ) ) );
                imageCounter = imageCounter + 1 ;
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ]);
            
            obj.volT1anat = rotate_3d( obj.volT1anat, 3, 2 ) ; 
            
            % display
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( obj.xLength, obj.yLength, ...
                    1, obj.zLength ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : obj.zLength
                    displayArray(:,:,1,count) = ...
                        obj.volT1anat(:,:,count) ;
                end

                %display the montage
                figure ;
                temp = abs( displayArray ) ;
                montage( temp, 'DisplayRange', [ ] ) ;
                colorbar ;
                title( 'T1 Anatomical Scan' ) ; 
                drawnow ; snapnow ;
                
            end %if(doDisplay==1)
            
        end
        
        % open tiff formated stacks of microscopy data
        function [ obj ] = fOpenMicroscopyStack( obj, pathObj, doDisplay )
           
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.Microscopy_subdir ] ) ;
            !rm .DS_Store
            
            fileList = dir ; 
            
            imageInfo = imfinfo( fileList(3).name ) ;
            obj.volMS_vascular = ...
                uint16( zeros( imageInfo(1).Height, imageInfo(1).Width, length(imageInfo)/2 ) ) ;
            obj.volMS = ...
                uint16( zeros( imageInfo(1).Height, imageInfo(1).Width, length(imageInfo)/2 ) ) ;   
            
            imageCounter = 0 ; 
            for count = 1 : length(imageInfo)/2
                imageCounter = imageCounter + 1 ;
                obj.volMS(:,:,count) = imread( fileList(3).name, 'Index', imageCounter ) ; 
                imageCounter = imageCounter + 1 ;
                obj.volMS_vascular(:,:,count) = imread( fileList(3).name, 'Index', imageCounter ) ; 
            end
            
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ]);
            
            if( doDisplay )
                 FourDviewer( double( obj.volMS ) ) ;
                 FourDviewer( double( obj.volMS_vascular ) ) ;
            end
        end
        
        function [ obj ] = fOpenMontageStack( obj, pathObj, doDisplay ) 
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.montage_subdir ] ) ;
            !rm .DS_Store
            
            %get the image list
            imagelist = dir ;

            obj.dicomHeaderData = dicominfo( imagelist(3).name ) ;
            
            obj.zLength = double( obj.dicomHeaderData.Private_0019_100a ) ;
            
            % note- that zLength must be set
            tmpImage = dicomread( imagelist(3).name ) ;
            obj.numVolumes = length(imagelist) - 2 ; 
            fullWidth = size( tmpImage, 1 ) ;
            fullHeight = size( tmpImage, 2 ) ;
            %obj.numVolumes = 50 ; 
            
            numImageRowsCols = ceil( obj.zLength.^0.5 ) ;
            imageDimensions = ...
                floor( ( fullWidth - numImageRowsCols+1 ) / numImageRowsCols ) ;
            obj.xLength = imageDimensions ;
            obj.yLength = imageDimensions ;
            
%             tmpHeader = dicominfo( imagelist(3).name ) ;
%             obj.TE = tmpHeader.EchoTime ;
            
            %init the volumes
            obj.volMontage = zeros( obj.xLength, obj.yLength, obj.zLength, obj.numVolumes ) ;
            
            for volCount = 1 : obj.numVolumes
                sliceCount = 1 ; 
                newImage = dicomread( imagelist(2+volCount).name ) ; 
            for rowCount = 1 : numImageRowsCols
            for colCount = 1 : numImageRowsCols
            
                if( sliceCount < obj.zLength ) 
                    try
                    obj.volMontage( :,:,sliceCount, volCount ) = ...
                        newImage(rowCount+(rowCount-1)*imageDimensions : ...
                                   rowCount-1+(rowCount)*imageDimensions, ...
                                 colCount+(colCount-1)*imageDimensions : ...
                                   colCount-1+(colCount)*imageDimensions ) ;
                    catch err
                        keyboard
                    end
                end
                sliceCount = sliceCount +1 ;
                
            end
            end
            end
            %go back to the sequence directory
            cd([ pathObj.source_code_pathway ])
            
            % display
            if( doDisplay == 1 )
              
                FourDviewer( obj.volMontage ) ;
                
            end %if(doDisplay==1)
            
        end
        
        function [ obj ] = fOpenQMT( obj, pathObj, doDisplay )
            
            %change to the data directory
            cd( [ pathObj.root_data_pathway pathObj.subject_directories{1} ...
                pathObj.qMT_subdir ] ) ;
            !rm .DS_Store
            !rm .directory
            
            %get the image list
            imagelist = dir ;
            
            obj.qMT_observations = size( obj.qMT_data_table, 1 ) ;
            
            obj.qMT_unqiue_offset_freq = [ ] ; 
            for rowCount = 1 : obj.qMT_observations
                
                valueNotFound = true ; 
                for uniqueValues = 1 : length( obj.qMT_unqiue_offset_freq )
                   if( obj.qMT_unqiue_offset_freq(uniqueValues) ...
                         == obj.qMT_data_table(rowCount,4) ) 
                      valueNotFound = false ; 
                   end
                end
                if( valueNotFound ) 
                  obj.qMT_unqiue_offset_freq = ...
                   [obj.qMT_unqiue_offset_freq obj.qMT_data_table(rowCount,4)];  
                end
            end
            
            obj.qMT_unique_qMTflip = [ ] ; 
            for rowCount = 1 : obj.qMT_observations
                
                valueNotFound = true ; 
                for uniqueValues = 1 : length( obj.qMT_unique_qMTflip )
                   if( obj.qMT_unique_qMTflip(uniqueValues) ...
                         == obj.qMT_data_table(rowCount,3) ) 
                      valueNotFound = false ; 
                   end
                end
                if( valueNotFound ) 
                  obj.qMT_unique_qMTflip = ...
                   [obj.qMT_unique_qMTflip obj.qMT_data_table(rowCount,3)];  
                end
            end
            
            obj.qMT_unique_tr_and_flip_angle_combinations = [ ] ;
            for rowCount = 1 : obj.qMT_observations
                
                valueNotFound = true ; 
                for uniqueValues = 1 : size( obj.qMT_unique_tr_and_flip_angle_combinations, 1 )
                   if( not( isempty( obj.qMT_unique_tr_and_flip_angle_combinations ) ) )
                    if( obj.qMT_unique_tr_and_flip_angle_combinations(uniqueValues,1) ...
                         == obj.qMT_data_table(rowCount,1) && ...
                       obj.qMT_unique_tr_and_flip_angle_combinations(uniqueValues,2) ...
                         == obj.qMT_data_table(rowCount,2) )
                      
                     valueNotFound = false ; 
                    end
                   end
                end
                if( valueNotFound ) 
                  obj.qMT_unique_tr_and_flip_angle_combinations = ...
                   [obj.qMT_unique_tr_and_flip_angle_combinations ; ...
                    obj.qMT_data_table(rowCount,1) obj.qMT_data_table(rowCount,2)];
                end
            end
            
            obj.qMT_num_unique_offset_freq = length( obj.qMT_unqiue_offset_freq ) ; 
            obj.qMT_num_unique_qMTflip = length( obj.qMT_unique_qMTflip ) ;
            obj.qMT_num_unique_tr_and_flip_angle_combinations = ...
                size( obj.qMT_unique_tr_and_flip_angle_combinations, 1 ) ; 
            
            obj.dicomHeaderData = dicominfo( imagelist( 3 ).name ) ;

            tmpImage = dicomread( imagelist( 3 ).name ) ;
            [ obj.xLength, obj.yLength, shouldBeOne ] = size( tmpImage ) ;
            %obj.zLength = length( imagelist ) - 2 ;
            %obj.zLength must be set externally of this method.
            
            obj.qMT_num_vols = ( length( imagelist ) -2 ) ./ obj.zLength ;
            obj.qMT_num_ref_volumes = obj.qMT_num_vols - obj.qMT_observations ; 
            obj.qMT_num_unique_references = obj.qMT_num_ref_volumes ./ ...
                obj.qMT_num_unique_tr_and_flip_angle_combinations ; 
        
            obj.volQMTsource = zeros( obj.xLength, obj.yLength, ...
                obj.zLength, obj.qMT_num_vols ) ;

            %open all the dicoms and put them in the right space
            ImageCounter = 3 ;
            for tCount = 1 : obj.qMT_num_vols
            for zCount = 1 : obj.zLength
                
                obj.volQMTsource( :, :, zCount, tCount ) = ...
                    double( dicomread( imagelist( ImageCounter ).name ) );
                
                ImageCounter = ImageCounter +1 ;
            end
            end
            
            %open all the dicoms and sort into higher dimensional array
            obj.volQMTsourceSorted = zeros( obj.xLength, ...
                obj.yLength, ...
                obj.zLength, ...
                obj.qMT_num_unique_offset_freq, ...
                obj.qMT_num_unique_qMTflip, ...
                obj.qMT_num_unique_tr_and_flip_angle_combinations ) ;
            
            ImageCounter = 3 ; 
            for RF_TR_Count = 1 : obj.qMT_num_unique_tr_and_flip_angle_combinations
            for mtFlipCount = 1 : obj.qMT_num_unique_qMTflip
            for freqCount = 1 : obj.qMT_num_unique_offset_freq
            for zCount = 1 : obj.zLength
                
                try
                obj.volQMTsourceSorted(:,:,zCount,freqCount,mtFlipCount,RF_TR_Count) = ...
                    double( dicomread( imagelist( ImageCounter ).name ) );
                catch err
                    keyboard
                end
                
                ImageCounter = ImageCounter +1 ; 
            end
            end
            end
            end
            
            obj.volQMTreference = zeros(obj.xLength,obj.yLength,obj.zLength, ... 
                obj.qMT_num_ref_volumes ) ;
            obj.volQMTreferenceSorted = zeros(obj.xLength,obj.yLength,obj.zLength, ... 
                obj.qMT_num_unique_references, obj.qMT_num_unique_tr_and_flip_angle_combinations ) ;
            
            startReferenceCounter = ImageCounter ; 
            
            for refCount = 1 : obj.qMT_num_ref_volumes
            for zCount = 1 : obj.zLength
               
                obj.volQMTreference(:,:,zCount,refCount) = ...
                    double( dicomread( imagelist( ImageCounter ).name ) );
                
                ImageCounter = ImageCounter +1 ;
            end
            end
            
            ImageCounter = startReferenceCounter ; 
            
            for trFlipCount = 1 : obj.qMT_num_unique_tr_and_flip_angle_combinations
            for refCount = 1 : obj.qMT_num_unique_references
            for zCount = 1 : obj.zLength
               
                obj.volQMTreferenceSorted(:,:,zCount,refCount,trFlipCount) = ...
                    double( dicomread( imagelist( ImageCounter ).name ) );
                
                ImageCounter = ImageCounter +1 ;
            end
            end
            end
            
            %go back to project root directory
            cd( pathObj.source_code_pathway );
            
            %display            
            if( doDisplay == 1 )
                FourDviewer( obj.volQMTsource ) ;
            end %if(doDisplay==1)
            
        end
        
        
    end
    
    methods (Access = private)
        
    end
    
end
