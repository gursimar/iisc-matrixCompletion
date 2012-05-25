      PROGRAM main
!
!     Example Program solving Ax=b via ScaLAPACK routine PDPOSV
!
!     The global symmetric positive definite matrix is
!           __               __
!           |  9  0  0  1  1  |
!           |  0  9  0  2  -2 |
!     A  =  |  0  0  9  1  -1 |
!           |  1  2  1  9  0  |
!           |  1 -2 -1  0  9  |
!           --               --
!     The righthand side is
!
!          __  __
!          | 11 |
!          |  9 |
!     b =  |  9 |
!          | 13 |
!          |  7 |
!          --  --
!     In this program, only upper triangular part of this matrix is
!     stored in 2 by 2 process grid with 2 by 2 block.
!     Each process stores elements as follows
!
!         --- P0 ---           --- P1 ---
!     A = 9  0  1  b = 11       A = 0  1
!         0  9 -2       9           0  2
!         1 -2  9       7          -1  9
!
!         --- P3 ---           --- P4 ---
!     A = 1 0 -1   b =  9       A = 9  1
!         0 2  0       13           1  9
!
!  Further Details
!  ===============
!
!  Contributed by Keita Teranishi, University of Tennessee, 1996.
!
!  =====================================================================
!
!     .. Parameters ..
      INTEGER            DLEN_, IA, JA, IB, JB, N, MB, NB, RSRC, CSRC,&
                       MXLLDA, MXLLDB, NRHS, NBRHS, NOUT, LWORK,&
                       MXLOCC, MXRHSC
      PARAMETER          ( DLEN_ = 9, IA = 1, JA = 1, IB = 1, JB = 1,&
                        N = 5, MB = 2, NB = 2, RSRC = 0, CSRC = 0,&
                        MXLLDA = 3, MXLLDB = 3, NRHS = 1, NBRHS = 1,&
                        NOUT = 6, LWORK = 20, MXLOCC = 3, MXRHSC = 1 )
      DOUBLE PRECISION   ONE
      PARAMETER          ( ONE = 1.0D+0 )
!     ..
!     .. Local Scalars ..
      INTEGER            ICTXT, INFO, MYCOL, MYROW, NPCOL, NPROW
      DOUBLE PRECISION   ANORM, BNORM, EPS, RESID, XNORM
!     ..
!     .. Local Arrays ..
      INTEGER            DESCA( DLEN_ ), DESCB( DLEN_ )
      DOUBLE PRECISION   A( MXLLDA, MXLOCC ), A0( MXLLDA, MXLOCC ),&
                        B( MXLLDB, MXRHSC ), B0( MXLLDB, MXRHSC ),&
                        WORK( LWORK )
!     ..
!     .. External Functions ..
      DOUBLE PRECISION   PDLAMCH, PDLANGE, PDLANSY
      EXTERNAL           PDLAMCH, PDLANGE, PDLANSY
!     ..
!     .. External Subroutines ..
      EXTERNAL           BLACS_EXIT, BLACS_GRIDEXIT, BLACS_GRIDINFO,&
                        DESCINIT, MATINIT, PDLACPY, PDLAPRNT, PDPOSV,&
                       PDSYMM, SL_INIT
!     ..
!     .. Intrinsic Functions ..
      INTRINSIC          DBLE
!     ..
!     .. Data statements ..
      DATA               NPROW / 2 / , NPCOL / 2 /
!     ..
     CALL SL_INIT( ICTXT, NPROW, NPCOL )
      CALL BLACS_GRIDINFO( ICTXT, NPROW, NPCOL, MY_ROW, MY_COL )
print*,ictxt,my_row,my_col
      CALL DESCINIT( DESCA, N, N, MB, NB, RSRC, CSRC, ICTXT, MXLLDA,&
                    INFO )
      CALL DESCINIT( DESCB, N, NRHS, NB, NBRHS, RSRC, CSRC, ICTXT,&
                    MXLLDB, INFO )
CALL BLACS_EXIT( 0 )
end program main

