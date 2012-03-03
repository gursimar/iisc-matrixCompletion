% Experimen to prove that my random entery(in matrix) generator is not
% correct
clear all
clc
%close all

% Control variables
lrate=0.002;   %learning rate
l=8;

M = 64 * ones(9,10);
%subplot(2,2,1)
%imagesc(M)

a = size(M);
FRO_NORM_DIFF_MISSING =999;

for f=1:25000
    for l = 1:90
        tic
        % Construct the missing matrix
        k = randint(l,1,(a(1)*a(2))-1)+1;
        M_missing = M;
        M_missing(k)=0;            

        FRO (f,l) = sum(sum((M-M_missing).^2));
    end
    display (['Percentage done is  ' num2str(f)])
end

%subplot(2,1,1)
plot(sum(FRO)./25000);
title('Frobinius norm difference between original and sparse matrix');
%subplot(2,1,2)
%plot(RMSE)
%title('RMSE of dense matrix');
