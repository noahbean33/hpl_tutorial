#!/usr/bin/env bash
set -e

cd /nfs/general/resources

sudo dnf install aocc-compiler-5.0.0-1.x86_64.rpm -y

sudo dnf install aocl-linux-aocc-5.0.0-1.x86_64.rpm -y

sudo dnf install amduprof-5.0-1479.x86_64.rpm -y