# Boot
![Bildschirmfoto](https://user-images.githubusercontent.com/76865553/135759685-91855b87-4aa0-4cfa-9917-9b3406ed1750.png)

### Arguments

These are boot arguments that are passed to `boot.efi`, which in turn passes them to the system kernel. See Apple's documentation for a list n the `com.apple.Boot.plist` manual. Some commonly used ones are:

- `-v` &rarr;  enables "verbose" mode. Shows the boot log instead of the Apple Logo.
- `debug=0x100` &rarr; Disables the watchdog which helps to prevent a reboot after a kernel panic. Helpful for debugging
- `keepsyms=1` &rarr; This is a companion setting to debug=0x100 that tells the OS to also print the symbols on a kernel panic. Helpfull for debugging as well
- `wegnoegpu` &rarr; Disables discrete GPUs, which is a requirement if it is not supported by macOS (provided by `Whatevergreen.kext`).

On top of that, installed Kexts like Lilu, Whatevergreen and others provide boot-arg as well. If you righ-click anywhere in this list you wili find many more boot-args not covererd here: 

![Bildschirmfoto](https://user-images.githubusercontent.com/76865553/135818786-923330d4-564a-41c6-acbf-ae16b4ac0d55.png)

### Custom Logo

- `YES/NO:` – Default or no Logo
- `Apple` – Apple grey on grey
- `Alternate` – Apple white on black
- `Theme` – ?
- `None` – No Logo, but a Background

**NOTE**: As of r5140.1 "Apple" and "Alternate" don't show a progress bar. Feels like these are just a wallpaper covering the bootscreen. 

### Debug
If set to `true`, a log will be created on next boot. This will seriously slow down the boot time but allows you figure out what the problem was because each step will be accompanied by writing a debug.log to disk/flash drive. Boottime is about 10 minutes just to get into the GUI. But if everything hangs, you can press Reset, and then look for the file `/EFI/CLOVER/misc/debug.log`, which collectively records all logs for all loads, as long as this parameter is set.

### Default Volume

### DisableCloverHotkeys
### HibernationFixup
### Legacy Boot

Legacy Boot. Necessary for runnning older versions of Windows and Linux. Depends on the hardware and the construction of the BIOS, so several algorithms have been implemented. 

The options are:

- `LegacyBiosDefault`: for those UEFI BIOSes that contain a LegacyBios protocol.
- `PBRtest`, `PBR`, `PBRsata` - variants of the PBR boot algorithm.

In general, it has not been possible to achieve unconditional legacy boot operation. It is easier and better to forget about legacy systems and use UEFI versions of OSes. The oldest of them is Windows 7-64, and I personally see no reason to stick with WindowsXP. Does anyone still use a 32 bit only processor? Well, good luck then!

### NeverDoRecovery
### NeverHibernate
### NoEarlyProgress
### RtcHibernateAware
### SignatureFixup
### SkipHibernateTimeout
### StrictHibernate
### Timeout
### XMPDetection
