#
#  -- High Performance Computing Linpack Benchmark (HPL)
#     HPL - 2.3 - December 2, 2018
#     Antoine P. Petitet
#     University of Tennessee, Knoxville
#     Innovative Computing Laboratory
#     (C) Copyright 2000-2008 All Rights Reserved
#
#  -- Copyright notice and Licensing terms:
#
#  Redistribution  and  use in  source and binary forms, with or without
#  modification, are  permitted provided  that the following  conditions
#  are met:
#
#  1. Redistributions  of  source  code  must retain the above copyright
#  notice, this list of conditions and the following disclaimer.
#
#  2. Redistributions in binary form must reproduce  the above copyright
#  notice, this list of conditions,  and the following disclaimer in the
#  documentation and/or other materials provided with the distribution.
#
#  3. All  advertising  materials  mentioning  features  or  use of this
#  software must display the following acknowledgement:
#  This  product  includes  software  developed  at  the  University  of
#  Tennessee, Knoxville, Innovative Computing Laboratory.
#
#  4. The name of the  University,  the name of the  Laboratory,  or the
#  names  of  its  contributors  may  not  be used to endorse or promote
#  products  derived   from   this  software  without  specific  written
#  permission.
#
#  -- Disclaimer:
#
#  THIS  SOFTWARE  IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#  ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,  INCLUDING,  BUT NOT
#  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE UNIVERSITY
#  OR  CONTRIBUTORS  BE  LIABLE FOR ANY  DIRECT,  INDIRECT,  INCIDENTAL,
#  SPECIAL,  EXEMPLARY,  OR  CONSEQUENTIAL DAMAGES  (INCLUDING,  BUT NOT
#  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#  DATA OR PROFITS; OR BUSINESS INTERRUPTION)  HOWEVER CAUSED AND ON ANY
#  THEORY OF LIABILITY, WHETHER IN CONTRACT,  STRICT LIABILITY,  OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# ######################################################################
#
#
SHELL            = /bin/sh


# 3h is the max time for a normal job - https://dochub.comp.nus.edu.sg/cf/guides/compute-cluster/slurm-info
# 976GB is the max mem slurm allows for this node type
# xcnf is 1 x EPYC 7763 (64 core)

#
arch             = ZEN3

.EXPORT_ALL_VARIABLES:

CDIR = $(shell pwd)
PATH = $(CDIR)/mpich-install/bin:$(shell echo $$PATH)
LD_LIBRARY_PATH=$(CDIR)/mpich-install/lib:$(CDIR)/OpenBLAS/lib

FI_PROVIDER=psm3
PSM3_NIC=enp131s0f0
FI_PSM3_IFACE=enp131s0f0
PSM3_ADDR_FMT=4
PSM3_SUBNETS=192.168.48.0/21
PSM3_ALLOW_ROUTERS=1
FI_PSM3_ALLOW_ROUTES=1
PSM3_TCP_BIND_SRC=0

OMP_NUM_THREADS=2
OMP_PLACES=cores
OMP_PROC_BIND=close
OPENBLAS_NUM_THREADS=2
OPENBLAS_CORETYPE=Zen
OMP_SCHEDULE=static
OMP_DYNAMIC=false

#
SBATCH = sbatch
SRUN = srun

SRUN_RUN_OPTIONS = --job-name=xhpl \
	--chdir=$(CDIR) \
	--time=3:00:00 \
	--constraint=xcnf \
	--mem=976GB \
	--cpus-per-task=2 \
	--ntasks-per-node=32 \
	--threads-per-core=1 \
	--cpu-freq=performance \
	--mpi=pmi2 \
	--cpu-bin=cores \
	--mem-bind=local \
	--export=ALL
SRUN_MAKE_OPTIONS = --constraint=xcnf --cpus-per-task=64 --chdir=$(CDIR)
SRUN_SINGLE_NODE_OPTION = --nodes=1
SRUN_MULTI_NODE_OPTION = --nodes=4
SRUN_VERBOSE_OPTION = -v

#
## Targets #############################################################
#
all              :
	$(SRUN) $(SRUN_MAKE_OPTIONS) $(MAKE) install
#
# ######################################################################
#
install          : clean_arch unzip_lib startup refresh build
#
unzip_lib        :
	unzip -o OpenBLAS.zip
	unzip -o mpich.zip
#
# If we do make -j there will be errors
#
startup          :
	$(MAKE) -f Make.top startup_dir     arch=$(arch)
	$(MAKE) -f Make.top startup_src     arch=$(arch)
	$(MAKE) -f Make.top startup_tst     arch=$(arch)
	$(MAKE) -f Make.top refresh_src     arch=$(arch)
	$(MAKE) -f Make.top refresh_tst     arch=$(arch)
#
refresh          :
	$(MAKE) -f Make.top refresh_src     arch=$(arch)
	$(MAKE) -f Make.top refresh_tst     arch=$(arch)
#
build            :
	$(MAKE) -f Make.top build_src       arch=$(arch)
	$(MAKE) -f Make.top build_tst       arch=$(arch)
	cp $(CDIR)/HPL_4n_short.dat $(CDIR)/HPL.dat

#
run_multi_verbose        :
	ulimit -s unlimited # set environment stack size
	ulimit -n 65535     # number of open files
	$(SRUN) $(SRUN_RUN_OPTIONS) $(SRUN_MULTI_NODE_OPTION) $(SRUN_VERBOSE_OPTION) $(CDIR)/bin/ZEN3/xhpl
run_multi        :
	ulimit -s unlimited # set environment stack size
	ulimit -n 65535     # number of open files
	$(SRUN) $(SRUN_RUN_OPTIONS) $(SRUN_MULTI_NODE_OPTION) $(CDIR)/bin/ZEN3/xhpl
#
run              :
	cp $(CDIR)/HPL_4n_short.dat $(CDIR)/HPL.dat; \
		$(MAKE) run_multi
run_medium       :
	cp $(CDIR)/HPL_4n_medium.dat $(CDIR)/HPL.dat; \
		$(MAKE) run_multi
run_long         :
	cp $(CDIR)/HPL_4n_long.dat $(CDIR)/HPL.dat; \
		$(MAKE) run_multi
#
run_async   :
	cp $(CDIR)/HPL_4n_async.dat $(CDIR)/HPL.dat; \
		$(SBATCH) $(CDIR)/job.sh
#
#
run_single        :
	ulimit -s unlimited # set environment stack size
	ulimit -n 65535     # number of open files
	cp $(CDIR)/HPL_1n_short.dat $(CDIR)/HPL.dat; \
		$(SRUN) $(SRUN_RUN_OPTIONS) $(SRUN_SINGLE_NODE_OPTION) $(CDIR)/bin/ZEN3/xhpl
run_single_async    :
	cp $(CDIR)/HPL_1n_full.dat $(CDIR)/HPL.dat; \
		$(SBATCH) $(CDIR)/job-single.sh

#
clean            :
	$(MAKE) -f Make.top clean_src       arch=$(arch)
	$(MAKE) -f Make.top clean_tst       arch=$(arch)
#
clean_arch       :
	$(MAKE) -f Make.top clean_arch_src  arch=$(arch)
	$(MAKE) -f Make.top clean_arch_tst  arch=$(arch)
#
clean_arch_all   :
	$(MAKE) -f Make.top clean_arch_all  arch=$(arch)
#
clean_guard      :
	$(MAKE) -f Make.top clean_guard_src arch=$(arch)
	$(MAKE) -f Make.top clean_guard_tst arch=$(arch)
#
# ######################################################################
