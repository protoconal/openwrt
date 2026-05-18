# SPDX-License-Identifier: GPL-2.0-only

define Device/RealtekDTS
  PROFILES = Default $$(DTS)
  DEVICE_DTS_DIR := ../dts
  KERNEL := kernel-bin | append-dtb | lzma
endef

define Device/GWR300N
  $(Device/RealtekDTS)
  DEVICE_DTS := GWR300
  DEVICE_TITLE := Greatek GWR 300N
  SUPPORTED_DEVICES := gwr300v1 gwr300-v1
  IMAGE_SIZE := 3904k
  DEV_PROFILE := GWR300N
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x18000
  CVIMG_LOADER_START_ADDR := 0x81000000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef
TARGET_DEVICES += GWR300N

define Device/RE172
  $(Device/RealtekDTS)
  DEVICE_DTS := RE172
  DEVICE_TITLE := Multilaser RE172 V1
  SUPPORTED_DEVICES := re172v1 re172-v1
  IMAGE_SIZE := 4032k
  DEV_PROFILE := RE172
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x10000
  CVIMG_LOADER_START_ADDR := 0x81000000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef
TARGET_DEVICES += RE172

define Device/RE707
  $(Device/RealtekDTS)
  DEVICE_DTS := RE707
  DEVICE_TITLE := Multilaser RE707 V1
  SUPPORTED_DEVICES := re707v1 re707-v1
  IMAGE_SIZE := 3904k
  DEV_PROFILE := RE707
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x20000
  CVIMG_LOADER_START_ADDR := 0x81000000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef
TARGET_DEVICES += RE707
