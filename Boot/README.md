# Boot
![Boot](https://user-images.githubusercontent.com/76865553/136703418-a28fed86-1f46-4519-80ad-671e96b89141.jpeg)
### Arguments

These are boot arguments that are passed over to `boot.efi`, which in turn passes them down to the system kernel. See Apple's documentation for a list n the `com.apple.Boot.plist` manual. Some commonly used ones are:

| Flag           | Description                                                 |
| :------------: | :---------------------------------------------------------- |
| `-v`           | Verbose Mode. Shows the boot log instead of the Apple Logo. |
| `-x`           | Safe Mode                                                   |
| `-s`           | Single User Mode                                            |
| `debug=0x100`  | Disables the watchdog which helps to prevent a reboot after a kernel panic. Helpful for debugging |
| `keepsyms=1`   | This is a companion setting to debug=0x100 that tells the OS to also print the symbols on a kernel panic. Helpful for debugging as well |
| `nvda_drv=1`   | Enable NVIDIA Web Drivers        |
| `nv_disable=1` | Disable NVIDIA graphics cards    |
| `wegnoegpu`    | Disables discrete GPUs, which is a requirement if it is not supported by macOS (provided by `Whatevergreen.kext`). |

On top of that, installed Kexts like Lilu, Whatevergreen and others provide boot-arg as well. If you right-click anywhere in this list you will find many more boot-args not covered here:

<details><summary><strong>Screenshot</strong></summary>
![Bildschirmfoto](https://user-images.githubusercontent.com/76865553/135818786-923330d4-564a-41c6-acbf-ae16b4ac0d55.png)
</details>

### Default Boot Volume
Default Boot Volume is used to specify which entry is the default boot entry in the Clover GUI. It can be set to:

- `LastBootedVolume`: The last booted volume will be set as default one in Clover GUI.
- Volume Name: The name of the volume. E.g. `Macintosh`.
- GUID - Globally Unique ID of the volume shown in Clover's boot, preboot or debug log. E.g. `57272A5A-7EFE-4404-9CDA-C33761D0DB3C`.
- Part of Device Path - Also shown in Clover's logs. E.g. HD(1,GPT,57272A5A-7EFE-4404-9CDA-C33761D0DB3C,0x800,0xFF000).

OS X Startup Disk can be used to reboot into another volume, but for the following reboot DefaultVolume will be used again.

### Legacy
Legacy Boot. Necessary for running older versions of Windows and Linux. Depends on the hardware and the construction of the BIOS, so several algorithms have been implemented. 

The options are:

- `LegacyBiosDefault`: for those UEFI BIOSes that contain a LegacyBios protocol.
- `PBRtest`, `PBR`, `PBRsata` - variants of the PBR boot algorithm.

In general, it has not been possible to achieve unconditional legacy boot operation. It is easier and better to forget about legacy systems and use UEFI versions of OSes. The oldest of them is Windows 7-64, and I personally see no reason to stick with WindowsXP. Does anyone still use a 32 bit only processor? Well, good luck then!

### Default Loader
In addition to `DefaultVolume`, the path of the loader can be specified as DefaultLoader. This provides more precise default entry selection for Volumes that have multiple Loaders. The value can be the complete path or a unique portion like like file name.

### XMPDetection
Detect best eXtreme Memory Profile when detecting memory or disable XMP detection.

### NoEarlyProgress
Removes tooltips before loading the loader interface, e.g. "Welcome to Clover".

### Custom Logo
Enables the drawing of the custom boot logo.

- `YES`– Uses the default boot style, Apple.
- `NO` – Disables custom boot logo.
- `Apple` – Use the default gray on gray Apple logo.
- `Alternate` – Use the alternate white on black Apple logo.
- `Theme` – Use the theme boot screen for entry type - NOT IMPLEMENTED.
- `None` – Use no logo only background color, gray if not specified by custom entry.

**NOTE**: As of r5140.1 "Apple" and "Alternate" don't show a progress bar. Feels like these are just a wallpaper covering the bootscreen.

### DisableCloverHotkeys
Disables all hotkeys in the bootloader menu. The list of all hotkeys can be found by pressing F1 in the bootloader menu.

### HibernationFixup
Fixes Hibernation on System's without native NVRAM

### NeverDoRecovery
With FileVault2 technology, it is now possible to use a hotkey, but to do so, you have to override the assignments already made in Clover.

### NeverHibernate
Disables the hibernation state detection.

### RtcHibernateAware
The key to safely work with the RTC during hibernation. Only required in macOS 10.13

### SkipHibernateTimeout
Disables the Hibernation Timeout.

### StrictHibernate
This only works if you have working NVRAM. It is compatible with FileVault2 technology, where the old way does not work.

### Timeout
Sets the timeout in seconds (0-30 s), before the boot process continues loading the default volume. The timer is disabled if a user input occurs before the timer ends. 

- `-1`: sets the timeout to infinite. Nothing happens until a user input happens. 
- `Fast`: Skips the GUI and boots from the default volume instantly, so no user interaction is possible – so no chance to correct something in case of an error.

### SignatureFixup
 When hibernating, the system leaves a signature in the image, which is then checked by `boot.efi`. We wanted to fix it with this key. Probably for nothing. It's recommended to leave it disabled.
 
### Debug
If set to `true`, a log will be created on next boot. This will seriously slow down the boot time but allows you figure out what the problem was because each step will be accompanied by writing a debug.log to disk/flash drive. The boot time is about 10 minutes just to get into the GUI. But if everything hangs, you can press Reset, and then look for the file `/EFI/CLOVER/misc/debug.log`, which collectively records all logs for all loads, as long as this parameter is set.
