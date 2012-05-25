program matm
use omp_lib
implicit none
integer, parameter :: n = 16200
integer :: i,j,k
double precision, dimension(n,n) :: a
double precision, dimension(n) :: x,b
integer  :: t1,t2

  integer incx
  integer incy
double precision :: alpha,beta,kachra
  integer lda
integer m
character trans
external :: dgemv
trans = 'N'
  alpha = 2.0D+00
  lda = n
  incx = 1
  beta = 3.0D+00
  incy = 1
do i=1,n
x(i) = i*1.0D+00
do j=1,n
a(i,j) = (i+j)*1.00D+00
end do
end do
call system_clock(t1)
b = matmul(a,x)
call system_clock(t2)
print*,"MATMUL  :", b(n/2), (t2-t1)

call system_clock(t1)
b = matmult(n,a,x) 
call system_clock(t2)
print*,"MATMULT :", b(n/2), (t2-t1)

call system_clock(t1)
call dgemv ( 'N', n, n,1.0D+00, a, n, x, 1, 1, b, 1 )
call system_clock(t2)
print*,"DGEMV   :",b(n/2), (t2-t1)

CONTAINS
FUNCTION MATMULT(dim,a,x)
  INTEGER :: dim
  double precision, DIMENSION(dim,dim) :: a
  double precision, DIMENSION(dim) :: x
  INTEGER ::i,j
  double precision, DIMENSION(dim) :: MATMULT
!$omp parallel 
!$omp workshare

  MATMULT(1:n) = matmul( a(1:n,1:n), x(1:n) )

!$omp end workshare

!$omp end parallel

END FUNCTION MATMULT
end program matm


