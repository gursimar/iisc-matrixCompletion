PROGRAM p2p
INTEGER err, rank, size,cnt
real  :: data,a,x,y,pic,t1,t2
real value
integer count
call second(t1)
do cnt=1,5000000
x = rand()
y = rand()
a = x*x+y*y
a = sqrt(a)
if(a<1) then
pic = pic+1
end if
end do
pic = pic/5000000
pic=pic*4.0
print*,'SENDING',pic
call second(t2)
print*, (t2-t1)
END


