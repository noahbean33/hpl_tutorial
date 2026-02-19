#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipelines return the exit status of the last command to exit with a non-zero status.
set -o pipefail

# --- Configuration ---
# Use the number of available processors for parallel builds
# You can override this by setting, e.g., BUILD_PROCS=8
BUILD_PROCS=$(nproc)

# --- Paths ---
# We will keep all source code in a 'sources' directory and all final installations in an 'install' directory.
# This is a cleaner approach than installing into the source directories.
TOP_DIR="$PWD"
SRC_DIR="$TOP_DIR/sources"
INSTALL_DIR="$TOP_DIR/install"

OPENMPI_SRC_DIR="$SRC_DIR/openmpi"
OPENBLAS_SRC_DIR="$SRC_DIR/openblas"
HPL_SRC_DIR="$SRC_DIR/hpl"

OPENMPI_INSTALL_DIR="$INSTALL_DIR/openmpi"
OPENBLAS_INSTALL_DIR="$INSTALL_DIR/openblas"

# Create base directories
mkdir -p "$SRC_DIR"
mkdir -p "$INSTALL_DIR"

# --- URLs and Versions ---
OPENMPI_URL="https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.8.tar.gz"
OPENMPI_TARBALL=$(basename "$OPENMPI_URL")
OPENMPI_DIR_NAME="openmpi-5.0.8"

OPENBLAS_URL="https://github.com/OpenMathLib/OpenBLAS/releases/download/v0.3.30/OpenBLAS-0.3.30.tar.gz"
OPENBLAS_TARBALL=$(basename "$OPENBLAS_URL")
OPENBLAS_DIR_NAME="OpenBLAS-0.3.30"

HPL_URL="https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz"
HPL_TARBALL=$(basename "$HPL_URL")
HPL_DIR_NAME="hpl-2.3"

# --- Download and Extract ---
cd "$SRC_DIR"

# Check if tarballs exist, otherwise download
if [ ! -f "$OPENMPI_TARBALL" ]; then
    echo "Downloading OpenMPI..."
    wget "$OPENMPI_URL"
fi

if [ ! -f "$OPENBLAS_TARBALL" ]; then
    echo "Downloading OpenBLAS..."
    wget "$OPENBLAS_URL"
fi

if [ ! -f "$HPL_TARBALL" ]; then
    echo "Downloading HPL..."
    wget "$HPL_URL"
fi

# Check if directories exist, otherwise extract
if [ ! -d "$OPENMPI_SRC_DIR" ]; then
    echo "Extracting OpenMPI..."
    mkdir -p "$OPENMPI_SRC_DIR"
    tar -xvf "$OPENMPI_TARBALL" -C "$OPENMPI_SRC_DIR" --strip-components=1
fi

if [ ! -d "$OPENBLAS_SRC_DIR" ]; then
    echo "Extracting OpenBLAS..."
    mkdir -p "$OPENBLAS_SRC_DIR"
    tar -xvf "$OPENBLAS_TARBALL" -C "$OPENBLAS_SRC_DIR" --strip-components=1
fi

if [ ! -d "$HPL_SRC_DIR" ]; then
    echo "Extracting HPL..."
    mkdir -p "$HPL_SRC_DIR"
    tar -xvf "$HPL_TARBALL" -C "$HPL_SRC_DIR" --strip-components=1
fi

echo "Downloads and extractions are complete."
cd "$TOP_DIR"


# --- Compile OpenBLAS ---
echo "--- Building OpenBLAS ---"
cd "$OPENBLAS_SRC_DIR"
# The 'make install' command will create the destination directory
make -j"$BUILD_PROCS"
make PREFIX="$OPENBLAS_INSTALL_DIR" install
echo "OpenBLAS installation complete in $OPENBLAS_INSTALL_DIR"
cd "$TOP_DIR"

# --- Compile OpenMPI ---
echo "--- Building OpenMPI ---"
cd "$OPENMPI_SRC_DIR"
# Correctly separate configure, make, and install steps
./configure --prefix="$OPENMPI_INSTALL_DIR"
make -j"$BUILD_PROCS" all
make install
echo "OpenMPI installation complete in $OPENMPI_INSTALL_DIR"
cd "$TOP_DIR"

# --- Compile HPL ---
echo "--- Building HPL ---"
cd "$HPL_SRC_DIR"

# Create the Makefile for HPL. This is a more robust way to do it.
# We use standard -L and -l flags for the linker, which is better practice.
cat > Make.Linuxtest <<EOF
SHELL        = /bin/sh
CD           = cd
CP           = cp
LN_S         = ln -s
MKDIR        = mkdir
RM           = /bin/rm -f
TOUCH        = touch

ARCH         = Linuxtest

TOPdir       = ${HPL_SRC_DIR}
INCdir       = \$(TOPdir)/include
BINdir       = \$(TOPdir)/bin/\$(ARCH)
LIBdir       = \$(TOPdir)/lib/\$(ARCH)

HPLlib       = \$(LIBdir)/libhpl.a

# Message Passing library (MPI)
MPdir        = ${OPENMPI_INSTALL_DIR}
MPinc        = -I\$(MPdir)/include
MPlib        = -L\$(MPdir)/lib -lmpi

# Linear Algebra library (BLAS)
LAdir        = ${OPENBLAS_INSTALL_DIR}
LAinc        = -I\$(LAdir)/include
LAlib        = -L\$(LAdir)/lib -lopenblas

# HPL includes / libraries / specifics
HPL_INCLUDES = -I\$(INCdir) -I\$(INCdir)/\$(ARCH) \$(LAinc) \$(MPinc)
HPL_LIBS     = \$(HPLlib) \$(LAlib) \$(MPlib)
HPL_OPTS     = -DHPL_CALL_CBLAS
HPL_DEFS     = \$(F2CDEFS) \$(HPL_OPTS) \$(HPL_INCLUDES)

# Compilers / linkers - Optimization flags
CC           = \$(MPdir)/bin/mpicc
CCNOOPT      = \$(HPL_DEFS)
CCFLAGS      = \$(HPL_DEFS) -fomit-frame-pointer -O3 -funroll-loops -march=native

LINKER       = \$(MPdir)/bin/mpicc
LINKFLAGS    = \$(CCFLAGS)

ARCHIVER     = ar
ARFLAGS      = r
RANLIB       = echo
EOF

echo "Generated HPL Make.Linuxtest"
make arch=Linuxtest
echo "HPL build complete. Executable is in $HPL_SRC_DIR/bin/Linuxtest/xhpl"
