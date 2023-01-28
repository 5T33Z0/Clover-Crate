# RtVariables
![RTvarsnu](https://user-images.githubusercontent.com/76865553/140332564-944c61eb-6168-4a12-b580-0f0744fd4fdf.png)

This section contains runtime variables affecting Apple services or Clover itself. `ROM` and `MLB` for example are required to allow registration in iMessage service. Starting from Clover r1129, the parameters are taken from SMBIOS and are not needed to be entered manually unless something is missing.

**TABLE of CONTENTS**

- [ROM](#rom)
- [MLB](#mlb)
- [BooterConfig](#booterconfig)
  - [Bitfields for boot-arg flags](#bitfields-for-boot-arg-flags)
- [CsrActiveConfig](#csractiveconfig)
  - [Flags for Security Settings](#flags-for-security-settings)
  - [Recommended values for disabling System Integrity Protection](#recommended-values-for-disabling-system-integrity-protection)
- [HWTarget](#hwtarget)
  - [Working around issues with  `HWTarget` in macOS 13 to receive System Updates](#working-around-issues-with--hwtarget-in-macos-13-to-receive-system-updates)


## ROM
Last digits of `SmUUID` or `MAC Address`. Clover can detect and apply the MAC Address of your Ethernet Adapter automatically if `UseMacAddr0` is selected. This does not work for everyone, so test it.

## MLB
**MLB** = BoardSerialNumber

## BooterConfig
Bitmask containing various boot flags. There's no further info in the manual about any of them. But if you ever wanted to know where the value `0x28` for `BooterConfig` comes from, check the next table.

### Bitfields for boot-arg flags
|Bit  | Flag Name | HEX Value  | Default flags</br>(r5142+)
|:---:|-----------|:-----------:|:---------------:|
|0| Reboot On Panic    | 0x1 |
|1| Hi DPI             | 0x2 |
|2| Black Screen       | 0x4 |
|3| CSR Active Config  | 0x8 | x |
|4| CSR Pending Config | 0x10 |
|5| CSR Boot           | 0x20 | x |
|6| Black Background   | 0x40 |

**NOTES**: 

- In most cases you don't have to change anything here. But if you do, you should exactly know what you are doing and why! You can also change these flags from the Options menu in the Bootloader GUI (Options/System Parameters/bootargs/Flags). But in this case the applied settings are only applied temporary for the next boot.
- The Clover menu contains 2 additional entries: "Login UI" and "Install UI". They don't have a hex value assigned to them so you can't add them to the bitmask.
- My [Clover Calcs](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) spreadsheet contains a calculator to calculate your own bitmask (usually not required).

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

**NOTES**: 

- `0xA87` is a 12 bit bitmask and as such, is only valid for macOS 11 and newer. So if you are using an older Version of macOS, use the **CloverCalcs** Spreadsheet which can be found in the [**Xtras Section**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) to calculate your own.
- You can also change these flags from the options menu in the Clover GUI (Options > System Parameters > System Integrity Protection). But in this case, the flags are only applied temporarily until the next reboot.
- Contrary to popular believe, enabling bit 12 (ALLOW_UNAUTHENTICATED_ROOT) which is required for applying Post-Install patches like installing removed iGPU/GPU drivers *does not* disable System Update Notifications. This only happens when used in combination with bit 5 (ALLOW_APPLE_INTERNAL).

### Recommended values for disabling System Integrity Protection
:warning: Disabling SIP is not recommended!

| macOS Version     | Bitmask Size  | CsrActiveConfig |
|------------------:|:-------------:|:---------------:|
| macOS 11/12/13    | 12 bits       |`0xFEF`
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

To confirm that the parameter is set, reboot and enter in Terminal: `sysctl hw.target`. It should return the value you entered for `HWTarget`

**Source**: [**Insanelymac**](https://www.insanelymac.com/forum/topic/284656-clover-general-discussion/?do=findComment&comment=2771041)

### Working around issues with  `HWTarget` in macOS 13 to receive System Updates

As of Clover r5151, `HWTarget` is [broken](https://www.insanelymac.com/forum/topic/284656-clover-general-discussion/?do=findComment&comment=2800185) in macOS Ventura. As a consequence, you can't install OTA updates when using an SMBIOS of a Mac model with a T2 security chip. Do the following to re-enable System Updates (for now):

- Add `RestrictEvents.kext` 
- Add boot-arg `revpatch=sbvmm` &rarr; Forces VMM SB model, allowing OTA updates for unsupported models on macOS 11.3 or newer.

**More details here:** [Fixing issues with System Update Notifications in macOS 11.3 and newer](https://github.com/5T33Z0/OC-Little-Translated/tree/main/S_System_Updates#what-about-clover)

**NOTES**

- `HWTarget` is only required when using a SMBIOS of Macs with a T2 chip.
- `HWTarget` values are very similar to those used by OpenCore for `SecureBootModel`. For example, the value for MacPro7,1 is `j160` in OpenCore, whereas in Clover it's `J160AP`.
