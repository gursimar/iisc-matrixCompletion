function [qmrr cgne] = qmr_dim(choice,N,strt)
if (nargin<3)
    strt=1;
end
clf;
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
%qmrr = zeros(1,N);
%size_of_a = zeros(1,N);
if(choice==1)
for it=strt:N
    it
    a = rand((it+2),(it+2));
    %a = vander(a);
    %a = a'*a;
    size_of_a(it) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    save('condition_number.txt','-ascii', '-double','temp_cond','-append')
    t=clock;
    [x, y] = system('gfortran QMR.f90');
    [x, y] = system('./a.out');
    y = str2num(y);
    if(isempty(y))
        det(a)
       disp('Encountered a Fatal Problem in QMR')          
        
    qmrr(it) = -1;
    else
        qmrr(it) = etime(clock,t);
    end
    
    t=clock;
    [x, y] = system('gfortran CGNE.f90');
    [x, y] = system('./a.out');
    y = str2num(y);
    if(isempty(y))
        det(a)
       disp('Encountered a Fatal Problem in CGNE')          
       cgne(it) = -1;
    else
    cgne(it) = etime(clock,t);
    end
end
elseif(choice==2)
for it=strt:N
    it
    a = rand((it+2),1);
    a = vander(a);
    
    %a = a'*a;
    size_of_a(it) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    save('condition_number.txt','-ascii', '-double','temp_cond','-append')
    t=clock;
    [x, y] = system('gfortran QMR.f90');
    [x, y] = system('./a.out');
    y = str2num(y);
    if(isempty(y))
        det(a)
       disp('Encountered a Fatal Problem in QMR')          
       qmrr(it) = -1 ;
    else
    qmrr(it) = etime(clock,t);
    end
    t=clock;
    [x, y] = system('gfortran CGNE.f90');
    [x, y] = system('./a.out');
    y = str2num(y);
    if(isempty(y))
        det(a)
       disp('Encountered a Fatal Problem in CGNE')          
       cgne(it) = -1;
    else
    cgne(it) = etime(clock,t);
    end
end
elseif (choice==3)
    for it=strt:N
    it
    a = hilb(it+2);
    %a = a'*a;
    size_of_a(it) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    save('condition_number.txt','-ascii', '-double','temp_cond','-append')
    [x, y] = system('gfortran QMR.f90');
    [x, y] = system('./a.out');
    y = str2num(y);
    if(isempty(y))
        det(a)
       disp('Encountered a Fatal Problem')          
       continue 
    end
    qmrr(it) = y;
end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');

end
toc;
  clf;
  plot(size_of_a,qmrr,'ko','LineWidth',2)
  hold on;
  plot(size_of_a,cgne,'ks')
  hold on
  grid minor
  %axis([0 max(size_of_a) 0 max(qmrr)])
  legend('QMR','CGNE','Location','Best');
  xlabel('Dimension');
  ylabel('Number of Iterations');
  saveas(gcf,strcat('qmr_dim_',num2str(N),'_',num2str(choice),'.png'))
  
