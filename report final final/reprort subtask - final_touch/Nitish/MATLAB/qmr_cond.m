function X = qmr_cond(choice,dim,N)
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
qmrr = zeros(1,N);
if(choice==1)
    for it=1:N
        it
        a = rand(dim,dim);
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        [x y] = system('gfortran QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        qmrr(it) = y;
                
    end
elseif(choice ==2)
    for it=1:N
        it
        a = rand(dim,1);
        a = vander(a);
        %a = a'*a;
        %det(a)
        condition_number(it) = cond(a);
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        [x y] = system('gfortran QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
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
plot(condition_number,qmrr,'ko','LineWidth',2)
hold on
%plot(condition_number,steep,'ks','LineWidth',2)
grid minor
axis([0 median(condition_number) 0 max(qmrr)])
%legend('CG','Steepest Descent','Location','Best');
xlabel('Condition Number');
ylabel('Number of Iterations');
saveas(gcf,strcat('qmr_cond_',num2str(N),'_',num2str(choice),'.png'))
