n=2000
a = rand(n,n);
a= a'*a;
dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f');
save('positive_definite.txt','-ascii', '-double','a','-append');
tic;qmr(a,ones(n,1),1e-8,10000000);toc;
[x y] = system('./fishy.sh');
dlmwrite('2000.txt',y)

n=3000
a = rand(n,n);
a= a'*a;
dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f');
save('positive_definite.txt','-ascii', '-double','a','-append');
tic;qmr(a,ones(n,1),1e-8,10000000);toc;
[x y] = system('./fishy.sh');
dlmwrite('3000.txt',y)

n=4000
a = rand(n,n);
a= a'*a;
dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f');
save('positive_definite.txt','-ascii', '-double','a','-append');
tic;qmr(a,ones(n,1),1e-8,10000000);toc;
[x y] = system('./fishy.sh');
dlmwrite('4000.txt',y)

n=5000
a = rand(n,n);
a= a'*a;
dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f');
save('positive_definite.txt','-ascii', '-double','a','-append');
tic;qmr(a,ones(n,1),1e-8,10000000);toc;
[x y] = system('./fishy.sh');
dlmwrite('5000.txt',y)