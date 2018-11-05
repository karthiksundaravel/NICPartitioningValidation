#!/usr/bin/bash

sed 's/^\(GRUB_CMDLINE_LINUX=".*\)"/\1 iommu=pt intel_iommu=on default_hugepagesz=1GB hugepagesz=1G hugepages=10"/g' -i /etc/default/grub
grub2-mkconfig -o /etc/grub2.cfg
