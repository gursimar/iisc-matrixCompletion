% to check the curve for circle (rank dont matter, take it enough). 

clear all
clc
close all
tic

% Control variables
r=260;           % rank approximation (or latent features)
l_lim=2000;     % Missing enteries limit (starting from 1) for the loop 
lrate=0.002;    % learning rate
mc_itr = 13000  % Monti carlo iterations
fro_th=0.05	% Frobinius norm threshold

 %To construct image
imageSizeX = 50;
imageSizeY = 50;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
 %Next create the circle in the image.
centerX = 25;
centerY = 25;
radius = 15;
width = 10;
M = 64.*( (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 <= radius.^2 & (rowsInImage - centerY).^2 + (columnsInImage - centerX).^2 >=(radius-width).^2);


% To construct rectangle
%a = 64 *  ones (9,1)
%b = [64 64 64 0 0 0 64 64 64]
%b = b'
%c = [64 64 64 0 64 0 64 64 64]
%c =c'
%M = [a a a b c c  b a a a]
%subplot(2,2,1)
%image(M)	% Plot the original matrix

% End of control variables

a = size(M);


for f=1:mc_itr
    tic
    for l = 100:100
        % Construct the missing matrix by randomly removing enteries
        k = randperm(a(1)*a(2));
        k = k (1:l);
        
        M_missing = M;
        M_missing(k)=32;

        %image(M_missing)      % plot the missing matrix
        %title('Missing enteries')

        % Initialize two latent feature matrices with some random enteries
        u_approx_missing = randint (a(1),r,3);
        v_approx_missing = randint (r,a(2),3);

        % Approximation matrix for the original matrix
        M_approx_missing = u_approx_missing * v_approx_missing;
        
        %pause

        % Do iterations and make corrections
        k=0; % will count number of iterations
        FRO_NORM_DIFF_MISSING =999;	% Resets the var for new computations(999 > fro_th)
        
        while(FRO_NORM_DIFF_MISSING>fro_th)
            FRO_NORM_DIFF_MISSING = 0;	%resets the value
            for i = 1:a(1)
                for j = 1:a(2)
                    if M_missing(i,j) ~= 32 % assume 32 are missing enteries
                        % make corrections
                        err = M_missing(i,j) - (u_approx_missing(i,:) * v_approx_missing(:,j));
                        c = u_approx_missing(i,:); 
                        u_approx_missing(i,:) = u_approx_missing(i,:) + (err*lrate).* v_approx_missing(:,j)';
                        v_approx_missing(:,j) = v_approx_missing(:,j) + (err*lrate).* c';
                        FRO_NORM_DIFF_MISSING = FRO_NORM_DIFF_MISSING + err*err;
                    end
                end
            end
            %pause
            k=k+1; % this will calculate iterations

            M_approx_missing =u_approx_missing * v_approx_missing;
            %M_approx_missing=int8(M_approx_missing);
            %display (M_approx_missing-M)
            %image (M_approx_missing);
            %title (['After ' int2str(k)  ' iterations'])

            %display(FRO_NORM_DIFF_MISSING);
            %pause
        end
        %pause

        % Store the results
    end
    
    K(f) = k;
    RMSE_missing(f) = sum(sum((M_approx_missing-M).^2  ))/l;
    toc
    display ([num2str(f) ' ' 'Fraction done is  ' num2str(f/mc_itr)])
end

toc