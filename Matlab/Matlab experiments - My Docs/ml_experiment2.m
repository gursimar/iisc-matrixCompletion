x1 = -10:0.5:10;
x0 = ones (size(x1))
x = [x0' x1']
theta0 = -10:0.5:10
theta1 = -10:0.5:10
[T0 T1] = meshgrid(theta0, theta1);

