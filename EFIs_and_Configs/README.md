# Resources for configuring Clover's `config.plist`

## Preface
One of the main criticisms about Clover is that there's no english documentation and no Configuration guide. 

First of all, if there is no English documentation, what is this please? Second of all the Clover Github repo contains a Wiki as well. Third and finally, a [**Configuration Guide for Clover**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) existed long before OpenCore was even conceived. It's written by CorpNewt who went on to create a lot of helpful tools for OpenCore. :fax:

Listed below, you find various options for configuring your Clover `config.plist`.

## Configuring the Clover `config.plist`

### Option 1: Hackintosh Vanilla Desktop Guide (Intel Desktops)
If you have a For 3rd Gen to 9th Gen Intel Core dektop system and want to configure it from scratch, you can follow this guide to set up you Clover `config.plist`. For 10th Gen Intel and AMD, use Options 2 or 3 instead.

1. Follow the Instructions for your Intel CPU on [**Hackintosh Vanilla Desktop Guide**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
2. Add ACPI Tables and Patches listed in the corresponding OpenCore Installation Guide. Check the [**OC2Clover**](https://github.com/5T33Z0/Clover-Crate/tree/main/OC2Clover) section to find out which SSDTs can be substituted by Clover's DSDT fixes instead.
3. Since the Vanilla Desktop guide is from 2018, it doesn't cover "Quirks" settings. Add them by utilizing the OpenCore install guide as explained [**here**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)

### Option 2: Preconfigured Clover Configs (Intel Dektops and Laptops)
&rarr; see **Dektop** and **Laptop** Configs and EFIs in this section, Covers 2nd to 10th Gen Intel Core CPUs.

### Option 3: Utilizing the OC Install Guide (Intel/AMD Dektops, Intel Laptops)
You can you can utilize the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) to configure 2nd to 10th Gen Intel Core and AMD CPUs. For Clover, the following sections are relevant:

OpenCore Config | Clover Config and EFI Folder
----------------|------------------------------
`ACPI/Add`      | Add ACPI tables to `EFI/Clover/ACPI/patches`. Check the [**OC2Clover**](https://github.com/5T33Z0/Clover-Crate/tree/main/OC2Clover) section to find out which SSDTs can be substituted by Clover's DSDT fixes.
`ACPI/Patch`    | `ACPI/DSDT/Patches`
`DeviceProperties` | `Devices/Properties`
`Kernel/Patch`  | `Kernel and Kext Patches`
`Booter/Quirks`</br>`Kernel/Quirks`</br>`Kernel/Scheme`|`Quirks`
`Misc/Security/SecureBootModel`| `RTVariables/HWTarget`
`NVRAM`         | `Boot/Arguments`, `RTVariables/CsrActiveConfig` and other parameters
`PlatformInfo/Generic` | `SMBIOS`, `RT Variables`

#### 11th Gen Intel CPUs and newer
Not covered by the OpenCore Install Guide. Follow the [**Comet Lake Instructions**](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html) from the OpenCore install Guide and then just look for Help on Reddit or Github.

## Clover Folder structure and pkg installation
Refer to my [**Clover Upgrade Guide**](https://github.com/5T33Z0/Clover-Crate/tree/main/Upgrading_Clover)
