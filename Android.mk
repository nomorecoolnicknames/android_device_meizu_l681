LOCAL_PATH:= $(call my-dir)

ifneq ($(filter l681, $(TARGET_DEVICE)),)

# Several shared makefiles are gated on TARGET_DEVICE and list m681 but not
# l681. Include them here so their modules exist for this device. If one of
# them later adds l681 to its own filter, drop the matching include.

# This tree's own subdirectories (nvram/). Keep first, while LOCAL_PATH is
# still this directory.
include $(call first-makefiles-under,$(LOCAL_PATH))

# vendor/mediatek: GUI-only symbol shims, wmt_loader, libwifi-hal-mt66xx and
# the MTK HIDL RIL (libril + rild).
MTK_SYMBOLS_GUI_ONLY := true
include vendor/mediatek/symbols/Android.mk
MTK_SYMBOLS_GUI_ONLY :=
include vendor/mediatek/combo_loader/Android.mk
include vendor/mediatek/wlan/wifi_hal/Android.mk
include vendor/mediatek/ril/Android.mk

# device/meizu/m3_meizu_m6-common: lib_driver_cmd_mt66xx, libbt-vendor,
# libxlog and flyme-res. The mkdir creates the prebuilt kernel header path.
include $(call first-makefiles-under,device/meizu/m3_meizu_m6-common)
$(shell mkdir -p $(PRODUCT_OUT)/obj/KERNEL_OBJ/usr)

# vendor/meizu/m681: its Android.mk guards every module on
# TARGET_DEVICE == m681. Include it with TARGET_DEVICE temporarily set to m681;
# install paths are already fixed at this point, so they stay those of l681.
l681_saved_target_device := $(TARGET_DEVICE)
TARGET_DEVICE := m681
include vendor/meizu/m681/Android.mk
TARGET_DEVICE := $(l681_saved_target_device)
l681_saved_target_device :=
ifeq ($(ALL_MODULES.mtk-ril.PATH),)
$(error l681: vendor/meizu/m681/Android.mk defined no mtk-ril module -- its TARGET_DEVICE guard changed; see device/meizu/l681/Android.mk step 4)
endif

endif
