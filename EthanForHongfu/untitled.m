

%% open multi echo SPGR images

clear all ; close all hidden ;
doDisplay = 0 ;

o = PathManager( 'WORK' ) ;
o.subject_directories = { '2016_07_27_Physio_03011' } ;
o.ME_SPGR_subdir =  '/QSM__NORMOXIA_9' ; 

objSourceData = SourceData(0) ;
objSourceData.numEchoesSPGR = 8 ; 

[ objSourceData ] = fOpenMechoSPGR( objSourceData, o, doDisplay ) ;
  
%% 

PercentThreshold = 0.1 ;
objMask = Mask( abs( objSourceData.volMESPGR(:,:,:,1) ), ...
    PercentThreshold, 0 ) ;

objMask.volBrainMask = objMask.volMask ; 
objMask.maskFillingThreshold = 12 ; 
objMask = FillErrorsInMask( objMask, 0 ) ;
