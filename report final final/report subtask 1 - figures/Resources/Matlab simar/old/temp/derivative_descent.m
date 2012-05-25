clear all
close all
x = -10:0.1:10;
y = x.*x;
alpha=0.06

plot(x,y)

hold all;

pt(1) = randint(1,1,[-10 10])

plot(pt(1),pt(1).*pt(1),'*')

i=2
while(1)
    pt(i) = pt(i-1) - (alpha*2*pt(i-1))
    plot(pt(i),pt(i).*pt(i),'*')
    i=i+1;
    pause
end