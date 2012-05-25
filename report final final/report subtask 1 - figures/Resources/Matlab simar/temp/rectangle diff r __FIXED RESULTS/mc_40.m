clear all
clc
close all
tic

% Control variables
r=40;           % rank approximation (or latent features)
l_lim=80;     % Missing enteries limit (starting from 1) for the loop 
lrate=0.002;    % learning rate
mc_itr = 10000  % Monti carlo iterations
fro_th=0.05	% Frobinius norm threshold

% To construct image
%imageSizeX = 25;
%imageSizeY = 25;
%[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
% Next create the circle in the image.
%centerX = 12;
%centerY = 12;
%radius = 5;
%width = 5;
%M = 64.*( (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2 & (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 >=(radius-width).^2);

% To construct rectangle
a = 64 *  ones (9,1)
b = [64 64 64 0 0 0 64 64 64]
b = b'
c = [64 64 64 0 64 0 64 64 64]
c =c'
M = [a a a b c c  b a a a]
%subplot(2,2,1)
%image(M)	% Plot the original matrix

% End of control variables

a = size(M);
FRO_NORM_DIFF_MISSING =999;

for f=1:mc_itr
    tic
    for l = 1:5:l_lim
        % Construct the missing matrix by randomly removing enteries
        k = randperm(a(1)*a(2));
        k = k (1:l);
        
        M_missing = M;
        M_missing(k)=32;

        %image(M_missing)      % plot the missing matrix
        %title('Missing enteries')

         % Initialize two latent feature matrices with some random enteries
        M_approx_missing =  4* rand(a);
        u_approx_missing = [eye(a(1)) zeros(a(1),r-a(1))];
        v_approx_missing = [M_approx_missing; zeros(r-a(1),a(2))];

        %pause

        % Do iterations and make corrections
        k=0; % will count number of iterationsr=60;           % rank approximation (or latent feat
        FRO_NORM_DIFF_MISSING = 999;    % To reset it (999 is assigned to make it > fro_th).


        while(FRO_NORM_DIFF_MISSING>fro_th)
            FRO_NORM_DIFF_MISSING = 0;	%resets the value
            for i = 1:a(1)
                for j = 1:a(2)
                    %pause
                    if M_missing(i,j) ~= 32 % assume 32 are missing enteries so we can't calculate errors
                        % make corrections
                        err = M_missing(i,j) - (u_approx_missing(i,:) * v_approx_missing(:,j));
			c = u_approx_missing(i,:); 
                        u_approx_missing(i,:) = u_approx_missing(i,:) + (err*lrate).* v_approx_missing(:,j)';
                        v_approx_missing(:,j) = v_approx_missing(:,j) + (err*lrate).* c';
                        FRO_NORM_DIFF_MISSING = FRO_NORM_DIFF_MISSING + err*err;
                    end
                end
            end
            k=k+1; % this will calculate iterations

            M_approx_missing =u_approx_missing * v_approx_missing;
            %M_approx_missing=int8(M_approx_missing);
            %display (M_approx_missing-M)
            %image (M_approx_missing);
            %title (['After ' int2str(k)  ' iterations'])

            %display(FRO_NORM_DIFF_MISSING);
            %pause
        end

        FRO (f,l) = FRO_NORM_DIFF_MISSING;
        RMSE_missing(f,l) = sum(sum((M_approx_missing-M).^2  ))/l;
    end
    display ([num2str(f) ' ' 'Fraction done is  ' num2str(f/mc_itr)])
    toc
end

toc
plot((sum(RMSE_missing))./mc_itr)
title('RMSE of sparse matrix');
