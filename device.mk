LOCAL_PATH := device/meizu/l681
TARGET_MEIZU_MT675X_DEVICE := l681

$(call inherit-product, device/meizu/mt6755-common/device-common.mk)
# Not every tree ships the dalvik heap presets; dalvik.vm.heap* is set elsewhere.
$(call inherit-product-if-exists, frameworks/native/build/phone-xxhdpi-3072-dalvik-heap.mk)

# Board-specific stock files
# Keep above the m681 vendor inherit: the first PRODUCT_COPY_FILES entry for a
# destination wins, so these override the m681 copies.
# The modem (HQ6755_66_B1A_L, MOLY.LR11.W1539) carries the board RF
# configuration; m681 modem, WMT/Wi-Fi firmware and sensor HAL files must not
# be used on l681. Sensors use the L681H hwmsen HAL with msensord and akmd09911.
ifeq ($(strip $(L681_STOCK_DIR)),)
$(error Set L681_STOCK_DIR to the matching L681H L91 stock system directory)
endif
l681_stock_check := $(shell $(LOCAL_PATH)/tools/check_l681_stock.sh \
        $(L681_STOCK_DIR) $(LOCAL_PATH)/l681-stock-files.sha256)
ifneq ($(strip $(l681_stock_check)),)
$(error $(l681_stock_check))
endif

PRODUCT_COPY_FILES += \
    $(L681_STOCK_DIR)/etc/firmware/modem_1_ulwctg_n.img:$(TARGET_COPY_OUT_VENDOR)/firmware/modem_1_ulwctg_n.img \
    $(L681_STOCK_DIR)/etc/firmware/dsp_1_ulwctg_n.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/dsp_1_ulwctg_n.bin \
    $(L681_STOCK_DIR)/etc/firmware/modem_3_3g_n.img:$(TARGET_COPY_OUT_VENDOR)/firmware/modem_3_3g_n.img \
    $(L681_STOCK_DIR)/etc/firmware/catcher_filter_1_ulwctg_n.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/catcher_filter_1_ulwctg_n.bin \
    $(L681_STOCK_DIR)/etc/firmware/catcher_filter_3_3g_n.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/catcher_filter_3_3g_n.bin \
    $(L681_STOCK_DIR)/etc/firmware/em_filter_1_ulwctg_n.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/em_filter_1_ulwctg_n.bin \
    $(L681_STOCK_DIR)/etc/firmware/ROMv2_lm_patch_1_0_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv2_lm_patch_1_0_hdr.bin \
    $(L681_STOCK_DIR)/etc/firmware/ROMv2_lm_patch_1_1_hdr.bin:$(TARGET_COPY_OUT_VENDOR)/firmware/ROMv2_lm_patch_1_1_hdr.bin \
    $(L681_STOCK_DIR)/etc/firmware/WIFI_RAM_CODE_6755:$(TARGET_COPY_OUT_VENDOR)/firmware/WIFI_RAM_CODE_6755 \
    $(L681_STOCK_DIR)/etc/firmware/WIFI_RAM_CODE_6755:system/etc/firmware/WIFI_RAM_CODE \
    $(L681_STOCK_DIR)/etc/firmware/WIFI_RAM_CODE_6755:system/etc/firmware/WIFI_RAM_CODE_6755 \
    $(L681_STOCK_DIR)/etc/mddb/DbgInfo_LR11.W1539.MD.MP_HQ6755_66_B1A_L_MOLY_LR11_W1539_MD_MP_V9_P20_2016_11_16_19_58_1_ulwctg_n:$(TARGET_COPY_OUT_VENDOR)/etc/mddb/DbgInfo_LR11.W1539.MD.MP_HQ6755_66_B1A_L_MOLY_LR11_W1539_MD_MP_V9_P20_2016_11_16_19_58_1_ulwctg_n \
    $(L681_STOCK_DIR)/etc/mddb/MDDB_InfoCustomAppSrcP_MT6755_S00_MOLY_LR11_W1539_MD_MP_V9_P20_1_ulwctg_n.EDB:$(TARGET_COPY_OUT_VENDOR)/etc/mddb/MDDB_InfoCustomAppSrcP_MT6755_S00_MOLY_LR11_W1539_MD_MP_V9_P20_1_ulwctg_n.EDB \
    $(L681_STOCK_DIR)/etc/mddb/MDDB.META_MT6755_S00_MOLY_LR11_W1539_MD_MP_V9_P20_1_ulwctg_n.EDB:$(TARGET_COPY_OUT_VENDOR)/etc/mddb/MDDB.META_MT6755_S00_MOLY_LR11_W1539_MD_MP_V9_P20_1_ulwctg_n.EDB \
    $(L681_STOCK_DIR)/etc/mddb/mdm_layout_desc_1_ulwctg_n.dat:$(TARGET_COPY_OUT_VENDOR)/etc/mddb/mdm_layout_desc_1_ulwctg_n.dat \
    $(L681_STOCK_DIR)/lib/hw/sensors.mt6755.so:$(TARGET_COPY_OUT_VENDOR)/lib/hw/sensors.mt6755.so \
    $(L681_STOCK_DIR)/lib64/hw/sensors.mt6755.so:$(TARGET_COPY_OUT_VENDOR)/lib64/hw/sensors.mt6755.so \
    $(L681_STOCK_DIR)/bin/msensord:$(TARGET_COPY_OUT_VENDOR)/bin/msensord \
    $(L681_STOCK_DIR)/bin/akmd09911:$(TARGET_COPY_OUT_VENDOR)/bin/akmd09911 \
    $(LOCAL_PATH)/rootdir/l681-sensors.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/l681-sensors.rc

$(call inherit-product, vendor/meizu/m681/m681-vendor.mk)

PRODUCT_DEVICE := l681

# Keep the platform camera and audio libraries: the Flyme copies shadow the
# LineageOS ones and break app_process. filter-out supports one '%' wildcard,
# so match on the destination suffix.
PRODUCT_COPY_FILES := $(filter-out \
    %:system/lib/libcamera_metadata.so \
    %:system/lib64/libcamera_metadata.so \
    %:system/lib/libcamera_client.so \
    %:system/lib64/libcamera_client.so \
    %:system/lib/libcamera2ndk.so \
    %:system/lib64/libcamera2ndk.so \
    %:system/lib/libcameraservice.so \
    %:system/lib64/libcameraservice.so \
    %:system/lib/libaudioflinger.so \
    %:system/lib/libaudiopolicymanager.so \
    %:system/lib64/libaudiopolicymanager.so \
    %:system/lib/libaudiopolicymanagerdefault.so \
    %:system/lib64/libaudiopolicymanagerdefault.so \
    %:system/lib/libaudiopolicyservice.so \
    %:system/lib64/libaudiopolicyservice.so \
    %:system/lib/libaudiopolicyenginedefault.so \
    %:system/lib64/libaudiopolicyenginedefault.so \
    %:system/lib/libaudioeffect_jni.so \
    %:system/lib64/libaudioeffect_jni.so \
    %:system/etc/audio_policy_configuration.xml \
    %:system/etc/audio_policy_volumes.xml \
    %:system/etc/default_volume_tables.xml \
    %:system/etc/a2dp_audio_policy_configuration.xml \
    %:system/etc/usb_audio_policy_configuration.xml \
    %:system/etc/r_submix_audio_policy_configuration.xml \
    vendor/meizu/m681/proprietary/vendor/app/AtciService/% \
    vendor/meizu/m681/proprietary/vendor/app/AutoDialer/% \
    vendor/meizu/m681/proprietary/vendor/app/BatteryWarning/% \
    vendor/meizu/m681/proprietary/vendor/app/BtTool/% \
    vendor/meizu/m681/proprietary/vendor/app/CalendarImporter/% \
    vendor/meizu/m681/proprietary/vendor/app/DrmProvider/% \
    vendor/meizu/m681/proprietary/vendor/app/EngineerMode/% \
    vendor/meizu/m681/proprietary/vendor/app/Gba/% \
    vendor/meizu/m681/proprietary/vendor/app/LocationEM2/% \
    vendor/meizu/m681/proprietary/vendor/app/MDMLSample/% \
    vendor/meizu/m681/proprietary/vendor/app/MTKLogger/% \
    vendor/meizu/m681/proprietary/vendor/app/MTKThermalManager/% \
    vendor/meizu/m681/proprietary/vendor/app/MiraVision/% \
    vendor/meizu/m681/proprietary/vendor/app/MtkFloatMenu/% \
    vendor/meizu/m681/proprietary/vendor/app/RootPA/% \
    vendor/meizu/m681/proprietary/vendor/app/SelfRegister/% \
    vendor/meizu/m681/proprietary/vendor/app/SensorHub/% \
    vendor/meizu/m681/proprietary/vendor/app/SimRecoveryTestTool/% \
    vendor/meizu/m681/proprietary/vendor/app/YGPS/%,\
    $(PRODUCT_COPY_FILES))

# Kernel
# Install the prebuilt kernel explicitly. M681_PREBUILT_KERNEL is rejected: the
# first PRODUCT_COPY_FILES rule for :kernel wins and would put an m681 kernel
# into the l681 boot image.
ifneq ($(strip $(M681_PREBUILT_KERNEL)),)
$(error l681: M681_PREBUILT_KERNEL задан ($(M681_PREBUILT_KERNEL)) — ядро m681 в boot.img l681 недопустимо; снимите переменную)
endif
M681_EFFECTIVE_KERNEL_PREBUILT := $(strip $(TARGET_PREBUILT_KERNEL))
ifneq ($(M681_EFFECTIVE_KERNEL_PREBUILT),)
PRODUCT_COPY_FILES += \
    $(M681_EFFECTIVE_KERNEL_PREBUILT):kernel
endif

# Audio
# libaudio_param_parser.so searches /sdcard/.audio_param, /odm/etc/audio_param,
# /vendor/etc/audio_param and /system/etc/audio_param; mirror the calibration
# set to /system/etc/audio_param as a fallback.
M681_AUDIO_PARAM_SRC := $(wildcard vendor/meizu/m681/proprietary/vendor/etc/audio_param/*)
PRODUCT_COPY_FILES += \
    $(foreach f,$(M681_AUDIO_PARAM_SRC),$(f):system/etc/audio_param/$(notdir $(f)))
# Legacy MTK audio_policy.conf, also probed under /system/etc.
PRODUCT_COPY_FILES += \
    vendor/meizu/m681/proprietary/vendor/etc/audio_policy.conf:system/etc/audio_policy.conf

# Runtime vendor fixes:
# - mnld is a 32-bit vendor binary and aborts without libcurl.
# - Goodix fingerprint HAL links libgf_* from the legacy system linker namespace.
# - camera libcam_platform dlopens libvmp_render from the vendor namespace.
# - camera libcam.camadapter needs the stock FilterEffect_ProcessImage symbol.
# - camera.mt6755.so is a stock vendor HAL; keep its camera_client/metadata ABI
#   in the vendor search path without replacing framework-owned system copies.
# - stock ProjectConfig keeps the Flyme camera feature matrix visible at runtime.
# - stock static fuelgauged avoids a libfgauge/libc++ bad_alloc abort.
# - fp-keys/mtk-kpd/ACCDET must not fall back to Generic.kl.
PRODUCT_COPY_FILES += \
    vendor/meizu/m681/proprietary/vendor/lib/libcurl.so:$(TARGET_COPY_OUT_VENDOR)/lib/libcurl.so \
    vendor/meizu/m681/proprietary/vendor/lib/libvmp_render.so:$(TARGET_COPY_OUT_VENDOR)/lib/libvmp_render.so \
    vendor/meizu/m681/proprietary/lib/libcamera_client.so:$(TARGET_COPY_OUT_VENDOR)/lib/libcamera_client.so \
    vendor/meizu/m681/proprietary/lib/libcamera_metadata.so:$(TARGET_COPY_OUT_VENDOR)/lib/libcamera_metadata.so \
    vendor/meizu/m681/proprietary/vendor/data/misc/ProjectConfig.mk:$(TARGET_COPY_OUT_VENDOR)/data/misc/ProjectConfig.mk \
    vendor/meizu/m681/proprietary/lib/libfilter_effects.so:system/lib/libfilter_effects.so \
    vendor/meizu/m681/proprietary/lib64/libfilter_effects.so:system/lib64/libfilter_effects.so \
    vendor/meizu/m681/proprietary/bin/goodixfingerprintd:system/bin/goodixfingerprintd \
    vendor/meizu/m681/proprietary/lib/libcamera_client_mtk.so:system/lib/libcamera_client_mtk.so \
    vendor/meizu/m681/proprietary/lib64/libcamera_client_mtk.so:system/lib64/libcamera_client_mtk.so \
    vendor/meizu/m681/proprietary/vendor/lib/libMcClient.so:system/lib/libMcClient.so \
    vendor/meizu/m681/proprietary/lib/libgf_ca.so:system/lib/libgf_ca.so \
    vendor/meizu/m681/proprietary/vendor/lib64/libvmp_render.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libvmp_render.so \
    vendor/meizu/m681/proprietary/lib64/libcamera_client.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libcamera_client.so \
    vendor/meizu/m681/proprietary/lib64/libcamera_metadata.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libcamera_metadata.so \
    vendor/meizu/m681/proprietary/vendor/lib64/libMcClient.so:system/lib64/libMcClient.so \
    vendor/meizu/m681/proprietary/lib64/libgf_hal.so:system/lib64/libgf_hal.so \
    vendor/meizu/m681/proprietary/lib64/libgf_ca.so:system/lib64/libgf_ca.so \
    vendor/meizu/m681/proprietary/lib64/libgf_algo.so:system/lib64/libgf_algo.so \
    vendor/meizu/m681/proprietary/vendor/bin/fuelgauged_static:system/bin/fuelgauged_static \
    $(LOCAL_PATH)/keylayout/fp-keys.kl:system/usr/keylayout/fp-keys.kl \
    $(LOCAL_PATH)/keylayout/mtk-kpd.kl:system/usr/keylayout/mtk-kpd.kl \
    $(LOCAL_PATH)/keylayout/ACCDET.kl:system/usr/keylayout/ACCDET.kl

# Modem firmware comes from L681_STOCK_DIR above; ccci_mdinit looks it up by
# file name in /custom/etc/firmware and /vendor/firmware.
# The IMEI lives in NVRAM: back up nvram, nvdata and proinfo before flashing.

PRODUCT_PROPERTY_OVERRIDES += \
    rild.libpath=mtk-ril.so \
    ril.first.md=1 \
    ril.active.md=12 \
    ril.current.share_modem=2 \
    ril.external.md=0 \
    ril.flightmode.poweroffMD=0 \
    ril.radiooff.poweroffMD=0 \
    ril.specific.sm_cause=0 \
    ril.telephony.mode=0 \
    ro.telephony.sim.count=2 \
    ro.telephony.default_network=9,9 \
    persist.m681.ril.no_ia=1 \
    persist.radio.default.sim=0 \
    persist.radio.mobile.data=1,1 \
    persist.radio.mobile.enable=1,1 \
    persist.radio.multisim.config=dsds \
    persist.radio.flashless.fsm=0 \
    persist.radio.flashless.fsm_cst=0 \
    persist.radio.flashless.fsm_rw=0 \
    persist.radio.fd.counter=15 \
    persist.radio.fd.off.counter=5 \
    persist.radio.fd.r8.counter=15 \
    persist.radio.fd.off.r8.counter=5 \
    persist.radio.mtk_dsbp_support=1 \
    persist.radio.mtk_ps2_rat=W/G \
    wifi.interface=wlan0 \
    wifi.direct.interface=wlan0 \
    wifi.tethering.interface=ap0 \
    ro.mtk.no_conn_autostart=true \
    qemu.hw.mainkeys=0 \
    ro.mediatek.wlan.wsc=1 \
    ro.mediatek.wlan.p2p=0 \
    ro.mediatek.gemini_support=true \
    ro.mediatek.chip_ver=S01 \
    ro.mediatek.version.sdk=4 \
    ro.mtk_agps_app=1 \
    ro.mtk_bt_support=1 \
    ro.mtk_c2k_support=0 \
    ro.mtk.c2k.om.mode=none \
    ro.mtk.c2k.slot2.support=0 \
    ro.mtk_dhcpv6c_wifi=1 \
    ro.mtk_eap_sim_aka=1 \
    ro.mtk_enable_md1=1 \
    ro.mtk_enable_md3=0 \
    ro.mtk_external_sim_support=0 \
    ro.mtk_gemini_support=1 \
    ro.mtk_gemini_enhancement=1 \
    ro.mtk_gps_support=1 \
    ro.mtk_lte_support=1 \
    ro.mtk_md_world_mode_support=1 \
    ro.mtk_modem_monitor_support=1 \
    ro.mtk_srlte_support=1 \
    ro.mtk_sim_hot_swap=1 \
    ro.mtk_sim_hot_swap_common_slot=1 \
    ro.mtk_trustonic_tee_support=1 \
    ro.mtk_wapi_support=1 \
    ro.mtk_wlan_support=1 \
    ro.mtk_world_phone=1 \
    ro.mtk_world_phone_policy=0 \
    ro.mtk_audio_ape_support=1 \
    ro.mtk_deinterlace_support=1 \
    ro.mtk_flv_playback_support=1 \
    ro.mtk_widevine_drm_l3_support=1 \
    ro.mtk_wmv_playback_support=1 \
    ro.mtk_wfd_support=1 \
    ro.mtk_wfd_sink_support=1 \
    ro.mtk_wfd_sink_uibc_support=1 \
    persist.mtk.datashaping.support=1 \
    persist.mtk.wcn.combo.chipid=-1 \
    persist.mtk.wcn.dynamic.dump=0 \
    persist.mtk.wcn.fwlog.status=no

# PackageManager aborts if any compiler-filter property is empty.
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    pm.dexopt.first-boot=verify-at-runtime \
    pm.dexopt.boot=verify-at-runtime \
    pm.dexopt.install=interpret-only \
    pm.dexopt.bg-dexopt=speed-profile \
    pm.dexopt.ab-ota=speed-profile \
    pm.dexopt.nsys-library=speed \
    pm.dexopt.shared-apk=speed \
    pm.dexopt.forced-dexopt=speed \
    pm.dexopt.core-app=speed

PRODUCT_PROPERTY_OVERRIDES += \
    persist.m681.cam.no_torch=0 \
    persist.m681.cam.force640=0 \
    persist.m681.cam.no_fullraw=1 \
    persist.m681.cam.p1path=2 \
    persist.m681.cam.pre_p1magic=1 \
    persist.m681.cam.sync_tuning=1 \
    persist.m681.cam.deq_retry=0 \
    persist.m681.cam.deq_us=50000 \
    persist.m681.cam.deq_to=100 \
    camera.disable_zsl_mode=1 \
    camera.zsdmode=0 \
    debug.featurepipe.enable=0 \
    debug.tworunpass2.enable=0 \
    debug.lowPowerVR.enable=0 \
    debug.forceFPS.enable=0 \
    debug.pass1.pdafon=0 \
    debug.pass1.rawtype=0 \
    debug.mtk_cam_zsdmfb_support=0 \
    debug.mtk_cam_zsdhdr_support=0 \
    debug.camera.vfb.disable=1 \
    debug.camera.eis.disable=1 \
    debug.eis.EMEnabled=0 \
    debug.eis.dump=0 \
    debug.eisDrv.dump=0 \
    debug.eis.disable=1 \
    persist.camera.eis.enable=0 \
    persist.camera.eis.disable=1 \
    persist.camera.vfb.enable=0 \
    persist.camera.vfb.disable=1 \
    cam.dumpnpipelog.enable=0 \
    camera.featurepipe.dumpvfb=0

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:system/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:system/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:system/etc/permissions/android.hardware.fingerprint.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:system/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.software.backup.xml:system/etc/permissions/android.software.backup.xml \
    frameworks/native/data/etc/android.software.print.xml:system/etc/permissions/android.software.print.xml \
    frameworks/native/data/etc/android.software.sip.xml:system/etc/permissions/android.software.sip.xml \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration.xml:system/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:system/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:system/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration.xml:system/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:system/etc/usb_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:system/etc/r_submix_audio_policy_configuration.xml \
    hardware/broadcom/wlan/bcmdhd/config/p2p_supplicant_overlay.conf:system/etc/wifi/p2p_supplicant_overlay.conf \
    hardware/broadcom/wlan/bcmdhd/config/wpa_supplicant_overlay.conf:system/etc/wifi/wpa_supplicant_overlay.conf \
    $(LOCAL_PATH)/wifi/wifi_concurrency_cfg.txt:system/etc/wifi/wifi_concurrency_cfg.txt \
    vendor/meizu/m681/proprietary/vendor/firmware/WMT_SOC.cfg:system/etc/firmware/WMT_SOC.cfg \
    $(LOCAL_PATH)/gps/gps.conf:system/etc/gps.conf \
    $(LOCAL_PATH)/media/media_codecs.xml:system/etc/media_codecs.xml \
    $(LOCAL_PATH)/media/media_codecs_performance.xml:system/etc/media_codecs_performance.xml \
    $(LOCAL_PATH)/media/media_codecs_mediatek_audio.xml:system/etc/media_codecs_mediatek_audio.xml \
    $(LOCAL_PATH)/media/media_codecs_mediatek_video.xml:system/etc/media_codecs_mediatek_video.xml \
    $(LOCAL_PATH)/media/media_codecs_google_audio.xml:system/etc/media_codecs_google_audio.xml \
    $(LOCAL_PATH)/media/media_codecs_google_video_le.xml:system/etc/media_codecs_google_video_le.xml \
    $(LOCAL_PATH)/media/media_profiles.xml:system/etc/media_profiles.xml \
    $(LOCAL_PATH)/rootdir/default.prop:root/default.prop \
    $(LOCAL_PATH)/rootdir/FWUpgradeInit.rc:root/FWUpgradeInit.rc \
    $(LOCAL_PATH)/sepolicy/file_contexts:root/file_contexts \
    $(LOCAL_PATH)/rootdir/fstab.mt6755:root/fstab.mt6755 \
    $(LOCAL_PATH)/rootdir/init.aee.rc:root/init.aee.rc \
    $(LOCAL_PATH)/rootdir/init.c2k.rc:root/init.c2k.rc \
    $(LOCAL_PATH)/rootdir/init.common_svc.rc:root/init.common_svc.rc \
    $(LOCAL_PATH)/rootdir/init.connectivity.rc:root/init.connectivity.rc \
    $(LOCAL_PATH)/rootdir/init.epdg.rc:root/init.epdg.rc \
    $(LOCAL_PATH)/rootdir/init.fon.rc:root/init.fon.rc \
    $(LOCAL_PATH)/rootdir/init.microtrust.rc:root/init.microtrust.rc \
    $(LOCAL_PATH)/rootdir/init.modem.rc:root/init.modem.rc \
    $(LOCAL_PATH)/rootdir/init.mt6755.rc:root/init.mt6755.rc \
    $(LOCAL_PATH)/rootdir/init.mt6755.usb.rc:root/init.mt6755.usb.rc \
    $(LOCAL_PATH)/rootdir/init.no_ssd.rc:root/init.no_ssd.rc \
    $(LOCAL_PATH)/rootdir/init.nvdata.rc:root/init.nvdata.rc \
    $(LOCAL_PATH)/rootdir/init.preload.rc:root/init.preload.rc \
    $(LOCAL_PATH)/rootdir/init.project.rc:root/init.project.rc \
    $(LOCAL_PATH)/rootdir/init.recovery.mt6755.rc:root/init.recovery.mt6755.rc \
    $(LOCAL_PATH)/rootdir/init.rilproxy.rc:root/init.rilproxy.rc \
    $(LOCAL_PATH)/rootdir/init.ssd.rc:root/init.ssd.rc \
    $(LOCAL_PATH)/rootdir/init.ssd_nomuser.rc:root/init.ssd_nomuser.rc \
    $(LOCAL_PATH)/rootdir/init.trace.rc:root/init.trace.rc \
    $(LOCAL_PATH)/rootdir/init.trustonic.rc:root/init.trustonic.rc \
    $(LOCAL_PATH)/rootdir/init.usb.configfs.rc:root/init.usb.configfs.rc \
    $(LOCAL_PATH)/rootdir/init.volte.rc:root/init.volte.rc \
    $(LOCAL_PATH)/rootdir/init.xlog.rc:root/init.xlog.rc \
    $(LOCAL_PATH)/rootdir/init.zygote32.rc:root/init.zygote32.rc \
    $(LOCAL_PATH)/rootdir/init.zygote64_32.rc:root/init.zygote64_32.rc \
    $(LOCAL_PATH)/rootdir/property_contexts:root/property_contexts \
    $(LOCAL_PATH)/rootdir/seapp_contexts:root/seapp_contexts \
    $(LOCAL_PATH)/rootdir/service_contexts:root/service_contexts \
    $(LOCAL_PATH)/rootdir/ueventd.mt6755.rc:root/ueventd.mt6755.rc \
    $(LOCAL_PATH)/rootdir/ueventd.rc:root/ueventd.rc \
    $(LOCAL_PATH)/rootdir/bin/pstore-preserve.sh:root/sbin/pstore-preserve.sh \
    $(LOCAL_PATH)/rootdir/bin/bootdiag-mark.sh:root/sbin/bootdiag-mark.sh \
    $(LOCAL_PATH)/rootdir/bin/mcregistry-setup.sh:root/sbin/mcregistry-setup.sh \
    $(LOCAL_PATH)/rootdir/bin/repair-userde.sh:root/sbin/repair-userde.sh \
    $(LOCAL_PATH)/rootdir/bin/m681_connectivity_autostart.sh:root/sbin/m681_connectivity_autostart.sh \
    $(LOCAL_PATH)/rootdir/bin/m681_wifi_kick.sh:system/bin/m681_wifi_kick.sh \
    $(LOCAL_PATH)/rootdir/bin/forge-ril-kick.sh:system/bin/forge-ril-kick.sh \
    $(LOCAL_PATH)/rootdir/forge-ril-kick.rc:system/etc/init/forge-ril-kick.rc \
    $(LOCAL_PATH)/rootdir/forge-diag.rc:system/etc/init/forge-diag.rc \
    $(LOCAL_PATH)/rootdir/bin/m681_mdtype_fix.sh:system/bin/m681_mdtype_fix.sh \
    $(LOCAL_PATH)/rootdir/bin/m681_postboot_recover.sh:system/bin/m681_postboot_recover.sh
# The InvenSense libraries are not needed: their only consumer is the m681
# sensor HAL, which this device does not use.

PRODUCT_PACKAGES += \
    libfs_mgr \
    libion \
    libwifi-hal-mt66xx \
    libtinycompress \
    libtinyxml \
    libtinyxml_32 \
    libxml2 \
    m681_nvram_wifi_repair \
    org.apache.http.legacy \
    sgdisk \
    m681_vendor_hal_symlinks \
    wpa_supplicant \
    wpa_supplicant.conf

# MTK framework resources, VoLTE/VoWiFi and diagnostics (prebuilt modules
# from vendor/meizu/m681).
PRODUCT_PACKAGES += \
    mediatek-res \
    CustomPropInterface \
    ImsService \
    WfoService \
    CDS_INFO

# HIDL
# HAL services for the Nougat vendor blobs; same layout as the MT675x
# meizu_m6 tree.

# Service managers
PRODUCT_PACKAGES += \
    hwservicemanager \
    vndservicemanager \
    servicemanager \
    mediaserver

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.graphics.allocator@2.0-impl \
    android.hardware.graphics.allocator@2.0-service \
    android.hardware.graphics.composer@2.1-impl \
    android.hardware.graphics.mapper@2.0-impl \
    android.hardware.memtrack@1.0-impl \
    android.hardware.renderscript@1.0-impl \
    libmtkshim_gui \
    libmtkshim_ui \
    libmtkshim_sensor \
    libmtkshim_icu

# Health / thermal / power
PRODUCT_PACKAGES += \
    android.hardware.health@1.0-impl \
    android.hardware.health@1.0-service \
    android.hardware.thermal@1.0-impl \
    android.hardware.thermal@1.0-service \
    android.hardware.power@1.0-impl \
    power.default

# Lights: the generic AOSP passthrough service wraps lights.mt6755.so. Both
# -service and -impl are required: the service dlopens the -impl library.
PRODUCT_PACKAGES += \
    android.hardware.light@2.0-service \
    android.hardware.light@2.0-impl

# Vibrator: MTK wrapper service for vibrator.default.so.
PRODUCT_PACKAGES += \
    android.hardware.vibrator@1.0-service.mtk

# Audio
PRODUCT_PACKAGES += \
    android.hardware.audio@2.0-impl \
    android.hardware.audio@2.0-service.mtk \
    android.hardware.audio.effect@2.0-impl \
    libaudiopolicymanagerdefault \
    libaudio-resampler \
    libnbaio \
    libtinyalsa \
    libtinycompress \
    libtinyxml \
    libfs_mgr

# Sensors: wrappers around the stock hwmsen sensors.mt6755.so.
PRODUCT_PACKAGES += \
    android.hardware.sensors@1.0-impl.mtk \
    android.hardware.sensors@1.0-service.mtk

# Keymaster / DRM
PRODUCT_PACKAGES += \
    android.hardware.keymaster@3.0-impl \
    android.hardware.drm@1.0-impl \
    android.hardware.drm@1.0-service

# Camera / GNSS / media
# The camera provider service needs the passthrough -impl library, which it
# does not pull in itself.
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.0-impl \
    android.hardware.gnss@1.0-service \
    android.hardware.camera.provider@2.4-impl \
    android.hardware.camera.provider@2.4-service \
    libstagefright_soft_avcenc \
    libstagefright_soft_aacdec \
    libstagefright_soft_aacenc \
    libstagefright_soft_amrdec \
    libstagefright_soft_amrnbenc \
    libstagefright_soft_amrwbenc \
    libstagefright_soft_avcdec \
    libstagefright_soft_flacdec \
    libstagefright_soft_flacenc \
    libstagefright_soft_g711dec \
    libstagefright_soft_gsmdec \
    libstagefright_soft_hevcdec \
    libstagefright_soft_mp3dec \
    libstagefright_soft_mpeg2dec \
    libstagefright_soft_mpeg4dec \
    libstagefright_soft_mpeg4enc \
    libstagefright_soft_opusdec \
    libstagefright_soft_rawdec \
    libstagefright_soft_vorbisdec \
    libstagefright_soft_vpxdec \
    libstagefright_soft_vpxenc \
    libcurl \
    libandroid_net

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.0-service

# Wi-Fi / Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.wifi@1.0 \
    android.hardware.wifi@1.0-service \
    lib_driver_cmd_mt66xx \
    hostapd \
    wificond \
    wmt_loader \
    android.hardware.bluetooth@1.0-service.mtk

# VINTF
# Framework manifest and compatibility matrix; both live under sepolicy/.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sepolicy/manifest.xml:system/manifest.xml \
    $(LOCAL_PATH)/sepolicy/compatibility_matrix.xml:system/compatibility_matrix.xml

# hwservicemanager reads the device manifest from /vendor/manifest.xml.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/sepolicy/manifest.xml:$(TARGET_COPY_OUT_VENDOR)/manifest.xml

# Also install the media profiles under the legacy V1_0 name.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/media/media_profiles.xml:system/etc/media_profiles_V1_0.xml

# Device identity
PRODUCT_NAME := lineage_l681
PRODUCT_DEVICE := l681
PRODUCT_BRAND := meizu
PRODUCT_MANUFACTURER := Meizu
PRODUCT_MODEL := l681
PRODUCT_RELEASE_NAME := l681
TARGET_OTA_ASSERT_DEVICE := l681,l681h,l91
PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME=lineage_l681 \
    PRODUCT_DEVICE=l681 \
    TARGET_DEVICE=l681

# ADB
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.secure=0 \
    ro.debuggable=1 \
    ro.adb.secure=0
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    ro.secure=0 \
    ro.debuggable=1 \
    ro.adb.secure=0 \
    persist.sys.usb.config=adb \
    persist.service.adb.enable=1 \
    persist.sys.adb.shell=/system/bin/sh

# libalsautils is needed by the MTK audio HAL.
PRODUCT_COPY_FILES += \
    vendor/meizu/m681/proprietary/vendor/lib/libalsautils.so:$(TARGET_COPY_OUT_VENDOR)/lib/libalsautils.so \
    vendor/meizu/m681/proprietary/vendor/lib64/libalsautils.so:$(TARGET_COPY_OUT_VENDOR)/lib64/libalsautils.so

# Fingerprint
# The Goodix HAL and goodixfingerprintd list libkeymaster1.so and
# libsoftkeymaster.so in DT_NEEDED but bind no symbols from them; the vendor
# copies have those entries removed. libkeymaster1.so is still installed
# because libsoftkeymasterdevice.so uses it.
PRODUCT_COPY_FILES += \
    vendor/meizu/m681/proprietary/lib/libkeymaster1.so:system/lib/libkeymaster1.so \
    vendor/meizu/m681/proprietary/lib64/libkeymaster1.so:system/lib64/libkeymaster1.so

# libsoftkeymaster.so only satisfies DT_NEEDED of the Goodix binaries; no
# 32-bit consumer exists, so only the 64-bit copy is installed.
PRODUCT_COPY_FILES += \
    vendor/meizu/m681/proprietary/lib64/libsoftkeymaster.so:system/lib64/libsoftkeymaster.so

# goodixfpd service. It also restarts vendor.fps_hal once the daemon is up,
# since the HAL opens the device only once at start.
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/goodixfpd.rc:system/etc/init/goodixfpd.rc

# Zygote: GL preload opens /proc/ged, which fails the fork fd sanitizer.
# Set in build.prop because /system/etc/prop.default is not loaded here.
PRODUCT_PROPERTY_OVERRIDES += ro.zygote.disable_gl_preload=true

# Dexopt: no phone-*.mk preset is inherited, so provide the compiler filters.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    pm.dexopt.first-boot=quicken \
    pm.dexopt.boot=verify \
    pm.dexopt.install=quicken \
    pm.dexopt.bg-dexopt=speed-profile \
    pm.dexopt.ab-ota=speed-profile \
    pm.dexopt.inactive=verify \
    pm.dexopt.shared=speed

# Logging
# Silence expected noise: the secure OS is MicroTrust TEEI, so the Trustonic
# client cannot reach mcdaemon; vndksupport logs every vendor HAL dlopen.
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    log.tag.McClient=S \
    log.tag.McDriverClient=S \
    log.tag.TeeSyCommonClient=S \
    log.tag.TeeSyMcClient=S \
    log.tag.vndksupport=S

# Seccomp
# MTK OMX components need the extra mediacodec policy (pselect6).
PRODUCT_COPY_FILES += \
    device/meizu/l681/seccomp/mediacodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy

# RIL
# Build the MTK HIDL rild and libril (vendor/mediatek/ril) instead of the AOSP
# ones; see BoardConfig.mk.
ENABLE_VENDOR_RIL_SERVICE := true

PRODUCT_PACKAGES += \
    rild

# librilmtk and mtk-ril are prebuilt modules installed only on demand; list
# them so they are installed whichever RIL is built (rild.libpath dlopens
# mtk-ril.so at runtime).
PRODUCT_PACKAGES += \
    librilmtk \
    mtk-ril

# The MTK rild installs no init rc; replace any inherited rild.rc with ours.
PRODUCT_COPY_FILES := $(filter-out %:$(TARGET_COPY_OUT_VENDOR)/etc/init/rild.rc, \
    $(PRODUCT_COPY_FILES))
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rild-mtk-hidl.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/rild.rc
