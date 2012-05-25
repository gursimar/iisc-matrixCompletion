PROGRAM FILES
IMPLICIT NONE
INTEGER ::i,j,k
INTEGER, DIMENSION(6,6) ::x

OPEN(UNIT = 1, FILE = "matrix")

DO i=1,n
READ(1,*) (x(i,k),k=1,n) !--   <- implicit in-line do loop
END DO

x=11
do i=1,3
PRINT*, (x(i,j),j=1,3)

end do

END PROGRAM FILES

