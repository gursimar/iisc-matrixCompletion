program TwoDFFT
! Fortran example.
! 2D complex to complex, and real to conjugate-even

Use MKL_DFTI
Complex :: X_2D(32,100)
Real :: Y_2D(34, 102)
Complex :: X(3200)
Real :: Y(3468)
Equivalence (X_2D, X)
Equivalence (Y_2D, Y)
type(DFTI_DESCRIPTOR), POINTER :: My_Desc1_Handle, My_Desc2_Handle
Integer :: Status, L(2)

!...put input data into X_2D(j,k), Y_2D(j,k), 1<=j=32,1<=k<=100
!...set L(1) = 32, L(2) = 100
!...the transform is a 32-by-100
! Perform a complex to complex transform
Status = DftiCreateDescriptor( My_Desc1_Handle, DFTI_SINGLE, DFTI_COMPLEX, 2, L)
Status = DftiCommitDescriptor( My_Desc1_Handle)
Status = DftiComputeForward( My_Desc1_Handle, X)
Status = DftiFreeDescriptor(My_Desc1_Handle)

! result is given by X_2D(j,k), 1<=j<=32, 1<=k<=100
! Perform a real to complex conjugate-even transform
Status = DftiCreateDescriptor( My_Desc2_Handle, DFTI_SINGLE, DFTI_REAL, 2, L)
Status = DftiCommitDescriptor( My_Desc2_Handle);
Status = DftiComputeForward( My_Desc2_Handle, Y)
Status = DftiFreeDescriptor(My_Desc2_Handle)
! result is given by the complex value z(j,k) 1<=j<=32; 1<=k<=100
! and is stored in CCS format
print*,'Program Completed Successfully';
end
