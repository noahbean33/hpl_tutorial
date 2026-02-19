#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e
# Treat unset variables as an error when substituting.
set -u
# Pipelines return the exit status of the last command to exit with a non-zero status.
set -o pipefail

# --- Configuration ---
BUILD_PROCS=$(nproc)

# --- Paths ---
TOP_DIR="$PWD"
SRC_DIR="$TOP_DIR/sources"
INSTALL_DIR="$TOP_DIR/install"

OPENMPI_SRC_DIR="$SRC_DIR/openmpi"
HPL_SRC_DIR="$SRC_DIR/hpl"

OPENMPI_INSTALL_DIR="$INSTALL_DIR/openmpi"
MKL_INSTALL_PATH="/opt/intel/oneapi/mkl/latest" # Default path from Intel's installer

# Create base directories
mkdir -p "$SRC_DIR"
mkdir -p "$INSTALL_DIR"

# --- URLs and Versions ---
OPENMPI_URL="https://download.open-mpi.org/release/open-mpi/v5.0/openmpi-5.0.8.tar.gz"
OPENMPI_TARBALL=$(basename "$OPENMPI_URL")

HPL_URL="https://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz"
HPL_TARBALL=$(basename "$HPL_URL")

# --- Download and Extract (OpenMPI & HPL only) ---
cd "$SRC_DIR"

if [ ! -f "$OPENMPI_TARBALL" ]; then
    echo "Downloading OpenMPI..."
    wget "$OPENMPI_URL"
fi

if [ ! -f "$HPL_TARBALL" ]; then
    echo "Downloading HPL..."
    wget "$HPL_URL"
fi

if [ ! -d "$OPENMPI_SRC_DIR" ]; then
    echo "Extracting OpenMPI..."
    mkdir -p "$OPENMPI_SRC_DIR"
    tar -xvf "$OPENMPI_TARBALL" -C "$OPENMPI_SRC_DIR" --strip-components=1
fi

if [ ! -d "$HPL_SRC_DIR" ]; then
    echo "Extracting HPL..."
    mkdir -p "$HPL_SRC_DIR"
    tar -xvf "$HPL_TARBALL" -C "$HPL_SRC_DIR" --strip-components=1
fi

echo "Downloads and extractions are complete."
cd "$TOP_DIR"

# --- Install Intel MKL ---
echo "--- Checking for Intel MKL ---"
if [ ! -d "$MKL_INSTALL_PATH" ]; then
    echo "Intel MKL not found. Installing via APT..."
    echo "This will require sudo privileges to add Intel's repository."
    
    # Get Intel's GPG key
    wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
    # Add the key
    sudo apt-key add GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
    # Remove the key file
    rm GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB
    
    # Add Intel's oneAPI repository
    echo "deb https://apt.repos.intel.com/oneapi all main" | sudo tee /etc/apt/sources.list.d/oneAPI.list
    
    # Update and install
    sudo apt-get update
    sudo apt-get install -y intel-oneapi-mkl-devel
    
    echo "Intel MKL installation complete."
else
    echo "Intel MKL is already installed."
fi
cd "$TOP_DIR"


# --- Compile OpenMPI ---
# We must re-configure and re-build OpenMPI to ensure it's clean
echo "--- Building OpenMPI ---"
cd "$OPENMPI_SRC_DIR"
# Clean previous build just in case
make distclean || true 
./configure --prefix="$OPENMPI_INSTALL_DIR"
make -j"$BUILD_PROCS" all
make install
echo "OpenMPI installation complete in $OPENMPI_INSTALL_DIR"
cd "$TOP_DIR"

# --- Compile HPL with MKL ---
echo "--- Building HPL (with MKL) ---"
cd "$HPL_SRC_DIR"

# Define MKLROOT for the Makefile
MKLROOT="${MKL_INSTALL_PATH}"

# We'll name this architecture 'Linuxtest_mkl'
cat > Make.Linuxtest_mkl <<EOF
SHELL        = /bin/sh
CD           = cd
CP           = cp
LN_S         = ln -s
MKDIR        = mkdir
RM           = /bin/rm -f
TOUCH        = touch

ARCH         = Linuxtest_mkl

TOPdir       = ${HPL_SRC_DIR}
INCdir       = \$(TOPdir)/include
BINdir       = \$(TOPdir)/bin/\$(ARCH)
LIBdir       = \$(TOPdir)/lib/\$(ARCH)

HPLlib       = \$(LIBdir)/libhpl.a

# Message Passing library (MPI)
MPdir        = ${OPENMPI_INSTALL_DIR}
MPinc        = -I\$(MPdir)/include
MPlib        = -L\$(MPdir)/lib -lmpi

# Linear Algebra library (Intel MKL)
MKLROOT      = ${MKLROOT}
LAinc        = -I\$(MKLROOT)/include
# MKL Link line for 64-bit integer, OpenMP-threaded, GCC-compatible
LAlib        = -L\$(MKLROOT)/lib -lmkl_intel_lp64 -lmkl_sequential -lmkl_core -lpthread -lm -ldl

# HPL includes / libraries / specifics
HPL_INCLUDES = -I\$(INCdir) -I\$(INCdir)/\$(ARCH) \$(LAinc) \$(MPinc)
HPL_LIBS     = \$(HPLlib) \$(LAlib) \$(MPlib)
HPL_OPTS     = -DHPL_CALL_CBLAS
HPL_DEFS     = \$(F2CDEFS) \$(HPL_OPTS) \$(HPL_INCLUDES)

# Compilers / linkers - Optimization flags
CC           = \$(MPdir)/bin/mpicc
CCNOOPT      = \$(HPL_DEFS)
# Added -fopenmp, which is required by MKL
CCFLAGS      = \$(HPL_DEFS) -fomit-frame-pointer -O3 -funroll-loops -march=native -fopenmp

LINKER       = \$(MPdir)/bin/mpicc
# Added -Wl,-rpath to embed MKL's library path in the executable
LINKFLAGS    = \$(CCFLAGS) -Wl,-rpath,\$(MKLROOT)/lib
ARCHIVER     = ar
ARFLAGS      = r
RANLIB       = echo
EOF

echo "Generated HPL Make.Linuxtest_mkl"
# Clean previous build and make the new one
make clean arch=Linuxtest
make arch=Linuxtest_mkl
echo "HPL build complete."
echo "Executable is in: $HPL_SRC_DIR/bin/Linuxtest_mkl/xhpl"
