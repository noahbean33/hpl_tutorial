#!/usr/bin/env bash
set -e

sudo dnf update -y
sudo dnf install nfs-utils -y

cd /

sudo mkdir /nfs/general/resources/setup/scripts -p
sudo mkdir /nfs/general/logs/iperf -p
sudo mkdir /nfs/general/tests
sudo mkdir /nfs/general/slurm/munge -p
sudo mkdir /nfs/general/mpi
sudo mkdir /nfs/general/hpl/amd -p
sudo mkdir /nfs/general/icon

sudo tee -a /etc/exports << END
/nfs/general        10.3.143.121(rw,sync,no_subtree_check)
/home               10.3.143.121(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.121(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.149(rw,sync,no_subtree_check)
/home               10.3.143.149(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.149(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.99(rw,sync,no_subtree_check)
/home               10.3.143.99(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.99(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.76(rw,sync,no_subtree_check)
/home               10.3.143.76(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.76(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.56(rw,sync,no_subtree_check)
/home               10.3.143.56(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.56(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.188(rw,sync,no_subtree_check)
/home               10.3.143.188(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.188(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.234(rw,sync,no_subtree_check)
/home               10.3.143.234(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.234(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.168(rw,sync,no_subtree_check)
/home               10.3.143.168(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.168(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.39(rw,sync,no_subtree_check)
/home               10.3.143.39(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.39(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.75(rw,sync,no_subtree_check)
/home               10.3.143.75(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.75(rw,sync,no_root_squash,no_subtree_check)
/nfs/general        10.3.143.8(rw,sync,no_subtree_check)
/home               10.3.143.8(rw,sync,no_root_squash,no_subtree_check)
/scratch            10.3.143.8(rw,sync,no_root_squash,no_subtree_check)
END

cd / 

sudo chown -R rocky:rocky /nfs/general

sudo systemctl restart nfs-server
sudo systemctl status nfs-server