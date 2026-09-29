# Copyright (C) 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
# BoardConfig.mk - Meizu M3 Note Intl (l681 / L681H / L91), MediaTek MT6755

DEVICE_PATH := device/meizu/l681

# MT6755 uses Cortex-A53 / ARMv8.0-A. Do not enable ARMv8.1 LSE instructions.
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

TARGET_USES_64_BIT_BINDER := true

# Platform
# ro.hardware must resolve to mt6755, otherwise init.mt6755.rc and
# ueventd.mt6755.rc are not read.
TARGET_BOARD_PLATFORM := mt6755
TARGET_BOOTLOADER_BOARD_NAME := mt6755
TARGET_BOARD_PLATFORM_GPU := mali-t860mp2

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

BOARD_NAME := l681

# Assert
# "m3note" is intentionally left out: it belongs to the m681 board revision.
TARGET_OTA_ASSERT_DEVICE := l681,l681h,l91

# Display
# 1080x1920 panel. The LCM driver is selected by name by the bootloader
# (lcm= on the kernel command line); the kernel carries several panel drivers.
TARGET_SCREEN_WIDTH := 1080
TARGET_SCREEN_HEIGHT := 1920
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# A-only stock partition geometry. No dynamic partitions or super partition.
BOARD_FLASH_BLOCK_SIZE := 131072

BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2684354560
BOARD_CACHEIMAGE_PARTITION_SIZE := 452984832
BOARD_USERDATAIMAGE_PARTITION_SIZE := 27879521280

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4

# A-only. No A/B, no virtual A/B, no dynamic partitions, no super image.
# PRODUCT_USE_DYNAMIC_PARTITIONS must not be assigned here: it is a product
# variable and already read-only when BoardConfig.mk is read.
AB_OTA_UPDATER := false
BOARD_USES_RECOVERY_AS_BOOT := false
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false

# Treble uses the stock custom partition for /vendor.
# The shipping API remains that of the stock vendor ABI; VNDK is selected explicitly.
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912
BOARD_VNDK_VERSION := current

BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# The prebuilt Nougat-era blobs are installed with PRODUCT_COPY_FILES, so their
# DT_NEEDED entries are not checked at build time.
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true

# Boot header addresses and page size must match this board.
# Keep the base and offsets together when changing kernel packaging.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x03f88000
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset $(BOARD_RAMDISK_OFFSET) --second_offset $(BOARD_SECOND_OFFSET) --tags_offset $(BOARD_TAGS_OFFSET)

# Legacy MTK boot header: no header_version, no dtb in bootimg, no dtbo.
BOARD_BOOT_HEADER_VERSION := 0
BOARD_INCLUDE_DTB_IN_BOOTIMG :=
BOARD_INCLUDE_RECOVERY_DTBO :=

# Keep hardware identity and binder devices in the kernel command line.
# LCM selection remains with the bootloader and board kernel.
BOARD_KERNEL_CMDLINE := $(strip $(L681_KERNEL_CMDLINE_EXTRA) bootopt=64S3,32N2,64N2 androidboot.selinux=permissive enforcing=0)

# First-stage mount uses by-name paths (rootdir/etc/fstab.mt6755), so
# androidboot.partition_map is not needed on the command line.

# Kernel
# Prebuilt 3.10.72 kernel with binder, hwbinder and vndbinder. This tree never
# compiles a kernel; kernel/meizu/m681 only provides the generated kernel
# headers needed by libtinycompress.
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/meizu/m681
TARGET_KERNEL_CONFIG := m681_49_defconfig
TARGET_FORCE_PREBUILT_KERNEL := true
TARGET_KERNEL_VERSION := 3.10
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel

# Exact kernel identity gate; no claim about Android-version compatibility.
L681_PREBUILT_SHA256 := a150f5756935be8c78bbdafe56425f9502184d9bcc8692126fba0a2928199693
l681_kernel_sha256 := $(word 1,$(shell sha256sum $(TARGET_PREBUILT_KERNEL)))
ifneq ($(l681_kernel_sha256),$(L681_PREBUILT_SHA256))
$(error l681 prebuilt kernel differs from the pinned a9binder2 artifact)
endif

# Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6755
BOARD_SUPPRESS_SECURE_ERASE := true
BOARD_CHARGER_SHOW_PERCENTAGE := true

# Wi-Fi
# MediaTek WMT / CONNSYS combo chip (not Broadcom).
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0

# SELinux
# The Nougat-era MTK blobs violate current neverallow rules; SELinux is
# permissive via the kernel command line. Revisit before an enforcing build.
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Qualcomm
# Keep off: otherwise SurfaceFlinger is built with the QTI display wrappers.
BOARD_USES_QCOM_HARDWARE := false
TARGET_USES_QCOM_BSP := false

# Properties
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop

# Shims
# TARGET_LD_SHIM_LIBS for the Nougat-ABI Mali EGL, gralloc and libgui_ext blobs.
include vendor/meizu/m681/BoardConfigVendor.mk
