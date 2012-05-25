function X = lmgen(n)
delete positive_definite.txt
dlmwrite('positive_definite.txt', n, 'delimiter', ' ','precision', '%.0f')
fid = fopen('positive_definite.txt','a');
        
for it=1:n
for it=1:n
    c = rand
    fprintf(fid,'%2.4f  ',c)
end
fprintf(fid,'\n');
end