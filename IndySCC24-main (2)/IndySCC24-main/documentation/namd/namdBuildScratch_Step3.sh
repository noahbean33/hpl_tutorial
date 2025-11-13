#!/bin/bash

sudo cp NAMD_3.0_Source.tar.gz /scratch

cd /scratch

sudo tar -zxf NAMD_3.0_Source.tar.gz

cd NAMD_3.0_Source

sudo tar -xf charm-8.0.0.tar

cd charm-8.0.0

sudo ./build charm++ mpi-linux-x86_64  mpicxx -j32  --with-production

cd ..

sudo wget http://www.ks.uiuc.edu/Research/namd/libraries/fftw-linux-x86_64.tar.gz

sudo tar xzf fftw-linux-x86_64.tar.gz

sudo mv linux-x86_64 fftw

sudo wget https://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64-threaded.tar.gz

sudo tar xzf tcl8.6.13-linux-x86_64-threaded.tar.gz

sudo mv tcl8.6.13-linux-x86_64-threaded tcl-threaded

# STOOOOOP

#Configure NAMD
./config Linux-x86_64-g++ --charm-arch mpi-linux-x86_64-mpicxx --with-fftw --tcl-prefix `pwd`/tcl-threaded

cd Linux-x86_64-g++/

#Build NAMD
make -j32
