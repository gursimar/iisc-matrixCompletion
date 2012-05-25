PROGRAM p2p
!Run with two processes
INCLUDE 'mpif.h'
INTEGER err, rank, size,cnt
!Program Output
double precision  :: data,a,x,y,pic
!P: 0 Got data from processor 1
!P: 0 Got 100 elements
DOUBLE PRECISION value
!P: 0 value[5]=3.
integer status(MPI_STATUS_SIZE)
integer count
CALL MPI_INIT(err)
CALL MPI_COMM_RANK(MPI_COMM_WORLD,rank,err)
CALL MPI_COMM_SIZE(MPI_COMM_WORLD,size,err)
!call MPI_SEND(data,100,MPI_DOUBLE_PRECISION,0,55,MPI_COMM_WORLD,err)
!call MPI_RECV(data,1,MPI_DOUBLE_PRECISION,MPI_ANY_SOURCE,55,MPI_COMM_WORLD,status,err)

if(rank.eq.0) then
!call MPI_RECV(data,1,MPI_DOUBLE_PRECISION,MPI_ANY_SOURCE,55,MPI_COMM_WORLD,status,err)
print*,"RECIEVED",data
else
print*,"I AM ", rank
do cnt=1,500
print*,cnt
x = rand()
y = rand()
a = x*x+y*y
a = sqrt(a)
if(a<1) then
pic = pic+1
end if
end do
pic = pic/500
pic=pic*4.0
print*,'SENDING',pic
end if
call MPI_SEND(pic,1,MPI_DOUBLE_PRECISION,0,55,MPI_COMM_WORLD,err)
CALL MPI_FINALIZE(err)
END


