function [data] = load_sliceV3(twix_obj,ARG,PRG,mode)

    %----------------------------------------------------------------------
    %% load kdata or iData
    %----------------------------------------------------------------------
    
    if(strcmp(mode,'kData'))
        
        twix_obj.image.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.image.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.image.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.image.flagSkipToFirstLine = 0; % set 0 to get zero lines for pf
        
        if PRG.DEBUG
            data = twix_obj.image(:,:,:,:,ARG.sl,:,:,:,1:2,:,:,:,:,:,:,:);    
        else
            data = twix_obj.image(:,:,:,:,ARG.sl,:,:,:,:,:,:,:,:,:,:,:);    
        end
    elseif (strcmp(mode,'iData'))

        twix_obj.refscan.flagRampSampRegrid  = 0; % does not work properly anyway
        twix_obj.refscan.flagRemoveOS        = 0; % set 1 to remove readout oversampling
        twix_obj.refscan.flagIgnoreSeg       = 0; % set 0 to seperate data into segments
%         twix_obj.refscan.flagSkipToFirstLine = 1; % set 0 to get zero lines for pf
        
        data = twix_obj.refscan(:,:,:,:,ARG.sl,:,:,:,:,:,:,:,:,:,:,:);
    else
        disp("[ERROR]: unknown data type");
        return;        
    end

    data = squeeze(single(data));
    


    %--------------------------------------------------------------------------
    %% Apply full PC to data
    %--------------------------------------------------------------------------
    data = pc_aply_const(data, ARG.pc_const_shift);
    data = nft_nft_1D(data, ARG.pc_linea_shift, ARG.trj, false);
        
    if(strcmp(mode,'kData'))
        data = data(:,:,:,:,1)+data(:,:,:,:,2);
        data = permute(data, [1,3,2,4,5]);
    else
        data = data(:,:,:,1) + data(:,:,:,2);
        data = permute(data, [1,3,2,4]); 
    end
    
end