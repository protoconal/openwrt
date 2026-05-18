# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

KERNEL_LOADADDR = 0x80100000

DEVICE_VARS += \
BELKIN_HEADER \
BELKIN_MODEL \
        CAMEO_BOARD_MODEL \
        CAMEO_BOARD_VERSION \
        CAMEO_CUSTOMER_SIGNATURE \
        CAMEO_KERNEL_PART \
        CAMEO_KERNEL_PART_SIZE \
        CAMEO_ROOTFS_PART \
        FLASH_ADDR \
        H3C_DEVICE_ID \
        H3C_PRODUCT_ID \
LINKSYS_HEADER \
ZYNFW_BOARD \
ZYNFW_ALIGN \
ZYXEL_VERS

DEVICE_VARS += IMAGE_SIZE CVIMG_KERNEL_BURN_ADDR CVIMG_LOADER_START_ADDR CVIMG_ROOTFS_BURN_ADDR

define Build/rt-compress
$(STAGING_DIR_HOST)/bin/xz -9 --format=lzma --stdout "$@" > "$@.new"
mv "$@.new" "$@"
endef

define Build/rt-loader
$(MAKE) all clean -C rt-loader CROSS_COMPILE="$(TARGET_CROSS)" \
KERNEL_IMG_IN="$@" KERNEL_IMG_OUT="$@.new" BUILD_DIR="$@.build"
mv "$@.new" "$@"
endef

define Build/rt-loader-no-uimage
        $(MAKE) all clean -C rt-loader CROSS_COMPILE="$(TARGET_CROSS)" \
                KERNEL_ADDR="$(KERNEL_LOADADDR)" KERNEL_IMG_IN="$@" \
                KERNEL_IMG_OUT="$@.new" BUILD_DIR="$@.build"
        mv "$@.new" "$@"
endef

define Build/rt-loader-standalone
$(MAKE) all clean -C rt-loader CROSS_COMPILE="$(TARGET_CROSS)" \
FLASH_ADDR=$(FLASH_ADDR) KERNEL_IMG_OUT="$@.new" BUILD_DIR="$@.build"
mv "$@.new" "$@"
endef

define Build/loader-common
  rm -rf $@.src
  $(MAKE) -C lzma-loader \
     PKG_BUILD_DIR="$@.src" \
     TARGET_DIR="$(dir $@)" LOADER_NAME="$(notdir $@)" \
     BOARD="$(DEV_PROFILE)" \
     SUBTARGET="$(SUBTARGET)" \
     LZMA_TEXT_START=0x81000000 LOADADDR=0x80000000 \
     $(1) compile loader.bin
  mv "$@.bin" "$@"
  rm -rf $@.src
endef

define Build/loader-cmdline-compile
  $(call Build/loader-common,LOADER_DATA="$@" KERNEL_CMDLINE="$(CMDLINE)")
endef

define Build/cvimg
        $(STAGING_DIR_HOST)/bin/cvimg \
                -i $@ \
                -o $@.new \
                $(1) && mv $@.new $@ || rm -f $@
endef

define Build/cvimg-kernel
        $(call Build/cvimg, \
                -e $(CVIMG_LOADER_START_ADDR) \
                -b $(CVIMG_KERNEL_BURN_ADDR) \
                -c new \
                -t kernel \
                $(1))
endef

define Build/cvimg-fw
        $(call Build/cvimg, \
                -e $(CVIMG_LOADER_START_ADDR) \
                -b $(CVIMG_KERNEL_BURN_ADDR) \
                -c new \
                -t fw \
                $(1))
endef

define Build/cvimg-custom
        $(call Build/cvimg, \
                -e $(CVIMG_LOADER_START_ADDR) \
                -b $(CVIMG_KERNEL_BURN_ADDR) \
                -s $(CVIMG_CUSTOM_SIGNATURE) \
                $(1))
endef

define Build/cvimg-rootfs
        $(call Build/cvimg, \
                -e $(CVIMG_ROOTFS_BURN_ADDR) \
                -b $(CVIMG_ROOTFS_BURN_ADDR) \
                -c new \
                -t rootfs \
                $(1))
endef

define Build/append-cvimg-rootfs
        cp $(IMAGE_ROOTFS) $(IMAGE_ROOTFS).new && \
        $(STAGING_DIR_HOST)/bin/padjffs2 $(IMAGE_ROOTFS).new \
                $(if $(BLOCKSIZE),$(BLOCKSIZE:%k=%),4 8 16 64 128 256) && \
        $(STAGING_DIR_HOST)/bin/cvimg \
                -i $(IMAGE_ROOTFS).new \
                -o $(IMAGE_ROOTFS).new \
                -e $(CVIMG_ROOTFS_BURN_ADDR) \
                -b $(CVIMG_ROOTFS_BURN_ADDR) \
                -c new \
                -t rootfs \
                $(1) && (dd if=$(IMAGE_ROOTFS).new >> $@ && \
                        rm -f $(IMAGE_ROOTFS).new) || rm -f $@ $(IMAGE_ROOTFS).new
endef

define Build/append-fake-rootfs
        $(call Build/cvimg, \
                -a $(BLOCKSIZE) \
                -f)
endef

define Build/cvimg-pad-rootfs
        $(call Build/cvimg, \
                -b $(CVIMG_KERNEL_BURN_ADDR) \
                -c new \
                -a $(BLOCKSIZE) \
                -t rootfs \
                -j)
endef

define Build/tbs_dlink_big
  $(STAGING_DIR_HOST)/bin/tbs_dlink -b $(1) $@
endef

define Build/zyxel-vers
       ( echo VERS;\
       for hw in $(ZYXEL_VERS); do\
               echo -n "V9.99($$hw.0) | ";\
               date -d @$(SOURCE_DATE_EPOCH) +%m/%d/%Y;\
       done ) >> $@
endef

define Build/cameo-tag
$(SCRIPT_DIR)/cameo-tag.py $@ $(CAMEO_KERNEL_PART_SIZE)
endef

define Build/cameo-version
echo -n "OpenWrt" >> $@
dd if=/dev/zero bs=25 count=1 >> $@
endef

define Build/cameo-headers
        dd if=$@ bs=$(CAMEO_KERNEL_PART_SIZE) count=1 of=$@.kernel_part; \
        dd if=$@ bs=$(CAMEO_KERNEL_PART_SIZE) skip=1 of=$@.rootfs_part; \
        $(SCRIPT_DIR)/cameo-imghdr.py $@.kernel_part $@.kernel_part.hex \
                "$(CAMEO_BOARD_MODEL)" os $(CAMEO_KERNEL_PART) \
                $(CAMEO_CUSTOMER_SIGNATURE) \
                $(CAMEO_BOARD_VERSION) \
                $(KERNEL_LOADADDR); \
        $(SCRIPT_DIR)/cameo-imghdr.py $@.rootfs_part $@.rootfs_part.hex \
                "$(CAMEO_BOARD_MODEL)" squashfs $(CAMEO_ROOTFS_PART) \
                $(CAMEO_CUSTOMER_SIGNATURE) \
                $(CAMEO_BOARD_VERSION); \
        cat $@.kernel_part.hex $@.rootfs_part.hex > $@
endef

define Build/7z
$(STAGING_DIR_HOST)/bin/7zr a $(@).new -t7z -m0=lzma $(@)
mv $@.new $@
endef

define Build/h3c-image
$(STAGING_DIR_HOST)/bin/mkh3cimg \
-i $(@) \
-o $(@).new \
-c 7z \
-p $(H3C_PRODUCT_ID) \
-d $(H3C_DEVICE_ID)
mv $@.new $@
endef

define Build/h3c-vfs
$(STAGING_DIR_HOST)/bin/mkh3cvfs \
-i $(@) \
-o $(@).new \
-f openwrt-kernel.bin
mv $@.new $@
endef

define Build/belkin-header
$(SCRIPT_DIR)/belkin-header.py $(@) $(@).new $(BELKIN_HEADER) ${BELKIN_MODEL}
mv $@.new $@
endef

define Build/linksys-image
$(SCRIPT_DIR)/linksys-image.sh $(@) $(@).new $(LINKSYS_MODEL)
mv $@.new $@
endef

define Build/xikestor-nosimg
$(STAGING_DIR_HOST)/bin/nosimg-enc -i $@ -o $@.new
mv $@.new $@
endef

define Build/xikestor-sks7300-img
$(STAGING_DIR_HOST)/bin/sks7300-img \
-i $@ \
-o $@.new \
-n OpenWrt \
-v $(VERSION_DIST)$(firstword $(subst +, , $(firstword $(subst -, ,$(REVISION)))))
mv $@.new $@
endef

define Build/zynsig
$(STAGING_DIR_HOST)/bin/zynsig -i $@ \
-o $@.new
mv $@.new $@
endef

define Device/Default
  PROFILES = Default
  KERNEL := \
kernel-bin | \
append-dtb | \
libdeflate-gzip | \
uImage gzip
  KERNEL_INITRAMFS := \
kernel-bin | \
append-dtb | \
libdeflate-gzip | \
uImage gzip
  DEVICE_DTS_DIR := ../dts
  DEVICE_DTS = $$(SOC)_$(1)
  COMPILE :=
  IMAGES := sysupgrade.bin
  IMAGE/sysupgrade.bin := \
append-kernel | \
pad-to 64k | \
append-rootfs | \
pad-rootfs | \
check-size | \
append-metadata
endef

define Device/kernel-lzma
  KERNEL := \
kernel-bin | \
append-dtb | \
lzma | \
uImage lzma
  KERNEL_INITRAMFS := \
kernel-bin | \
append-dtb | \
lzma | \
uImage lzma
endef

define Device/uimage-rt-loader
KERNEL/rt-loader := kernel-bin | append-dtb | rt-compress | rt-loader
KERNEL := $$(KERNEL/rt-loader) | uImage none
KERNEL_INITRAMFS := $$(KERNEL/rt-loader) | uImage none
endef

define Device/rt-loader-bootbase
KERNEL/rt-compress := kernel-bin | append-dtb | rt-compress
KERNEL := $$(KERNEL/rt-compress) | uImage lzma
KERNEL_INITRAMFS := $$(KERNEL/rt-compress) | uImage lzma | rt-loader
endef

define Build/zynos-firmware
$(STAGING_DIR_HOST)/bin/mkzynfw \
    -B $(ZYNFW_BOARD) \
    -b $(KDIR)/loader-$(DEVICE_NAME).bin \
    -r $@:$(ZYNFW_ALIGN) \
    -o $@.new
mv $@.new $@
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
