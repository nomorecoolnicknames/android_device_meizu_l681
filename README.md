# Meizu M3 Note (l681)

Device tree for the Meizu M3 Note (L681 board revision) for LineageOS 20.0.

## Specifications

| | |
| --- | --- |
| Codename | l681 (L681H, L91) |
| SoC | MediaTek MT6755 (Helio P10) |
| CPU | ARM Cortex-A53 (arm64) |
| GPU | Mali-T860 MP2 |
| Display | 1080 x 1920 |
| Android | 13 |

## Status

- Treble product configuration: present
- Kernel: prebuilt 3.10.72; not validated with this branch
- Display, touch, Wi-Fi, Bluetooth: untested
- SIM, LTE, calls: untested
- Camera, audio, sensors, fingerprint: untested
- GPS: untested
- SELinux: permissive

## Building

Sync the LineageOS 20.0 source tree and place this tree at `device/meizu/l681`.
Add the local manifest from
[android_local_manifests_meizu](https://github.com/nomorecoolnicknames/android_local_manifests_meizu)
(branch `lineage-20.0`) to `.repo/local_manifests/` and sync again.

Required inputs:

- `vendor/meizu/m681` vendor tree for this branch
- `kernel/meizu/m681` (kernel headers only)
- Prebuilt kernel at `device/meizu/l681/prebuilt/Image.gz-dtb` (checked against `prebuilt/SHA256SUMS`)
- Platform adaptations for legacy MediaTek blobs

```sh
source build/envsetup.sh
breakfast l681
brunch l681
```

Related device, common and kernel trees are listed in the
[ReMeizu source index](https://github.com/nomorecoolnicknames/remeizu/blob/main/SOURCE_INDEX.md).
