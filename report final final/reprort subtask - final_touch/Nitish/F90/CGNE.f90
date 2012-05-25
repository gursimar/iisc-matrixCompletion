!CONJUGATE_GRADIENT METHOD
!Nitish Keskar : Version 1.0 : 18/05/2011
!INTRINSIC FUNCTIONS USED MATMUL

!Stuff to be done : Read from file


!USE SAMPLE :  
! DECLARATIONS
PROGRAM CONJUGATE_GRADIENT
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

!a = MATMUL(transpose(a),a)
!b = MATMUL(transpose(a),b)
x = 0 !Initial Guess
!PRINT*, 'Initial Guess = Zero Vector'
!PRINT*

r = b - MATMUL(a,x)
d = r
rs_old = DOT_PRODUCT(r,r)
cnt = 0
DO
cnt = cnt+1

ad = MATMUL(a,d)
!if(i==n) then
!print*,'a:', a
!print*,'d:', d
!read*, k
!end if
alpha = rs_old/DOT_PRODUCT(ad,ad)
x = x + alpha * d
!PRINT *,'Iteration : ',cnt,'   ','x=', x
r  = r - alpha*MATMUL(TRANSPOSE(a),ad)
rs_new = DOT_PRODUCT(r,r)


IF(SQRT(rs_new)<tolerance) THEN
!PRINT*
!PRINT*, "NORM LESSER THAN TOLERANCE, CONVERGENCE ACHIEVED";
EXIT
END IF

d = r + rs_new/rs_old* d
rs_old = rs_new

!if (i==n .OR. i==n-1) then
!print*,'ad = ',ad
!print*
!print*, 'alpha : ', alpha
!print*
!print*,'r = ',r
!print*
!print*,'d = ', d
!print*
!print*,'rs_old', rs_old
!print*
!end if
END DO
!PRINT*
!PRINT*, 'x = '
!PRINT*
!PRINT*,x
!PRINT*
PRINT*,(i-1)
!PRINT*,"Number of Iterations : ", (i-1)
!PRINT*


!DO i=1,n
!PRINT*, (a(i,j), j =1,n)
!END DO

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

END PROGRAM CONJUGATE_GRADIENT



!SUBROUTINE DOT_PR(v1,v2,v)
!IMPLICIT NONE
!INTEGER, PARAMETER :: n=3
!INTEGER :: i,j,k
!DOUBLE PRECISION, INTENT(IN), DIMENSION (n) :: v1
!DOUBLE PRECISION, INTENT(IN), DIMENSION (n) :: v2
!DOUBLE PRECISION, INTENT(OUT) :: v
!DOUBLE PRECISION :: ans=0
!ans = 0
!print*, "ans init", ans
!DO i=1,n
!ans = ans + v1(i)*v2(i)
!print*, "ans = ",ans, "i = ", i;
!END DO
!v=ans
!print*,"V ",v;
!v = SQRT(v)
!print*,"V sqrt",v;
!END SUBROUTINE DOT_PR


