function [condition_number] = thirddim(choice,dim,N)

l_lt = 9e9
u_lt = 1e10
clc;
tic;
%NITISH KESKAR :: JUNE 2nd 2011
%CHOICE 1 FOR NORMAL 2 FOR VANDERMONDE
condition_number = zeros(1,N);
qmrr = zeros(1,N);
if(choice==1)
    it=0
    while (it<N)
        b = linspace(1,dim,dim)';
        a = rand(dim,dim);
        
         if(cond(a)>l_lt && cond(a)<u_lt && det(a) ~= 0)
             %a = a'*a;
        %det(a)
        it=it+1
        condition_number(it) = cond(a);
       dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        save('rhs_positive_definite.txt','-ascii', '-double','b')
        [x y] = system('gfortran QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        qmrr(it) = y;
        [x y] = system('gfortran R_QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
nm = norm(inv(a)*b);
proxi(it) = y/nm;
         else
             
            %disp('Rejected');
             continue;
         end
    end
elseif(choice ==2)
    it=0
    while (it<N)
        b = linspace(1,dim,dim)';
       
        a = rand(dim,1);
        a = vander(a);
        cond(a);
         if(cond(a)>l_lt && cond(a)<u_lt && det(a) ~= 0)
             %a = a'*a;
        %det(a)
         it=it+1
        condition_number(it) = cond(a);
        
        dlmwrite('positive_definite.txt', length(a), 'delimiter', ' ','precision', '%.0f')
        save('positive_definite.txt','-ascii', '-double','a','-append')
        save('rhs_positive_definite.txt','-ascii', '-double','b')
        [x y] = system('gfortran QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        qmrr(it) = y;
 [x y] = system('gfortran R_QMR.f90');
        [x y] = system('./a.out');
        y = str2num(y);
        if(isempty(y))
            disp('Encountered a Fatal Problem')
            continue
        end
        %size(inv(a))
        %size(b)
nm = norm(inv(a)*b);
proxi(it) = y/nm;
         else
             
            %disp('Rejected');
             continue;
         end
    end
else
    disp('Choice Has To Be Either 1(NORMAL) or 2(VANDERMONDE)');
end
toc;
clf;
plot(proxi,qmrr,'ko','LineWidth',2)
hold on
%plot(condition_number,steep,'ks','LineWidth',2)
grid minor
%axis([0 median(condition_number) 0 max(qmrr)])
%legend('CG','Steepest Descent','Location','Best');
xlabel('Distance of Final Solution from Initial');
ylabel('Number of Iterations');
saveas(gcf,strcat('thirddim_',num2str(dim),'_',num2str(choice),'.png'))
