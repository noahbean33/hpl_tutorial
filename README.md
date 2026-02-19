# HPL (High Performance Linpack) Benchmark Tutorial

A step-by-step guide to building and running the [HPL benchmark](https://www.netlib.org/benchmark/hpl/) on Linux. This repository provides two automated build scripts—one using **OpenBLAS** and one using **Intel MKL**—so you can choose the math library that best fits your hardware.

---

## Table of Contents

1. [What Is HPL?](#what-is-hpl)
2. [Prerequisites](#prerequisites)
3. [Repository Structure](#repository-structure)
4. [Build Option 1 — OpenBLAS](#build-option-1--openblas)
5. [Build Option 2 — Intel MKL](#build-option-2--intel-mkl)
6. [Running HPL](#running-hpl)
7. [Understanding HPL.dat](#understanding-hpldat)
8. [Tuning Tips](#tuning-tips)
9. [Interpreting Results](#interpreting-results)
10. [Troubleshooting](#troubleshooting)
11. [License](#license)

---

## What Is HPL?

HPL (High Performance Linpack) solves a dense system of linear equations and measures floating-point performance in **GFLOPS** (billions of floating-point operations per second). It is the benchmark behind the [TOP500](https://www.top500.org/) list of the world's fastest supercomputers, and it is equally useful for validating the performance and stability of a single workstation or a small cluster.

---

## Prerequisites

Both build scripts target a **Debian/Ubuntu**-based Linux environment. Ensure the following packages are installed before running either script:

```bash
sudo apt-get update
sudo apt-get install -y build-essential gfortran wget tar
```

| Requirement | Purpose |
|---|---|
| `build-essential` | GCC, G++, make |
| `gfortran` | Fortran compiler (required by OpenBLAS and OpenMPI) |
| `wget` | Downloading source tarballs |
| `tar` | Extracting source tarballs |

> **Note:** The MKL script (`build_hpl_mkl.sh`) will additionally install `intel-oneapi-mkl-devel` via APT if it is not already present. This requires `sudo` privileges.

---

## Repository Structure

```
hpl_tutorial/
├── build_hpl.sh          # Build with OpenMPI + OpenBLAS (all from source)
├── build_hpl_mkl.sh      # Build with OpenMPI + Intel MKL
├── LICENSE
└── README.md             # This guide
```

After a successful build the scripts create the following directories:

```
hpl_tutorial/
├── sources/              # Downloaded & extracted source code
│   ├── openmpi/          # OpenMPI 5.0.8 source
│   ├── openblas/         # OpenBLAS 0.3.30 source (OpenBLAS build only)
│   └── hpl/              # HPL 2.3 source + compiled binary
├── install/              # Compiled libraries
│   ├── openmpi/          # OpenMPI installation prefix
│   └── openblas/         # OpenBLAS installation prefix (OpenBLAS build only)
```

---

## Build Option 1 — OpenBLAS

This script downloads, compiles, and installs **OpenMPI 5.0.8**, **OpenBLAS 0.3.30**, and **HPL 2.3** entirely from source. No Intel software is required.

### What It Builds

| Component | Version | Purpose |
|---|---|---|
| OpenMPI | 5.0.8 | MPI implementation for parallel execution |
| OpenBLAS | 0.3.30 | Optimized BLAS/LAPACK library |
| HPL | 2.3 | The Linpack benchmark itself |

### How to Run

```bash
cd hpl_tutorial
chmod +x build_hpl.sh
./build_hpl.sh
```

The build uses all available CPU cores (`nproc`) by default. This can take a significant amount of time (especially OpenMPI). When complete, the HPL binary is located at:

```
sources/hpl/bin/Linuxtest/xhpl
```

---

## Build Option 2 — Intel MKL

This script uses **Intel Math Kernel Library (MKL)** instead of OpenBLAS. MKL is highly optimized for Intel processors and can deliver significantly higher GFLOPS on Intel hardware.

### What It Builds

| Component | Version | Purpose |
|---|---|---|
| OpenMPI | 5.0.8 | MPI implementation for parallel execution |
| Intel MKL | Latest (via oneAPI) | Optimized BLAS/LAPACK from Intel |
| HPL | 2.3 | The Linpack benchmark itself |

### How to Run

```bash
cd hpl_tutorial
chmod +x build_hpl_mkl.sh
./build_hpl_mkl.sh
```

If MKL is not already installed at `/opt/intel/oneapi/mkl/latest`, the script will:

1. Download Intel's GPG signing key.
2. Add the Intel oneAPI APT repository.
3. Install `intel-oneapi-mkl-devel`.

> **Note:** Steps 1–3 require `sudo`. You will be prompted for your password.

When complete, the HPL binary is located at:

```
sources/hpl/bin/Linuxtest_mkl/xhpl
```

---

## Running HPL

HPL reads its configuration from a file called **`HPL.dat`** that must be in the **same directory** as the `xhpl` executable.

### Step 1 — Create `HPL.dat`

A sample `HPL.dat` is included with the HPL source at `sources/hpl/testing/ptest/HPL.dat`. Copy it into the binary directory:

**For the OpenBLAS build:**

```bash
cp sources/hpl/testing/ptest/HPL.dat sources/hpl/bin/Linuxtest/
```

**For the MKL build:**

```bash
cp sources/hpl/testing/ptest/HPL.dat sources/hpl/bin/Linuxtest_mkl/
```

### Step 2 — Set the Library Path

The dynamic linker needs to find the shared libraries at runtime.

**For the OpenBLAS build:**

```bash
export LD_LIBRARY_PATH=$PWD/install/openmpi/lib:$PWD/install/openblas/lib:${LD_LIBRARY_PATH:-}
```

**For the MKL build:**

```bash
export LD_LIBRARY_PATH=$PWD/install/openmpi/lib:/opt/intel/oneapi/mkl/latest/lib:${LD_LIBRARY_PATH:-}
```

### Step 3 — Run the Benchmark

Use `mpirun` from the local OpenMPI installation to launch HPL. The `-np` flag specifies the number of MPI processes.

**For the OpenBLAS build:**

```bash
cd sources/hpl/bin/Linuxtest
../../../../install/openmpi/bin/mpirun --allow-run-as-root -np 4 ./xhpl
```

**For the MKL build:**

```bash
cd sources/hpl/bin/Linuxtest_mkl
../../../../install/openmpi/bin/mpirun --allow-run-as-root -np 4 ./xhpl
```

> **Tip:** Remove `--allow-run-as-root` if you are running as a normal (non-root) user.

The number of processes (`-np`) **must** match `P × Q` in your `HPL.dat` (see below).

---

## Understanding HPL.dat

`HPL.dat` is the input file that controls every aspect of the benchmark. Below is an annotated example suitable for a quick test on a single machine:

```
HPLinpack benchmark input file
Innovative Computing Laboratory, University of Tennessee
HPL.dat output file name (6 chars)
6            device out (6=stdout,7=stderr,file)
1            # of problems sizes (N)
10000        Ns
1            # of NBs
192          NBs
0            PMAP process mapping (0=Row-,1=Column-major)
1            # of process grids (P x Q)
2            Ps
2            Qs
16.0         threshold
1            # of panel fact
2            PFACTs (0=left, 1=Crout, 2=Right)
1            # of recursive stopping criterium
4            NBMINs (>= 1)
1            # of panels in recursion
2            NDIVs
1            # of recursive panel fact.
1            RFACTs (0=left, 1=Crout, 2=Right)
1            # of broadcast
1            BCASTs (0=1rg,1=1rM,2=2rg,3=2rM,4=Lng,5=LnM)
1            # of lookahead depth
1            DEPTHs (>=0)
2            SWAP (0=bin-exch,1=long,2=mix)
64           swapping threshold
0            L1 in (0=transposed,1=no-transposed) form
0            U  in (0=transposed,1=no-transposed) form
1            Equilibration (0=no,1=yes)
8            memory alignment in double (> 0)
```

### Key Parameters

| Parameter | Description | Guidance |
|---|---|---|
| **N** | Problem size (matrix order) | Larger N → higher GFLOPS but more memory. Use ~80–90% of available RAM. Formula: `N = sqrt(RAM_in_bytes / 8) * 0.85` |
| **NB** | Block size | Typically 128–256. Try 192 as a starting point; tune in steps of 32. |
| **P × Q** | Process grid | Must equal the number of MPI processes (`-np`). Keep P ≤ Q and both as close to square as possible. |
| **PFACT** | Panel factorization algorithm | 0=Left, 1=Crout, 2=Right. `2` (Right) is usually fastest. |
| **RFACT** | Recursive panel factorization | Same options as PFACT. `1` (Crout) is a common choice. |
| **BCAST** | Broadcast algorithm | Values 0–5. `1` (1-ring Modified) is a good default. |
| **DEPTH** | Lookahead depth | `1` is a good default; try `0` and `2` as well. |

---

## Tuning Tips

### Choosing N (Problem Size)

The matrix requires `N² × 8` bytes of memory (double-precision). To compute a good N for your system:

```bash
# Example: 32 GB of RAM
python3 -c "import math; ram=32*(1024**3); print(int(math.sqrt(ram/8)*0.85))"
# Output: ~55,000
```

Round down to the nearest multiple of NB.

### Choosing NB (Block Size)

- **OpenBLAS:** Start with `192` or `256`. Test multiples of 64.
- **Intel MKL:** Start with `192` or `384`. MKL often benefits from larger block sizes on modern Intel CPUs.

### Choosing P and Q

For a single machine with `C` cores, set `-np C` and choose P and Q such that:

- `P × Q = C`
- `P ≤ Q`
- P and Q are as close together as possible

| Cores | Recommended P × Q |
|---|---|
| 4 | 2 × 2 |
| 8 | 2 × 4 |
| 12 | 3 × 4 |
| 16 | 4 × 4 |
| 32 | 4 × 8 |
| 64 | 8 × 8 |

### Running Multiple Configurations

HPL.dat supports sweeping over multiple values at once. For example, to test three problem sizes and two block sizes:

```
3            # of problems sizes (N)
10000 20000 30000
2            # of NBs
192 256
```

HPL will run all combinations automatically.

---

## Interpreting Results

HPL prints a results table to stdout. A typical output looks like:

```
================================================================================
T/V                N    NB     P     Q               Time                 Gflops
--------------------------------------------------------------------------------
WR11C2R4       10000   192     2     2               5.23             1.274e+02
```

| Column | Meaning |
|---|---|
| **T/V** | Encoded test parameters (Wall-clock, Row-major, PFACT, BCAST, DEPTH, RFACT) |
| **N** | Problem size |
| **NB** | Block size |
| **P** | Process grid rows |
| **Q** | Process grid columns |
| **Time** | Wall-clock time in seconds |
| **Gflops** | Performance in billions of floating-point operations per second |

The line will end with a **PASSED** or **FAILED** residual check. A **FAILED** result means the computed solution exceeded the numerical accuracy threshold and the GFLOPS number should not be trusted. This usually indicates a hardware issue (overclocking, faulty RAM) or incorrect library linkage.

### Theoretical Peak

You can compare your result against the theoretical peak of your CPU:

```
Peak GFLOPS = (# cores) × (clock speed in GHz) × (FLOPs per cycle)
```

FLOPs per cycle depends on your CPU's SIMD width:

| ISA | FLOPs/cycle (DP) |
|---|---|
| SSE2 | 2 |
| AVX | 4 |
| AVX2 + FMA | 16 |
| AVX-512 | 32 |

An efficiency of **80–95%** of theoretical peak is considered excellent for HPL.

---

## Troubleshooting

### `xhpl: error while loading shared libraries`

The runtime linker cannot find OpenMPI, OpenBLAS, or MKL. Ensure `LD_LIBRARY_PATH` is set correctly (see [Step 2](#step-2--set-the-library-path)).

### `mpirun was unable to find the specified executable`

Make sure you are in the correct `bin/` directory and that the build completed successfully.

### `HPL ERROR: N < 0` or nonsensical output

Your `HPL.dat` file is malformed. Verify it is in the same directory as `xhpl` and follows the exact format shown above.

### Build fails during OpenMPI compilation

- Ensure `gfortran` is installed.
- Check disk space — OpenMPI's build tree can exceed 2 GB.
- If re-running after a failure, delete the `sources/openmpi` directory and try again.

### `FAILED` residual check

- Lower the problem size (N) to rule out memory issues.
- Check for CPU overheating or overclocking instability.
- Try a different BLAS library (switch between OpenBLAS and MKL scripts).

### Running on multiple nodes (cluster)

To run across machines, create a hostfile and pass it to `mpirun`:

```bash
# hostfile.txt
node1 slots=16
node2 slots=16
```

```bash
mpirun --hostfile hostfile.txt -np 32 ./xhpl
```

Ensure HPL, its libraries, and `HPL.dat` are accessible on all nodes (e.g., via a shared NFS mount).

---

## License

This project is licensed under the terms of the [Apache 2.0 License](LICENSE).
