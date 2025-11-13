#!/usr/bin/env bash

source /nfs/general/spack/share/spack/setup-env.sh 
rm -rf /home/rocky/optimized_icon/
rm -rf /home/rocky/icon-model/
mkdir /home/rocky/optimized_icon

set -ex

# cd ~
# wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.2.tar.gz
# tar xf openmpi-4.1.2.tar.gz
# cd ~
# mkdir -p .tools/
# cd openmpi-4.1.2
# ./configure --prefix=/nfs/general/mpi4_1_2 2>&1 | tee config.out
# make -j3 all 2>&1 | tee make.out 
# sudo make install 2>&1 | tee install.out

cd /home/rocky/optimized_icon
sudo dnf install libxml2 libxml2-devel
git clone https://gitlab.dkrz.de/icon/icon-model.git
cd icon-model
git checkout "icon-2024.07-public"
compiler='gcc@11.4.1'
mpi='openmpi@4.1.2'
# module load  openmpi/4.1.4-gcc-12.2.0 gcc/12.2.0 netlib-lapack/3.9.1
MPI_ROOT='/nfs/general/mpi4_1_2'
CC=$MPI_ROOT/bin/mpicc
CFLAGS='-g -gdwarf-4 -march=native -mpc64'
ICON_CFLAGS='-O3 -ltl '
ICON_BUNDLED_CFLAGS='-O2'

ZLIB_ROOT=$(spack find --format='{prefix}' "zlib%${compiler}")
ZLIB_LIBS="-L$ZLIB_ROOT/lib64 -lz"

HDF5_ROOT=$(spack find --format='{prefix}' "hdf5%${compiler} +fortran+hl ^${mpi}%${compiler}")
HDF5_LIBS="-L$HDF5_ROOT/lib64 -lhdf5_hl_fortran -lhdf5_fortran -lhdf5"

XML2_ROOT=/usr
XML2_LIBS="-L$XML2_ROOT/lib64 -lxml2"

NETCDF_ROOT=$(spack find --format='{prefix}' "netcdf-c%${compiler} ^${mpi}%${compiler}")
NETCDFF_ROOT=$(spack find --format='{prefix}' "netcdf-fortran%${compiler} ^${mpi}%${compiler}")
NETCDF_LIBS="-L$NETCDF_ROOT/lib -lnetcdf"
NETCDFF_LIBS="-L$NETCDFF_ROOT/lib -lnetcdff"

FYAML_ROOT=$(spack find --format='{prefix}' "libfyaml%${compiler}")
FYAML_LIBS="-L$FYAML_ROOT/lib -lfyaml"

ECCODES_ROOT=$(spack find --format='{prefix}' "eccodes%${compiler} +fortran")
ECCODES_LIBS="-L$ECCODES_ROOT/lib64 -leccodes_f90 -leccodes"

FC=$MPI_ROOT/bin/mpif90 
FCFLAGS="-I${HDF5_ROOT}/include -I${NETCDFF_ROOT}/include -I${ECCODES_ROOT}/include -fmodule-private -fimplicit-none -fmax-identifier-length=63 -Wall -Wcharacter-truncation -Wconversion -Wunderflow -Wunused-parameter -Wno-surprising -fall-intrinsics -g -march=native -mpc64"
common_extra_FCFLAGS='-fbacktrace -fbounds-check -fstack-protector-all -finit-real=nan -finit-integer=-2147483648 -finit-character=127 -O2'

ICON_FCFLAGS="${common_extra_FCFLAGS} -std=f2008 -DDO_NOT_COMBINE_PUT_AND_NOCHECK"
ICON_OCEAN_FCFLAGS='-O3 -fno-tree-loop-vectorize -std=f2008'
ICON_BUNDLED_FCFLAGS="${common_extra_FCFLAGS} -std=f2008"
ICON_ECRAD_FCFLAGS="${common_extra_FCFLAGS} -fallow-invalid-boz"

ICON_DACE_FCFLAGS="${common_extra_FCFLAGS} -fallow-argument-mismatch"
ICON_DACE_PATH='externals/dace_icon'

NETLIB_LAPACK_ROOT=$(spack find --format='{prefix}' "netlib-lapack%${compiler}")
BLAS_LAPACK_LDFLAGS="-L${NETLIB_LAPACK_ROOT}/lib64"
BLAS_LAPACK_LIBS="-llapack -lblas"


LDFLAGS="-L${HDF5_ROOT}/lib -L${NETCDF_ROOT}/lib -L${NETCDFF_ROOT}/lib ${BLAS_LAPACK_LDFLAGS} -L${ECCODES_ROOT}/lib64 -L${FYAML_ROOT}/lib -L/lib64"
LIBS="-Wl,--disable-new-dtags -Wl,--as-needed ${XML2_LIBS} ${FYAML_LIBS} ${ECCODES_LIBS} ${BLAS_LAPACK_LIBS} ${NETCDFF_LIBS} ${NETCDF_LIBS} ${HDF5_LIBS} ${ZLIB_LIBS} -ldl"
CPPFLAGS="-I${HDF5_ROOT}/include -I${NETCDF_ROOT}/include -I${ECCODES_ROOT}/include -I${XML2_ROOT}/include/libxml2/libxml -I${FYAML_ROOT}/include"
MPI_LAUNCH=$MPI_ROOT/bin/mpirun

export LD_LIBRARY_PATH=${HDF5_ROOT}/lib:${NETCDF_ROOT}/lib:${NETCDFF_ROOT}/lib:${XML2_ROOT}/lib64:${ZLIB_ROOT}/lib64:${NETLIB_LAPACK_ROOT}/lib64:${ECCODES_ROOT}/lib64:${FYAML_ROOT}/lib:/lib64/:${LD_LIBRARY_PATH}
export PATH=$HDF5_ROOT/bin:$PATH

./configure \
CC="${CC}" \
CFLAGS="${CFLAGS}" \
CPPFLAGS="${CPPFLAGS}" \
FC="${FC}" \
FCFLAGS="${FCFLAGS}" \
ICON_BUNDLED_CFLAGS="${ICON_BUNDLED_CFLAGS}" \
ICON_BUNDLED_FCFLAGS="${ICON_BUNDLED_FCFLAGS}" \
ICON_CFLAGS="${ICON_CFLAGS}" \
ICON_ECRAD_FCFLAGS="${ICON_ECRAD_FCFLAGS}" \
ICON_FCFLAGS="${ICON_FCFLAGS}" \
ICON_OCEAN_FCFLAGS="${ICON_OCEAN_FCFLAGS}" \
ICON_DACE_FCFLAGS="${ICON_DACE_FCFLAGS}" \
ICON_DACE_PATH="${ICON_DACE_PATH}" \
LDFLAGS="${LDFLAGS}" \
LIBS="${LIBS}" \
MPI_LAUNCH="${MPI_LAUNCH}"

make -j25


touch  /home/rocky/optimized_icon/icon-model/run/hostfile
cat << EOF > /home/rocky/optimized_icon/icon-model/run/hostfile
scc135-cpu0 slots=32
scc135-cpu1 slots=32
scc135-cpu2 slots=32
scc135-cpu3 slots=32
scc135-cpu4 slots=32
scc135-cpu5 slots=32
scc135-cpu6 slots=32
scc135-cpu7 slots=32
scc135-cpu8 slots=32
scc135-cpu9 slots=32
EOF

cp  /nfs/general/data-SC_R2B4/exp.tropical_cyclones_R2B4_SC  /home/rocky/optimized_icon/icon-model/run/
cp /nfs/general/exp.tropical_cyclones_R2B4_SC.run /home/rocky/optimized_icon/icon-model/run/
chmod +x  /home/rocky/optimized_icon/icon-model/run/exp.tropical_cyclones_R2B4_SC.run

