# How to Run HPL

This repository contains the necessary files to run the High Performance Linpack (HPL) benchmark. This guide provides instructions on how to compile and run HPL, based on the setup in the `example_3` directory, which is configured for an AMD EPYC Milan 64-core node.

## Prerequisites

Before you begin, ensure you have a suitable HPC environment. The benchmark in `example_3` was tested with:

*   **Compiler**: NVIDIA HPC SDK 23.11 (nvhpc)
*   **MPI**: OpenMPI 4.1.5
*   **Math Library**: NVHPC BLAS/LAPACK

You will need to load the appropriate modules for your environment. For example:

```bash
module load nvhpc/23.11/nvhpc
```

## Compilation and Execution Steps

The following steps are based on the process documented in `example_3/README.md`.

### 1. Prepare Compilation Configuration

Navigate to the HPL setup directory and create a makefile for your architecture. The example uses `Make.test`.

```bash
cd example_3/HPL/setup
cp Make.Linux_Intel64 Make.test
```

You will need to **edit `Make.test`** to set the correct paths for your MPI and math libraries.

### 2. Compile HPL

Once your makefile is configured, navigate to the root of the HPL directory and compile the code.

```bash
cd ..
make arch=test
```

### 3. Run the Benchmark

After a successful compilation, the executable `xhpl` will be located in the `bin/test` directory. 

```bash
cd bin/test
```

Before running, you may need to configure the `HPL.dat` file with your desired parameters (Problem Size, Block Size, Process Grid, etc.).

To run the benchmark (using 64 processes in this example), use `mpirun`:

```bash
mpirun -np 64 ./xhpl > hpl_results.txt
```

The output of the run will be saved to `hpl_results.txt`.

## Additional Information

*   For more detailed installation instructions, refer to the `INSTALL` file inside the `example_3/HPL` directory.
*   For performance tuning guidance, see the `TUNING` file in the same directory.
*   The `example_3/Results` directory contains sample output files from a previous run.
