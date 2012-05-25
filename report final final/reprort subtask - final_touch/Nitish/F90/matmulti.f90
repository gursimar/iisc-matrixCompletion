!CONJUGATE_GRADIENT METHOD
!Nitish Keskar : Version 1.0 : 18/05/2011
!INTRINSIC FUNCTIONS USED MATMUL
!Stuff to be done : Read from file
!USE SAMPLE :  
! DECLARATIONS
PROGRAM MATMULTI
IMPLICIT NONE
INTEGER :: n
INTEGER :: i,j,k,cnt
DOUBLE PRECISION, ALLOCATABLE :: a(:,:)
DOUBLE PRECISION, ALLOCATABLE :: x(:),b(:),r(:),catch(:),d(:),ad(:)
DOUBLE PRECISION :: alpha,t1,t2,beta,rs_old,rs_new
DOUBLE PRECISION, PARAMETER :: tolerance = 1.0e-8

!PRINT*
!PRINT*, "Solving AX = B"
!PRINT*

OPEN (UNIT = 1, file = "positive_definite.txt")
READ(1,*) n
ALLOCATE(a(n,n))
ALLOCATE(x(n))
ALLOCATE(b(n))
ALLOCATE(r(n))
ALLOCATE(d(n))
ALLOCATE(catch(n))
ALLOCATE(ad(n))
!PRINT*
!PRINT*, "DIMENSION OF SQUARE MATRIX : ",n
!PRINT*
DO i=1,n
READ(1,*) (a(i,k),k=1,n)
END DO

!READ(1,*) (b(k),k=1,n)
do i=1,n
b(i) = i*i*i*i
end do

x = matmult(n,a,b)
!x = matmul(a,b)
print*,x(n)
CONTAINS

FUNCTION MATMULT(dim,a,x)
  INTEGER :: dim
  DOUBLE PRECISION, DIMENSION(dim,dim) :: a
  DOUBLE PRECISION, DIMENSION(dim) :: x
  INTEGER ::i,j
  DOUBLE PRECISION, DIMENSION(dim) :: MATMULT

!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j,dim)
!$OMP DO
  do i=1, dim
    MATMULT(i)=0.0
    do j=1, dim
      MATMULT(i) = MATMULT(i) + a(i,j)*x(j)
    enddo
  enddo

!$OMP END DO
!$OMP END PARALLEL
END FUNCTION MATMULT

END PROGRAM MATMULTI


