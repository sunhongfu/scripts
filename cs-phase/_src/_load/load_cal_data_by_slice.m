function [kDataPC, iDataPC] = load_cal_data_by_slice(twix_obj, iSl)

%     disp(['getting sl:' num2str(iSlIndex)]);
    %----------------------------------------------------------------------
    %phase correction for image data
    %----------------------------------------------------------------------
    if(isfield(twix_obj,'phasecor'))
        kDaSl = unique(twix_obj.phasecor.Sli, 'stable');
        iSlId = kDaSl(iSl);      
        
        kDataPC = twix_obj.phasecor(:,:,:,:,iSlId,:,:,:,:,:,:,:,:,:,:,:);
        kDataPC = squeeze(single(kDataPC));
        kDataPC = squeeze(kDataPC(:,:,end,:,:,:,:,:,:,:));
    else
        kDataPC = 0;
    end
    
    %----------------------------------------------------------------------
    %phase correction for auto calibration lines
    %----------------------------------------------------------------------    
    if(isfield(twix_obj,'refscanPC'))
        kDaSl = unique(twix_obj.refscanPC.Sli, 'stable');
        iSlId = kDaSl(iSl);         
        
        iDataPC=twix_obj.refscanPC(:,:,:,:,iSlId,:,:,:,:,:,:,:,:,:,:,:);        
        iDataPC = squeeze(single(iDataPC));       
    else
        iDataPC = 0;
    end
    
    
    
end