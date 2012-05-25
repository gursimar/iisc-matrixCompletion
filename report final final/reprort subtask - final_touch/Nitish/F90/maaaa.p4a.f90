!!
!! file for maaaa.f90
!!
PROGRAM MATAAA
   INTEGER :: N, CC, X, SEED, Y
   REAL*4 :: B
   REAL*8 :: A
   SAVE SEED
   REAL*8 , ALLOCATABLE :: I(:)
   DATA SEED /38429/
   OPEN (UNIT=1,FILE='positive_definite.txt') 
   READ (1, *) N
   PRINT *, N
   ALLOCATE (I(N)) 
   I = 1
   PRINT *, I
END PROGRAM MATAAA
