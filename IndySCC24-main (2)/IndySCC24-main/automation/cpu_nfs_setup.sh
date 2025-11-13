#!/usr/bin/env bash
set -e

## Needs 1 input to run ##

sudo dnf update -y
sudo dnf install nfs-utils -y

cd /

sudo mkdir -p /nfs/general
sudo mkdir -p /nfs/home

sudo tee -a /etc/fstab << END
$@:/var/nfs/general    /nfs/general   nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
$@:/home               /nfs/home      nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0
END

sudo sudo systemctl daemon-reload

sudo mount $@:/nfs/general /nfs/general
sudo mount $@:/home /nfs/home

df -h
