function X = steepcg_cond(choice,dim,N)
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE) or 3(HILBERT)
cg = zeros(1,N);
steep = zeros(1,N);
condition_number = zeros(1,N);

if(choice==1)
    for it=1:N
        it
        a = rand(dim,dim);
        a = a'*a;
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
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
elseif(choice ==2)
    for it=1:N
        it
        a = rand(dim,1);
        a = vander(a);
        a = a'*a;
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
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
        a = hilb(dim);
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
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
plot(condition_number,cg,'ko','LineWidth',2)
hold on
plot(condition_number,steep,'ks','LineWidth',2)
grid minor
axis([0 median(condition_number) 0 median(steep)])
legend('CG','Steepest Descent','Location','Best');
xlabel('Condition Number');
ylabel('Number of Iterations');
saveas(gcf,strcat('steepcg_cond_',num2str(N),'_',num2str(choice),'.png'))

