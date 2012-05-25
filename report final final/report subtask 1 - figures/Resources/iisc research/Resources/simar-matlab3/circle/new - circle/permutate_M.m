clear all
clc

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
a = size(M);
rank(M)
norm(M,'fro')
image(M)
figure
% To permutate M randomly


for i = 1:50
    k = randperm(a(1));
    k = k(1:2);
    temp = M(k(1),:);
    M(k(1),:) = M(k(2),:);
    M(k(2),:) =temp;
end
rank(M)
norm(M,'fro')
image(M)