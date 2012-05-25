PROGRAM BLA
double precision, dimension(5) :: a,b
a = 2
b = 4
b = pddot(10,5,a,b)
print*,b

CONTAINS
DOUBLE PRECISION FUNCTION PDDOT( CONTXT, N, X, Y )
!
! -- BLACS example code --
! Written by Clint Whaley 7/26/94.
! ..
! .. Scalar Arguments ..
      INTEGER CONTXT, N
! ..
! .. Array Arguments ..
      DOUBLE PRECISION X(*), Y(*)
! ..
!
!  Purpose
!  =======
!  PDDOT is a restricted parallel version of the BLAS routine
!  DDOT.  It assumes that the increment on both vectors is one,
!  and that process {0,0} starts out owning the vectors and 
!  has N.  It returns the dot product of the two N-length vectors
!  X and Y, i.e. PDDOT = X' Y.
!
!  Arguments
!  =========
!
!  CONTEXT      (input) INTEGER
!           This integer is passed to the BLACS to indicate a context.
!           A context is a universe where messages exist and do not
!           interact with other context's messages.  The context includes
!           the definition of a grid, and each process's coordinates in it.
!
!  N            (input/ouput) INTEGER
!           The length of the vectors X and Y.  Input 
!		for {0,0}, output for everyone else.
!
!  X            (input/output) DOUBLE PRECISION array of dimension (N)
!           The vector X of PDDOT = X' Y.  Input for {0,0},
!           output for everyone else.
!
!  Y            (input/output) DOUBLE PRECISION array of dimension (N)
!           The vector Y of PDDOT = X' Y.  Input for {0,0},
!           output for everyone else.
!
!  =====================================================================
! ..
! .. External Functions ..
      DOUBLE PRECISION DDOT
      EXTERNAL DDOT
! ..
! .. External Subroutines ..
      EXTERNAL BLACS_GRIDINFO, DGEBS2D, DGEBR2D, DGSUM2D
! ..
! .. Local Scalars ..
      INTEGER IAM, NPROCS, NPROW, NPCOL, MYPROW, MYPCOL, I, LN
      DOUBLE PRECISION LDDOT
! ..
! .. Executable Statements ..
!
! Find out what grid has been set up, and pretend it's 1-D
!  CALL BLACS_GRIDINFO( CONTXT, NPROW, NPCOL, MYPROW, MYPCOL )
      IAM = MYPROW*NPCOL + MYPCOL
      NPROCS = NPROW * NPCOL
!
! Do bone-headed thing, and just send entire X and Y to
! everyone
!
      IF ( (MYPROW.EQ.0) .AND. (MYPCOL.EQ.0) ) THEN
	 CALL IGEBS2D(CONTXT, 'All', 'i-ring', 1, 1, N, 1 )
	 CALL DGEBS2D(CONTXT, 'All', 'i-ring', N, 1, X, N )
	 CALL DGEBS2D(CONTXT, 'All', 'i-ring', N, 1, Y, N )
      ELSE
	 CALL IGEBR2D(CONTXT, 'All', 'i-ring', 1, 1, N, 1, 0, 0 )
	 CALL DGEBR2D(CONTXT, 'All', 'i-ring', N, 1, X, N, 0, 0 )
	 CALL DGEBR2D(CONTXT, 'All', 'i-ring', N, 1, Y, N, 0, 0 )
      ENDIF
!
! Find out the number of local rows to multiply (LN), and
! where in vectors to start (I)
!
      LN = N / NPROCS
      I = 1 + IAM * LN
!
! Last process does any extra rows
!
      IF (IAM .EQ. NPROCS-1) LN = LN + MOD(N, NPROCS)
!
! Figure dot product of my piece of X and Y
!
      LDDOT = DDOT( LN, X(I), 1, Y(I), 1 )
!
! Add local dot products to get global dot product;
! give all procs the answer
!
      CALL DGSUM2D( CONTXT, 'All', '1-tree', 1, 1, LDDOT, 1, -1, 0 )

      PDDOT = LDDOT

      RETURN
      END FUNCTION
END PROGRAM BLA
