
program mataaa
implicit none
integer, parameter :: n=10
integer :: x,y
double precision,dimension(n) :: a,b
double precision :: c
double precision, external :: atlas_ddot

do x=1,n
print*,x
if(x.eq.7) then
exit
end if
end do
c=1
print*,c
end program mataaa
