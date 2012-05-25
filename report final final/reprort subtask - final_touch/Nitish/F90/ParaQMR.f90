PROGRAM QMR
!MOSTLY BLAS

!function [x, error, iter, flag] = qmr( A, x, b, M, max_it, tol )

!  -- Iterative template routine --
!     Univ. of Tennessee and Oak Ridge National Laboratory
!     October 1, 1993
!     Details of this algorithm are described in "Templates for the
!     Solution of Linear Systems: Building Blocks for Iterative
!     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
!     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
!     1993. (ftp netlib2.cs.utk.edu cd linalg get templates.ps).
!
!  [x, error, iter, flag] = qmr( A, x, b, M, max_it, tol )
!
! qmr.m solves the linear system Ax=b using the 
! Quasi Minimal Residual Method with preconditioning.
!
! input   A        REAL matrix
!         x        REAL initial guess vector
!         b        REAL right hand side vector
!         M        REAL preconditioner
!         max_it   INTEGER maximum number of iterations
!         tol      REAL error tolerance
!
! output  x        REAL solution vector
!         error    REAL error norm
!         iter     INTEGER number of iterations performed
!         flag     INTEGER: 0: solution found to tolerance
!                           1: no convergence given max_it
!                     exitdown:
!                          -1: rho
!                          -2: beta
!                          -3: gamma
!                          -4: delta
!                          -5: ep
!                          -6: xi
IMPLICIT NONE
INTEGER :: n
INTEGER :: iter,flag,j,k,cnt,no_use
DOUBLE PRECISION, ALLOCATABLE :: a(:,:)
DOUBLE PRECISION, ALLOCATABLE :: x(:),b(:),r(:),catch(:),p(:),ap(:),q(:),s(:),v_tld(:),&
w_tld(:),z(:),y_tld(:),z_tld(:),p_tld(:),d(:),y(:),v(:),w(:)
DOUBLE PRECISION :: alpha,beta,gamma,rho,xi,eta,theta,t2,rs_old,rs_new,bnrm2,ep,gamma_1,theta_1,delta,rho_1,error
DOUBLE PRECISION, EXTERNAL :: DNRM2,DDOT
DOUBLE PRECISION, PARAMETER :: tol = 1.0e-8


!PRINT*
!PRINT*, "Solving AX = B"
!PRINT*

OPEN (UNIT = 1, file = "positive_definite.txt")
READ(1,*) n

ALLOCATE(a(n,n))
ALLOCATE(x(n))
ALLOCATE(b(n))
ALLOCATE(r(n))
ALLOCATE(p(n))
ALLOCATE(catch(n))
ALLOCATE(ap(n))
ALLOCATE(q(n))
ALLOCATE(s(n))
ALLOCATE(v_tld(n))
ALLOCATE(w_tld(n))
ALLOCATE(z(n))
ALLOCATE(y_tld(n))
ALLOCATE(z_tld(n))
ALLOCATE(d(n))
ALLOCATE(y(n))
ALLOCATE(v(n))
ALLOCATE(w(n))
ALLOCATE(p_tld(n))


OPEN (UNIT = 1, file = "positive_definite.txt")
DO iter=1,n
READ(1,*) (a(iter,k),k=1,n)
END DO

!READ(1,*) (b(k),k=1,n)
b=1

!PRINT*, "A = "
!DO iter=1,n
!PRINT*, (a(iter,k),k=1,n) 
!END DO
!PRINT*
!PRINT*, "B = "
!DO iter=1,n
!PRINT*, b(iter)
!END DO
!PRINT*
!PRINT*

   iter = 0                                   ! initialization
   flag = 0

   bnrm2 = DNRM2(n,b,1)

if  ( bnrm2 .eq. 0.0 ) then
bnrm2 = 1.0 
PRINT*,iter
!PRINT*, "Exiting : Initial Solution is the Answer"
stop !kyapata
end if

!CALL DGEMV('N',n,n,1.0D+00,A,n,x,1,0.0D+00,catch,1)
   r = b - MATMUL(A,x)
   error = DNRM2(n,r,1)/ bnrm2
   
if ( error < tol ) then
!PRINT*, "Convergence Achieved : Residual Error Less than Tolerance"
stop
end if

!REMOVED FOR NOW. BRING IN LATER. NITISH

!   [M1,M2] = lu( M ) !LU DECOMPOSITION

v_tld = r
y = v_tld
rho = DNRM2(n,y,1)

   w_tld = r
   z = w_tld
   xi = DNRM2(n,z,1)

   gamma =  1.0
   eta = -1.0
   theta =  0.0

DO iter=1,n*n                      ! begin iteration

if ( rho .eq. 0.0 .or. xi .eq. 0.0 )then
PRINT*, "Exiting : FATAL ERROR >>>>> RHO/XI = 0"
exit
end if

      v = v_tld / rho
      y = y / rho

      w = w_tld / xi
      z = z / xi

      delta = DDOT(n,z,1,y,1)
!delta = DOT_PRODUCT(z,y)
if ( delta .eq. 0.0 ) then
PRINT*, "Exiting : FATAL ERROR >>>>> DELTA = 0"
exit
end if

      y_tld = y
      z_tld = z

      if ( iter > 1 ) then                       ! direction vector 
         p = y_tld - ( xi*delta / ep )*p
         q = z_tld - ( rho*delta / ep )*q
      else
         p = y_tld
         q = z_tld
      end if

!CALL DGEMV('N',n,n,1.0D+00,A,n,p,1,0.0D+00,p_tld,1) !<< INCREASES ITERATIONS
      p_tld = MATMUL(A,p)
      ep = DDOT(n,q,1,p_tld,1)
       !ep = DOT_PRODUCT(q,p_tld)
if ( ep .eq. 0.0 )then
PRINT*, "Exiting : FATAL ERROR >>>>> EP = 0"
 stop
 end if

      beta = ep / delta
      if ( beta .eq. 0.0 ) then
PRINT*, "Exiting : FATAL ERROR >>>>> BETA = 0"
stop
end if

      v_tld = p_tld - beta*v
      y = v_tld

      rho_1 = rho
      rho = DNRM2(n,y,1)
CALL DGEMV('T',n,n,1.0D+00,A,n,q,1,0.0D+00,catch,1)
      w_tld = catch - ( beta*w )
!w_tld = MATMUL(TRANSPOSE(A),q ) - ( beta*w )
      z =  w_tld

      xi = DNRM2(n,z,1)

      gamma_1 = gamma
      theta_1 = theta

      theta = rho / ( gamma_1*beta )
      gamma = 1.0 / sqrt( 1.0 + (theta*theta) )
      
if ( gamma .eq. 0.0 ) then
PRINT*, "Exiting : FATAL ERROR >>>>> GAMMA = 0"
exit
end if

      eta = -eta*rho_1*(gamma*gamma) / ( beta*(gamma_1*gamma_1) )

      if ( iter > 1 ) then                        
         d = eta*p + (( theta_1*gamma )*( theta_1*gamma ))*d
         s = eta*p_tld + (( theta_1*gamma )*( theta_1*gamma ))*s
      else
         d = eta*p
         s = eta*p_tld
      end if

      x = x + d                               ! update approximation

!PRINT*,"Iteration : ",iter, "x = ",x
      r = r - s                               ! update residual
      error = DNRM2(n,r,1) / bnrm2               ! check convergence
      
if ( error <= tol ) then 
PRINT*,iter
!PRINT*
!PRINT*, "Converged"
!PRINT*,"Iterations : ",iter
!PRINT*, "x = ",x
stop
end if

   end do


   if ( error < tol ) then                        ! converged
      flag =  0
   else if ( rho .eq. 0.0 )  then                    ! exitdown
      flag = -1
   else if ( beta .eq. 0.0 )then
      flag = -2
   else if ( gamma .eq. 0.0 )then
      flag = -3
   else if ( delta .eq. 0.0 )then
      flag = -4
   else if ( ep .eq. 0.0 )then
      flag = -5
   else if ( xi .eq. 0.0 )then
      flag = -6
   else                                        ! no convergence
      flag = 1
   end if
PRINT*, "SOMETHING UNEXPECTED HAS OCCURED"
print*,"REFER ERROR CODE : ",flag
print*,"Iterations : ",iter

END PROGRAM QMR
!  END qmr.f90
