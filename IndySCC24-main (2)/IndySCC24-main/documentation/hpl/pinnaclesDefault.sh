#!/bin/bash
#SBATCH --nodes=1                    # request 1 node
#SBATCH --partition=short            # short partition
#SBATCH --mem=125G                   # request 125 GB per node 
#SBATCH --time=06:00:00              
#SBATCH --ntasks-per-node=32         # 32 cores
#SBATCH --output=job%j.out           # standard output file
#SBATCH --job-name=myjobname         # job name
#SBATCH --export=ALL

module load openmpi/4.1.4-gcc-12.2.0

module load intel/oneapi

module load tbb/2021.12

module load compiler-rt/2024.1.2

module load mkl/2024.1

# wherever xhpl is
# if you submit the job while in the folder with xhpl, no need to cd
# cd hpl-2.3/testing/

mpirun -np [cores] xhpl

# alternative

# mpirun -np [cores] --map-by core xhpl