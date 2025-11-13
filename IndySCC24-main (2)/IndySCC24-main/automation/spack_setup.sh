#!/usr/bin/env bash
set -e

cd ~

export SPACK_ROOT=/home/rocky/spack

git clone -c feature.manyFiles=true https://github.com/spack/spack.git ${SPACK_ROOT}
source ${SPACK_ROOT}/share/spack/setup-env.sh
spack --help

spack compiler find