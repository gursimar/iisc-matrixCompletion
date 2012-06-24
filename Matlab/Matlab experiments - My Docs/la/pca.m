clc
clear
close all

r=1;
fro_th=0.05	% Frobinius norm threshold
lrate=0.003;    % learning rate


a=10* randn(1000,1);
b= randn(1000,1);
R = [cosd(15) -sind(15); sind(15) cosd(15)]
G = R *[a,b]';
[U S V] = svd(G);   % svd of the matrix
x= G (1,:);
y= G (2,:);

plot(a,b,'.')
ylim([-40,40])
xlim ([-40 40])
hold on
plot(x,y,'g.')
vectarrow ([0 0],40*U(:,1)')
hold on;
vectarrow ([0 0],40*U(:,2)')

% New method to display line ....
%LEAST SQUARES....
A = [ones(1000,1) G(1,:)']
ATA = A' * A
bn = G (2,:)'
ATB = A' * bn;
line  = inv (ATA) * ATB
hold all
xl = -40:0.1:40;
yl = line(1)  + line(2).*xl;

plot(xl,yl);


%% figure 2 just plotting the svd
[U S V] = svd(G);   % svd of the matrix
figure
G_svd = U * S* V';
plot (G_svd(1,:),G_svd(2,:),'.');
ylim([-40,40])
xlim ([-40 40])

VT = V';
G_svd_drop = U(:,1:r) * S(1:r,1:r) * VT(1:r,:);


%% figure 3 plotting by dropping columns
figure
plot (G_svd_drop(1,:),G_svd_drop(2,:),'.');
ylim([-40,40])
xlim ([-40 40])

% G is the matrix of original data
G_missing = G;

a = size(G);
u_approx_missing = randint (a(1),r,2);
v_approx_missing = randint (r,a(2),2);

% Approximation matrix for the original matrix
M_approx_missing = u_approx_missing * v_approx_missing;

%pause

% Do iterations and make corrections
k=0; % will count number of iterations
FRO_NORM_DIFF_MISSING =999;	% Resets the var for new computations(999 > fro_th)

%close all;

while(FRO_NORM_DIFF_MISSING>fro_th && k <3000)
    FRO_NORM_DIFF_MISSING = 0;	%resets the value
    for i = 1:a(1)
        for j = 1:a(2)
            %pause
            if G_missing(i,j) ~= 32 % assume 32 are missing enteries
                % make corrections
                err = G_missing(i,j) - (u_approx_missing(i,:) * v_approx_missing(:,j));
                c = u_approx_missing(i,:); 
                u_approx_missing(i,:) = u_approx_missing(i,:) + (err*lrate).* v_approx_missing(:,j)';
                v_approx_missing(:,j) = v_approx_missing(:,j) + (err*lrate).* c';
                FRO_NORM_DIFF_MISSING = FRO_NORM_DIFF_MISSING + err*err;
            end
        end
    end
    k=k+1 % this will calculate iterations

    M_approx_missing =u_approx_missing * v_approx_missing;
    %M_approx_missing=int8(M_approx_missing);
    %display (M_approx_missing-M)
    %image (M_approx_missing);
    %title (['After ' int2str(k)  ' iterations'])
    sum(sum((M_approx_missing-G).^2))
    %display(FRO_NORM_DIFF_MISSING);
    %pause
end
figure
plot (M_approx_missing(1,:),M_approx_missing(2,:),'.');
ylim([-40,40])
xlim ([-40 40])