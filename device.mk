#
# Copyright (C) 2026 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/meizu/l681

# Soong namespaces
# Soong has no TARGET_DEVICE guard; modules of this tree reach Make only for
# products that list the namespace here (see Android.bp).
PRODUCT_SOONG_NAMESPACES += \
    device/meizu/l681 \
    vendor/meizu/m681

# Screen density
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay

# Ramdisk
# First-stage init mounts the first_stage_mount entries, so the fstab must
# also be in the boot ramdisk, not only in /vendor/etc.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/etc/fstab.mt6755:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6755

# VINTF
# Enforced, since PRODUCT_ENFORCE_VINTF_MANIFEST follows PRODUCT_FULL_TREBLE.
DEVICE_MANIFEST_FILE := $(LOCAL_PATH)/manifest.xml

# Wi-Fi
# wpa_supplicant.conf is not a module; the device tree ships the file itself.
PRODUCT_PACKAGES += \
    libwpa_client \
    wpa_supplicant \
    hostapd

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/wifi/wpa_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/wpa_supplicant.conf \
    $(LOCAL_PATH)/wifi/p2p_supplicant.conf:$(TARGET_COPY_OUT_VENDOR)/etc/wifi/p2p_supplicant.conf

# wpa_supplicant service; nothing else in the image defines it.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/init/init.l681.wifi.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.l681.wifi.rc

# HIDL HALs and the libraries the Nougat-era blobs need in the vendor
# namespace. Same vendor set as m681.
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-service \
    android.hardware.graphics.mapper@2.0-impl-2.1 \
    android.hardware.memtrack@1.0-impl \
    android.hardware.memtrack@1.0-service \
    android.hardware.renderscript@1.0-impl \
    android.hardware.power@1.0-impl \
    android.hardware.power@1.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.light@2.0-service \
    android.hardware.vibrator@1.0-impl \
    android.hardware.vibrator@1.0-service \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service \
    android.hardware.audio.effect@2.0-impl \
    android.hardware.audio@6.0-impl \
    android.hardware.audio.effect@6.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service \
    android.hardware.drm@1.4-service.clearkey \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    android.hardware.sensors@1.0-impl \
    android.hardware.sensors@1.0-service \
    android.hardware.wifi@1.0-service \
    libwifi-hal-mt66xx \
    wificond

PRODUCT_PACKAGES += \
    libgui_mt6755fwd \
    libcamera_client_vendor \
    libstdc++.vendor \
    libtinyxml \
    libalsautils

# audio.primary.mt6755.so needs libtinycompress, which needs the kernel
# headers from kernel/meizu/m681 (see TARGET_FORCE_PREBUILT_KERNEL).
PRODUCT_PACKAGES += \
    libtinycompress

# Permissions
# Camera, sensors and Bluetooth features are not declared yet.
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/handheld_core_hardware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/handheld_core_hardware.xml

# Vendor blobs: the m681 Nougat base plus board-specific l681 files.
# Do not substitute m681 modem, connectivity firmware or sensor calibration files.
$(call inherit-product, vendor/meizu/m681/m681-vendor-blobs.mk)

# Shims for the Nougat ABI; linker wiring is in vendor/meizu/m681/BoardConfigVendor.mk.
$(call inherit-product, vendor/meizu/m681/m681-vendor-shims.mk)

PRODUCT_PACKAGES += \
    m681_vendor_symlinks
