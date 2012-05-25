a = ones (9,1)
b = [1 1 1 0 0 0 1 1 1]
b = b'
c = [1 1 1 0 1 0 1 1 1]
c =c'
M = [a a a b c  c  b a a a]
imagesc(M)
colormap(gray)
[u, s ,v] = svd (M)


v_tr = v'
M_com = u(:,1:3) * s(1:3,1:3) * v_tr(1:3,:)
figure
imagesc (M)