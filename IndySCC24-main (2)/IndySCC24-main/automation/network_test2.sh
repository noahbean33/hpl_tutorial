#!/usr/bin/env bash
set -e

## Needs 2 inputs to run ##
## iperf documentation https://iperf.fr/iperf-doc.php#3doc ##

## Server node ##
ssh $1 << EOF
  netstat -rn > /nfs/general/logs/$1_network.txt
  sudo dnf install iperf3 -y;
  iperf3 -C bbr --fq-rate 6G -c $2 --logfile /nfs/general/logs/$2_network.txt
  iperf3 -C bbr --fq-rate 6G --bidir -c $2 --logfile /nfs/general/logs/$1_$2_network.txt
EOF