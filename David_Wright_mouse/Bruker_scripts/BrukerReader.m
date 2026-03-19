%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%         Reads Bruker MRI fid data into Matlab          %
%                                                        %
%                    David Wright                        %
%                                                        %
%        Input is a directory containing fid             %
%        acqp and method files                           %
%                                                        %
%        use: [Result, param]=loadBruker('/data/');      %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [image, param]=BrukerReader(datapath)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                      load ACQ                          %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

acqpfile=fopen([datapath,'/acqp']);
acqp=fread(acqpfile,'*char')';
fclose(acqpfile);
clear acqpfile;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                   Get Version                          %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seq1=strfind(acqp,'##$ACQ_sw_version=(');
seq2=seq1+29;
tt=acqp(seq2);
while (tt~='.')
   seq2=seq2+1;
   tt=acqp(seq2);
end
param.version=str2num(acqp(seq1+29:seq2-1));
seq1=seq2+1;
tt=acqp(seq2+1);
while (tt~='>')
   seq2=seq2+1;
   tt=acqp(seq2);
end
param.versionII=str2num(acqp(seq1:seq2-1));

if(isempty(seq1)==1)
    param.version=6;
    param.versionII=0;
end
clear tt seq1 seq2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                   Get Sequence                         %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seq1=strfind(acqp,'##$PULPROG=(');
seq2=seq1+12;
tt=acqp(seq2);
while (tt~='<')
   seq2=seq2+1;
   tt=acqp(seq2);
end
seq1=seq2+1;
tt=acqp(seq2);
while (tt~='>')
   seq2=seq2+1;
   tt=acqp(seq2);
end
param.sequence=convertCharsToStrings(acqp(seq1:seq2-5));
clear tt seq1 seq2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        %
%                   Get Dimensions                       %
%                                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tt=strfind(acqp,'##$ACQ_dim=');
param.dimensions=str2num(acqp(tt+11));
clear tt;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                    Open fid file                       %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if param.version==5
    if param.dimensions==2 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FLASH'
        [image, param]=Bruker_MGE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_CEST'
        [image, param]=Bruker_dwSegGre_CEST(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_MTR'
        [image, param]=Bruker_dwSegGre_MTR(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_3D_pv5(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_3D(datapath,acqp);
    elseif param.dimensions==1 && param.sequence=='PRESS'
        [image, param]=Bruker_PRESS(datapath,acqp);    
    elseif param.dimensions==3 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_3D_pv6(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_2D_pv6(datapath,acqp);
    end

elseif param.version==6
    if param.dimensions==2 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FLASH'
        [image, param]=Bruker_MGE_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_CEST'
        [image, param]=Bruker_dwSegGre_CEST(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_MTR'
        [image, param]=Bruker_dwSegGre_MTR(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_3D(datapath,acqp);
    elseif param.dimensions==1 && param.sequence=='PRESS'
        [image, param]=Bruker_PRESS(datapath,acqp);    
    elseif param.dimensions==3 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_3D_pv6(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_2D_pv6(datapath,acqp);
    end
elseif param.version==360 && param.versionII==3.1

    if param.dimensions==2 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FAIR_RARE'
        [image, param]=Bruker_FAIR_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwrightFAIR_RARE'
        [image, param]=Bruker_dwrightFAIR_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiStandard'
        [image, param]=Bruker_DtiStandard_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_CEST'
        [image, param]=Bruker_dwSegGre_CEST(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_MTR'
        [image, param]=Bruker_dwSegGre_MTR(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_2D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_3D(datapath,acqp);
    elseif param.dimensions==1 && param.sequence=='PRESS'
        [image, param]=Bruker_PRESS(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_3D_pv360(datapath,acqp);
    end
elseif param.version==360 && param.versionII==3.5
    if param.dimensions==2 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FAIR_RARE'
        [image, param]=Bruker_FAIR_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwrightFAIR_RARE'
        [image, param]=Bruker_dwrightFAIR_RARE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_2D_pv360(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiStandard'
        [image, param]=Bruker_DtiStandard_2D(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_2D_pv360_5(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_CEST'
        [image, param]=Bruker_dwSegGre_CEST(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='dwSegGre_MTR'
        [image, param]=Bruker_dwSegGre_MTR(datapath,acqp);
    elseif param.dimensions==2 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_2D_pv360_5(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RARE'
        [image, param]=Bruker_RARE_3D(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='MGE'
        [image, param]=Bruker_MGE_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='FLASH'
        [image, param]=Bruker_FLASH_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='RAREVTR'
        [image, param]=Bruker_RAREVTR_3D(datapath,acqp);
    elseif param.dimensions==1 && param.sequence=='PRESS'
        [image, param]=Bruker_PRESS(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='SegFLASH'
        [image, param]=Bruker_segFLASH_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='DtiEpi'
        [image, param]=Bruker_DWI_3D_pv360(datapath,acqp);
    elseif param.dimensions==3 && param.sequence=='EPI'
        [image, param]=Bruker_EPI_3D_pv360(datapath,acqp);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                        % 
%                     Clean up                           %
%                                                        %    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
clear datapath    
    
end


