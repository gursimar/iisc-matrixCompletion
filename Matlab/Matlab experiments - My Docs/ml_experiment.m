%% Why we need three parameters to represent line in logistic regression
% while in linear regression we need only two of them. Also we need only
% two parameters to represent line (two points in 3d will represent a
% unique line).

% Answer: In logistic regression what is have is actually a plane rather
% than a line, inclination of that plane will decide how fast the
% probability will change as distane of x chnages from the logistic
% regression line corresponding to z=0. Because its a plane rather than a
% line, so we need three parameters.


theta0 =  -3
theta1 = 1
theta2 = 1

x1 = -10:1.5:10;
x2 = -10:1.5:10;
[X1 X2] = meshgrid(x1,x2);

Z1 = theta0 + theta1 *X1 + theta2*X2;

surf(X1,X2,Z1)
hold on;
% draw axis
h = line ([-10 10],[0 0],[0 0])
set(h,'Color','k','LineWidth',2)
h = line ([0 0],[-10 10],[0 0])
set(h,'Color','k','LineWidth',2)
h = line ([0 0],[0 0],[-30 30])
set(h,'Color','k','LineWidth',2)
rotate3d;

%% Different thetas
theta0 =  -12
theta1 = 4
theta2 = 4


x1 = -10:1.5:10;
x2 = -10:1.5:10;
[X1 X2] = meshgrid(x1,x2);

Z2 = theta0 + theta1 *X1 + theta2*X2;
surf(X1,X2,Z2)

%% Yet another thetas corresponding to same lines
theta0 =  -36
theta1 = 12
theta2 = 12


x1 = -10:1.5:10;
x2 = -10:1.5:10;
[X1 X2] = meshgrid(x1,x2);

Z3 = theta0 + theta1 *X1 + theta2*X2;
surf(X1,X2,Z3)


%% Plot of sigmoid ranges
figure
Z1 = 1 ./ (1+ exp(-Z1));
Z2 = 1 ./ (1+ exp(-Z2));
Z3 = 1 ./ (1+ exp(-Z3));


surf(X1,X2,Z1)
hold on;
%surf(X1,X2,Z2)
surf(X1,X2,Z3)
rotate3d
