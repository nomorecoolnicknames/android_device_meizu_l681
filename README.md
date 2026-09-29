# Meizu M3 Note (l681)

Device tree for the Meizu M3 Note (L681 board revision) for LineageOS 16.0.

## Specifications

| | |
| --- | --- |
| Codename | l681 (L681H, L91) |
| SoC | MediaTek MT6755 (Helio P10) |
| Architecture | arm64 |
| Display | 1080 x 1920 |
| Android | 9 |

## Status

- Product configuration and stock-input checks: present
- Kernel: pinned prebuilt 3.10.72
- Boot: untested
- Display, touch, Wi-Fi, Bluetooth: untested
- SIM, LTE, calls: untested
- Camera, audio, sensors, fingerprint: untested
- GPS: untested
- SELinux: permissive

## Building

Sync the LineageOS 16.0 source tree (JDK 8) and place this tree at `device/meizu/l681`.

Required inputs:

- `device/meizu/mt6755-common`
- `vendor/mediatek` sources, including the MTK telephony headers
- `vendor/meizu/m681` vendor tree
- The L681H L91 stock system, passed as `L681_STOCK_DIR` (not the M681 firmware);
  the files are checked against `l681-stock-files.sha256`
- `kernel/meizu/meizu_m6/kernel-3.18` (kernel headers)
- Prebuilt kernel at `device/meizu/l681/prebuilt-kernel/Image.gz-dtb` (checked against `prebuilt-kernel/EXPECTED.txt`)

```sh
export L681_STOCK_DIR=/path/to/l681-l91/system
source build/envsetup.sh
breakfast l681
brunch l681
```

`tools/check_copy_sources.sh "$ANDROID_BUILD_TOP" "$L681_STOCK_DIR"` checks the static
PRODUCT_COPY_FILES inputs before a build.

Related device, common and kernel trees are listed in the
[ReMeizu source index](https://github.com/nomorecoolnicknames/remeizu/blob/main/SOURCE_INDEX.md).
