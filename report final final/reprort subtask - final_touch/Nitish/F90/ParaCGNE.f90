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
DOUBLE PRECISION, EXTERNAL :: DNRM2,DDOT        
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

!r = b - MATMUL(a,x)
!ONLY BECAUSE x=0
r = b
d = r
rs_old = DDOT(n,r,1,r,1)
cnt = 0
DO
cnt = cnt+1
CALL DGEMV('N',n,n,1.0D+00,A,n,d,1,0.0D+00,ad,1)
!ad = MATMUL(a,d)
!if(i==n) then
!print*,'a:', a
!print*,'d:', d
!read*, k
!end if
alpha = rs_old/DDOT(n,ad,1,ad,1)
x = x + alpha * d
!PRINT *,'Iteration : ',cnt,'   ','x=', x
CALL DGEMV('T',n,n,1.0D+00,a,n,ad,1,0.0D+00,catch,1)
r  = r - alpha*catch
!r  = r - alpha*MATMUL(TRANSPOSE(a),ad)
rs_new = DDOT(n,r,1,r,1)


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


