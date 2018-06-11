function [ PHASE_OUT ] = rescalePhaseImage( PHASE_IN, invert )
% rescale phase image outputed by scanner (ranging from [-4096:4095]
% to the [-PI:PI] range
%
% PHASE_IN: phase image with value ranging from [-4096:4095]
% invert: Invert sign (i.e. to convert from left-handed system to
%         right-handed system (default = 1)

full_dig_range  = 8188;
half_range = 4096;

if (~exist('invert', 'var'))
    invert = 1;
end
if (invert ~= 0)
    PHASE_IN = -PHASE_IN;
end
if range(PHASE_IN(:)) == full_dig_range;
    
    PHASE_OUT = (PHASE_IN / half_range) * pi;
    
else
    
    PHASE_OUT = PHASE_IN;
    
end



end

