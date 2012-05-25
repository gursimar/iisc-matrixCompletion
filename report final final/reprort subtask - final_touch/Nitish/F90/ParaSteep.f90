!Parallel Steepest Descent Method
!Nitish Keskar : Version 1.0 : 7/06/2011
!INTRINSIC FUNCTIONS USED MATMUL

!USE SAMPLE :  
! DECLARATIONS
PROGRAM STEEPEST_DESCENT
IMPLICIT NONE
INTEGER :: n,lt,cml
INTEGER :: i,j,k,cnt
DOUBLE PRECISION, ALLOCATABLE :: a(:,:)
DOUBLE PRECISION, ALLOCATABLE :: x(:),b(:),r(:),d(:),ar(:)
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
ALLOCATE(ar(n))
lt = n*n

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


DO
i=i+1
!PRINT *,'Iteration : ',(i-1),'   ','x=', x

!$OMP PARALLEL DEFAULT(SHARED)
!$OMP FLUSH  (a,r,t1,t2)
!$OMP SECTIONS


!$OMP SECTION
ar = MATMULT(n,a,r)

!$OMP SECTION
t1 = DOT_PRODUCT(r,r)

!$OMP END SECTIONS NOWAIT
!$OMP END PARALLEL
!$OMP FLUSH  (a,r,t1,t2)

t2 =  DOT_PRODUCT(r,ar)



IF(t1<tolerance) THEN
!PRINT*, 'CONVERGENCE ACHIEVED, NORM LESS THAN TOLERANCE'
EXIT
END IF

if(t2==0) then
print*, "FATAL ERROR : DIVIDE BY ZERO"
return
end if


alpha = t1/t2
x = x + alpha * r

IF(MOD(i,lt)==0) THEN
r= b - MATMULT(n,a,x)
ELSE

r = r - alpha*ar
END IF
END DO
PRINT*,(i-1)

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
