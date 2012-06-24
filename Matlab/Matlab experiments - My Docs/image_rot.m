im1 = imread('a.png');imshow(im1);    
[m,n,p]=size(im1);
thet = rand(1);
m1=m*cos(thet)+n*sin(thet);
n1=m*sin(thet)+n*cos(thet);    

for i=1:m
    for j=1:n
       t = uint16((i-m/2)*cos(thet)-(j-n/2)*sin(thet)+m1/2);
       s = uint16((i-m/2)*sin(thet)+(j-n/2)*cos(thet)+n1/2);
       if t~=0 && s~=0           
        im2(t,s,:)=im1(i,j,:);
       end
    end
end
figure;
imshow(im2);
