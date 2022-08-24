# Boot

## Boot

![Boot](https://user-images.githubusercontent.com/76865553/136703418-a28fed86-1f46-4519-80ad-671e96b89141.jpeg)

<details>

<summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

* [Arguments](boot.md#arguments)
  * [Debugging](boot.md#debugging)
  * [GPU-specific boot arguments](boot.md#gpu-specific-boot-arguments)
  * [Network-specific boot arguments](boot.md#network-specific-boot-arguments)
  * [Other useful boot arguments](boot.md#other-useful-boot-arguments)
* [Boot-args and device properties provided by kexts](boot.md#boot-args-and-device-properties-provided-by-kexts)
  * [Lilu.kext](boot.md#lilukext)
  * [Whatevergreen.kext](boot.md#whatevergreenkext)
  * [AppleALC](boot.md#applealc)
* [Custom Logo](boot.md#custom-logo)
* [Debug](boot.md#debug)
  * [Enabling the Preeboot.log](boot.md#enabling-the-preebootlog)
* [Default Boot Volume](boot.md#default-boot-volume)
* [Default Loader](boot.md#default-loader)
* [DisableCloverHotkeys](boot.md#disablecloverhotkeys)
* [Fast](boot.md#fast)
* [HibernationFixup](boot.md#hibernationfixup)
* [Legacy](boot.md#legacy)
* [NeverDoRecovery](boot.md#neverdorecovery)
* [NeverHibernate](boot.md#neverhibernate)
* [NoEarlyProgress](boot.md#noearlyprogress)
* [RtcHibernateAware](boot.md#rtchibernateaware)
* [SignatureFixup](boot.md#signaturefixup)
* [SkipHibernateTimeout](boot.md#skiphibernatetimeout)
* [StrictHibernate](boot.md#stricthibernate)
* [Timeout](boot.md#timeout)
* [XMPDetection](boot.md#xmpdetection)
* [Adding Clover entry to the BIOS Boot menu](boot.md#adding-clover-entry-to-the-bios-boot-menu)

</details>

### Arguments

These are boot arguments that are passed over to `boot.efi`, which in turn passes them down to the system kernel. See Apple's documentation for a list n the `com.apple.Boot.plist` manual. Some commonly used ones are:

<details>

<summary><strong>List of boot-args</strong> (click to reveal content)</summary>

#### Debugging

#### GPU-specific boot arguments

For more iGPU and dGPU-related boot args see the Whatevergreen topic.

#### Network-specific boot arguments

#### Other useful boot arguments

### Boot-args and device properties provided by kexts

#### Lilu.kext

Assorted Lilu boot-args. Remember that Lilu acts as a patch engine providing functionality for other kexts in the hackintosh universe, so you got to be aware of that if you use any of these commands!

#### Whatevergreen.kext

Listed below you'll find a small but useful assortment of WEG's boot args for everything graphics-related. Check the [complete list](https://github.com/acidanthera/WhateverGreen/blob/master/README.md#boot-arguments) to find many, many more.

#### AppleALC

Boot-args for your favorite audio-enabler kext. All the Lilu boot arguments affect AppleALC as well.

If you right-click anywhere in the "Arguments" list, you will find many more boot-args not covered here:

<img src="https://user-images.githubusercontent.com/76865553/135818786-923330d4-564a-41c6-acbf-ae16b4ac0d55.png" alt="Bildschirmfoto" data-size="original">

</details>

### Custom Logo

Enables the drawing of the custom boot logo.

* `YES`– Uses the default boot style, Apple.
* `NO` – Disables custom boot logo.
* `Apple` – Use the default gray on gray Apple logo.
* `Alternate` – Use the alternate white on black Apple logo.
* `Theme` – Use the theme boot screen for entry type - NOT IMPLEMENTED.
* `None` – Use no logo only background color, gray if not specified by custom entry.

**NOTE**: As of r5140.1 "Apple" and "Alternate" don't show a progress bar. Feels like these are just a wallpaper covering the bootscreen.

### Debug

If set to `true`, a debug log will be created on next boot. This will slow down the boot time significantly (up to 10 minutes) but allows you figure out what the problem is since each step will be documented by writing a `debug.log` to disk/flash drive which will be saved line for line. So even if the system hangs and you have to perform a hard reset, you won't lose the log. It will be located under `/EFI/CLOVER/misc/debug.log` and collectively records all logs for all boots, as long as the `Debug` feature is enabled.

#### Enabling the Preeboot.log

Alternatively, you could use the the `preboot.log` instead which is not as in-depth but still very useful for identifying configuration issues and hardware conflicts. To enable it, press the `F2` key in the Clover Boot Menu GUI. The `preboot.log` will be saved in under `EFI/CLOVER/misc/`. However, the file's log entries end once macOS takes over control of the system. But it is still a useful resource for resolving issues that occur prior to macOS being started – and it's way faster than using the `Debug` option.

### Default Boot Volume

Default Boot Volume is used to specify which entry is the default boot entry in the Clover GUI. It can be set to:

* `LastBootedVolume`: The last booted volume will be set as default one in Clover GUI.
* Volume Name: The name of the volume. E.g. `Macintosh`.
* GUID - Globally Unique ID of the volume shown in Clover's boot, preboot or debug log. E.g. `57272A5A-7EFE-4404-9CDA-C33761D0DB3C`.
* Part of Device Path - Also shown in Clover's logs. E.g. HD(1,GPT,57272A5A-7EFE-4404-9CDA-C33761D0DB3C,0x800,0xFF000).

OS X Startup Disk can be used to reboot into another volume, but for the following reboot DefaultVolume will be used again.

### Default Loader

In addition to `DefaultVolume`, the path to the default boot loader of an Operating System can be specified here by entering the path to the boot loader or a unique portion of the file name. This can be useful for Volumes which contain multiple boot loaders, so the desired boot loader is used by default when said volume is selected.

**IMPORTANT**: You cannot use the `Default Loader` section to set Clover or OpenCore as default Boot Loaders, since both are _Boot Managers_, not _Boot Loaders!_ Boot Managers choose which Boot Loader to select. They don't actually boot the system. That's the job of Boot Loaders. Examples for _Boot Loaders_ are:

* `boot.efi` for macOS
* `bootmgfw.efi` for Windows
* `grubx64.efi` for Linux

### DisableCloverHotkeys

Disables all hotkeys in the bootloader menu. The list of all hotkeys can be found by pressing F1 in the bootloader menu.

### Fast

Skips the bootloader GUI and boots directly into the selected default volume instead. Reduces boot time but also disables any user interaction with the boot menu to change an operating system or change any other settings.

### HibernationFixup

Fixes hibernation on systems without native NVRAM support.

### Legacy

Legacy Boot. Necessary for running older versions of Windows and Linux. Depends on the hardware and the BIOS, so several algorithms have been implemented.

The options are:

* `LegacyBiosDefault`: for those UEFI BIOSes that contain a LegacyBios protocol.
* `PBRtest`, `PBR`, `PBRsata` - variants of the PBR boot algorithm.

In general, it has not been possible to achieve unconditional legacy boot operation. It is easier and better to forget about legacy systems and use UEFI versions of OSes. The oldest of them is Windows 7-64, and I personally see no reason to stick with Windows XP. Does anyone still use a 32-bit only processor? Well, good luck then!

### NeverDoRecovery

With FileVault2 technology, it is now possible to use a hotkey, but to do so, you have to override the assignments already made in Clover.

### NeverHibernate

Disables the hibernation state detection.

### NoEarlyProgress

Removes tooltips before loading the loader interface, e.g. "Welcome to Clover".

### RtcHibernateAware

The key to safely work with the RTC during hibernation. Only required in macOS 10.13.

### SignatureFixup

When hibernating, the system leaves a signature in the image, which is then checked by `boot.efi`. We wanted to fix it with this key. Probably for nothing. It's recommended to leave it disabled.

### SkipHibernateTimeout

Disables the Hibernation Timeout.

### StrictHibernate

This only works if you have working NVRAM. It is compatible with FileVault2 technology, where the old method does not work.

### Timeout

Sets the timeout in seconds (0-30 s), before the boot process continues loading the default volume. The timer is disabled if a user input occurs before the timer ends.

* `-1`: sets the timeout to infinite. Nothing happens until a user input happens.
* `Fast`: Skips the GUI and boots from the default volume instantly, so no user interaction is possible – so no chance to correct something in case of an error.

### XMPDetection

Enables (if set to `0`) or disables XMP detection. By default it's disabled (set to `-1`). Usually, enabling this feature is only necessary if the XMP Profile of the RAM is not detected. In addition to simply enabling/disabling XMP detection, you can can also choose between Profile 1 (`1`) or Profile 2 (`2`) if your RAM modules support different memory profiles. Perhaps in the future the profiles will be used for other purposes.

## Adding Clover entry to the BIOS Boot menu

If for some reason the entry for the partition containing the Clover bootloader is missing from your BIOS boot menu, you can let Clover create one. But this has to be done in from within the Clover boot menu because this affects UEFI BIOS variables working prior to Clover being started, so it can't be set up in the config.plist.

In order to do so, do the following:

1. In the Clover boot menu, select "Clover Boot Options":\
   ![screenshot1](https://user-images.githubusercontent.com/76865553/159431070-103960ad-90b8-4a1a-b86c-7127c9bfac2d.png)
2. In the next screen, you will find the PCI path pointing to the `CLOVERX64.efi` bootloader file. Clicking or hitting Enter on "Add Clover boot options for all entries" will generate a boot entry in the BIOS boot menu:\
   ![screenshot2](https://user-images.githubusercontent.com/76865553/159431126-4afa3874-d322-4cf2-b18e-942e8e76b86d.png)
