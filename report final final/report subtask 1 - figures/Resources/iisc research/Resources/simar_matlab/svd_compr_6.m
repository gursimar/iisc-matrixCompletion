% This program evaluates accuracy curve of the approximated matrix with
% increasing sparseness
tic
%clear all
clc
%close all

% Control variables
r=80;    % rank approximation
l=8000;    % no of missing enteries
lrate=0.002;   %learning rate

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

%a = 64 *  ones (9,1)
%b = [64 64 64 0 0 0 64 64 64]
%b = b'
%c = [64 64 64 0 64 0 64 64 64]
%5c =c'
%M = [a a a b c c  b a a a]
%subplot(2,2,1)
%imagesc(M)

a = size(M);
FRO_NORM_DIFF_MISSING =999;

% Plot the original matrix
%subplot(2,2,1)
%image(M)
%title('Original image')
%colormap(gray)
[u, s ,v] = svd (M);

% Compressed image by dropping columns (SVD)
v_tr = v';
M_com = u(:,1:3) * s(1:3,1:3) * v_tr(1:3,:);
%subplot(2,2,2)
%imagesc (M_com)
%title('Only three singular values')
for f=1:25000
    for l = 1:90
        % Construct the missing matrix
        k = randint(l,1,(a(1)*a(2))-1)+1;
        M_missing = M;
        M_missing(k)=32;
        %subplot(2,2,2)
        %image(M_missing)      % plot the missing matrix
        %title('Missing enteries')

        % Plot the random image
        %u_approx = randint (a(1),r,3);
        %v_approx = randint (r,a(2),3);
        %M_approx = u_approx * v_approx;
        u_approx_missing = randint (a(1),r,3);
        v_approx_missing = randint (r,a(2),3);
        M_approx_missing = u_approx_missing * v_approx_missing;
        %max(M_approx)
        %subplot(2,2,3)
        %image(M_approx)
        %title('Starting point')
        %subplot(2,2,4)
        %image(M_approx)
        %title('Starting point-with missing')

        %pause

        % Do iterations and corrections
        k=0; % will count number of iterations

        while(FRO_NORM_DIFF_MISSING>0.05)
        %while(1)
            FRO_NORM_DIFF_MISSING = 0;
            for i = 1:a(1)
                for j = 1:a(2)
                    %pause
                    %err = lrate .* (M(i,j) - (u_approx(i,:) * v_approx(:,j)));
                    %u_approx(i,:) = u_approx(i,:) + err.* v_approx(:,j)';
                    %v_approx(:,j) = v_approx(:,j) + err.* u_approx(i,:)';

                    if M_missing(i,j) ~= 32 % assume 32 are missing enteries so we can't calculate errors
                        % make corrections
                        c = M_missing(i,j) - (u_approx_missing(i,:) * v_approx_missing(:,j));
                        err = lrate .* (M_missing(i,j) - (u_approx_missing(i,:) * v_approx_missing(:,j)));
                        u_approx_missing(i,:) = u_approx_missing(i,:) + err.* v_approx_missing(:,j)';
                        v_approx_missing(:,j) = v_approx_missing(:,j) + err.* u_approx_missing(i,:)';
                        FRO_NORM_DIFF_MISSING = FRO_NORM_DIFF_MISSING + c*c;
                    end
                end
            end
            k=k+1; % this will calculate iterations

            %M_approx = u_approx * v_approx;
            %subplot(2,2,3);
            %image (int8(M_approx));
            %title (['After ' int2str(k)  ' iterations'])
            %FRO_NORM_DIFF = norm(M,'fro') - norm (M_approx,'fro')

            M_approx_missing =u_approx_missing * v_approx_missing;
            %M_approx_missing=int8(M_approx_missing);
            %display (M_approx_missing-M)
            %subplot(2,2,4);
            %image (M_approx_missing);
            %title (['After ' int2str(k)  ' iterations'])

            %display(FRO_NORM_DIFF_MISSING);
            %pause
        end

        % These contain
        FRO (f,l) = FRO_NORM_DIFF_MISSING;
        RMSE_missing(f,l) = sum(sum((M_approx_missing-M).^2  ))/l;
        %RMSE(l) = sum(sum((M_approx-M).^2  ));
        FRO_NORM_DIFF_MISSING = 999;    % To reset it.
    end
    display (['Percentage done is  ' num2str(f) '  ' num2str(f/250)])
end

toc
%subplot(2,1,1)
plot((sum(RMSE_missing))./25000)
title('RMSE of sparse matrix');
%subplot(2,1,2)
%plot(RMSE)
%title('RMSE of dense matrix');