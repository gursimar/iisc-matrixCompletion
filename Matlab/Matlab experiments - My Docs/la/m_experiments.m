clear all
close all

t = -5*pi:0.1:5*pi;

z = t/2;
x = 1.5 * cos(t);
y = 1.5 *  sin(t);
M = [x;y;z];
plot3(M(1,:),M(2,:),M(3,:),'LineWidth',1.5)

xlim([-10 10])
ylim([-10 10])
zlim([-10 10])
%grid on

hold on;
H = line ([-10 10],[0 0]);
set (H,'color','k','LineWidth',1.5)
H = line ([0 0],[-10 10]);
set (H,'color','k','LineWidth',1.5)
H = line ([0 0],[0 0],[-10 10]);
set (H,'color','r','LineWidth',1.5)

xlabel ('x')
ylabel ('y')
zlabel ('z')
text (11,0,'x')
text (-11,0,'x')
text (0,11,'y')
text (0,-11,'y')
text (0,0,11,'z')
text (0,0,-11,'z')
rotate3d

% here you can plot more such spirals..

a = pi/2;
T = [ 1 0 0; 0 cos(a) -sin(a); 0 sin(a) cos(a)]

%T = [ 0.7071 0 -0.7071; 0 1 0; 0.7071 0 0.7071]

hold on;

S = T*M

plot3(S(1,:),S(2,:),S(3,:),'m','LineWidth',1.5)
