function [xDataPC] = load_cal_data(twix_obj,slice_range,type)


    if(strcmp(type , 'kData'))
    %----------------------------------------------------------------------
    %phase correction for image data
    %----------------------------------------------------------------------
        twix_obj.phasecor.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.phasecor.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.phasecor.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.phasecor.flagSkipToFirstLine = 1; % set 0 to get zero lines for pf
        
        xDataPC = twix_obj.phasecor(:,:,:,:,slice_range,:,:,:,:,:,:,:,:,:,:,:);
        xDataPC = squeeze(xDataPC(:,:,end,:,:,:,:,:,:,:));      
    elseif (strcmp(type , 'iData')) 
    %----------------------------------------------------------------------
    %phase correction for auto calibration lines
    %----------------------------------------------------------------------
        twix_obj.refscanPC.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.refscanPC.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.refscanPC.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.refscanPC.flagSkipToFirstLine = 1; % set 0 to get zero lines for pf
        
        xDataPC=twix_obj.refscanPC(:,:,:,:,slice_range,:,:,:,:,:,:,:,:,:,:,:);        
        xDataPC = squeeze(single(xDataPC));
    else
    %----------------------------------------------------------------------
    %???????????????????????
    %----------------------------------------------------------------------
    disp('[WARNING]: Unknown calibration data type.')
        xDataPC = 0;
    end
    
end