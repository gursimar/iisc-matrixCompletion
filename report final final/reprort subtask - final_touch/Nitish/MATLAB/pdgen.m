for i=1:1:10000000
a = rand(4,4);
bp = eig(a);
bpc = .5*(bp+conj(bp));
b = min(bpc);
bb = min(bp);
if(b>0 && bp>0)
bp
b
chol(a)
a
break;
end
end
