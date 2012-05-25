function [qmrr pqmrr] = sc_qmr(choice,N,strt)
nii = 500;
if (nargin<3)
    strt=1;
end

clf;

%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
%qmrr = zeros(1,N);
%size_of_a = zeros(1,N);
if(choice==1)
    ip=1;
for it=strt:nii:N
    
    it
    a = rand((it+2),(it+2));
    %a = vander(a);
    a = a'*a;
    size_of_a(ip) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
    
   [x, y] = system('gfortran QMR.f90 ');
   t=clock; tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        chol(a);
       disp('Encountered a Fatal Problem in QMR')          
        
    qmrr(ip) = -0.1;
    else
        qmrr(ip) = etime(clock,t);
    end
    toc;
    disp('Serial Done : On To Parallel Mode');
    
    
    [x, y] = system('ifort -fp-model source ParaQMR.f90 -xSSE3 -L$MKLROOT/lib/ia32  -lmkl_blas95  -Wl,--start-group -lmkl_intel -lmkl_intel_thread -lmkl_core -Wl,--end-group -liomp5 -lpthread -m32');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        chol(a);
       disp('Encountered a Fatal Problem in ParaQMR')          
       pqmrr(ip) = -0.1;
    else
    pqmrr(ip) = etime(clock,t);
    end
    ip=ip + 1 ;
    toc;
    disp('Parallel Done : On To Serial Mode');
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
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
    
   [x, y] = system('gfortran QMR.f90 ');
   t=clock; tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        chol(a);
       disp('Encountered a Fatal Problem in QMR')          
        
    qmrr(ip) = -0.1;
    else
        qmrr(ip) = etime(clock,t);
    end
    toc;
    disp('Serial Done : On To Parallel Mode');
    
    
    [x, y] = system('ifort -fp-model source ParaQMR.f90 -xSSE3 -L$MKLROOT/lib/ia32  -lmkl_blas95  -Wl,--start-group -lmkl_intel -lmkl_intel_thread -lmkl_core -Wl,--end-group -liomp5 -lpthread -m32');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        det(a)
        chol(a);
       disp('Encountered a Fatal Problem in ParaQMR')          
       pqmrr(ip) = -0.1;
    else
    pqmrr(ip) = etime(clock,t);
    end
    ip=ip + 1 ;
    toc;
    disp('Parallel Done : On To Serial Mode');
end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');

end
spdup = qmrr./pqmrr;
  clf;
  plot(size_of_a,spdup,'ob','LineWidth',2)
  %plot(size_of_a,qmrr,'ob','LineWidth',2)
  %hold on;
  %plot(size_of_a,pqmrr,'xr','LineWidth',2)
  hold on
  grid minor
  %axis([max(0,(strt-2)) (N+2) -0.1 max(max(qmrr),max(pqmrr))])
  %legend('QMR','Parallel QMR','Location','Best');
  xlabel('Dimension');
  %ylabel('Time for Completion');
  ylabel('SpeedUp Ratio');
  p1 = xlim;
  p2 = ylim;
  
  weird=qmrr-pqmrr;
  ana=0;
  for it=1:length(qmrr)
      if(weird(it)<0)
          ana=ana+1;
      end
  end
    sprintf('Anamolies: %d',ana)
  saveas(gcf,strcat('sca_qmr_',num2str(N),'_',num2str(choice),'.png'))
  
