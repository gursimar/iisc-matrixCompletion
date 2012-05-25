#!/bin/sh
echo 1
export MKL_NUM_THREADS=1

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 2
export MKL_NUM_THREADS=2

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 3
export MKL_NUM_THREADS=3

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 4
export MKL_NUM_THREADS=4

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 6
export MKL_NUM_THREADS=6

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 8
export MKL_NUM_THREADS=8

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 10
export MKL_NUM_THREADS=10

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out

echo 16
export MKL_NUM_THREADS=16

ifort -fp-model source  ParaQMR.f90 -xSSE3 -lmkl_blas95 -lmkl_intel -lmkl_intel_thread -lmkl_core -liomp5 -lpthread -m32  && /usr/bin/time -f "%E"  ./a.out


 
