% MRF_MATCH_CPP: performs the dictionary matching via a exteral c++ program

%%-----------------------------------------------------------------------%%
%  Authors: M.A. Cloos
%  Martijn.Cloos@nyumc.org
%  Date: 2016 Oct 4
%  New York University School of Medicine, www.cai2r.net
%%-----------------------------------------------------------------------%%
function [] = mrf_match_cpp(img)

%%-----------------------------------------------------------------------%%
% Make directory to hold the binary data
%%-----------------------------------------------------------------------%%
if ~exist('./4_cpp', 'dir')
    mkdir('./4_cpp');
end
%%-----------------------------------------------------------------------%%
% Export data for C++ dictionary matching
%%-----------------------------------------------------------------------%%
    for sl=1:size(img,1)
        
        data = real(permute(squeeze(img(sl,:,:,:)), [3 1 2]));
        data = single(data(:));

        file_id = sprintf('./4_cpp/mrf_data_4_cpp_match_%04d', sl);
        fid = fopen(file_id,'w');
        fwrite(fid, data, 'single');
        fclose(fid);
    end

    mask = single(ones(size(img,2),size(img,3)));
    fid = fopen('./4_cpp/mrf_mask_4_cpp_matc.float','w');
    fwrite(fid, mask, 'single');
    fclose(fid);


end