!CONJUGATE_GRADIENT METHOD
!Nitish Keskar : Version 1.0 : 18/05/2011
!INTRINSIC FUNCTIONS USED MATMUL

!Stuff to be done : Read from file


!USE SAMPLE :  
! DECLARATIONS
PROGRAM CONJUGATE_GRADIENT
IMPLICIT NONE
INTEGER, PARAMETER :: n=4
INTEGER :: i,j,k,cnt,no_use
DOUBLE PRECISION, DIMENSION(n,n) :: a
DOUBLE PRECISION, DIMENSION(n) :: x,b,r,catch,p,ap,q,s
DOUBLE PRECISION :: alpha,beta_t1,t2,beta,rs_old,rs_new
DOUBLE PRECISION, PARAMETER :: tolerance = 1.0e-8

PRINT*
PRINT*, "Solving AX = B"
PRINT*

OPEN (UNIT = 1, file = "positive_definite")
DO i=1,n
READ(1,*) (a(i,k),k=1,n)
END DO

!READ(1,*) (b(k),k=1,n)
b=1

PRINT*, "A = "
DO i=1,n
PRINT*, (a(i,k),k=1,n) 
END DO
PRINT*
PRINT*, "B = "
DO i=1,n
PRINT*, b(i)
END DO
PRINT*
PRINT*

!PRINT*, "Press Any Key To Continue"
!PRINT*
!READ*,no_use


!ALGORITHM BEGINS


x = 0 !Initial Guess
PRINT*, 'Initial Guess = Zero Vector'
PRINT*
r = b
p = r
q = r
s = r
rs_old = DOT_PRODUCT(s,r)
cnt = 0
DO
cnt = cnt+1
ap = MATMUL(a,p)
!if(i==n) then
!print*,'a:', a
!print*,'p:', p
!read*, k
!end if
alpha = DOT_PRODUCT(s,r)/DOT_PRODUCT(q,ap)!
x = x + alpha * p!
PRINT *,'Iteration : ',cnt,'   ','x=', x
r  = r - alpha*ap !
s  = s - alpha*MATMUL(TRANSPOSE(a),q) !
rs_new = DOT_PRODUCT(s,r) ! rs ps
beta = rs_new/rs_old

IF(SQRT(DOT_PRODUCT(r,r))<tolerance) THEN
PRINT*
PRINT*, "NORM LESSER THAN TOLERANCE, CONVERGENCE ACHIEVED";
EXIT
END IF

p = r + beta* p
q = s + beta* q
rs_old = rs_new

!if (i==n .OR. i==n-1) then
!print*,'ap = ',ap
!print*
!print*, 'alpha : ', alpha
!print*
!print*,'r = ',r
!print*
!print*,'p = ', p
!print*
!print*,'rs_old', rs_old
!print*
!end if
END DO

PRINT*
PRINT*, 'x = '
PRINT*
PRINT*,x
PRINT*
PRINT*,"Number of Iterations : ", (i-1)
PRINT*


!DO i=1,n
!PRINT*, (a(i,j), j =1,n)
!END DO
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


