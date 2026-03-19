function in_plane_correction(mag_fname, mask_fname, Gx_fname, Gy_fname, corr_flag)

% *************************************************************************
% function 
%
% DESCRIPTION: Function to correct for the effects of in-plane field
%              field inhomogeneities in MGRE data. 
%              (Baudrexel et al. MRM 2009;62:263?268.)
%              
%              If the field inhomogeneities are considered to be linear
%              accross the voxel size, corr_flag = 0 
%
%              (Fernández-Seara and Wehrli, MRM 2000;44(3):358?366.)
%              If the field inhomogeneities have been fit using a second
%              degree quadratic function, corr_flag = 1
%              (Yang et al. MRM 2010;63:1258?1268.)
%
%              The effects of field inhomogeneities are corrected for by
%              limiting the number of echoes used in further
%              post-processing steps. To this respect, a map of the maximum
%              number of echoes that should be used, for each voxel is
%              created: *_max_echoes.mnc
%
% INPUTS: 
% mag_fname : 
%
% OUTPUT:
%
% AUTHOR: Eva Alonso Ortiz
% 
%*************************************************************************

%% constants
gamma = 2*pi*42.58e6; % rad*Hz/T

%% check existence and open data files
[fid, message] = fopen(mag_fname,'r');
if(fid == -1)
    error(sprintf('\nError : cannot find input file %s\n', mag_fname));
end

[fid, message] = fopen(Gx_fname,'r');
if(fid == -1)
    error(sprintf('\nError : cannot find input file %s\n', Gx_fname));
end

[fid, message] = fopen(Gy_fname,'r');
if(fid == -1)
    error(sprintf('\nError : cannot find input file %s\n', Gy_fname));
end

[mag_desc,mag] = niak_read_minc(mag_fname);
[mask_desc,mask] = niak_read_minc(mask_fname);
[Gx_desc,Gx] = niak_read_minc(Gx_fname);
[Gy_desc,Gy] = niak_read_minc(Gy_fname);

if max(reshape(mask,size(mask,1)*size(mask,2),size(mask,3))) > 1
    mask(find(mask > 0)) = 1;
end

% find echo times
num_echoes = mag_desc.info.dimensions(1,4);
echo_times(1)=input('Enter the first echo time in ms: ');
ES=input('Enter the echo spacing in ms: ');
echo_times(2:num_echoes) = echo_times(1)+ES*(1:num_echoes-1);
echo_times = echo_times*1e-3; % convert to seconds

% find slice thickness (cm)
delta_y = mag_desc.info.voxel_size(2)/10;
delta_x = mag_desc.info.voxel_size(1)/10;

y_pos = (delta_y/2):delta_y:delta_y*(size(mag,2)-1/2);
x_pos = (delta_x/2):delta_x:delta_x*(size(mag,1)-1/2);

threeD_flag = 0;
twoP_flag = 0;
threeP_flag = 0;
% check if gradient maps are 2D or 3D
if Gy_desc.info.dimensions(2) > 1  
    threeD_flag = 1;
    % check if gradient maps have been obtained through 2 point or 3 point
    % fitting
    if size(Gy,3) ~= size(mag,3)
        twoP_flag = 1;
    else 
        threeP_flag = 1;
    end
end

%% find the max TE for each pixel that should be used to correct for through-plane inhomogeneities.    
if corr_flag == 0

    if threeD_flag == 0
        Gy = reshape(Gy(:,:,:,1), size(mag,1),size(mag,3),1,1);
        Gx = reshape(Gx(:,:,:,1), size(mag,2),size(mag,3),1,1);
        for i=1:size(mag,1)
            for j=1:size(mag,2)
                for k=1:size(mag,3)
                    TEmax_Gy(i,j,k) = (0.7*pi)/(gamma*Gy(i,k)*delta_y*1e-7);
                    TEmax_Gx(i,j,k) = (0.7*pi)/(gamma*Gx(j,k)*delta_x*1e-7);
                    TEmax(i,j,k) = min([TEmax_Gy(i,j,k) TEmax_Gx(i,j,k)]);
                    if isempty(max(find(echo_times<=squeeze(TEmax(i,j,k))))) ~= 1
                             max_echoes(i,j,k) = max(find(echo_times<=squeeze(TEmax(i,j,k)))); 
                    else
                             max_echoes(i,j,k) = num_echoes;
                    end 
                end
            end
        end
    elseif threeD_flag == 1
        if twoP_flag == 1
            for i=1:size(mag,1)-1
                for j=1:size(mag,2)-1
                    for k=1:size(mag,3)-1
                        TEmax_Gy(i,j,k) = (0.7*pi)/(gamma*abs(Gy(i,j,k))*delta_y*1e-7);
                        TEmax_Gx(i,j,k) = (0.7*pi)/(gamma*abs(Gx(i,j,k))*delta_x*1e-7);
                        TEmax(i,j,k) = min([TEmax_Gy(i,j,k) TEmax_Gx(i,j,k)]); %choose the smallest of the two 
                        if isempty(max(find(echo_times<=squeeze(TEmax(i,j,k))))) ~= 1
                             max_echoes(i,j,k) = max(find(echo_times<=squeeze(TEmax(i,j,k)))); 
                        else
                             max_echoes(i,j,k) = num_echoes;
                        end                    
                    end
                end
            end
        end
        if threeP_flag == 1
            for i=1:size(mag,1)
                for j=1:size(mag,2)
                    for k=1:size(mag,3)
                        TEmax_Gy(i,j,k) = (0.7*pi)/(gamma*abs(Gy(i,j,k))*delta_y*1e-7);
                        TEmax_Gx(i,j,k) = (0.7*pi)/(gamma*abs(Gx(i,j,k))*delta_x*1e-7);
                        TEmax(i,j,k) = min([TEmax_Gy(i,j,k) TEmax_Gx(i,j,k)]); %choose the smallest of the two 
                        if isempty(max(find(echo_times<=squeeze(TEmax(i,j,k))))) ~= 1
                             max_echoes(i,j,k) = max(find(echo_times<=squeeze(TEmax(i,j,k)))); 
                        else
                             max_echoes(i,j,k) = num_echoes;
                        end                     
                    end
                end
            end
        end
    end
end

if corr_flag == 1
    TEmax_Gy =  zeros(size(mag,1),size(mag,2),size(mag,3));
    TEmax_Gx =  zeros(size(mag,1),size(mag,2),size(mag,3));
    TEmax = zeros(size(mag,1),size(mag,2),size(mag,3));
    max_echoes = zeros(size(mag,1),size(mag,2),size(mag,3));    
    
     for i=2:size(mag,1)
            for j=2:size(mag,2)
                for k=1:size(mag,3)
                    if mask(i,j,k) == 1 
                        if ((abs(Gy(i,1,k,1))*(y_pos(j)^2-y_pos(j-1)^2)+abs(Gy(i,1,k,2))*(y_pos(j)-y_pos(j-1))) ~= 0 && (abs(Gx(1,j,k,1))*(x_pos(i)^2-x_pos(i-1)^2)+abs(Gx(1,j,k,2))*(x_pos(i)-x_pos(i-1))) ~= 0)
                            TEmax_Gy(i,j,k) = (0.7*pi)/(gamma*(abs(Gy(i,1,k,1))*(y_pos(j)^2-y_pos(j-1)^2)+abs(Gy(i,1,k,2))*(y_pos(j)-y_pos(j-1)))*1e-7);
                            TEmax_Gx(i,j,k) = (0.7*pi)/(gamma*(abs(Gx(1,j,k,1))*(x_pos(i)^2-x_pos(i-1)^2)+abs(Gx(1,j,k,2))*(x_pos(i)-x_pos(i-1)))*1e-7);
                            TEmax(i,j,k) = min([TEmax_Gy(i,j,k) TEmax_Gx(i,j,k)]);
                                if isempty(max(find(echo_times<=squeeze(TEmax(i,j,k))))) ~= 1
                                    max_echoes(i,j,k) = max(find(echo_times<=squeeze(TEmax(i,j,k)))); 
                                else
                                    max_echoes(i,j,k) = num_echoes;
                                end
                        else
                            max_echoes(i,j,k) = num_echoes;
                        end
                    end
                end
            end
     end
end

%% save max echo time map
[pathstr, name, ext] = fileparts(mag_fname);
max_echoes_fname = strcat(name,'_max_echoes.mnc');

[fid, message] = fopen(max_echoes_fname,'r');
if(fid >= 3)
  unix(['rm ',max_echoes_fname]);
end

mag_desc.file_name = max_echoes_fname;

if threeD_flag == 0
    mag_desc.info.dimensions = [size(mag,1), size(mag,2), size(mag,3)];
elseif threeD_flag == 1
    if twoP_flag == 1
        mag_desc.info.dimensions = [size(mag,1)-1, size(mag,2)-1, size(mag,3)-1];

    end
    if threeP_flag == 1
        mag_desc.info.dimensions = [size(mag,1), size(mag,2), size(mag,3)];
    end
end
niak_write_minc(mag_desc,max_echoes);
