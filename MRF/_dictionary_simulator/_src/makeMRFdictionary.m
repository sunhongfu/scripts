function dict=makeMRFdictionary(RFpulses ,TR ,T1, T2, df)
% This function calculates the MRF signal evolution for an IR-bSSFP-based readout % for a single material (T1, T2, df) for the input RF pulse train and TR.
% This code is based on the single isochromat method popularized by Klaus
% Scheffler. This works for bSSFP as long as one can assume that both the
% flip angle and off-resonance frequency are essentially homogeneous inside % a voxel.
%
% %
% %
% % %
%
%
%
% if nargin<5
% end df=0;
% if nargin<4
% end T2=50;
% if nargin<3
% end T1=1000;
% if nargin<2
% end TR=rand(1,1000)*4+10;
% if nargin<1
% end RFpulses=10*pi./180*randn(1,1000);

N   = length(TR);
rf  = abs(RFpulses);
rph = angle(RFpulses);

dict= zeros(1,N);

 m1=[0 0 -1].';    % This assumes a perfect inversion pulse with no delay
 
 
 
 for ii=1:N
    rx=    [   1.0 0.0 0.0;        %rotation matrix for pulse
               0.0 cos(rf(ii)) sin(rf(ii));
               0.0 -sin(rf(ii)) cos(rf(ii))];
           
    rdzp=  [   cos(rph(ii)) sin(rph(ii)) 0.0; %RF phase
               -sin(rph(ii)) cos(rph(ii)) 0.0;
               0.0 0.0 1.0];
           
    rdzm=  [   cos(-rph(ii)) sin(-rph(ii)) 0.0;
               -sin(-rph(ii)) cos(-rph(ii)) 0.0;
            0.0 0.0 1.0];
        
    e1=exp(-TR(ii)./T1);        % relaxation terms
    e2=exp(-TR(ii)./T2);
    beta=df.*TR(ii)*2*pi;
    
rbeta= [ cos(beta./2) sin(beta./2) 0.0; % 1/2 off-resonance rotation
         -sin(beta./2) cos(beta./2) 0.0;
         0.0 0.0 1.0];
     
e12= [ e2 0.0 0.0;
       0.0 e2 0.0;
       0.0 0.0 e1];

    m1=rdzp*rx*rdzm*m1;    % do RF pulse
    m1=(e12*m1+(1-e1)*[0 0 1].');  %relax
    m1=rbeta*m1;   % Off-resonance for first 1/2 of TR
    dict(ii) = m1(1)+1j.*m1(2);  %Sample assuming TE=TR/2
    dict(ii) = dict(ii).*exp(1i*rph(ii));
    m1=rbeta*m1;  % Off-resonance for 2nd 1/2 of TR
 end
 