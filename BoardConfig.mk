DEVICE_PATH := device/meizu/l681
TARGET_MEIZU_MT675X_DEVICE := l681
BOARD_SECCOMP_POLICY := $(DEVICE_PATH)/seccomp

include device/meizu/mt6755-common/BoardConfigCommon.mk
include vendor/meizu/m681/BoardConfigVendor.mk

# Display
# The old MTK display blobs are more stable with a 32-bit SurfaceFlinger.
TARGET_32_BIT_SURFACEFLINGER := true
# MTK GuiExt/HWC sets up the primary display with three buffers.
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
# The legacy MTK HWC never signals present/retire fences correctly.
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true

# Wi-Fi
# MediaTek WMT / CONNSYS combo chip; use the MTK private driver commands.
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_mt66xx
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_mt66xx
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
WIFI_DRIVER_OPERSTATE_PATH := /sys/class/net/wlan0/operstate
WIFI_DRIVER_STATE_CTRL_RETRIES := 8
WIFI_DRIVER_STATE_CTRL_RETRY_DELAY_US := 1000000

# Kernel command line
# The bootloader keeps only the first 99 bytes of the header cmdline and
# appends lcm=, fps=, vram= and androidboot.hardware itself. Keep the header
# short; L681_KERNEL_CMDLINE_EXTRA goes first so it is never cut.
BOARD_KERNEL_CMDLINE := $(strip $(L681_KERNEL_CMDLINE_EXTRA) bootopt=64S3,32N2,64N2 androidboot.selinux=permissive enforcing=0)

# Treble
# A-only, with /vendor on the stock 512 MiB "custom" partition.
# VNDK is not enabled: libgui is vendor_available but depends on libsensor,
# which is not, so soong_build fails with BOARD_VNDK_VERSION := current.
TARGET_COPY_OUT_VENDOR := vendor
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_SIZE := 536870912

# Partitions
# Sizes follow the l681 stock scatter; this board differs from m681.
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 16777216
# userdata ends at the eMMC size minus flashinfo (16 MiB) and the backup GPT,
# floored to the 128 KiB flash block.
BOARD_USERDATAIMAGE_PARTITION_SIZE := 27308982272

# A-only (non-A/B) — this device has no slot suffix or dynamic partitions.
AB_OTA_UPDATER := false

# Split system/vendor build properties (Oreo requirement).
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true

# Platform policy goes in BOARD_PLAT_SEPOLICY_DIRS, vendor policy in
# BOARD_SEPOLICY_DIRS; both live in this tree.
BOARD_PLAT_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/plat
BOARD_SEPOLICY_DIRS += \
    $(DEVICE_PATH)/sepolicy \
    $(DEVICE_PATH)/sepolicy/vendor

# Boot image
# Matches the stock boot image header: page size 2048, header version 0 and
# an empty board name, so no --board is passed.
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_MKBOOTIMG_ARGS := --ramdisk_offset 0x04f88000 --second_offset 0x00e88000 --tags_offset 0x03f88000
BOARD_RAMDISK_OFFSET := 0x04f88000
BOARD_SECOND_OFFSET := 0x00e88000
BOARD_TAGS_OFFSET := 0x03f88000

# Assert
TARGET_OTA_ASSERT_DEVICE := l681,l681h,l91
BOARD_NAME := l681
TARGET_SYSTEM_PROP := device/meizu/l681/system.prop

# Kernel
# The prebuilt kernel requires the L681 board DTB and binder, hwbinder and vndbinder devices.
TARGET_NO_KERNEL := false
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/meizu/meizu_m6/kernel-3.18
TARGET_KERNEL_CONFIG :=
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt-kernel/Image.gz-dtb
BOARD_KERNEL_IMAGE_NAME := kernel
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/prebuilt-kernel/Image.gz-dtb:kernel

# Fail the build if the prebuilt kernel does not match
# prebuilt-kernel/EXPECTED.txt.
l681_kernel_check := $(shell $(DEVICE_PATH)/tools/check_prebuilt_kernel.sh \
        $(TARGET_PREBUILT_KERNEL) $(DEVICE_PATH)/prebuilt-kernel/EXPECTED.txt)
ifneq ($(strip $(l681_kernel_check)),)
$(error $(l681_kernel_check))
endif

# RIL
# Use the MTK HIDL RIL wrapper (vendor/mediatek/ril): the stock MTK RIL blobs
# cannot publish IRadio. MTK's telephony/ril.h has a larger RIL_Env than
# AOSP's and mtk-ril.so relies on it, so its headers take precedence.
TARGET_SPECIFIC_HEADER_PATH := vendor/mediatek/include
BOARD_PROVIDES_RILD := true
BOARD_PROVIDES_LIBRIL := true
