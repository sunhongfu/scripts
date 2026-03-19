function local_field_gradient(field_fname, mask_fname, fit_flag)

% *************************************************************************
% function local_field_gradient(field_fname, mask_fname, fit_flag)
%
% DESCRIPTION: Function which calculates the field gradients in x,y, and z 
%              directions resulting from B0 field inhomogeneities.
%              The user can select the type of fitting used:
%              fit_flag = -1 -> matlab "gradient" function, i.e. central
%                               difference
%              fit_flag = 0 -> linear fitting using two points (adjacent
%                              voxels)
%              fit_flag = 1 -> linear fitting using 3 points (three
%                              consecutive voxels)
%              fit_flag = 2 -> linear fit using all voxels
%              fit_flag = 3 -> 2nd degree polynomial fit 
%              fit_flag = 4 -> fit data to a polynomial, then take the first
%                              derivative to find the gradient
%
% INPUTS: 
% field_fname : field map used to calculate gradients
% mask_fname : mask used to avoid fitting noise
% fit_flag : select desired fitting for field vs. distance
%
% OUTPUT:
% delBz.mnc delBy.mnc delBx.mnc in uT/m
%
% AUTHOR: Eva Alonso Ortiz
% 
%*************************************************************************

% constants
gamma = 2*pi*42.58e6; % rad*Hz/T

% open data files
[field_desc,field] = niak_read_minc(field_fname);
[mask_desc,mask] = niak_read_minc(mask_fname);

delta_z = field_desc.info.voxel_size(3)/1e3; % slice thickness in m
delta_y = field_desc.info.voxel_size(2)/1e3; 
delta_x = field_desc.info.voxel_size(1)/1e3; 

z_position = (delta_z/2):delta_z:delta_z*(size(field,3)-1/2);
y_position = (delta_y/2):delta_y:delta_y*(size(field,2)-1/2);
x_position = (delta_x/2):delta_x:delta_x*(size(field,1)-1/2);

% check that mask and data_vol are the same dimensions
if size(mask,1)*size(mask,2) ~= size(field,1)*size(field,2)
    error(sprintf('\nError: Mask file dimensions do not match data image file.\n')); 
end

if max(reshape(mask,size(mask,1)*size(mask,2),size(mask,3))) > 1
    mask(find(mask > 0)) = 1;
end

% field gradient calculation 
B0 = 1e6*field/gamma; % convert from rad*Hz to uT

if fit_flag == -1
    [delBx, delBy, delBz] = gradient(B0, delta_x, delta_y, delta_z); 
end

% calculate local field gradient  Hwang et al. doi: 10.1016/j.neuroimage.2010.04.023
if fit_flag == 0
    
    for i=1:size(B0,1)
        for j=1:size(B0,2)
            for k=1:(size(B0,3)-1)
                delBz(i,j,k) = (B0(i,j,k+1)-B0(i,j,k))/(delta_z);
            end
        end
    end
    
    for i=1:size(B0,1)
        for j=1:(size(B0,2)-1)
            for k=1:(size(B0,3)-1)
                delBy(i,j,k) = (B0(i,j+1,k)-B0(i,j,k))/(delta_y);
            end
        end
    end
    
    for i=1:(size(B0,1)-1)
        for j=1:size(B0,2)
            for k=1:(size(B0,3)-1)
                delBx(i,j,k) = (B0(i+1,j,k)-B0(i,j,k))/(delta_x);
            end
        end
    end    
    
end

if fit_flag == 1
    
    if mod(size(B0,3),3)==0
        max_k_range = size(B0,3);
    elseif mod(size(B0,3)-1,3)==0
        max_k_range = size(B0,3)-1;
    elseif mod(size(B0,3)-2,3)==0
        max_k_range = size(B0,3)-2;
    end
    
    if mod(size(B0,2),3)==0
        max_j_range = size(B0,2);
    elseif mod(size(B0,2)-1,3)==0
        max_j_range = size(B0,2)-1;
    elseif mod(size(B0,2)-2,3)==0
        max_j_range = size(B0,2)-2;
    end
          
    if mod(size(B0,1),3)==0
        max_i_range = size(B0,1);
    elseif mod(size(B0,1)-1,3)==0
        max_i_range = size(B0,1)-1;
    elseif mod(size(B0,1)-2,3)==0
        max_i_range = size(B0,1)-2;
    end
    
    % calculate local field gradient by performing linear fit for three
    % consecutive slices
    delBz = zeros(size(B0,1),size(B0,2),size(B0,3));
    delBz_offset = zeros(size(B0,1),size(B0,2),size(B0,3));

    for i=1:size(B0,1)
        for j=1:size(B0,2)
            for k=2:3:max_k_range
                
                if mask(i,j,(k-1):(k+1)) == 1

                    fit_B0 = B0(i,j,(k-1):(k+1));
                    fit_z = z_position((k-1):(k+1));

                    A_design =  [fit_z',ones(size(fit_z))'];
                    b = squeeze(fit_B0);

                    [fit_para_tmp] = lscov(A_design,b);
                    delBz(i,j,(k-1):(k+1)) = fit_para_tmp(1);
                    delBz_offset(i,j,(k-1):(k+1)) = fit_para_tmp(2); 

                end
            end
        end
    end
    
%     % plot a few voxels
%     counter = 1;
%     for i=1:size(B0,1)
%         for j=1:size(B0,2)
% 
%             ind = find(mask(i,j,:)==1);
%             if ( size(ind,1)==19 && counter < 100 )
%                 % plot a few fits
%                 %f=figure('visible','off'); 
%                 figure;
%                 hold on;
%                 grid on;
%                 xlabel('z (cm)');
%                 ylabel('Field (T)');
% 
%                 scatter(z_position(ind),squeeze(B0(i,j,ind)));
% 
%                 for k=2:3:size(B0,3)
%                     fit = squeeze(delBz_offset(i,j,k))+squeeze(delBz(i,j,k)).*z_position((k-1):(k+1));
%                     plot(z_position((k-1):(k+1)),fit);
%                 end
%                 
%                 fig_name = strcat('3p_zFIT_vox_',num2str(i),'_',num2str(j));
%                 print('-djpeg',fig_name);
% 
%                 %close all;
%                 counter = counter+1;
%             end
% 
%         end
%     end    
    
    % calculate local field gradient by performing linear fit for three
    % consecutive slices
    delBy = zeros(size(B0,1),size(B0,2),size(B0,3));
    delBy_offset = zeros(size(B0,1),size(B0,2),size(B0,3));

    for i=1:size(B0,1)
        for k=1:size(B0,3)
            for j=2:3:max_j_range           
                
                if mask(i,(j-1):(j+1),k) == 1

                    fit_B0 = B0(i,(j-1):(j+1),k);
                    fit_y = y_position((j-1):(j+1));

                    A_design =  [fit_y',ones(size(fit_y))'];
                    b = squeeze(fit_B0)';

                    [fit_para_tmp] = lscov(A_design,b);
                    delBy(i,(j-1):(j+1),k) = fit_para_tmp(1);
                    delBy_offset(i,(j-1):(j+1),k) = fit_para_tmp(2);

                end
            end
        end
    end
    
%     % plot a few voxels
%     counter = 1;
%     for i=1:size(B0,1)
%         for k=1:size(B0,3)
% 
%             ind = find(mask(i,:,k)==1)';
%             if ( size(ind,1)>2 && counter < 100 )
%                 % plot a few fits
%                 f=figure('visible','off'); 
%                 hold on;
%                 grid on;
%                 xlabel('y (cm)');
%                 ylabel('Field (T)');
% 
%                 for j=ind(2):2:ind(end)
%                     % only plot consecutive points
%                     if mask(i,(j-1):(j+1),k) == 1
%                         scatter(y_position((j-1):(j+1)),squeeze(B0(i,(j-1):(j+1),k)));
%                         fit = squeeze(delBy_offset(i,j,k))+squeeze(delBy(i,j,k)).*y_position((j-1):(j+1));
%                         plot(y_position((j-1):(j+1)),fit);
%                     end
%                 end
%                 
%                 fig_name = strcat('3p_yFIT_vox_',num2str(i),'_',num2str(j));
%                 print('-djpeg',fig_name);
% 
%                 close all;
%                 counter = counter+1;
%             end
% 
%         end
%     end

    % calculate local field gradient by performing linear fit for three
    % consecutive slices
    delBx = zeros(size(B0,1),size(B0,2),size(B0,3));
    delBx_offset = zeros(size(B0,1),size(B0,2),size(B0,3));

    for j=1:size(B0,2)
        for k=1:size(B0,3)
            for i=2:3:max_i_range           
                
                if mask((i-1):(i+1),j,k) == 1

                    fit_B0 = B0((i-1):(i+1),j,k);
                    fit_x = x_position((i-1):(i+1));

                    A_design =  [fit_x',ones(size(fit_x))'];
                    b = squeeze(fit_B0);

                    [fit_para_tmp] = lscov(A_design,b);
                    delBx((i-1):(i+1),j,k) = fit_para_tmp(1);
                    delBx_offset((i-1):(i+1),j,k) = fit_para_tmp(2);

                end
            end
        end
    end
    
end

if fit_flag == 2

    % calculate local field gradient by performing linear fit
    delBz = zeros(size(B0,1),size(B0,2));
    delBz_offset = zeros(size(B0,1),size(B0,2));
    STDz = zeros(size(B0,1),size(B0,2));

    counter = 1;

    for i=1:size(B0,1)
        for j=1:size(B0,2)

            ind = find(mask(i,j,:)==1);

            if size(ind,1)>1

                fit_B0 = B0(i,j,ind);
                fit_z = z_position(ind);

                A_design =  [fit_z',ones(size(fit_z))'];
                b = squeeze(fit_B0);

                [fit_para_tmp, STD(i,j,:)] = lscov(A_design,b);
                delBz(i,j) = fit_para_tmp(1);
                delBz_offset(i,j) = fit_para_tmp(2);
                STDz(i,j) = STD(i,j,1); 

%                 if (size(ind,1)==18 && counter < 100)
%                     % plot a few fits
%                     f=figure('visible','off'); 
%                     hold on;
%                     grid on;
%                     xlabel('z (cm)');
%                     ylabel('Field (T)');
% 
%                     scatter(fit_z,squeeze(fit_B0));
%                     fit = squeeze(delBz_offset(i,j))+squeeze(delBz(i,j)).*fit_z(:);
%                     plot(fit_z,fit);
% 
%                     fit_text = strcat('slope: (',num2str(1e7*delBz(i,j)),'+/-',num2str(1e7*STDz(i,j)),')mG/cm');
%                     textbp(fit_text);
% 
%                     fig_name = strcat('zLinFit_vox_',num2str(i),'_',num2str(j));
%                     print('-djpeg',fig_name);
% 
%                     close all;
%                     counter = counter+1;
%                 end
            end
        end
    end


    delBy = zeros(size(B0,1),size(B0,3));
    delBy_offset = zeros(size(B0,1),size(B0,3));
    STDy = zeros(size(B0,1),size(B0,3));

    for i=1:size(B0,1)
        for k=1:size(B0,3)

            ind = find(mask(i,:,k)==1)';

            if size(ind,1)>1

                fit_B0 = B0(i,ind,k);
                fit_y = y_position(ind);

                A_design =  [fit_y',ones(size(fit_y))'];
                b = squeeze(fit_B0)';

                [fit_para_tmp, STD(i,k,:)] = lscov(A_design,b);
                delBy(i,k) = fit_para_tmp(1);
                delBy_offset(i,k) = fit_para_tmp(2);
                STDy(i,k) = STD(i,k,1);
                
%                 if (size(ind,1)>50 && counter < 100)
%                     % plot a few fits
%                     f=figure('visible','off'); 
%                     hold on;
%                     grid on;
%                     xlabel('y (cm)');
%                     ylabel('Field (T)');
% 
%                     scatter(fit_y,squeeze(fit_B0));
%                     fit = squeeze(delBy_offset(i,k))+squeeze(delBy(i,k)).*fit_y(:);
%                     plot(fit_y,fit);
% 
%                     fit_text = strcat('slope: (',num2str(1e7*delBy(i,k)),'+/-',num2str(1e7*STDy(i,k)),')mG/cm');
%                     textbp(fit_text);
% 
%                     fig_name = strcat('yLinFit_vox_',num2str(i),'_',num2str(k));
%                     print('-djpeg',fig_name);
% 
%                     close all;
%                     counter = counter+1;
%                 end
            end
        end
    end

    delBx = zeros(size(B0,2),size(B0,3));
    delBx_offset = zeros(size(B0,2),size(B0,3));
    STDx = zeros(size(B0,2),size(B0,3));

    for j=1:size(B0,2)
        for k=1:size(B0,3)

            ind = find(mask(:,j,k)==1);

            if (isempty(ind)~=1 && size(ind,1)>1)

                fit_B0 = B0(ind,j,k);
                fit_x = x_position(ind);

                A_design =  [fit_x',ones(size(fit_x))'];
                b = squeeze(fit_B0);

                [fit_para_tmp, STD(j,k,:)] = lscov(A_design,b);
                delBx(j,k) = fit_para_tmp(1);
                delBx_offset(j,k) = fit_para_tmp(2);
                STDx(j,k) = STD(j,k,1);
            end
        end
    end
end

if fit_flag == 3

    % calculate local field gradient by performing non-linear fit
    delBz = zeros(size(B0,1),size(B0,2),1,3);

    counter = 1;

    for i=1:size(B0,1)
        for j=1:size(B0,2)

            ind = find(mask(i,j,:)==1);

            if size(ind,1)>2

                fit_B0 = squeeze(B0(i,j,ind))';
                fit_z = z_position(ind);

                [p,S] = polyfit(fit_z,fit_B0,2);
                delBz(i,j,1,:) = p;  

%                 if (size(ind,1)==18 && counter < 100)
%                     % plot a few fits
%                     f=figure('visible','off'); 
%                     hold on;
%                     grid on;
%                     xlabel('z (cm)');
%                     ylabel('Field (T)');
% 
%                     scatter(fit_z,squeeze(fit_B0));
%                     fit = squeeze(delBz(i,j,1,3))+squeeze(delBz(i,j,1,2))*fit_z(:)+squeeze(delBz(i,j,1,1)).*(fit_z(:)).^2;
%                     plot(fit_z,fit);
% 
%                     fit_text = strcat('fit: (',num2str(1e7*delBz(i,j,1,3)), ' + ',num2str(1e7*delBz(i,j,1,2)),'x + ',num2str(1e7*delBz(i,j,1,1)),'x^2) mG/cm');
%                     textbp(fit_text);
% 
%                     fig_name = strcat('zQuadFit_vox_',num2str(i),'_',num2str(j));
%                     print('-djpeg',fig_name);
% 
%                     close all;
%                     counter = counter+1;
%                 end
            end
        end
    end

    % calculate local field gradient by performing non-linear fit
    delBy = zeros(size(B0,1),1,size(B0,3),3);

    counter = 1;

    for i=1:size(B0,1)
        for k=1:size(B0,3)

            ind = find(mask(i,:,k)==1)';

            if size(ind,1)>2

                fit_B0 = squeeze(B0(i,ind,k));
                fit_y = y_position(ind);

                [p,S] = polyfit(fit_y,fit_B0,2);
                delBy(i,1,k,:) = p;  
                
%                  if (size(ind,1)>50 && counter < 100)
%                     % plot a few fits
%                     f=figure('visible','off'); 
%                     hold on;
%                     grid on;
%                     xlabel('y (cm)');
%                     ylabel('Field (T)');
% 
%                     scatter(fit_y,squeeze(fit_B0));
%                     fit = squeeze(delBy(i,1,k,3))+squeeze(delBz(i,1,k,2))*fit_z(:)+squeeze(delBz(i,1,k,1)).*(fit_z(:)).^2;
%                     plot(fit_y,fit);
% 
%                     fit_text = strcat('fit: (',num2str(1e7*delBy(i,1,k,3)), ' + ',num2str(1e7*delBy(i,1,k,2)),'x + ',num2str(1e7*delBy(i,1,k,1)),'x^2) mG/cm');
% 
%                     fig_name = strcat('yQuadFit_vox_',num2str(i),'_',num2str(k));
%                     print('-djpeg',fig_name);
% 
%                     close all;
%                     counter = counter+1;
%                 end
            end
        end
    end

        % calculate local field gradient by performing non-linear fit
    delBx = zeros(1,size(B0,2),size(B0,3),3);

    counter = 1;

    for j=1:size(B0,2)
        for k=1:size(B0,3)

            ind = find(mask(:,j,k)==1);

            if size(ind,1)>2

                fit_B0 = squeeze(B0(ind,j,k))';
                fit_x = x_position(ind);

                [p,S] = polyfit(fit_x,fit_B0,2);
                delBx(1,j,k,:) = p;  
            end
        end
    end
end

if fit_flag == 4
    
    [FX, FY, FZ] = gradient(B0, delta_x, delta_y, delta_z); 
    
    delBz = zeros(size(B0,1),size(B0,2),size(B0,3));

    counter = 1;

    for i=1:size(B0,1)
        for j=1:size(B0,2)

            %ind = find(mask(i,j,:)==1);

            %if size(ind,1)>5
            if (mask(i,j,:) == 1)

                %FZ_data = squeeze(FZ(i,j,ind))';
                FZ_data = squeeze(FZ(i,j,:))';
                
%                 fit_B0 = squeeze(B0(i,j,ind))';
%                 fit_z = z_position(ind);

                fit_B0 = squeeze(B0(i,j,:));
                fit_z = z_position(:);
                
                [p,S] = polyfit(fit_z,fit_B0,6);
                Bz_PolyFit(i,j,:) = p; 
                Bz_der(i,j,:) = polyder(p);
                %delBz(i,j,ind) =  squeeze(Bz_der(i,j,6))+ squeeze(Bz_der(i,j,5)).*(fit_z(:))+...
                delBz(i,j,:) =  squeeze(Bz_der(i,j,6))+ squeeze(Bz_der(i,j,5)).*(fit_z(:))+...
                                squeeze(Bz_der(i,j,4)).*(fit_z(:)).^2+squeeze(Bz_der(i,j,3)).*(fit_z(:)).^3+...
                                squeeze(Bz_der(i,j,2)).*(fit_z(:)).^4+squeeze(Bz_der(i,j,1)).*(fit_z(:)).^5;
                
                %if (size(ind,1)==18 && counter < 100)
                if (counter < 10)
                    % plot a few fits
                    f=figure('visible','off'); 
                    %figure;  
                    grid on;

                    subplot(2,1,1);
                    xlabel('z (m)');
                    ylabel('Field (T)');
                    hold on;
                    scatter(fit_z,squeeze(fit_B0),'b','fill');
                    fit = squeeze(Bz_PolyFit(i,j,7))+squeeze(Bz_PolyFit(i,j,6))*fit_z(:)+...
                          squeeze(Bz_PolyFit(i,j,5)).*(fit_z(:)).^2+squeeze(Bz_PolyFit(i,j,4)).*(fit_z(:)).^3+...
                          squeeze(Bz_PolyFit(i,j,3)).*(fit_z(:)).^4+squeeze(Bz_PolyFit(i,j,2)).*(fit_z(:)).^5+...
                          squeeze(Bz_PolyFit(i,j,1)).*(fit_z(:)).^6;
                    plot(fit_z,fit,'r');
                    sp1leg = legend('Field','PolyFit');
                    set(sp1leg,'Location','best');
                    hold off;
                    
                    subplot(2,1,2);
                    xlabel('z (m)');
                    ylabel('Field gradient (uT/m)');
                    hold on;
                    %scatter(fit_z,delBz(i,j,ind),'g','fill');
                    scatter(fit_z,delBz(i,j,:),'g','fill');
                    scatter(fit_z,FZ_data,'m','fill');
                    sp2leg = legend('PolyFit Derivative','Central Diff');
                    set(sp2leg,'Location','best');
                    hold off;

                    fig_name = strcat('zPolyDer_vox_',num2str(i),'_',num2str(j));
                    print('-djpeg',fig_name);

                    close all;
                    counter = counter+1;
                end

            end
        end
    end
end

% % take absolute value of local field gradient (since sinc function is even)
% % and convert from T/cm to mG/cm
% if fit_flag == -1
%     delBz = FZ*1e7;
%     delBy = FY*1e7;
%     delBx = FX*1e7;
% elseif fit_flag == 4
%     delBz = delBz*1e7;
% else
%     delBz = delBz*1e7;
%     delBy = delBy*1e7;
%     delBx = delBx*1e7;
% end
% 
% if fit_flag == 1 || fit_flag == 2
%     delBz_offset = 1e7*delBz_offset;
%     delBy_offset = 1e7*delBy_offset;
%     delBx_offset = 1e7*delBx_offset;
% end


% save field gradient map and fit error file names
[pathstr, name, ext] = fileparts(field_fname);

if fit_flag == -1
    delBz_fname = strcat(name,'_central_diff_delBz.mnc');
    delBy_fname = strcat(name,'_central_diff_delBy.mnc');
    delBx_fname = strcat(name,'_central_diff_delBx.mnc');
end

if fit_flag == 0
    delBz_fname = strcat(name,'_2p_delBz.mnc');
    delBy_fname = strcat(name,'_2p_delBy.mnc');
    delBx_fname = strcat(name,'_2p_delBx.mnc');
end

if fit_flag == 1
    delBz_fname = strcat(name,'_3p_LinFit_delBz.mnc'); 
    delBy_fname = strcat(name,'_3p_LinFit_delBy.mnc'); 
    delBx_fname = strcat(name,'_3p_LinFit_delBx.mnc'); 

    delBz_offset_fname = strcat(name,'_3p_LinFit_delBz_offset.mnc'); 
    delBy_offset_fname = strcat(name,'_3p_LinFit_delBy_offset.mnc'); 
    delBx_offset_fname = strcat(name,'_3p_LinFit_delBx_offset.mnc'); 
end

if fit_flag == 2
    delBz_fname = strcat(name,'_LinFit_delBz.mnc');
    delBy_fname = strcat(name,'_LinFit_delBy.mnc');
    delBx_fname = strcat(name,'_LinFit_delBx.mnc');

    delBz_offset_fname = strcat(name,'_LinFit_delBz_offset.mnc');
    delBy_offset_fname = strcat(name,'_LinFit_delBy_offset.mnc');
    delBx_offset_fname = strcat(name,'_LinFit_delBx_offset.mnc');
end



if fit_flag == -1
    field_desc.file_name = delBz_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBz);
    
%     field_desc.file_name = delBy_fname;
%     field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
%     niak_write_minc(field_desc,delBy);
% 
%     field_desc.file_name = delBx_fname;
%     field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
%     niak_write_minc(field_desc,delBx);
end

if fit_flag == 0
    
    field_desc.file_name = delBz_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3)-1, 1];
    niak_write_minc(field_desc,delBz);
    
    field_desc.file_name = delBy_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2)-1, field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBy);

    field_desc.file_name = delBx_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1)-1, field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBx);
end

if fit_flag == 1
    field_desc.file_name = delBz_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBz);    

    field_desc.file_name = delBy_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBy);
    
    field_desc.file_name = delBx_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBx); 
    
    field_desc.file_name = delBz_offset_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBz_offset);    

    field_desc.file_name = delBy_offset_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBy_offset);
    
    field_desc.file_name = delBx_offset_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBx_offset); 
end

if fit_flag == 2
    
    % save field gradient maps
    field_desc.file_name = delBz_fname;
    field_desc.info.dimensions = [size(B0,1), size(B0,2), 1, 1];
    niak_write_minc_ss(field_desc,delBz);

%     delBy = reshape(delBy,size(B0,1),1,size(B0,3),1);
%     field_desc.file_name = delBy_fname;
%     field_desc.info.dimensions = [size(B0,1), 1, size(B0,3), 1];
%     niak_write_minc(field_desc,delBy);
% 
%     delBx = reshape(delBx,1,size(B0,2),size(B0,3),1);
%     field_desc.file_name = delBx_fname;
%     field_desc.info.dimensions = [1, size(B0,2), size(B0,3), 1];
%     niak_write_minc(field_desc,delBx);

    % save linear fit offset maps
    field_desc.file_name = delBz_offset_fname;
    field_desc.info.dimensions = [size(B0,1), size(B0,2), 1, 1];
    niak_write_minc_ss(field_desc,delBz_offset(:,:,1));

    Bz_fname = strcat(name,'_LinFit_Bz_uTm-1.mnc');
    system(['mincconcat -clob -concat_dimension time ',delBz_fname,' ',delBz_offset_fname, ' ',Bz_fname]);                                              
    system(['rm ',delBz_fname,' ',delBz_offset_fname]); 

%     delBy_offset = reshape(delBy_offset,size(B0,1),1,size(B0,3),1);
%     field_desc.file_name = delBy_offset_fname;
%     field_desc.info.dimensions = [size(B0,1), 1, size(B0,3), 1];
%     niak_write_minc(field_desc,delBy_offset);
% 
%     By_fname = strcat(name,'_LinFit_By.mnc');
%     system(['mincconcat -clob -concat_dimension time ',delBy_fname,' ',delBy_offset_fname, ' ',By_fname]);                                              
%     system(['rm ',delBy_fname,' ',delBy_offset_fname]); 
%     
%     delBx_offset = reshape(delBx_offset,1,size(B0,2),size(B0,3),1);
%     field_desc.file_name = delBx_offset_fname;
%     field_desc.info.dimensions = [1, size(B0,2), size(B0,3), 1];
%     niak_write_minc(field_desc,delBx_offset);
%     
%     Bx_fname = strcat(name,'_LinFit_Bx.mnc');
%     system(['mincconcat -clob -concat_dimension time ',delBx_fname,' ',delBx_offset_fname, ' ',Bx_fname]);                                              
%     system(['rm ',delBx_fname,' ',delBx_offset_fname]);
    
end

if fit_flag == 3

   field_desc.info.dimensions = [size(B0,1), size(B0,2), 1, 1];
   
   PolyFit_Bz_a_fname = strcat(name,'_PolyFit_Bz_a.mnc');
   field_desc.file_name = PolyFit_Bz_a_fname;
   niak_write_minc_ss(field_desc,delBz(:,:,1,1));   
   
   PolyFit_Bz_b_fname = strcat(name,'_PolyFit_Bz_b.mnc');
   field_desc.file_name = PolyFit_Bz_b_fname;
   niak_write_minc_ss(field_desc,delBz(:,:,1,2));   
     
   PolyFit_Bz_c_fname = strcat(name,'_PolyFit_Bz_c.mnc');
   field_desc.file_name = PolyFit_Bz_c_fname;
   niak_write_minc_ss(field_desc,delBz(:,:,1,3));   
   
   PolyFit_Bz_fname = strcat(name,'_PolyFit_Bz.mnc');
   system(['mincconcat -clob -concat_dimension time ',PolyFit_Bz_a_fname,' ',PolyFit_Bz_b_fname,' ',PolyFit_Bz_c_fname,' ',PolyFit_Bz_fname]);                                              
   system(['rm ',PolyFit_Bz_a_fname,' ',PolyFit_Bz_b_fname,' ',PolyFit_Bz_c_fname]); 



   field_desc.info.dimensions = [size(B0,1), 1, size(B0,3), 1];
   
   PolyFit_By_a_fname = strcat(name,'_PolyFit_By_a.mnc');
   field_desc.file_name = PolyFit_By_a_fname;
   niak_write_minc(field_desc,delBy(:,1,:,1));   
   
   PolyFit_By_b_fname = strcat(name,'_PolyFit_By_b.mnc');
   field_desc.file_name = PolyFit_By_b_fname;
   niak_write_minc(field_desc,delBy(:,1,:,2));   
   
   PolyFit_By_c_fname = strcat(name,'_PolyFit_By_c.mnc');
   field_desc.file_name = PolyFit_By_c_fname;
   niak_write_minc(field_desc,delBy(:,1,:,3));  
   
   PolyFit_By_fname = strcat(name,'_PolyFit_By.mnc');
   system(['mincconcat -clob -concat_dimension time ',PolyFit_By_a_fname,' ',PolyFit_By_b_fname,' ',PolyFit_By_c_fname,' ',PolyFit_By_fname]);                                              
   system(['rm ',PolyFit_By_a_fname,' ',PolyFit_By_b_fname,' ',PolyFit_By_c_fname]); 

   

   field_desc.info.dimensions = [1, size(B0,2), size(B0,3), 1];
   
   PolyFit_Bx_a_fname = strcat(name,'_PolyFit_Bx_a.mnc');
   field_desc.file_name = PolyFit_Bx_a_fname;
   niak_write_minc(field_desc,delBx(1,:,:,1));   
    
   PolyFit_Bx_b_fname = strcat(name,'_PolyFit_Bx_b.mnc');
   field_desc.file_name = PolyFit_Bx_b_fname;
   niak_write_minc(field_desc,delBx(1,:,:,2));   
   
   PolyFit_Bx_c_fname = strcat(name,'_PolyFit_Bx_c.mnc');
   field_desc.file_name = PolyFit_Bx_c_fname;
   niak_write_minc(field_desc,delBx(1,:,:,3));   
   
   PolyFit_Bx_fname = strcat(name,'_PolyFit_Bx.mnc');
   system(['mincconcat -clob -concat_dimension time ',PolyFit_Bx_a_fname,' ',PolyFit_Bx_b_fname,' ',PolyFit_Bx_c_fname,' ',PolyFit_Bx_fname]);                                              
   system(['rm ',PolyFit_Bx_a_fname,' ',PolyFit_Bx_b_fname,' ',PolyFit_Bx_c_fname]); 
   
end

if fit_flag == 4

    delBz_fname = strcat(name,'_PolyFit_derivative_Bz.mnc');
    
    field_desc.file_name = delBz_fname;
    field_desc.info.dimensions = [field_desc.info.dimensions(1,1), field_desc.info.dimensions(1,2), field_desc.info.dimensions(1,3), 1];
    niak_write_minc(field_desc,delBz);
end