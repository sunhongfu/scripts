function [pc_const_shift, pc_linea_shift] = get_phase_calibration(kDataPC, ARG)

%--------------------------------------------------------------------------
%% find const phase calibration
%--------------------------------------------------------------------------
if(ARG.trj.bRampSample == true)
    if  strcmp(ARG.ACS , 'FLEET')
        pc_const_shift = 0;
    else
        pc_const_shift = pc_find_const(kDataPC);
    end
else
    disp('[WARNING]: 0 const phase assumed!')
    ARG.pc_const_shift = 0;
end

%--------------------------------------------------------------------------
%% apply const phase calibration
%--------------------------------------------------------------------------
kDataPC = pc_aply_const(kDataPC, pc_const_shift);

%--------------------------------------------------------------------------
%% find k-space shift
%--------------------------------------------------------------------------
pc_linea_shift = nft_get_shift(kDataPC,ARG.trj);
end