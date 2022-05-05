# RtVariables
![RTvarsnu](https://user-images.githubusercontent.com/76865553/140332564-944c61eb-6168-4a12-b580-0f0744fd4fdf.png)

This seciton contains Runtime Variables affecting Apple services or Clover itself. `ROM` and `MLB` for example are required to allow registration in iMessage service. Starting from Clover r1129 the parameters are taken from SMBIOS and are not needed to be entered maually here unless something is missing.

## ROM
Last digits of `SmUUID` or `MAC Address`. Clover can detect and apply the MAC Address of your Ethernet Adapter automatically if `UseMacAddr0` is selected. This does not work for everyone, so test it.

## MLB
**MLB** = BoardSerialNumber

## BooterConfig
These are bit masks to set various boot flags. There's no further info in the manual about them. But if you ever wanted to know where the value `0x28` for `BooterConfig` comes from, check the next table.

### Bitfields for boot-arg flags
|Bit| Flag Name | HEX Value  | Default in r5142
|:---:|-----------|-----------:|:---------------:|
|0|Reboot On Panic    | 0x1|
|1|Hi DPI             | 0x2|
|2|Black Screen       | 0x4|
|3|CSR Active Config  | 0x8|  x|
|4|CSR Pending Config | 0x10|
|5|CSR Boot           | 0x20| x|
|6|Black Background   | 0x40|

**NOTE**: In most cases you don't have to change anything here. But if you do, you should exactly know what you are doing and why! You can also change these flags from the Options menu in the Bootloader GUI (Options > System Parameters > bootargs > Flags). But in this case the applied settings are only applied temporary for the next boot.

## CsrActiveConfig
With the release of macOS El Capitan in 2015, a new security feature was introduced: System Integrity Protection (SIP). By default, SIP is enabled (`0x000`) and does not allow you to load your kexts or install your system utilities. To disable it, you can calculate your own bitmask containing various flags.
 
### Flags for Security Settings
The default value for `CsrActiveConfig` for Clover r5142 currently is `0xA87`, which consists of the following enabled flags:

|Bit| Flag Name | HEX Value | Clover Default
|:-:|-----------|----------:|:---------------:|
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
|11|CSR_ALLOW_UNAUTHENTICATED_ROOT|0x800|x

**NOTES**: `0xA87` is a 12 bit bit mask and as such, is only valid for macOS 11 and 12. So if you are using an older Version of macOS, use the **CloverCalcs** Spreadsheet which can be found in the [**Xtras Section**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) to calculate your own.

You can also change these flags from the options menu in the Bootloader GUI (Options > System Parameters > System Integrity Protection). But in this case the settings are only applied temporarily during the next boot.

### Recommended values for disabling System Integrity Protection
:warning: Disabling SIP is not recommended!

| macOS Version     | Bitmask Size  | CsrActiveConfig |
|------------------:|:-------------:|:---------------:|
| macOS 11/12       | 12 bits       |`0xFEF`
| macOS 10.14/10.15 | 11 bits       |`0x7FF`
| macOS 10.13       | 10 bits       |`0x3FF`
| macOS 10.12       | 9 bits        |`0x1FF`
| macOS 10.11       | 8 bits        |`0x0FF`

**NOTES**: 
Although not recommended, there are special cases, where you need to disable SIP completely. For example, if you have to patch-in removed drivers in post-install (like NVIDIA Kepler or Intel HD4000 graphics under macOS 12), it's absolutely *mandatory* to disable SIP to 1) be able to install the drivers and 2) to boot the system afterwards!

Check the [**Xtras Section**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) to find out more about Booter- and CsrActiveConfig and how to calculate your own.

## HWTarget
`HWTarget` is the latest feature introduced in Clover r5140. It's required for SMBIOSes of Macs with a T2 Security Chip in order to get notified about System Updates. It writes the variable `BridgeOSHardwareModel` to NVRAM, which is requested by macOS Monterey. 

If you use a SMBIOS of one of the Mac models listed below, copy the corresponding value and paste it in the `HWTarget` field of your `config.plist`.

- MacBookPro15,1 (`J680AP`), 15,2 (`J132AP`), 15,3 (`J780AP`), 15,4 (`J213AP`)
- MacBookPro16,1 (`J152FAP`), 16,2 (`J214KAP`), 16,3 (`J223AP`), 16,4 (`J215AP`)
- MacBookAir8,1 (`J140KAP`), 8,2 (`J140AAP`)
- MacBookAir9,1 (`J230KAP`)
- Macmini8,1 (`J174AP`)
- iMac20,1 (`J185AP`), 20,2 (`J185FAP`)
- iMacPro1,1 (`J137AP`)
- MacPro7,1 (`J160AP`)

To confirm that the parameter is set, reboot and enter in Terminal: `sysctl hw.target`. It should return the value you entered for `HWTarget`.

**Source**: [**Insanelymac**](https://www.insanelymac.com/forum/topic/284656-clover-general-discussion/?do=findComment&comment=2771041)

**NOTES**:
- From the look of things, the available `HWTarget` values seem to be identical with the values for `SecureBootModel` used by OpenCore, except that they're written in uppercase and and appended the letters "AP". For example, the value for MacPro7,1 is `j160` in OpenCore, whereas in Clover it's `J160AP`, etc.
- `HWTarget` is only required when using a SMBIOS of Macs with a T2 chip.
- `HWTarget` is only necessary when upgrading from Big Sur to Monterey. Once macOS Monterey is running, it seems no longer be required (supposedly).
