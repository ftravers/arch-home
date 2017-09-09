#!/usr/bin/env python

import arch_install_help

The smallest size a root partition can be is around 4 GigaBytes.

usb = []
bios_part = { 
    "partition_number":   1,
    "size":               "2m",
    "partition_type":     "bios_boot",
    "filesystem":         "none" }
root_part = {
    "partition_number":   2,
    "size":               "remainder",
    "partition_type":     "ext4",
    "filesystem":         "none" }


# sgdisk -n ${bios_boot_part}:${default_start_pos}:${bios_boot_part_size} --typecode=${bios_boot_part}:${bios_boot_type} ${device}
def make_partition(partition_details, device):
    pd = partition_details
    dev = device
    cmd = "sgdisk -n " + pd["partition_number"] + ":" + pd[""]

a = { "a": 123, "b": 456, "c": 789 }
for key, value in a.items():
    print ( "Key: " + key + ", Value: " + value )
print ( a["b"] )

