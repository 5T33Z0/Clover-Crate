## Boot
![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/boot.png)
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
