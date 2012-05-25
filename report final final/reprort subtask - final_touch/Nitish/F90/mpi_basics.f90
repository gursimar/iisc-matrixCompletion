program pyarelal
INCLUDE 'mpif.h'
INTEGER :: i
INTEGER, DIMENSION(20) :: data
if (rank.eq.0) then
do i=1,10
data(i) = i*i
print*, 'zero : ',data(i)
end do
call MPI_SEND(data,100,MPI_REAL,1,20028,MPI_COMM_WORLD,err)
else

call MPI_RECV(value,200,MPI_REAL,MPI_ANY_SOURCE,20028,MPI_COMM_WORLD,status,err)
print *, "P:",rank," got data from processor ",status(MPI_SOURCE)
call MPI_GET_COUNT(status,MPI_REAL,count,err)
print *, "P:",rank," got ",count," elements"
print *, "P:",rank," value(5)=",value(5)
end if
end program pyarelal
