#!/bin/bash

# Start Charm++ Setup

cd ~/openmpi-5.0.5

./configure --prefix="$HOME/openmpi-5.0.5-local"

make -j32

make install

export PATH=$HOME/openmpi-5.0.5-local/bin:$PATH

# NEXT: SCP NAMD 3.0 source package