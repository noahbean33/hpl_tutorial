# IndySCC-hero-HPL
2025

---
 High Performance Computing Linpack Benchmark (HPL)
 HPL - 2.3 - December 2, 2018

 HPL is a software package that solves a (random) dense linear
 system  in   double  precision  (64   bits)   arithmetic   on 
 distributed-memory  computers.   It can thus be regarded as a
 portable as well as  freely  available implementation  of the
 High Performance Computing Linpack Benchmark.

 The  HPL  software  package requires the availibility on your
 system of an implementation of the  Message Passing Interface
 MPI  (1.1 compliant).  An  implementation of either the Basic
 Linear Algebra Subprograms  BLAS  or the  Vector Signal Image
 Processing Library VSIPL is also needed.  Machine-specific as
 well as generic implementations of MPI, the  BLAS  and  VSIPL
 are available for a large variety of systems.

 Install See the file INSTALL in this directory.

 Tuning  See the file TUNING in this directory.

 Bugs  Known  problems and bugs with this release are documen-
ted in the file hpl/BUGS.

 Check out  the website  www.netlib.org/benchmark/hpl  for the
 latest information.

---
HPL Benchmark Results

Project Description
High Performance Linpack (HPL) benchmark test on AMD EPYC Milan 64-core node.

Hardware Configuration
CPU: AMD EPYC Milan Processor
Cores: 64 cores
Frequency: 2.0 GHz
Architecture: Zen 3 with AVX2

Software Environment
Compiler: NVIDIA HPC SDK 23.11 (nvhpc)
MPI: OpenMPI 4.1.5
Math Library: NVHPC BLAS/LAPACK

Configuration Process

1. Prepare compilation configuration
cd HPL/hpl-2.3/setup/Make
cp Make.Linux_Intel64 Make.test
Edit Make.test to configure MPI and math library paths

2. Load environment
module load nvhpc/23.11/nvhpc

3. Compile HPL
cd HPL/hpl-2.3
make arch=test

4. Run test
cd bin/test
Configure HPL.dat with desired parameters
mpirun -np 64 ./xhpl > hpl_end.txt

Test Results
Problem Size (N): 90000
Block Size (NB): 256
Process Grid: 8 x 8
Total Processes: 64
Compute Time: 268.33 seconds
Performance: 1811.2 Gflops
Residual Check: PASSED

File Description
Make.test: HPL compilation configuration file
HPL.dat: HPL runtime parameter configuration
hpl_end.txt: Complete performance test results
README: This project documentation

Note
The HPL benchmark completed successfully with all residual checks passed. The configuration and compilation process involved setting up the NVHPC environment, configuring the Makefile for local system paths, and optimizing runtime parameters for the 64-core AMD EPYC Milan system.
