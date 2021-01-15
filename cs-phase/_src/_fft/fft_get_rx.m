function [rx] = fft_get_rx(kdata)

%     kdata=permute(kdata,[1,3,2]);

    kdata=fftshift(kdata,2);
    kdata=fft(kdata,[],2);
    kdata=fftshift(kdata,2);
    kdata=fftshift(kdata,1);
    kdata=fft(kdata,[],1);
    kdata=fftshift(kdata,1);

    rx = conj(kdata);
end