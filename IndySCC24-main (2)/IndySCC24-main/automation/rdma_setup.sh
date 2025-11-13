#!/usr/bin/env bash
set -e

sudo dnf install perl-sigtrap tk createrepo kernel-rpm-macros
sudo mkdir /mnt/iso

sudo mount -t iso9660 -o loop /nfs/general/resources/MLNX_OFED_LINUX-24.10-0.7.0.0-rhel9.4-x86_64.iso /mnt/iso/

cd /mnt/iso
sudo ./mlnxofedinstall --add-kernel-support
