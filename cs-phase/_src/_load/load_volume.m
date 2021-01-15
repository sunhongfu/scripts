function [data] = load_volume(twix_obj,iEcho, mode)

    %----------------------------------------------------------------------
    %% load kdata or iData
    %----------------------------------------------------------------------
    
    if(strcmp(mode,'kData'))
        
        twix_obj.image.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.image.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.image.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.image.flagSkipToFirstLine = 0; % set 0 to get zero lines for pf
%         data = twix_obj.image(:,:,:,:,ARG.sl,:,:,:,:,:,:,:,:,:,:,:);
        data = twix_obj.image(:,:,:,:, : ,:,:,iEcho,:,:,:,:,:,:,:,:);
        
    elseif (strcmp(mode,'iData'))

        twix_obj.refscan.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.refscan.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.refscan.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.refscan.flagSkipToFirstLine = 1; % set 0 to get zero lines for pf
        
%         data = twix_obj.refscan(:,:,:,:,ARG.sl,:,:,:,:,:,:,:,:,:,:,:);
        data = twix_obj.refscan(:,:,:,:, : ,:,:,iEcho,:,:,:,:,:,:,:,:);
    else
        disp("[ERROR]: unknown data type");
        return;        
    end

    data = squeeze(single(data));
        
end