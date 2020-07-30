test_IDs = [];

fileID = fopen('syn_IDs.txt','w');
for i = 1:999
    for j = 1:5
        test_ID = [num2str(i) '-' num2str(j)];
        fprintf(fileID,'%s\n',test_ID);
    end
end

fclose(fileID);
