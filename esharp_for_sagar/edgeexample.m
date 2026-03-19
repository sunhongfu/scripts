
    %% Processing... (1) Determine SMV
    
    sharpOptions.radii              = [ 6 6 3 ] ;
    sharpOptions.thresholdParameter = 0.000001 ;
    
    gridDimensionVector = size( totalField ) ;
    midPoint            = ( gridDimensionVector + [1 1 1] ) / 2 ;
    midPoint            = sub2ind( gridDimensionVector, midPoint(1), midPoint(2), midPoint(3) ) ;
    
    reducedROI          = shaver( mask, sharpOptions.radii ) ;
    sphere                  = createellipsoid( gridDimensionVector, sharpOptions.radii) ;
    numAveragingPoints      = sum( sphere(:) ) ;
    
    sharpFilter             = - sphere / numAveragingPoints ;
    sharpFilter( midPoint ) = sharpFilter( midPoint ) + 1 ;
    
    
    %% (2) SHARP
    
    FFTSharpFilter = fftc( sharpFilter ) ;
    
    % Deconv.
    tmp            = fftc( reducedROI .* ifftc( fftc( sharpFilter ) .* fftc( totalField ) ) ) ./ FFTSharpFilter ;
    
    % Regularization
    tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
    tmp( tmpReg )  = 0 ;
    
    localPhaseNoSVD       = reducedROI .* real( ifftc( tmp ) );
    backgroundPhaseNoSVD  = reducedROI .* (totalField - localPhaseNoSVD) ;
    
    
    %% (3) TAYLOR
    taylorOptions.name                = strcat(dataSaveFldr, 'inVivo') ;
    taylorOptions.isSavingInterimVar  = 'true' ;
    taylorOptions.voxelSize           = [1 1 2] ;
    taylorOptions.expansionOrder      = 2 ;
    taylorOptions.numIterations       = 1 ;
    
    EdgeOut  = sharpedges( backgroundPhaseNoSVD, mask, reducedROI, taylorOptions) ;
    
    %% (4) TSVD
    
    extendedBackgroundPhase = mask .* ( EdgeOut.reducedBackgroundField + EdgeOut.extendedBackgroundField(:,:,:,3) ) ;
    tmpLocal       = mask .* ( totalField - extendedBackgroundPhase ) ;
    fTmpLocal      = fftc( tmpLocal ) ;
    
    % Regularization
    sharpOptions.thresholdParameter = 0.05 ;
    tmpReg         = FFTSharpFilter < sharpOptions.thresholdParameter ;
    
    fTmpLocal( tmpReg )  = 0 ;
    
    localPhaseEsharp = mask .* ifftc( fTmpLocal) ;
    
