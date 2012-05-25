function [cgnee qmrr] = cgnevsqmr_dim(choice,N,strt)
nii = 1000;
dim_kitna = 20
dim_kitna_copy = dim_kitna
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
    ip=1;
for it=strt:nii:N
    
    for rep = 1:dim_kitna 
    it
    a = rand((it+2),(it+2));
    %a = vander(a);
    %a = a'*a;
    size_of_a(ip) = length(a);
    temp_cond = cond(a);
    condition_number(ip) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
    
   [x, y] = system('ifort QMR.f90 ');
   t=clock; tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        %chol(a);
       disp('Encountered a Fatal Problem in QMR')          
        t1(rep) = -0.1
    %qmrr(ip) = -0.1;
    else
        t1(rep) = etime(clock,t);
    end
    toc;
    disp('QMR Done : On To CGNE');
    
    [x, y] = system('ifort CGNE.f90');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        %chol(a);
       disp('Encountered a Fatal Problem in CGNE')          
       t2(rep) = -0.1;
       %cgnee(ip) = -0.1;
    else
    t2(rep) = etime(clock,t);

    end
    
    toc;
    disp('CGNE Done : On To QMR');
    end
    qmrr(ip) = sum(t1)/dim_kitna;
    cgnee(ip) = sum(t1)/dim_kitna;
    ip=ip + 1 ;
end

elseif(choice==2)
    ip=1;
for it=strt:nii:N
    
    it
    a = rand((it+2),1);
    a = vander(a);
    %a = a'*a;
    size_of_a(ip) = length(a);
    temp_cond = cond(a);
    condition_number(ip) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
    
   [x, y] = system('ifort QMR.f90 ');
   t=clock; tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        %chol(a);
       disp('Encountered a Fatal Problem in QMR')          
        
    qmrr(ip) = -0.1;
    else
        qmrr(ip) = etime(clock,t);
    end
    toc;
    disp('QMR Done : On To CGNE');
    
    [x, y] = system('ifort CGNE.f90');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        %chol(a);
       disp('Encountered a Fatal Problem in CGNE')          
       cgnee(ip) = -0.1;
    else
    cgnee(ip) = etime(clock,t);
    ip=ip + 1 ;
    end
    toc;
    disp('CGNE Done : On To QMR');
end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');

end
toc;
  clf;
  plot(size_of_a,qmrr,'ob','LineWidth',2)
  hold on;
  plot(size_of_a,cgnee,'xr','LineWidth',2)
  hold on
  grid minor
  %axis([max(0,(strt-2)) (N+2) -0.1 max(max(qmrr),max(sqmrr))])
  legend('QMR','Parallel QMR','Location','Best');
  xlabel('Dimension');
  ylabel('Time for Completion');  clf;
      
  saveas(gcf,strcat('cgne_qmr_',num2str(N),'_',num2str(choice),'.png'))
  
