# RtVariables
![RTvarsnu](https://user-images.githubusercontent.com/76865553/140332564-944c61eb-6168-4a12-b580-0f0744fd4fdf.png)

The following two parameters are intended to allow registration in iMessage service.
Starting from Clover r1129 the parameters are taken from SMBiOS and are not needed to be entered here.

## ROM
Last digits of `SmUUID` or `MAC Address`. Clover can detect the MAC Address of your Ethernet Adapter if `UseMacAddr0` is selected. This does not work for everyone, so test it.

## MLB
**MLB** = BoardSerialNumber

## BooterConfig
These are bit masks to set various boot flags. There's no further info in the manual about them. But if you ever wanted to know, where the value `0x28` for `BooterConfig` comes from, check the next table.

### Bitfields for boot-arg flags
|Bit| Flag Name | HEX Value  | Default in r5142
|---|-----------|-----------:|:-------------------:|
|0|define kBootArgsFlagRebootOnPanic    | 0x1|
|1|define kBootArgsFlagHiDPI            | 0x2|
|2|define kBootArgsFlagBlack            | 0x4|
|3|define kBootArgsFlagCSRActiveConfig  | 0x8|  x|
|4|define kBootArgsFlagCSRPendingConfig | 0x10|
|5|define kBootArgsFlagCSRBoot          | 0x20| x|
|6|define kBootArgsFlagBlackBg          | 0x40|
|7|define kBootArgsFlagLoginUI          | 0x80|

## CsrActiveConfig
With the release of macOS ElCapitan in 2015, a new security feature was introduced: System Integrity Protection (SIP). By default, SIP is enabled (`0x000`) and does not allow you to load your kexts or install your system utilities. To disable it, Clover gives you the option of setting new in NVRAM.

### Flags for Security Settings
The default value for `CsrActiveConfig` in Clover r5142 currently: `0xA87`, which consists of the following enabled flags:

|Bit| Flag Name | HEX Value | Default in r5142
|---|-----------|----------:|:---------------:|
|0|CSR_ALLOW_UNTRUSTED_KEXTS|0x1|x
|1|CSR_ALLOW_UNRESTRICTED_FS|0x2|x
|2|CSR_ALLOW_TASK_FOR_PID|0x4|x
|3|CSR_ALLOW_KERNEL_DEBUGGER|0x8|
|4|CSR_ALLOW_APPLE_INTERNAL|0x10|
|5|CSR_ALLOW_UNRESTRICTED_DTRACE |0x20|
|6|CSR_ALLOW_UNRESTRICTED_NVRAM|0x40|
|7|CSR_ALLOW_DEVICE_CONFIGURATION|0x80|x
|8|CSR_ALLOW_ANY_RECOVERY_OS|0x100|
|9|CSR_ALLOW_UNAPPROVED_KEXTS|0x200|x
|10|CSR_ALLOW_EXECUTABLE_POLICY_OVERRIDE|0x400|
|11|CSR_ALLOW_UNAUTHETICATED_ROOT|0x800|x

### Values for completely disabling System Integrity Protection
:warning: Disbaling SIP is not recommended!

| macOS Version     | Bitmask Size  | CsrActiveConfig |
|------------------:|:-------------:|:---------------:|
| macOS 11/12       | 12 bits       |         `0xFEF` |
| macOS 10.14/10.15 | 11 bits       |         `0x7FF` |
| macOS 10.13       | 10 bits       |         `0x3FF` |
| macOS 10.12       | 9 bits        |         `0x1FF` |
| macOS 10.11       | 8 bits        |         `0x0FF` |

**Note**: Although not recommended, there are special cases, where you need to disable SIP completely. For example, if have to patch-in removed drivers in post-install (like NVIDIA Kepler or Intel HD4000 graphics under macOS 12), it's absolutely *mandatory* to disable SIP to 1) be able to install the drivers and 2) to boot the system afterwards!

Check the [**Xtras Section**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) to find out more about Booter- and CsrActiveConfig and how to calculate your own.

## HWTarget
`HWTarget`is the latest feature added to Clover r5140. It enables System Updates for macOS Monterey which use SMBIOSes of Macs with a T2 Chip. It writes the variable `BridgeOSHardwareModel` to NVRAM, which is requested by macOS Monterey. 

### Valid values for HWTarget
If you use a SMBIOS of one of the Mac models listed below, copy the corresponding value and paste it in the `HWTarget` field of your `config.plist`.

- MacBookPro15,1 (`J680AP`), 15,2 (`J132AP`), 15,3 (`J780AP`), & 15,4 (`J213AP`)
- MacBookPro16,1 (`J152FAP`), 16,3 (`J223AP`), & 16,4 (`J215AP`)
- MacBookPro16,2 (`J214KAP`)
- MacBookAir8,1 (`J140KAP`) & 8,2 (`J140AAP`) 
- MacBookAir9,1 (`J230KAP`) 
- Macmini8,1 (`J174AP`)
- iMac20,1 (`J185AP`) & 20,2 (`J185FAP`) 
- iMacPro1,1 (`J137AP`)
- MacPro7,1 (`J160AP`)

**Source**: [**Insanelymac**](https://www.insanelymac.com/forum/topic/284656-clover-general-discussion/?do=findComment&comment=2771041)

To confirm that the parameter is set, enter in Terminal: `sysctl hw.target`</br>
It should return the same value for HWTarget you entered in the config.
