#!/bin/bash
sudo zypper in -t pattern smt
for REPO in SLES12-SP3-{Pool,Updates} SUSE-OpenStack-Cloud-8-{Pool,Updates}; do
  smt-repos $REPO sle-12-x86_64 -e
done
smt-mirror -L /var/log/smt/smt-mirror.log
