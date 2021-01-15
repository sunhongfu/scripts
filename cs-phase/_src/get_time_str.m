function [tStr] = get_time_str()

t   = fix(clock); 
tStr= [num2str(t(1, 4)) ':' num2str(t(1, 5)) ' '];
    
end