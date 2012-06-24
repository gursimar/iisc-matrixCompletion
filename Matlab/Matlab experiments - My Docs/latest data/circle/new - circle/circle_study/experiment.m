clear all
clc
load ('data_circle.mat')

r=4;

subplot (2,2,1)
image(M_np)
title('Original M');

subplot(2,2,2)
image(M_p)
title('Permutated M');

% Taking SVD approximation
[u_np s_np v_np] = svd(M_np);
v_tr_np = v_np';
M_com_np = u_np(:,1:r) * s_np(1:r,1:r) * v_tr_np(1:r,:);

% Taking SVD approximation
[u_p s_p v_p] = svd(M_p);
v_tr_p = v_p';
M_com_p = u_p(:,1:r) * s_p(1:r,1:r) * v_tr_p(1:r,:);

subplot(2,2,3)
image(M_com_np)
title (['Approximation ' num2str(r)])

subplot(2,2,4)
image(M_com_p)
title (['Approximation ' num2str(r)])

FRO_np = sqrt(sum(sum((M_np - M_com_np ).^2)))
FRO_p = sqrt(sum(sum((M_p - M_com_p ).^2)))

