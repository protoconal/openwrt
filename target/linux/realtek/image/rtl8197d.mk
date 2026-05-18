# SPDX-License-Identifier: GPL-2.0-only

define Device/RealtekDTS
  PROFILES = Default $$(DTS)
  DEVICE_DTS_DIR := ../dts
  KERNEL := kernel-bin | append-dtb | lzma
endef

define Device/DIR815D1
  $(Device/RealtekDTS)
  DEVICE_DTS := DIR815D1
  DEV_PROFILE := DIR815D1
  IMAGE_SIZE := 7936k
  DEVICE_TITLE := D-Link DIR-815 D1
  SUPPORTED_DEVICES := dir-815-d1
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin := append-kernel | pad-to 1900544 | append-rootfs | pad-rootfs | \
	tbs_dlink_big -k 0x197400 -r 0x4DFF70 -g BR -m DIR825G1 -p RTL8197DL_AC1200
  IMAGE/sysupgrade.bin := append-kernel | pad-to 1900544 | append-rootfs | \
  pad-rootfs | append-metadata
endef
TARGET_DEVICES += DIR815D1

define Device/DIR822C1
  $(Device/RealtekDTS)
  BLOCKSIZE := 64k
  DEVICE_DTS := DIR822C1
  DEVICE_TITLE := D-Link DIR-822 C1
  SUPPORTED_DEVICES := dir-822-c1
  IMAGE_SIZE := 7936k
  DEV_PROFILE := DIR822C1
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x81000000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef
TARGET_DEVICES += DIR822C1
