classdef Mask
    %Mask - Create mask of an Image Volume
    %
    %   Dependancies:
    %       Pathmanager.m
    %       SourceData.m
    %       BrainSegmentation.m
    
    properties (SetAccess = public)
        
        volMask ;
        volBrainMask ;
        volErodedBrainMask ;
        volRegionMask ;
        volDoubleMask ;
        volRegrownMask ;
        sourceDataVol ;
        
        % brain extraction parameters
        Seed                = [ 128 128 64 ] ;
        numAngles           = [180 360]*3 ;
        innerSphereSize     = 80 ;
        RayThreshold        = 1500 ;
        maxRayLength        = 256 ;
        rayResolution       = 0.5 ;
        erosionLevel        = 10 ;
        rayFilterKernel     = zeros(7,7) ;
        
        % region growing parameters
        regionGrowingSeed   = [ 64 64 20 ] ; 
        dMaxDif             = 200 ; 
        
        maskFillingThreshold= 13 ;
        maskClippingThreshold =13 ; 
        
    end
    
    properties (SetAccess = private)
        
    end
    
    methods (Static)
        
    end
    
    methods (Access = public)
        
        function obj = Mask( sourceDataVol, PercentThreshold, doDisplay )
            
            obj.volMask = zeros( size( sourceDataVol ) ) ;
            obj.volMask( sourceDataVol > ...
                max(sourceDataVol(:))*PercentThreshold ) = 1 ;
            obj.sourceDataVol = sourceDataVol ;
            
            obj.rayFilterKernel(4,4) = 1 ;
            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( size( sourceDataVol, 1 ), ...
                                      size( sourceDataVol, 2 ), ...
                                   1, size( sourceDataVol, 3 ) ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : size( sourceDataVol, 3 )
                    displayArray(:,:,1,count) = ...
                        obj.volMask( :, :, count ) ;
                end

                %display the montage
                figure ;
                montage( displayArray , 'DisplayRange', [] ) ;
                colorbar ;
                title( 'Mask' ); 
                
            end
            
            addpath( 'Utilities/' )
            
        end
        
        function obj = doubleMask( obj, MaskLevel, KernelSize, numPasses, ...
                doDisplay )

            % Mask using a gaussian filter
            %   -Blurs the magnitude image before trying to 
            %   strip away the skull
            %---------------------------------------------------------
            %MaskLevel = 0.6;   % Minimum threshold value of the 
                                % magnitude image. Higher values will
                                % strip away more data

            %KernelSize = 95;   % 55 or even higher may be better, 
                                % higher values here mean more 
                                % blurring, which will keep the center
                                % of the brain from being masked

            obj.volDoubleMask = ones( size( obj.sourceDataVol ) ) ;
            
            xFilter = gausswin(KernelSize);
            yFilter = gausswin(KernelSize);
            [X, Y] = meshgrid(xFilter, yFilter);
            FilterKernel = X .* Y;

            for passCount = 1 : numPasses
            
                % Use the first echo for the mask
                for zSlice = 1:size(obj.sourceDataVol,3)

                    tmpMag = obj.volDoubleMask(:,:,zSlice) .* ...
                        obj.sourceDataVol(:,:,zSlice) ;
                    
                    tmpMask = zeros(size(tmpMag));
                    tmpMagFiltered = conv2(tmpMag, FilterKernel, 'same');

                    tmpMask( tmpMagFiltered > MaskLevel * ...
                        max(tmpMagFiltered(:))) = 1;

                    obj.volDoubleMask(:,:,zSlice) = tmpMask .* obj.volMask(:,:,zSlice) ;

                end

            end % for passCount = 1 : numPasses
            
            if( doDisplay == 1 )
                
                %declare the display array
                displayArray = zeros( size( obj.sourceDataVol, 1 ), ...
                                      size( obj.sourceDataVol, 2 ), ...
                                   1, size( obj.sourceDataVol, 3 ) ) ;
                
                %copy 3d Data into montage format for display
                for count = 1 : size( obj.sourceDataVol, 3 )
                    displayArray(:,:,1,count) = ...
                        obj.volDoubleMask( :, :, count ) ;
                end

                %display the montage
                figure ;
                montage( displayArray , 'DisplayRange', [] ) ;
                colorbar ;
                title( 'Double Mask' ); 
                
            end
            
        end
        
        function obj = RegionGrowing( obj, volData, doDisplay )
            
            seed = int16( obj.regionGrowingSeed ) ; 
            maxDiff = double( obj.dMaxDif ) ;
            volData = double( volData ) ;
            lMask = RegionGrowing_mex( volData, seed, maxDiff ) ;
            obj.volRegrownMask = double( lMask ) ;
            
            if( doDisplay == 1 )
                
                FourDviewer( volData, 'vol2' , obj.volRegrownMask ) ; 
                
            end
            
%             obj.volRegionMask = zeros( size( obj.volMask ) ) ;
%             neighbors = [  0  0  1 ; 
%                            0  1  1 ; 
%                            1  0  1 ; 
%                            0 -1  1 ; 
%                           -1  0  1 ; %5 
%                            1  1  1 ; 
%                           -1  1  1 ; 
%                            1 -1  1 ; 
%                           -1 -1  1 ; 
%                            1  0  0 ; %10
%                            0  0  0 ; 
%                           -1  0  0 ; 
%                            1  0  0 ; 
%                           -1  0  0 ; 
%                            1  0  0 ; %15
%                           -1  0  0 ;
%                            0  0 -1 ; 
%                            0  1 -1 ; 
%                            1  0 -1 ; 
%                            0 -1 -1 ; %20
%                           -1  0 -1 ; 
%                            1  1 -1 ; 
%                           -1  1 -1 ; 
%                            1 -1 -1 ; 
%                           -1 -1 -1 ] ; %25
%             
%             new_pixels_found = 1 ;
%             while( new_pixels_found == 1 )
%                 
%                 % check neighbors
%                 new_pixels_found = 0 ;
%                 
%                 % determine the outter pixels to consider
%                 
%                 
%                 % check neighbors
%                 for count = 1 : length( neighbors ) 
%                    
%                     centralPoint( xCurrent, yCurrent, zCurrent ) = ...
%                         1 ;
%                     if( 1 == centralPoint )
%                        
%                     end
%                     
%                 end
%                 
%             end
            
            
        end
        
        function obj = BrainExtraction( obj, seedPt, doDisplay )
           
%             numAlphaPositions   = 18*2 ;
%             numThetaPositions   = 36*2 ;
%             maxRayLength        = 256 ;
%             gradThreshold       = 2500 ;
%             minRayLength        = 20 ;
%             radiusIncrement     = 0.5 ;
            
            alphaPositions = [0:numAlphaPositions/180:180 - numAlphaPositions/180];%*pi ;
            thetaPositions = [0:numThetaPositions/360:360 - numThetaPositions/360];%*pi ;
            
            ray = zeros( numAlphaPositions * numThetaPositions, ...
                maxRayLength / radiusIncrement ) ;
            
            rayCount = 0 ;
            for alphaCount = 1 : numAlphaPositions
            for thetaCount = 1 : numThetaPositions
                
                rayCount = rayCount + 1 ;
                
                for rayPtCount = 1 : maxRayLength / radiusIncrement
                    
                    xPos = round( rayPtCount*radiusIncrement * sin( alphaPositions(alphaCount) ) * ...
                        cos( thetaPositions(thetaCount) ) ) + seedPt(1) ;
                    yPos = round( rayPtCount*radiusIncrement * sin( alphaPositions(alphaCount) ) * ...
                        sin( thetaPositions(thetaCount) ) ) + seedPt(2) ;
                    zPos = round( rayPtCount*radiusIncrement * cos( alphaPositions(alphaCount) ) ) ...
                        + seedPt(3) ;
                    
                    if( xPos > 0 && xPos < size( obj.sourceDataVol, 1 ) ...
                     && yPos > 0 && yPos < size( obj.sourceDataVol, 2 ) ...
                     && zPos > 0 && zPos < size( obj.sourceDataVol, 3 ) )
                  
                        ray(rayCount,rayPtCount) = ...
                            obj.sourceDataVol( xPos, yPos, zPos ) ;
                    
                    end
                    
                end
            end
            end
            
            figure; imagesc( ray ) ; title( 'ray' ) ;
            
            gradient = [zeros(1, numAlphaPositions*numThetaPositions)' ray] ...
                     - [ray zeros(1, numAlphaPositions*numThetaPositions)'] ;
                   
            figure; imagesc( gradient ) ; title( 'gradient' ) ;
            
            brainMask = zeros(size(obj.sourceDataVol)) ;
            brainContour = zeros(size(obj.sourceDataVol)) ;
            
            pointCheckVol = obj.sourceDataVol ;
            rayLengthMatrix = zeros( size( ray ) ) ;
            rayLengthMatrix( :, 1:25 ) = 1 ;
            
            rayCount = 0 ;
            numPtsIdentified = 0 ;
            for alphaCount = 1 : numAlphaPositions
            for thetaCount = 1 : numThetaPositions
                 
                rayCount = rayCount + 1 ;
                
                ptFound = 0 ;
                for count = minRayLength : maxRayLength
                    if( gradient(rayCount,count) > gradThreshold && ptFound == 0 )
                        ptFound = 1 ;
                        rayLength = count ;
                        rayLengthMatrix( rayCount,count ) = 1 ;
                    end
                end
                
                if( ptFound == 1 )
                
                    for count = minRayLength : rayLength / radiusIncrement

                        xPos = round( count * radiusIncrement * sin( alphaPositions(alphaCount) ) * ...
                            cos( thetaPositions(thetaCount) ) ) + seedPt(1) ;
                        yPos = round( count * radiusIncrement * sin( alphaPositions(alphaCount) ) * ...
                            sin( thetaPositions(thetaCount) ) ) + seedPt(2) ;
                        zPos = round( count * radiusIncrement * cos( alphaPositions(alphaCount) ) ) ...
                            + seedPt(3) ;
                    
                        if( xPos > 0 && xPos < size( obj.sourceDataVol, 1 ) ...
                         && yPos > 0 && yPos < size( obj.sourceDataVol, 2 ) ...
                         && zPos > 0 && zPos < size( obj.sourceDataVol, 3 ) )

                            numPtsIdentified = numPtsIdentified + 1 ;
                            brainMask(xPos,yPos,zPos) = 1 ;
                            brainContour(xPos,yPos,zPos) = max( obj.sourceDataVol(:) * 3 ) ;
                            
                        end
                        
                    end
                    
                end
                
            
            end
            end
            
            figure ; imagesc( rayLengthMatrix ) ; title( 'rayLengthCount' ) ;
            
            tmp = obj.sourceDataVol ;
            tmp( brainMask == 1 ) = max( obj.sourceDataVol(:) * 2 ) ;
            displayMontage( tmp, [] ) ;
            title( 'Brain Mask on Brain' ) ;
            
            tmp = obj.sourceDataVol ;
            tmp( brainContour == 1 ) = max( obj.sourceDataVol(:) * 2 ) ;
            displayMontage( tmp, [] ) ;
            title( 'Brain Contour on Brain' ) ;
            
            numPtsIdentified
            sum(pointCheckVol(:))
            
        end
        
        function obj = BrainExtractorMEX( obj, doDisplay )
        
            Dimensions = [ size(obj.sourceDataVol,1) 
                           size(obj.sourceDataVol,2) 
                           size(obj.sourceDataVol,3) ] ;

            imageVol = obj.sourceDataVol ;
            
            ipSeed                = obj.Seed ;
            ipnumAngles           = obj.numAngles ;
            ipinnerSphereSize     = obj.innerSphereSize ;
            tmp                   = imageVol .* obj.volMask ;
            ipgradientThreshold   = obj.RayThreshold * sum( tmp(:) )/sum( obj.volMask(:) );
            ipmaxRayLength        = obj.maxRayLength ;
            iprayResolution       = obj.rayResolution ;
            iperosionLevel        = obj.erosionLevel ;
            ipRayFilterKernel     = obj.rayFilterKernel ;
            
            [ SeedMask, InnerSphereContour, BrainContour, BrainMask, ErodedBrainMask ] = ...
                BrainExtractor( imageVol, ...
                ipSeed, Dimensions, ipnumAngles, ipinnerSphereSize,...
                ipgradientThreshold, ipRayFilterKernel, ipmaxRayLength, ...
                iprayResolution, iperosionLevel ) ; 
                  
            obj.volRegionMask = InnerSphereContour ;
            obj.volBrainMask = BrainMask .* obj.volMask ;
            obj.volErodedBrainMask = ErodedBrainMask .* obj.volMask ;
            
            if( doDisplay == 1 )
                
                tmp = obj.sourceDataVol ;
                tmp( SeedMask == 1 ) = max(tmp(:)) ;
                displayMontage( tmp, [] ) ;
                title( 'Seed Mask on Brain' ) ;
                
                tmp = obj.sourceDataVol ;
                tmp( InnerSphereContour == 1 ) = max(tmp(:)) ;
                displayMontage( tmp, [] ) ;
                title( 'Inner Sphere Contour on Brain' ) ;
                
                tmp = obj.sourceDataVol ;
                tmp( BrainContour == 1 ) = max(tmp(:)) ;
                displayMontage( tmp, [] ) ;
                title( 'Brain Contour on Brain' ) ;
                
                tmp = obj.sourceDataVol ;
                tmp( BrainMask == 1 ) = max(tmp(:)) ;
                displayMontage( tmp, [] ) ;
                title( 'Brain Mask on Brain' ) ;
                
                tmp = obj.sourceDataVol ;
                tmp( obj.volBrainMask == 1 ) = max(tmp(:)) ;
                displayMontage( tmp, [] ) ;
                title( 'Brain Mask Final on Brain' ) ;
                
                tmp = obj.sourceDataVol ;
                tmp( obj.volBrainMask == 1 ) = max(tmp(:)) ;
                displayMontageSag( tmp, [] ) ;
                title( 'Brain Mask Final on Brain' ) ;
                
            end
            
        end
        
        function obj = ClipErrorsInMask( obj, doDisplay ) 
        
            originalMask = obj.volBrainMask ;
            threshold = obj.maskClippingThreshold ;
            obj.volBrainMask = MaskClipping( originalMask, ...
                threshold ) ;
            
            if( doDisplay )
            
                displayMontage( originalMask, [] ) ;
                title( 'Original Mask' ) ;
                
                displayMontage( obj.volBrainMask, [] ) ;
                title( 'Filled Mask' ) ; 
                
            end
            
        end
       
        function obj = FillErrorsInMask( obj, doDisplay ) 
        
            originalMask = obj.volBrainMask ;
            threshold = obj.maskFillingThreshold ;
            obj.volBrainMask = MaskFilling( originalMask, ...
                threshold ) ;
            
            if( doDisplay )
            
                displayMontage( originalMask, [] ) ;
                title( 'Original Mask' ) ;
                
                displayMontage( obj.volBrainMask, [] ) ;
                title( 'Filled Mask' ) ; 
                
            end
            
        end
       
        function obj = RegisterBrainVolume( obj, display ) 
           
            obj = RegisterVolumes( obj, sourceVol, TargetVol, doDisplay ) ;
            
        end
        
        function obj = DisplayBrainMask( obj )
            
            tmp = obj.sourceDataVol ;
            tmp( obj.volBrainMask == 1 ) = max(tmp(:)) ;
            displayMontage( tmp, [] ) ;
            title( 'Brain Mask Final on Brain' ) ;

            displayMontageSag( tmp, [] ) ;
            
            displayMontageCor( tmp, [] ) ;
            
        end
        
    end
    
    methods (Access = private)
        
    end
    
end

% Helper Functions