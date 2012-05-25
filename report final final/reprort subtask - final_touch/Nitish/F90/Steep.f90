!Steepest Descent Method
!Nitish Keskar : Version 1.0 : 18/05/2011
!INTRINSIC FUNCTIONS USED MATMUL

!USE SAMPLE :  
! DECLARATIONS
PROGRAM STEEPEST_DESCENT
IMPLICIT NONE
INTEGER :: n,lt
INTEGER :: i,j,k,cnt
DOUBLE PRECISION, ALLOCATABLE :: a(:,:)
DOUBLE PRECISION, ALLOCATABLE :: x(:),b(:),r(:),catch(:),d(:),ar(:)
DOUBLE PRECISION :: alpha,t1,t2,beta,rs_old,rs_new
DOUBLE PRECISION, PARAMETER :: tolerance = 1.0e-8

!pRINT*
!pRINT*, "Solving AX = B"
!pRINT*

OPEN (UNIT = 1, file = "positive_definite.txt")
READ(1,*) n
ALLOCATE(a(n,n))
ALLOCATE(x(n))
ALLOCATE(b(n))
ALLOCATE(r(n))
ALLOCATE(d(n))
ALLOCATE(catch(n))
ALLOCATE(ar(n))
lt = n*n
!pRINT*
!pRINT*, "DIMENSION OF SQUARE MATRIX : ",n
!pRINT*

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
i=0

r = b - MATMULT(n,a,x)
!r = b - MATMUL(a,x)
DO 
i=i+1
!PRINT *,'Iteration : ',(i-1),'   ','x=', x
!pRINT*
ar = MATMUL(a,r)
!print*,'r = ', r(1),r(2),r(3)
t1 = DOT_PRODUCT(r,r)
IF(t1<tolerance) THEN
!pRINT*, 'CONVERGENCE ACHIEVED, NORM LESS THAN TOLERANCE'
EXIT
END IF
!print*,'t1', t1
t2 =  DOT_PRODUCT(r,ar)
!print*,'t2', t2

if(t2==0) then
print*, "FATAL ERROR"
return
end if


alpha = t1/t2
x = x + alpha * r

IF(MOD(i,lt)==0) THEN
!r= b - MATMUL(a,x)
r= b - MATMULT(n,a,x)
ELSE

r = r - alpha*ar
END IF
END DO
!pRINT*
!pRINT*, 'x = '
!pRINT*
!pRINT*,x
!pRINT*
PRINT*,(i-1)
!pRINT*,"Number of Iterations : ", (i-1)
!pRINT*


CONTAINS

FUNCTION MATMULT(dim,a,x)
  INTEGER :: dim
  DOUBLE PRECISION, DIMENSION(dim,dim) :: a
  DOUBLE PRECISION, DIMENSION(dim) :: x
  INTEGER ::i,j
  DOUBLE PRECISION, DIMENSION(dim) :: MATMULT

!$OMP PARALLEL DEFAULT(SHARED) PRIVATE(i,j)
!$OMP DO SCHEDULE (STATIC,dim/8) 
  do i=1, dim
    MATMULT(i)=0.0
    do j=1, dim
      MATMULT(i) = MATMULT(i) + a(i,j)*x(j)
    enddo
  enddo

!$OMP END DO
!$OMP END PARALLEL
END FUNCTION MATMULT

END PROGRAM STEEPEST_DESCENT

