

a = 0 : pi/30 : pi / 2;
b = 0 : pi/30 : pi / 2;

% zs = zeros(25, 3); 
% count = 1; 
for i = 1: 1 : length(a)
    tmp_a = a(i); 
    for j = 1 : 1 : length(a)
        tmp_b = b(j);
        
        z_prjs = [sin(tmp_a) * cos(tmp_b), sin(tmp_a) * sin(tmp_b), cos(tmp_a)];
%         zs(count, :) = z_prjs'; 
         figure(111)
h = vectarrow([0 0 0], z_prjs)
% set(h,  'linewidth', 3)
        %plot3([0, z_prjs(1)], [0, z_prjs(2)], [0, z_prjs(3)], 'linewidth', 3);
                hold on;
                axis([0, 1, 0, 1, 0, 1])
                view(15, 15)
                grid on
%         count = count + 1; 
    end
end

% z = cos(a); 
% y = sin(a) .* sin(b); 
% x = sin(a) .* cos(b); 

a = 0 : pi/100:pi/2; 
b = 0 : pi/100:pi/2; 
[t, p] = meshgrid(a, b);
X = sin(t) .* cos(p); 
Y = sin(t) .* sin(p); 
Z = cos(t); 


figure(111)
hold on
% mesh(X, Y, Z, 'EdgeColor', 'none')
colormap([0 0.4470 0.7410])
shading interp



