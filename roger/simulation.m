a = data';
b = [1/2 1/2];
c = [1/4 1/2 1/4];
d = [1/8 3/8 3/8 1/8];
e = [1/16 1/8 3/16 1/4 3/16 1/8 1/16];


a_b = conv(a,b);
a_c = conv(a,c);
a_d = conv(a,d);
a_e = conv(a,e);

figure; 
subplot(5,1,1); plot(a);
subplot(5,1,2); plot(a_b);
subplot(5,1,3); plot(a_c);
subplot(5,1,4); plot(a_d);
subplot(5,1,5); plot(a_e);

a_b_D = deconv(a_b,b);
a_c_D = deconv(a_c,c);
a_d_D = deconv(a_d,d);
a_e_D = deconv(a_e,e);

figure; 
subplot(5,1,1); plot(a);
subplot(5,1,2); plot(a_b_D);
subplot(5,1,3); plot(a_c_D);
subplot(5,1,4); plot(a_d_D);
subplot(5,1,5); plot(a_e_D);


% with noise
a_b = conv(a,b) + 30*randn(1,length(a)+1);
a_c = conv(a,c) + 30*randn(1,length(a)+2);
a_d = conv(a,d) + 30*randn(1,length(a)+3);
a_e = conv(a,e) + 30*randn(1,length(a)+6);


figure; 
subplot(5,1,1); plot(a);ylim([0,1000]);
subplot(5,1,2); plot(a_b);ylim([0,1000]);
subplot(5,1,3); plot(a_c);ylim([0,1000]);
subplot(5,1,4); plot(a_d);ylim([0,1000]);
subplot(5,1,5); plot(a_e);ylim([0,1000]);

a_b_D = deconv(a_b,b);
a_c_D = deconv(a_c,c);
a_d_D = deconv(a_d,d);
a_e_D = deconv(a_e,d);

figure; 
subplot(5,1,1); plot(a);
subplot(5,1,2); plot(a_b_D);
subplot(5,1,3); plot(a_c_D);
subplot(5,1,4); plot(a_d_D);
subplot(5,1,5); plot(a_e_D);

% FFT truncation
tmp_b = fft(a_b)./fft(b,length(a_b));
tmp_b(abs(fft(b,length(a_b)))<0.2) = 0;
a_b_D = real(ifft(tmp_b));

tmp_c = fft(a_c)./fft(c,length(a_c));
tmp_c(abs(fft(c,length(a_c)))<0.2) = 0;
a_c_D = real(ifft(tmp_c));

tmp_d = fft(a_d)./fft(d,length(a_d));
tmp_d(abs(fft(d,length(a_d)))<0.2) = 0;
a_d_D = real(ifft(tmp_d));

tmp_e = fft(a_e)./fft(e,length(a_e));
tmp_e(abs(fft(e,length(a_e)))<0.1) = 0;
a_e_D = real(ifft(tmp_e));

figure; ylim([0,1000]);
subplot(5,1,1); plot(a);ylim([0,1000]);
subplot(5,1,2); plot(a_b_D);ylim([0,1000]);
subplot(5,1,3); plot(a_c_D);ylim([0,1000]);
subplot(5,1,4); plot(a_d_D);ylim([0,1000]);
subplot(5,1,5); plot(a_e_D);ylim([0,1000]);
