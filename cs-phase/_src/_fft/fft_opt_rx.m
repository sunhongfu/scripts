function opt_img = fft_opt_rx(kdata,rx,ref,invNoiseCov)


    kdata=fftshift(kdata,2);
    kdata=fft(kdata,[],2);
    kdata=fftshift(kdata,2);
    kdata=fftshift(kdata,1);
    kdata=fft(kdata,[],1);
    imgs=fftshift(kdata,1);
    
    rx  = rx./ref;
    
    if(numel(invNoiseCov)>1)

        nRe = size(imgs,1);
        nPh = size(imgs,2);

        opt_img = zeros(nRe,nPh);

        for iRe = 1:nRe
            for iPh = 1:nPh
                s_matrix = squeeze(rx(iRe,iPh,:));
                i_matrix = squeeze(imgs(iRe,iPh,:)); 

                opt_img(iRe,iPh) = transpose(s_matrix)*invNoiseCov*i_matrix;

            end
        end
    
    else
        opt_img = squeeze(img);
    end

    

end