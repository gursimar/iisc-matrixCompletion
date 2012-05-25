!PARALLEL CONJUGATE_GRADIENT METHOD
!Nitish Keskar : Version 1.0 : 18/05/2011
!INTRINSIC FUNCTIONS USED MATMUL

!Stuff to be done : Read from file


!USE SAMPLE :  
! DECLARATIONS
PROGRAM CONJUGATE_GRADIENT_P
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
b=1

!PRINT*, "A = "
!DO i=1,n
!PRINT*, (a(i,k),k=1,n) 
!END DO
!PRINT*
!PRINT*, "B = "
!DO i=1,n
!PRINT*, b(i)
!END DO
!PRINT*
!PRINT*

!ALGORITHM BEGINS


x = 0 !Initial Guess
!PRINT*, 'Initial Guess = Zero Vector'
!PRINT*

r = b - MATMUL(a,x)
d = r
rs_old = DOT_PR(n,r,r)
cnt = 0
DO
cnt = cnt+1

ad = MATMUL(a,d)


alpha = rs_old/DOT_PR(n,d,ad)
x = x + alpha * d
r  = r - alpha*ad
rs_new = DOT_PR(n,r,r)


IF(SQRT(rs_new)<tolerance) THEN
EXIT
END IF
d = r + rs_new/rs_old* d
rs_old = rs_new
END DO
PRINT*,(i-1)

CONTAINS

FUNCTION MATMULT(dim,a,x)
  IMPLICIT NONE
  INTEGER :: dim
  DOUBLE PRECISION, DIMENSION(dim,dim) :: a
  DOUBLE PRECISION, DIMENSION(dim) :: x
  INTEGER ::i,j
  DOUBLE PRECISION, DIMENSION(dim) :: MATMULT

!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j)
!$OMP DO SCHEDULE (DYNAMIC,dim/8) 
  do i=1, dim
    MATMULT(i)=0.0
    do j=1, dim
      MATMULT(i) = MATMULT(i) + a(i,j)*x(j)
    enddo
  enddo
!$OMP END DO
!$OMP END PARALLEL
END FUNCTION MATMULT


FUNCTION DOT_PR(dim,v1,v2)
IMPLICIT NONE
INTEGER :: i,j,k,dim
DOUBLE PRECISION, DIMENSION (dim) :: v1
DOUBLE PRECISION, DIMENSION (dim) :: v2
DOUBLE PRECISION :: DOT_PR
DOUBLE PRECISION :: ans
ans = 0

!!$OMP  PARALLEL DEFAULT(SHARED) PRIVATE(i)
!!$OMP DO SCHEDULE(DYNAMIC,dim/8) REDUCTION(+:ans)
DO i=1,dim
ans = ans + v1(i)*v2(i)
END DO
!!$OMP END DO NOWAIT
!!$OMP END PARALLEL
DOT_PR=ans
END FUNCTION DOT_PR

END PROGRAM CONJUGATE_GRADIENT_P

