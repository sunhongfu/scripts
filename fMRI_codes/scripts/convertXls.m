clear
filename = 'mag_raw.xls';
A = xlsread(filename);
A = A(:,2:3);
A = permute(A,[2 1]);
A = reshape(A,2,65,[]);
A = permute(A,[1,3,2]);
A = reshape(A,[],65);
A = permute(A,[2 1]);

xlswrite('mag_raw_reshape.csv',A);
