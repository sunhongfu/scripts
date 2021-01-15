function [trj] = load_trj(myfid, nRe)


fileID = fopen(myfid);
bytes = fread(fileID,1000000,'char');% 'ubit8');
fclose(fileID);

fileID = fopen('header.txt','w');
fwrite(fileID,bytes,'char');% 'ubit8');
fclose(fileID);

trj.bRampSample = true;


% - find readout rampup time
header = native2unicode(bytes);
header = convertCharsToStrings(header);

try
substr = extractAfter(header, '<ParamLong."RampupTime">');
st = strfind(substr,'{');
en = strfind(substr,'}');
substr = extractBetween(substr,st(1)+1, en(1)-1);
trj.up = str2num(substr);
catch
    trj.up = 0;
    trj.bRampSample = false;
end


try
substr = extractAfter(header, '<ParamLong."RampdownTime">');
st = strfind(substr,'{');
en = strfind(substr,'}');
substr = extractBetween(substr,st(1)+1, en(1)-1);
trj.dn = str2num(substr);
catch
    trj.dn = 0;
    trj.bRampSample = false;    
end

try
substr = extractAfter(header, '<ParamLong."FlattopTime">');
st = strfind(substr,'{');
en = strfind(substr,'}');
substr = extractBetween(substr,st(1)+1, en(1)-1);
trj.fl = str2num(substr);
catch
    trj.fl = 0;
    trj.bRampSample = false;    
end

try
substr = extractAfter(header, '<ParamLong."DelaySamplesTime">');
st = strfind(substr,'{');
en = strfind(substr,'}');
substr = extractBetween(substr,st(1)+1, en(1)-1);
trj.dl = str2num(substr);
catch
    trj.dl = 0;
    trj.bRampSample = false;    
end

try
substr = extractAfter(header, '<ParamDouble."ADCDuration">');
st = strfind(substr,'>');
en = strfind(substr,'}');
substr = extractBetween(substr,st(1)+4, en(1)-1);
trj.adc = str2num(substr);
catch
    trj.adc = 0;
    trj.bRampSample = false;      
end



% just to show what this means:
    
    %
    dx = 1/nRe;
    dt = trj.adc/nRe;
    %
    
    % number of effected points on up ramp
    nUp = ceil((trj.up - trj.dl)/dt);
    
    
    % number of effected points on down ramp
    nDo = ceil((trj.adc + trj.dl - (trj.up+trj.fl))/dt);

if (trj.bRampSample == false)
    disp('[INFO]: up/down ramps have 0/0 samples.');
    
    x = (0:(nRe-1))/(nRe-1);
    x = x-0.5;
    w = x*0+1;
    
    trj.x = x;
    trj.w = w;    
    
else        
    disp(['[INFO]: up/down ramps have ' num2str(nUp) '/'  num2str(nDo) ' samples.']);

    
% make actual trajactory

    dt = trj.adc/nRe;
   
    step_size = 0.1; %0.1 microseconds
    one_over_step_size = 1.0/step_size;
    trj.dl = trj.dl*one_over_step_size;
    trj.up = trj.up*one_over_step_size;
    trj.dn = trj.dn*one_over_step_size;
    trj.fl = trj.fl*one_over_step_size;
    
    %design gradient
    G = [0:(trj.up-1), (0:(trj.fl-1))*0+trj.up, (trj.dn-1):-1:0 ];

    x0 = G*0;
    
    %make kx (entire gradient)
    for iI = 2:length(G)
        x0(iI) = G(iI) +x0(iI-1);
    end
    
    %extract part sampled
    st = (trj.dl) + 1;
    en = length(x0) - (trj.dl);
    x0 = x0(st:en);
    w0 = G(st:en);
    
    %normalize
    x0 = x0 - min(x0);
    x0 = x0 / max(x0);
    x0 = x0 - 0.5;
    w0 = w0 /max(w0);
    
    %extract closest point
    x = (1:nRe)*0;
    w = x;
    for iI=1:nRe
        x(iI) = x0(round(one_over_step_size*(dt*iI - dt/2.0)));
        w(iI) = w0(round(one_over_step_size*(dt*iI - dt/2.0)));
    end
    
    trj.x = x;
    trj.w = w;
end
    
end