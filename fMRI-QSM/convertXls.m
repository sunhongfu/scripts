clear
filename = 'interpo.xlsx';
A = xlsread(filename);
A = A(:,2:3);
A = permute(A,[2 1]);
A = reshape(A,2,108,[]);
A = permute(A,[1,3,2]);
A = reshape(A,[],108);
A = permute(A,[2 1]);

xlswrite('interpo_raw_reshape.csv',A);