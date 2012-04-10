clear all
close all
clc

a=[9 10]
l=20

for i=1:20000
    
    k = randperm(a(1)*a(2));
    k = k (1:l);
    result(:,i) = k;
end

