clear all
%close all
clc

a = ones (9,1)
b = [1 1 1 0 0 0 1 1 1]
b = b'
c = [1 1 1 0 1 0 1 1 1]
c =c'
M = [a a a b c c  b a a a]
subplot(2,2,1)
imagesc(M)
title('Original image')
colormap(gray)
[u, s ,v] = svd (M)


v_tr = v'
M_com = u(:,1:3) * s(1:3,1:3) * v_tr(1:3,:)
subplot(2,2,2)
imagesc (M)
title('Compressed image')


% new code date - 14 feb
a = size(M)
r=3;
u_approx = rand (a(1),r)
v_approx = rand (r,a(2))

M_approx = u_approx * v_approx
subplot(2,2,3)
imagesc(M_approx)
title('Compressed image - using iterations')

lrate=0.2


subplot(2,2,4)

k=0 % will count number of iterations
while(1)
    for i = 1:a(1)
        for j = 1:a(2)
            err = lrate .* (M(i,j) - (u_approx(i,:) * v_approx(:,j)));
            u_approx(i,:) = u_approx(i,:) + err.* v_approx(:,j)'
            v_approx(:,j) = v_approx(:,j) + err.* u_approx(i,:)'
%            u_approx(i,:) = u_approx(i,:) + err.* u_approx(i,:)
%            v_approx(:,j) = v_approx(:,j) + err.* v_approx(:,j)
            err
            %pause
        end
    end
    M_approx = u_approx * v_approx
    subplot(2,2,4)
    imagesc (M_approx)
    k=k+1;
    title (['After ' int2str(k)  ' iterations'])
    FRO_NORM_DIFF = norm(M,'fro') - norm (M_approx,'fro')
    pause
end
