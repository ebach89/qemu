#!/usr/bin/env sh


# Run 'virt' board with Ubuntu as guest, TrustZone is switched off
build/aarch64-softmmu/qemu-system-aarch64 -M virt -m 1024 \
  -cpu cortex-a57,pmu=on -smp cpus=4 \
  -kernel /home/ebach89/Work/VMs/qemu_arm64_ubuntu/vmlinuz-4.9.0-7-arm64 \
  -initrd /home/ebach89/Work/VMs/qemu_arm64_ubuntu/initrd.img-4.9.0-7-arm64 \
  -append 'root=/dev/vda2' \
  -drive if=none,file=/home/ebach89/Work/VMs/qemu_arm64_ubuntu/hda.qcow2,format=qcow2,id=hd \
  -device virtio-blk-pci,drive=hd \
  -netdev user,id=mynet \
  -device virtio-net-pci,netdev=mynet,romfile=/home/ebach89/Work/bins/qemu/arm64/pc-bios/efi-virtio.rom \
  -nographic \
  -redir tcp:2222::22

