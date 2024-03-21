# Dolby Audio Moto G Pro Magisk Module

## DISCLAIMER
- Motorola & Dolby apps and blobs are owned by Motorola™ & Dolby™.
- The MIT license specified here is for the Magisk Module only, not for Motorola & Dolby apps and blobs.

## Descriptions
- Dolby soundfx equalizer ported from Motorola Moto G Pro (sofiap_sprout) and integrated as a Magisk Module for all supported and rooted devices with Magisk
- Global type soundfx
- Changes/spoofs ro.product.brand to motorola which may break some system apps and features functionality
- Doesn't support auxiliary cable
- Conflicted with `vendor.dolby.hardware.dms@2.0-service`

## Sources
- https://dumps.tadiphone.dev/dumps/motorola/sofiap_sprout user-12-S0PR32.44-11-8-6de89-release-keys
- system_legacy: https://dumps.tadiphone.dev/dumps/motorola/sofiap_sprout sofiap_ao_eea-user-11-RPRS31.Q4U-20-36-f72e82-release-keys
- system_10: https://dumps.tadiphone.dev/dumps/motorola/sofiap_sprout sofiap_ao_eea-user-10-QPRS30.80-109-2-6-6e7cd-release-keys
- system_support: CrDroid ROM Android 13
- android.hardware.audio.effect@*-impl.so: https://dumps.tadiphone.dev/dumps/oneplus/op594dl1 qssi-user-14-UKQ1.230924.001-1701915639192-release-keys--US

## Screenshots
- https://t.me/androidryukimodsdiscussions/2722

## Requirements
- Android 9 and up
- Architecture 64 bit
- Magisk or KernelSU installed (Recommended to use Magisk Delta/Kitsune Mask for systemless early init mount manifest.xml if your ROM is Read-Only https://t.me/androidryukimodsdiscussions/100091)
- Moto Core Magisk Module installed https://github.com/reiryuki/Moto-Core-Magisk-Module except you are in Motorola ROM

## WARNING!!!
- Possibility of bootloop or even softbrick or a service failure on Read-Only ROM if you don't use Magisk Delta/Kitsune Mask.

## Installation Guide & Download Link
- Recommended to use Magisk Delta/Kitsune Mask https://t.me/androidryukimodsdiscussions/100091
- Remove any other else Dolby Magisk module with different name (no need to remove if it's the same name)
- Reboot
- Install Moto Core Magisk Module first: https://github.com/reiryuki/Moto-Core-Magisk-Module except you are in Motorola ROM
- If you have Dolby in-built in your ROM, then you need to activate data.cleanup=1 at the first time install (READ Optionals bellow!)
- Install this module https://www.pling.com/p/1531645/ via Magisk app or KernelSU app or Recovery if Magisk installed
- Install AML Magisk Module https://t.me/androidryukimodsdiscussions/29836 only if using any other else audio mod module
- Reboot
- If you are using KernelSU, you need to allow superuser list manually all package name listed in package.txt (and your home launcher app also) (enable show system apps) and reboot afterwards
- If you are using SUList, you need to allow list manually your home launcher app (enable show system apps) and reboot afterwards
- If options doesn't show up in Bluetooth audio, try disconnect and reconnect the Bluetooth and restart the app

## Optionals
- https://t.me/androidryukimodsdiscussions/2616
- Global: https://t.me/androidryukimodsdiscussions/60861
- Stream: https://t.me/androidryukimodsdiscussions/26764

## Troubleshootings
- https://t.me/androidryukimodsdiscussions/2617
- Global: https://t.me/androidryukimodsdiscussions/29836

## Support & Bug Report
- https://t.me/androidryukimodsdiscussions/2618
- If you don't do above, issues will be closed immediately

## Tested on
- Android 10 CrDroid ROM
- Android 11 DotOS ROM
- Android 12 AncientOS ROM
- Android 12.1 Nusantara ROM
- Android 13 AOSP ROM, CrDroid ROM, & AlphaDroid ROM
- Android 14 LineageOS ROM

## Credits and Contributors
- https://t.me/viperatmos
- https://t.me/androidryukimodsdiscussions
- @HELLBOY017
- You can contribute ideas about this Magisk Module here: https://t.me/androidappsportdevelopment

## Sponsors
- https://t.me/androidryukimodsdiscussions/2619


