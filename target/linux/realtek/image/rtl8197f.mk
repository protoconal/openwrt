# SPDX-License-Identifier: GPL-2.0-only

define Device/RealtekDTS
  PROFILES = Default $$(DTS)
  DEVICE_DTS_DIR := ../dts
  KERNEL := kernel-bin | append-dtb | lzma
endef

define Device/RE708
  $(Device/RealtekDTS)
  BLOCKSIZE := 64k
  DEVICE_DTS := RE708
  DEVICE_TITLE := Multilaser RE708 V1
  SUPPORTED_DEVICES := re708v1 re708-v1
  IMAGE_SIZE := 7936k
  DEV_PROFILE := RE708
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x81000000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef
TARGET_DEVICES += RE708

define Device/GWR1200AC
  $(Device/RealtekDTS)
  BLOCKSIZE := 64k
  DEVICE_TITLE := Greatek GWR1200AC V1
  SUPPORTED_DEVICES := gwr1200ac-v1
  IMAGE_SIZE := 7936k
  DEV_PROFILE := GWR1200AC
  CMDLINE := console=ttyS0,38400
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x80A00000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | cvimg-pad-rootfs
  IMAGE/sysupgrade.bin = append-kernel | append-fake-rootfs | append-rootfs | cvimg-kernel | pad-rootfs
endef

define Device/GWR1200AC-V1
  $(Device/GWR1200AC)
  DEVICE_DTS := GWR1200ACV1
  DEVICE_TITLE := Greatek GWR1200AC V1
  SUPPORTED_DEVICES := gwr1200ac-v1
endef
TARGET_DEVICES += GWR1200AC-V1

define Device/GWR1200AC-V2
  $(Device/GWR1200AC)
  DEVICE_DTS := GWR1200ACV2
  DEVICE_TITLE := Greatek GWR1200AC V2
  SUPPORTED_DEVICES := gwr1200ac-v2
endef
TARGET_DEVICES += GWR1200AC-V2

define Device/ACTIONRG1200
  $(Device/RealtekDTS)
  BLOCKSIZE := 64k
  DEVICE_DTS := ACTIONRG1200
  DEVICE_TITLE := Intelbras ACTIONRG1200 V1
  SUPPORTED_DEVICES := actionrg1200v1
  IMAGE_SIZE := 7872k
  DEV_PROFILE := ACTIONRG1200
  CMDLINE := console=ttyS0,115200
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x80A00000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | pad-offset 64k 16 | append-rootfs | pad-rootfs -x 16 | cvimg-kernel -T
  IMAGE/sysupgrade.bin = append-kernel | pad-offset 64k 16 | append-rootfs | pad-rootfs -x 16 | cvimg-kernel -S
endef
TARGET_DEVICES += ACTIONRG1200

define Device/ACTIONRF1200
  $(Device/RealtekDTS)
  BLOCKSIZE := 64k
  DEVICE_DTS := ACTIONRF1200
  DEVICE_TITLE := Intelbras ACTIONRF1200 V1
  SUPPORTED_DEVICES := actionrf1200v1
  IMAGE_SIZE := 7872k
  DEV_PROFILE := ACTIONRF1200
  CMDLINE := console=ttyS0,115200
  KERNEL := kernel-bin | append-dtb | lzma | loader-cmdline-compile
  CVIMG_KERNEL_BURN_ADDR := 0x30000
  CVIMG_LOADER_START_ADDR := 0x80A00000
  IMAGES := factory.bin sysupgrade.bin
  IMAGE/factory.bin = append-kernel | pad-offset 64k 16 | append-rootfs | pad-rootfs -x 16 | cvimg-kernel -T
  IMAGE/sysupgrade.bin = append-kernel | pad-offset 64k 16 | append-rootfs | pad-rootfs -x 16 | cvimg-kernel -S
endef
TARGET_DEVICES += ACTIONRF1200
