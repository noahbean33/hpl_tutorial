#!/usr/bin/env bash
set -e

sudo dnf install numactl -y

hostname > /nfs/general/logs/cpus.log
lscpu > /nfs/general/logs/cpus.log
grep -H . /sys/devices/system/cpu/cpu*/topology/thread_siblings_list > /nfs/general/logs/cpus.log
numactl -H -t > cpus.log


 
