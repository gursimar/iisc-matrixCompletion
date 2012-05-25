function [CGNEr sCGNEr] = sc_cgne(choice,N,strt)
nii = 500;
if (nargin<3)
    strt=1;
end
clf;

%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
%CGNEr = zeros(1,N);
%size_of_a = zeros(1,N);
if(choice==1)
    ip=1;
for it=strt:nii:N
    
    it
    a = rand((it+2),(it+2));
    %a = vander(a);
    %a = a'*a;
    size_of_a(ip) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
   
   [x, y] = system('gfortran CGNE.f90 ');
   t=clock;  tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in CGNE')          
        
    CGNEr(ip) = -0.1;
    else
        CGNEr(ip) = etime(clock,t);
    end
    toc;
    disp('Serial Done : On To Parallel Mode');
    
    
    [x, y] = system('ifort -fp-model source  ParaCGNE.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in ParaCGNE')          
       sCGNEr(ip) = -0.1;
    else
    sCGNEr(ip) = etime(clock,t);
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
    
    
   [x, y] = system('gfortran CGNE.f90 ');
   t=clock; tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in CGNE')          
        
    CGNEr(ip) = -0.1;
    else
        CGNEr(ip) = etime(clock,t);
    end
    toc;
    disp('Serial Done : On To Parallel Mode');
    
    
    [x, y] = system('ifort -fp-model source  ParaCGNE.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in ParaCGNE')          
       sCGNEr(ip) = -0.1;
    else
    sCGNEr(ip) = etime(clock,t);
    end
    ip=ip + 1 ;
    toc;
    disp('Parallel Done : On To Serial Mode');
end
elseif(choice==3)
ip=1;
for it=strt:nii:N
    
    it
    a = hilb(it+2);
    %a = vander(a);
    %a = a'*a;
    size_of_a(ip) = length(a);
    temp_cond = cond(a);
    condition_number(it) = cond(a);
    dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
    %save('positive_definite.txt','-ascii', '-double','size_of_a')
    save('positive_definite.txt','-ascii', '-double','a','-append')
    
   
   [x, y] = system('gfortran CGNE.f90 ');
   t=clock;  tic;
   [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in CGNE')          
        
    CGNEr(ip) = -0.1;
    else
        CGNEr(ip) = etime(clock,t);
    end
    toc;
    disp('Serial Done : On To Parallel Mode');
    
    
    [x, y] = system('ifort -fp-model source  ParaCGNE.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32');
    t=clock;tic;
    [x, y] = system('./a.out ');
    y = str2num(y);
    if(isempty(y))
        cond(a)
        chol(a);
       disp('Encountered a Fatal Problem in ParaCGNE')          
       sCGNEr(ip) = -0.1;
    else
    sCGNEr(ip) = etime(clock,t);
    end
    ip=ip + 1 ;
    toc;
    disp('Parallel Done : On To Serial Mode');
end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');

end
spdup = CGNEr./sCGNEr;
  clf;
  %plot(size_of_a,CGNEr,'ob','LineWidth',2)
  %hold on;
  %plot(size_of_a,sCGNEr,'xr','LineWidth',2)
  %hold on
  plot(size_of_a,spdup,'ob','LineWidth',2)
  grid minor
  %axis([max(0,(strt-2)) (N+2) -0.1 max(max(CGNEr),max(sCGNEr))])
  %legend('CGNE','Parallel CGNE','Location','Best');
  xlabel('Dimension');
  %ylabel('Time for Completion');
  ylabel('SpeedUp Ratio');
  p1 = xlim;
  p2 = ylim;
  
  weird=CGNEr-sCGNEr;
  ana=0;
  for it=1:length(CGNEr)
      if(weird(it)<0)
          ana=ana+1;
      end
  end
    sprintf('Anamolies: %d',ana)
  saveas(gcf,strcat('sca_CGNE_',num2str(N),'_',num2str(choice),'.png'))
  
