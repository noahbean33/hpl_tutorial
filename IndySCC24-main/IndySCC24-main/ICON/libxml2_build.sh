#!/bin/bash
export CC=$OPENMPI/mpicc
export CXX=$OPENMPI/mpic++
export FC=$OPENMPI/mpifort
export F77=$OPENMPI/mpif77
export F90=$OPENMPI/mpif90
export MPIFC=$OPENMPI/mpifort
export MPIF77=$OPENMPI/mpif77
export MPIF90=$OPENMPI/mpif90
export MPICC=$OPENMPI/mpicc
export MPICXX=$OPENMPI/mpic++
wget https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.4.tar.xz
tar -xJf libxml2-2.13.4.tar.xz
cd libxml2-2.13.4
mkdir build
CFLAGS="-O3" ./configure --prefix=$BUILD_PATH/libxml2-2.13.4 --with-zlib=$ZLIB_ROOT
make -j
make install
cd ..
rm libxml2-2.13.4.tar.xz
