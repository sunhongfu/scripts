function [ph] = fft_get_ph(kdata)

    %coil combine
    img = fftshift(fft(fftshift(kdata,1),[],1),1);
% img = squeeze(sqrt(sum(img.*conj(img),2)));    %SOS
% img = squeeze(sum(abs(img).*img,2));           %phase step 1
% img = sqrt(abs(img)).*exp(1i * angle(img));    %phase step 2
img = squeeze(sum(img(:,:,:,1,:).*conj(img(:,:,:,2,:)),2));           %phase differnce

% 
ph = angle(img);
% 
% % %plot amplitude
% % tmpA = abs(squeeze(tmp(:,1,1)));
% % [~, pos] = max(tmpA); % no 
% % figure(1); imshow(tmpA,[0,max(tmpA(:))]);
% 
% %plot phase
% tmpP = angle(squeeze(tmp(:,1,1)));
% figure(2); plot(tmpP);
% % figure(2); imshow(tmpP,[-pi,pi]);

%     rx = conj(kdata);
end