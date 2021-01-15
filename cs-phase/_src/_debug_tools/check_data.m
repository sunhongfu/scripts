function  check_data(data)

    tmp = squeeze(data);
    tmp = fftshift(ifft(fftshift(tmp,2),[],2),2);
    tmp = fftshift(ifft(fftshift(tmp,1),[],1),1);

    tmA = sqrt(sum(abs(tmp).*abs(tmp),3));
    tmP = angle(sum(abs(tmp).*tmp,3));

    lim =max(tmA(:))/4;
    disp(lim);
    
    figure(99);
    
    subplot(1,2,1); imshow(tmA,[0,lim]);
    subplot(1,2,2); imshow(tmP,[-pi,pi]);

end