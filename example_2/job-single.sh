#!/bin/bash -l

#SBATCH --job-name=xhpl
#SBATCH --constraint=xcnf
#SBATCH --mem=976GB
#SBATCH --output=logs/slurm-%j.out
#SBATCH --error=logs/slurm-%j.err
#SBATCH --time=23:00:00

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=2
#SBATCH --cpu-freq=performance
#SBATCH --threads-per-core=1

ulimit -s unlimited # set environment stack size
ulimit -l unlimited # set environment locked pages in memory limit
ulimit -n 65535     # number of open files
ulimit -u 16000     # max number of tasks

srun --mpi=pmi2 \
	--chdir=$CDIR \
	--cpu-bin=cores \
	--mem-bind=local \
	--export=ALL \
	$CDIR/bin/ZEN3/xhpl
