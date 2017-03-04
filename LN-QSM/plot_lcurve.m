% plot L-curve
cd ~/mount_helix/data/L-curve/QSM_SPGR_GE/mat

% load in the out*.mat matlab matrix
TVs={'10.0000e-006', '18.3298e-006', '33.5982e-006', '61.5848e-006', '112.8838e-006', '206.9138e-006', '379.2690e-006', '695.1928e-006', '1.2743e-003', '2.3357e-003', '4.2813e-003', '7.8476e-003', '14.3845e-003', '26.3665e-003', '48.3293e-003', '88.5867e-003', '162.3777e-003', '297.6351e-003', '545.5595e-003', '1.0000e+000'};
TIKs=TVs;

% TVs={'1e-3','2e-4','3e-4','4e-4','5e-4','6e-4','7e-4','8e-4','9e-4'};
% TIKs={'1e-3','2e-3','3e-3','4e-3','5e-3'};


Res = zeros(length(TVs));
TV = Res;
Tik = Res;

for i=1:length(TVs)
	for j=1:length(TIKs)
		load(['out_TV_' TVs{i} '_Tik_' TIKs{j} '.mat'],'Res_term','TV_term','Tik_term');
		Res(i,j) = Res_term;
		TV(i,j) = TV_term;
		Tik(i,j) = Tik_term;
	end
end

% (1) plot L-curves of TV vs Res for different TIKs
figure;
for i=1:length(TIKs)
	subplot(1,5,i)
	% plot(Res(:,i)+str2num(TIKs{i})*Tik(:,i),TV(:,i),'o-');
	plot(log(Res(:,i)),log(TV(:,i)),'o-');
	axis equal;
	title(['Tik=' num2str(TIKs{i})]);
end

% (2) plot L-curve of Tik vs Res for different TVs
figure;
for i=1:length(TVs)
	subplot(1,9,i);
	% plot(Res(i,:)+str2num(TVs{i})*TV(i,:),Tik(i,:),'o-');
	plot(log(Res(i,:)),log(Tik(i,:)),'o-');
	title(['TV=' num2str(TVs{i})]);
end


figure;
plot(log(Res(7,:)+str2num(TVs{7})*TV(7,:)),log(Tik(7,:)),'o-');
title(['TV=' num2str(TVs{7})]);

figure;
plot(log(Res(7,:)),log(Tik(7,:)),'o-');
title(['TV=' num2str(TVs{7})]);


figure;
plot(log(Res(:,8)),log(Tik(:,8)),'o-');
title(['TIK=' num2str(TIKs{8})]);




regularization = Tik(8,1:end);
consistency = Res(8,1:end);
Lambda = [10.0000e-006, 18.3298e-006, 33.5982e-006, 61.5848e-006, 112.8838e-006, 206.9138e-006, 379.2690e-006, 695.1928e-006, 1.2743e-003, 2.3357e-003, 4.2813e-003, 7.8476e-003, 14.3845e-003, 26.3665e-003, 48.3293e-003, 88.5867e-003, 162.3777e-003, 297.6351e-003, 545.5595e-003, 1.0000e+000];
Lambda = Lambda(1:end);

% cubic spline differentiation to find Kappa (largest curvature) 

% eta = log(regularization.^2);
% rho = log(consistency.^2);

eta = log(regularization);
rho = log(consistency);

% eta = regularization;
% rho = consistency;

M = [0 3 0 0;0 0 2 0;0 0 0 1;0 0 0 0];

pp = spline(Lambda, eta);
% plot(logspace(-5,0,100), ppval(pp, logspace(-5,0,100)),'-');

ppd = pp;

ppd.coefs = ppd.coefs*M;
eta_del = ppval(ppd, Lambda);
ppd.coefs = ppd.coefs*M;
eta_del2 = ppval(ppd, Lambda);

eta_fit = ppval(pp, logspace(-5,0,100));


pp = spline(Lambda, rho);
ppd = pp;

ppd.coefs = ppd.coefs*M;
rho_del = ppval(ppd, Lambda);
ppd.coefs = ppd.coefs*M;
rho_del2 = ppval(ppd, Lambda);

rho_fit = ppval(pp, logspace(-5,0,100));

Kappa = 2 * (rho_del2 .* eta_del - eta_del2 .* rho_del) ./ (rho_del.^2 + eta_del.^2).^1.5;

index_opt = find(Kappa == max(Kappa));
disp(['Optimal lambda, consistency, regularization: ', num2str([Lambda(index_opt), consistency(index_opt), regularization(index_opt)])])

figure, semilogx(Lambda, Kappa, 'marker', '*')






dx  = gradient(x);
ddx = gradient(dx);
dy  = gradient(y);
ddy = gradient(dy);
num   = dx .* ddy - ddx .* dy;
denom = dx .* dx + dy .* dy;
denom = sqrt(denom);
denom = denom .* denom .* denom;
curvature = num ./ denom;
curvature(denom < 0) = NaN;

