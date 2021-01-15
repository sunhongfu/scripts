function data = fft_sos_rx(kdata,rx)

%     kdata=permute(kdata,[1,3,2]);

    kdata=fftshift(kdata,2);
    kdata=fft(kdata,[],2);
    kdata=fftshift(kdata,2);
    kdata=fftshift(kdata,1);
    kdata=fft(kdata,[],1);
    kdata=fftshift(kdata,1);

    data=abs(kdata).^2;
    data=sqrt(sum(data,3));

    pha=angle(sum(rx.*kdata,3));
    data= data.*exp(1j* pha);
    
end