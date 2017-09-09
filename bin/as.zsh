#!/usr/bin/zsh

usage() {
  cat <<EOF
specify one of '-u' (install to USB) or '-c' (install to computer), not
both or neither :)

specify device with -d <device>.  For example: '-d /dev/sdb'.
EOF
}

zparseopts -E u=a_usb c=a_comp d:=a_device
usb=0
[[ -n $a_usb[1] ]] && usb=1

comp=0
if [[ -n $a_comp[1] ]]; then
    comp=1
fi

((total=usb+comp))
[[ total -ne 1 ]] && usage

device=$a_device[2]

if [[ usb -eq 1 ]]; then
    echo "format usb, device $device"
fi

if [[ comp -eq 1 ]]; then
    echo "format computer, device $device"
fi

format_usb() {
    sgdisk -n ${root_partition}:${default_start_pos}:${default_size} ${device}              # root partition
}

format_hd() {

}
