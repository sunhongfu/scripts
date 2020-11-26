% Description: Function to open multidimensional MRD/SUR files given a filename with PPR-parsing
% Inputs: string filename, reordering1, reordering2
% Outputs: complex data, raw dimension [no_expts,no_echoes,no_slices,no_views,no_views_2,no_samples], MRD/PPR parameters
% Author: Ruslan Garipov
% Date: 01/03/2014 - swapped views and views2 dimension - now correct
% 30 April 2014 - support for reading orientations added
% 11 September 2014 - swapped views and views2 in the array (otherwise the images are rotated)
% 13 October 2015 - scaling added as a parameter
% 19 October 2018 - image tags added
function [im,dim,par] = Get_mrd_3D5(filename,reordering1, reordering2)
% Read in MRD and SUR file formats
% reordering1, 2 is 'seq' or 'cen'
% reordering1 is for 2D (views)
% reordering2 is for 3D (views2)
fid = fopen(filename,'r');      % Define the file id
val = fread(fid,4,'int32');
xdim = val(1);
ydim = val(2); 
zdim = val(3);
dim4 = val(4);
fseek(fid,18,'bof');
datatype=fread(fid,1, 'uint16');
datatype = dec2hex(datatype);
fseek(fid,48,'bof');
scaling=fread(fid,1, 'float32');
bitsperpixel=fread(fid,1, 'uchar');
fseek(fid,152,'bof');
val = fread(fid,2, 'int32');
dim5 = val(1);
dim6 = val(2);
fseek(fid,256,'bof');
text=fread(fid,256);
no_samples = xdim;
no_views = ydim;
no_views_2=zdim;
no_slices = dim4;
no_echoes = dim5;
no_expts = dim6;

% Read in the complex image data
dim = [no_expts,no_echoes,no_slices,no_views_2,no_views,no_samples];

if size(datatype,2)>1
    onlydatatype = datatype(2);
    iscomplex = 2;
else
    onlydatatype = datatype(1);
    iscomplex = 1;
end
switch onlydatatype
    case '0' 
        dataformat = 'uchar';   datasize = 1; % size in bytes
    case '1' 
        dataformat = 'schar';   datasize = 1; % size in bytes
    case '2' 
        dataformat = 'short';   datasize = 2; % size in bytes
    case '3' 
        dataformat = 'int16';   datasize = 2; % size in bytes
    case '4' 
        dataformat = 'int32';   datasize = 4; % size in bytes
    case '5' 
        dataformat = 'float32'; datasize = 4; % size in bytes
    case '6' 
        dataformat = 'double';  datasize = 8; % size in bytes
    otherwise
        dataformat = 'int32';   datasize = 4; % size in bytes
end

num2read = no_expts*no_echoes*no_slices*no_views_2*no_views*no_samples*iscomplex; %*datasize;
[m_total, count] = fread(fid,num2read,dataformat); % reading all the data at once

if (count~=num2read)
    h = msgbox('We have a problem...');
end

if iscomplex == 2
    a=1:count/2;
    m_real = m_total(2*a-1);
    m_imag = m_total(2*a);
    clear m_total;
    m_C = m_real+m_imag*1i;
    clear m_real m_imag;
else
    m_C = m_total;
    clear m_total;
end
n=0;

% shaping the data manually:
ord=1:no_views;
if reordering1 == 'cen'
    for g=1:no_views/2
        ord(2*g-1)=no_views/2+g;
        ord(2*g)=no_views/2-g+1;
    end
end

ord1 = 1:no_views_2;
ord2 = ord1;
if reordering2 == 'cen'
    for g=1:no_views_2/2
        ord2(2*g-1)=no_views_2/2+g;
        ord2(2*g)=no_views_2/2-g+1;
    end
end

for a=1:no_expts
    for b=1:no_echoes
        for c=1:no_slices
            for d=1:no_views
                for e=1:no_views_2
                    m_C_1(a,b,c,ord(d),ord2(e),:) = m_C(1+n:no_samples+n); % sequential ordering                    
                    n=n+no_samples;
                end
            end
        end
    end
end

clear ord;
clear ord2;
m_C = squeeze(m_C_1);
clear m_C_1;
im=m_C;
sample_filename = char(fread(fid,120,'uchar')');
ppr_text = char(fread(fid,Inf,'uchar')');

fclose(fid);

%% parse fields in ppr section of the MRD file
if numel(ppr_text)>0
    cell_text = textscan(ppr_text,'%s','delimiter',char(13));
    PPR_keywords = {'BUFFER_SIZE','DATA_TYPE','DECOUPLE_FREQUENCY','DISCARD','DSP_ROUTINE','EDITTEXT','EXPERIMENT_ARRAY','FOV','FOV_READ_OFF','FOV_PHASE_OFF','FOV_SLICE_OFF','GRADIENT_STRENGTH','MULTI_ORIENTATION','Multiple Receivers','NO_AVERAGES','NO_ECHOES','NO_RECEIVERS','NO_SAMPLES','NO_SLICES','NO_VIEWS','NO_VIEWS_2','OBLIQUE_ORIENTATION','OBSERVE_FREQUENCY','ORIENTATION','PHASE_CYCLE','READ/PHASE/SLICE_SELECTION','RECEIVER_FILTER','SAMPLE_PERIOD','SAMPLE_PERIOD_2','SCROLLBAR','SLICE_BLOCK','SLICE_FOV','SLICE_INTERLEAVE','SLICE_THICKNESS','SLICE_SEPARATION','SPECTRAL_WIDTH','SWEEP_WIDTH','SWEEP_WIDTH_2','VAR_ARRAY','VIEW_BLOCK','VIEWS_PER_SEGMENT','SMX','SMY','SWX','SWY','SMZ','SWZ','VAR','PHASE_ORIENTATION','X_ANGLE','Y_ANGLE','Z_ANGLE','PPL','IM_ORIENTATION','IM_OFFSETS','IM_SLICE', 'IM_ECHO', 'IM_EXPERIMENT', 'FOV_OFFSETS', 'READ_VAR'};

    %PPR_type_0 keywords have text fields only, e.g. ":PPL C:\ppl\smisim\1ge_tagging2_1.PPL"
    PPR_type_0 = [23 53];
    %PPR_type_1 keywords have single value, e.g. ":FOV 300" and 'IM_SLICE', 'IM_ECHO', 'IM_EXPERIMENT' SUR tags
    PPR_type_1 = [8 42:47 56 57];
    %PPR_type_2 keywords have single variable and single value, e.g. ":NO_SAMPLES no_samples, 16"
    PPR_type_2 = [4 7 9:11 15:21 25 31 33 41 49 60];
    PPR_type_3 = 48; % VAR keyword only (syntax same as above)
    PPR_type_4 = [28 29]; % :SAMPLE_PERIOD sample_period, 300, 19, "33.3 KHz  30 ?s" and SAMPLE_PERIOD_2 - read the first number=timeincrement in 100ns
    %PPR_type_5 keywords have single variable and two values, e.g. ":SLICE_THICKNESS gs_var, -799, 100"
    PPR_type_5 = [34 35]; 
    % KEYWORD [pre-prompt,] [post-prompt,] [min,] [max,] default, variable [,scale] [,further parameters ...];
    PPR_type_6 = [39 50:52]; % VAR_ARRAY and angles keywords
    PPR_type_7 = [54 55]; % IM_ORIENTATION and IM_OFFSETS (SUR only)
    PPR_type_8 = 12; % GRADIENT_STRENGTH keyword
    PPR_type_9 = 59; % FOV_OFFSETS keyword
    par = struct('filename',filename);
    for j=1:size(cell_text{1},1)
        char1 = char(cell_text{1}(j,:));
        field_ = '';
        if ~isempty(char1)
            C = textscan(char1, '%*c%s %s', 1);
            field_ = char(C{1});
        end
    % find the corresponding number in PPR_keyword array:
        num = find(strcmp(field_,PPR_keywords));
        if num>0
            if find(PPR_type_3==num) % :VAR keyword
                C = textscan(char1, '%*s %s %f');
                field_title = char(C{1}); field_title(numel(field_title)) = [];
                numeric_field = C{2};
                par = setfield(par, field_title, numeric_field);
            elseif find(PPR_type_1==num)
                C = textscan(char1, '%*s %f');
                numeric_field = C{1};
                par = setfield(par, field_, numeric_field);
            elseif find(PPR_type_2==num)
                C = textscan(char1, '%*s %s %f');
                numeric_field = C{2};
                par = setfield(par, field_, numeric_field);
            elseif find(PPR_type_4==num)
                C = textscan(char1, '%*s %s %n %n %s');
                field_title = char(C{1}); field_title(numel(field_title)) = [];
                numeric_field = C{2};
                par = setfield(par, field_, numeric_field);
            elseif find(PPR_type_0==num)
                C = textscan(char1, '%*s %[^\n]');
                text_field = char(C{1}); %text_field = reshape(text_field,1,[]);
                par = setfield(par, field_, text_field);
            elseif  find(PPR_type_5==num)
                C = textscan(char1, '%*s %s %f %c %f');
                numeric_field = C{4};
                par = setfield(par, field_, numeric_field);
            elseif  find(PPR_type_6==num)
                C = textscan(char1, '%*s %s %f %c %f', 200);
                field_ = char(C{1}); field_(end) = [];% the name of the array            
                num_elements = C{2}; % the number of elements of the array
                numeric_field = C{4};
                multiplier = [];
                for l=4:numel(C)
                    multiplier = [multiplier C{l}];
                end
                pattern = ':';
                k=1;
                tline = char(cell_text{1}(j+k,:));            
                while (isempty(strfind(tline, pattern)))
                    tline = char(cell_text{1}(j+k,:));
                    arr = textscan(tline, '%*s %f', num_elements);
                    multiplier = [multiplier, arr{1}'];
                    k = k+1;
                    tline = char(cell_text{1}(j+k,:));
                end
                par = setfield(par, field_, multiplier);
            elseif find(PPR_type_7==num) % :IM_ORIENTATION keyword
                C = textscan(char1, '%s %f %f %f');
                field_title = char(C{1}); field_title(1) = [];
                numeric_field = [C{2}, C{3}, C{4}];
                par = setfield(par, field_title, numeric_field);
            elseif find(PPR_type_8==num) % GRADIENT_STRENGTH keyword
                C=textscan(char1(20:end), '%s %d %d %d %d %d', 'Delimiter', ',', 'ReturnOnError', 0);
                field_ = char(C{1});
                multiplier(1) = C{3};
                multiplier(2) = C{4};
                multiplier(3) = C{5};
                multiplier(4) = C{6};
                par = setfield(par, field_, multiplier);
            elseif find(PPR_type_9==num) % FOV_OFFSETS keyword
                C = textscan(char1, '%s %d', 200);
                field_ = char(C{1}); field_(1) = [];% the name of the array            
                num_elements = C{2}; % the number of elements of the array
                multiplier = [];
                for l=1:num_elements
                    tline = char(cell_text{1}(j+l,:));
                    arr = textscan(tline, '%*s %f', 3);
                    multiplier(l,1) = arr{1}(1);
                    multiplier(l,2) = arr{1}(2);
                    multiplier(l,3) = arr{1}(3);
                end
                par = setfield(par, field_, multiplier);
            end
            
        end
    end
    if isfield('OBSERVE_FREQUENCY','par')
        C = textscan(par.OBSERVE_FREQUENCY, '%q');
        text_field = char(C{1}); 
        par.Nucleus = text_field(1,:);
    else
        par.Nucleus = 'Unspecified';
    end
        par.datatype = datatype;
        file_pars = dir(filename);
        par.date = file_pars.date;

else par = [];
end
par.scaling = scaling;
