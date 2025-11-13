# NUS SoC HPC Onboarding - Software Benchmarking

_Henry Lee_

This report documents my process of optimizing and running the [High-Performance Linpack (HPL) benchmark](https://www.netlib.org/benchmark/hpl/index.html) (2.3) on the NUS SoC cluster using `xcnf` nodes.

<br>

| Configuration    | Nodes | Performance (TFLOPs) | Efficiency |
| ---------------- | ----- | -------------------- | ---------- |
| OpenBLAS + MPICH | 4     | **6.9**              | ~77%       |
| OpenBLAS + MPICH | 1     | **2.0**              | ~89%       |

<br>

Each `xcnf` node has:
 - **CPU**: 1 × AMD EPYC 7763 (64 cores)
 - **Memory**: 1 TB DDR4
 - **Storage**: 3.84 TB NVMe
 - **Network**: 10 GbE

Following the [task constraints](https://docs.google.com/document/d/e/2PACX-1vQP-1mDVAj_PcOadm9hjczi1shJzdZBL6rlBMDR8nOHR9Ua5keLvzGSVK6yaX6k4TVX8C1WrKlxrTql/pub), the benchmark can be built and executed by:
1. SSH into a login node in the SoC cluster
2. Download the source code and `cd` into the folder
3. Run `make`
4. Run `make run`

### Building HPL

The SoC cluster does not provide the `module` command. Instead, extra packages can be installed in the home directory, as recommended by [SoC's documentation](https://dochub.comp.nus.edu.sg/cf/guides/compute-cluster/software).
Libraries have been precompiled (`mpich.zip` and `OpenBLAS.zip`) and are unzipped automatically during `make`.

### MPI Library

I initially attempted to use the system installation at `/usr/bin/mpicc` (OpenMPI) but ran into errors using it with Slurm on multiple nodes due to mismatched runtime libraries.

I resolved this by building [MPICH](https://github.com/pmodels/mpich) from source in the home directory. The compiled `mpicc` automatically links the correct `lib` and `include` paths during HPL compilation.

### Linear Algebra Library

I tested [MKL](https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html), [AOCL](https://www.amd.com/en/developer/aocl.html), and [OpenBLAS](https://github.com/OpenMathLib/OpenBLAS).  

Based on [prior reports](https://news.ycombinator.com/item?id=25061223), I initially expected MKL to have the best performance. Then, I found out that [Intel MKL has been known to use SSE code paths on AMD CPUs that support newer SIMD instructions](https://www.pugetsystems.com/labs/hpc/How-To-Use-MKL-with-AMD-Ryzen-and-Threadripper-CPU-s-Effectively-for-Python-Numpy-And-Other-Applications-1637/).  I applied [a known workaround](https://danieldk.eu/Intel-MKL-on-AMD-Zen) and verified with `perf` that it was indeed using Zen-optimized kernels, but MKL still did not outperform OpenBLAS.

Screenshot from `perf`:  

![](perf_screenshot.png)

On 1 node:
| Library      | Performance (TFLOPs) |
|--------------|----------------------|
| **OpenBLAS** | **2.0**              |
| MKL          | 1.7                  |
| AOCL         | 1.1                  |

2.0 TFLOPs $\approx$ 89% of [the 2.26 TFLOPS theoretical peak of EPYC 7763](https://www.aspsys.com/hpc-processors/amd-epyc-7003/#:~:text=2.45%20GHz-,2257.92,-7713P).

### Slurm Configuration
 - Disabled hyperthreading (`--threads-per-core=1`)
 - Set CPU scaling governor to performance
 - Allocated maximum allowed memory (976GB) to increase the likelihood of obtaining an entire node
   - `--exclusive` was not allowed by Slurm config
 - Adjusted task-to-core mapping with `--cpus-per-task`, `--ntasks-per-node`, `OMP_NUM_THREADS` and `OPENBLAS_NUM_THREADS`

The EPYC 7763 CPU has 64 cores divided into 8 Core Complex Dies (CCDs) with 8 cores each. Based on its CPU topology, I expected 8 tasks × 8 CPUs per task to be optimal, but after benchmarking, 32 tasks × 2 CPUs per task yielded the best performance.

On 1 node:
| Configuration (Tasks per node × CPUs per task = 64)  | Performance (TFLOPs) |
|------------------------------------------------------|----------------------|
| 64 × 1                                               | 1.60                 |
| **32 × 2**                                           | **1.73**             |
| 16 × 4                                               | 1.80                 |
| 8 × 8                                                | 1.66                 |
| 4 × 16                                               | 1.14                 |

### HPL.dat

After tuning the runtime configuration, I optimized parameters in `HPL.dat` based on the [HPL tuning guide from the authors](https://www.netlib.org/benchmark/hpl/tuning.html).

`Nb`, `P` and `Q` refer to these dimensions in a matrix:

![](HPL_matrix_diagram.png)

`Nb` is the block size which should be a multiple of `N`. 
I initially used `Nb = 224` which was the value found in [AMD's tuning guide for 7003 processors](https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/tuning-guides/high-performance-computing-tuning-guide-amd-epyc7003-series-processors.pdf), but found a better value after testing.

On 4 nodes:
| Nb      | Performance (TFLOPs) |
|---------|----------------------|
| 168     | 5.16                 |
| **192** | **5.18**             |
| 224     | 5.12                 |
| 256     | 5.00                 |

For `P` and `Q`, `P × Q = Total number of MPI processes`

On 4 nodes, 32 tasks per node and `P × Q = 128`:
| P × Q      | Performance (TFLOPs) |
|------------|----------------------|
| 16 × 8     | 4.52                 |
| **8 × 16** | **4.88**             |
| 4 × 32     | 4.77                 |
| 2 × 64     | 4.21                 |

Since a double is 8 bytes, an appropriate `N` can be calculated with:

$$
N = \sqrt{\frac{\text{Memory in bytes}}{8}}
$$

Since each node has 1TB of RAM, the `N` calculated was quite large and required a long running time, so I tested lower `N` values too.

On 4 nodes:
| N           | Performance (TFLOPs) | Running Time (mins) |
|-------------|----------------------|-------------|
| **361,872** | **6.9**              | **45**      |
| 228,864     | 5.9                  | 30          |
| 161,856     | 5.7                  | 15          |
| 125,376     | 5.3                  | 5           |
| 102,336     | 4.8                  | 3           |
| 72,384      | 4.2                  | 1           |

For other parameters in `HPL.dat` (e.g. look-ahead depth), I followed the authors' recommendations, and performed additional automated testing with a python script (`search_params.py`).  

### OpenMP Settings

I experimented with several OpenMP environment variables to tune thread placement and scheduling, and found the following settings to be the most stable and performant across runs:
```
OMP_PLACES=cores
OMP_PROC_BIND=close
OMP_SCHEDULE=static
OMP_DYNAMIC=false
```
`OMP_PLACES=cores` and `OMP_PROC_BIND=close` ensured that threads were pinned close to their parent threads, improving cache locality and reducing cross-die communication.
`OMP_SCHEDULE=static` minimized scheduling overhead since the workload per thread was uniform, and `OMP_DYNAMIC=false` prevented the runtime from reallocating threads, avoiding unpredictable fluctuations in performance.

### Compiling HPL

HPL was compiled with the default optimization flags (`-fomit-frame-pointer -O3 -funroll-loops`), along with `-march=znver3` to fully utilize the Zen 3 instruction set. I also enabled `-DHPL_PROGRESS_REPORT` to display progress updates during execution, which was especially helpful for monitoring long-running jobs.

### Results

For ease of use and convenience (since `make run` should return the final result in the same SSH session, and the SSH session is unstable at times), `make run` has been limited to a running time of around **5 mins**, yielding **5.3 TFLOPs**.

A long asynchronous job (**45 mins**) with `make run_async` has maximum performance (**6.9 TFLOPs**).  
The output for asynchronous jobs can be found at `logs/slurm-$(SLURM_JOB_NO).out`.  

There are different commands (shown below) for higher values of `N`, higher running times, and higher FLOPs.

| Command                           | No. of Nodes | Running Time (mins) | N            | Performance (TFLOPs) | Type             |
|-----------------------------------|--------------|---------------------|--------------|----------------------|------------------|
| **`make run`**                    | **4**        | **5**               | **125,376**  | **5.3**              | **Synchronous**  |
| `make run_medium`                 | 4            | 15                  | 161,856      | 5.7                  | Synchronous      |
| `make run_long`                   | 4            | 30                  | 228,864      | 5.9                  | Synchronous      |
| **`make run_async`**              | **4**        | **45**              | **361,872**  | **6.9**              | **Asynchronous** |
| `make run_single`                 | 1            | 5                   | 82,880       | 1.8                  | Synchronous      |
| **`make run_single_async`**       | **1**        | **244**             | **351,624**  | **2.0**              | **Asynchronous** |

### Key Takeaways

Working on this task taught me a lot about how various system-level decisions and practical constraints influence HPC performance. I learned that:

 - Empirical testing is essential.
    - OpenBLAS ended up performing better than MKL, even though initial research suggested otherwise.
    - Similarly, task-to-core mappings based on CPU topology (e.g. one task per CCD) did not always yield the best results.
 - System settings matter.
    - Seemingly simple parameters, such as CPU frequency governors, had a significant impact on performance — sometimes more than expected.
 - Practical challenges are part of the process.
    - Resource limits on the cluster meant it wasn’t feasible to brute-force all possible configurations. Instead, I had to plan tests carefully to make efficient use of available nodes and job priorities.
    - Long synchronous runs were also prone to SSH disconnections, which led me to design asynchronous runs for reliability.

Overall, this task provided a valuable introduction to performance benchmarking and HPC tuning, and deepened my appreciation for how real-world HPC work demands both solid a understanding of the system and careful, iterative experimentation.

