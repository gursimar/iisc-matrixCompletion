function [cgnee qmrr] = cgnevsqmr_cond(choice,dim,N)
% CHOICE DIM N



clf;
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
%qmrr = zeros(1,N);
%size_of_a = zeros(1,N);
if(choice==1)
    
for it=1:N
    
    it
    a = rand(dim,dim);
    %a = vander(a);
    %a = a'*a;
    temp_cond = cond(a);
    condition_number(it) = cond(a);
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
        
    qmrr(it) = -0.1;
    else
        qmrr(it) = etime(clock,t);
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
       cgnee(it) = -0.1;
    else
    cgnee(it) = etime(clock,t);
    
    end
    toc;
    disp('CGNE Done : On To QMR');
end

elseif(choice==2)
    for it=1:N
    
    it
    a = rand(dim,1);
    a = vander(a);
    %a = a'*a;
    temp_cond = cond(a);
    condition_number(it) = cond(a);
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
        
    qmrr(it) = -0.1;
    else
        qmrr(it) = etime(clock,t);
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
       cgnee(it) = -0.1;
    else
    cgnee(it) = etime(clock,t);
    
    end
    toc;
    disp('CGNE Done : On To QMR');
end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');

end
toc;
  clf;
  
  semilogx(condition_number,qmrr,'ob','LineWidth',2)
  hold on;
  semilogx(condition_number,cgnee,'xr','LineWidth',2)
  hold on
  grid minor
  %axis([max(0,(strt-2)) (N+2) -0.1 max(max(qmrr),max(sqmrr))])
  legend('QMR','CGNE','Location','Best');
  xlabel('Condition Number');
  ylabel('Time for Completion');
      
  saveas(gcf,strcat('cgne_qmr_cond',num2str(dim),'_',num2str(choice),'.png'))
