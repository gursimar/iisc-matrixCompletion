function X = steepcg_dim(choice,N)
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE 3 FOR HILBERT
cg = zeros(1,N);
steep = zeros(1,N);
condition_number = zeros(1,N);
size_of_a = zeros(1,N);
if(choice==1)
    for it=1:N
        it
        a = rand((it+2),(it+2));
        a = a'*a;
        size_of_a(it) = length(a);
        temp_cond = cond(a);
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        %save('positive_definite.txt','-ascii', '-double','size_of_a')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        save('condition_number.txt','-ascii', '-double','temp_cond','-append')
        [x y] = system('gfortran CG.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        cg(it) = y;
        
        [x y] = system('gfortran Steep.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        steep(it) = y;
        
    end
    
elseif(choice==2)
    for it=1:N
        it
        a = rand((it+2),1);
        a = vander(a);
        a = a'*a;
        size_of_a(it) = length(a);
        temp_cond = cond(a);
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        %save('positive_definite.txt','-ascii', '-double','size_of_a')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        save('condition_number.txt','-ascii', '-double','temp_cond','-append')
        [x y] = system('gfortran CG.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        cg(it) = y;
        
        [x y] = system('gfortran Steep.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        steep(it) = y;
        
    end
elseif (choice==3)
     for it=1:N
        it
        a = hilb(it+2);
        
        size_of_a(it) = length(a);
        temp_cond = cond(a);
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        %save('positive_definite.txt','-ascii', '-double','size_of_a')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        save('condition_number.txt','-ascii', '-double','temp_cond','-append')
        [x y] = system('gfortran CG.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        cg(it) = y;
        
        [x y] = system('gfortran Steep.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        steep(it) = y;
        
    end
    
else
        
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE) or 3(HILBERT)');

end
toc;
clf;
plot(size_of_a,cg,'ko','LineWidth',2)
hold on
grid minor
plot(size_of_a,steep,'ks','LineWidth',2)
axis([0 max(size_of_a) 0 max(steep)])
legend('CG','Steepest Descent','Location','Best');
xlabel('Dimension');
ylabel('Number of Iterations');
saveas(gcf,strcat('steepcg_dim_',num2str(N),'_',num2str(choice),'.png'))
