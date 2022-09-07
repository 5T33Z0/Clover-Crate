# Resources for configuring Clover's `config.plist`

## Preface
One of the main (pseudo-)criticisms about Clover is that there's no english documentation and no Configuration guide. Besides the fact that these people must have been living under a rock for the past 10 years, it's simply not true!

First of all, if there is no English language guide, what is this please? Second off all, a [**Configuration Guide for Clover**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) existed long before OpenCore was even conceived. It's written by CorpNewt who went on to create a lot of helpful tools for OpenCore. :fax:

So, listed below, you find various approaches for configurating your Clover `config.plist`.

## Configuring the Clover `config.plist`

### Option 1: Use preconfigured Clover Configs
&rarr; see **Dektop** and **Laptop** Configs and EFIs in this section

### Option 2: Using the Hackintosh Vanilla Desktop Guide
It's outdated but still usable. If you have a For 3rd Gen to 9th Gen Intel Core CPU you can just follow this guide to set up you Clover `config.plist`. For configuring 10th Gen Intel and AMD, use Option 3

1. Follow the Instructions for your Intel CPU on [**Hackintosh Vanilla Desktop Guide**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
2. Add **ACPI Tables**, patches and Kernel Patches listed in the corresponding OpenCore Installation Guide
3. Since the Vanilla Desktop guide is from 2018, it doesn't contain "Quirks" settings. Add them by utilizing the OpenCore install guide as explained [**here**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)

### Option 3: Utilizing the OC Install Guide
You can you can utilize the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) to configure 2nd to 10th Gen Intel Core and AMD CPUs. For Clover, the following sections are relevant:

OpenCore Config | Clover Config and EFI Folder
----------------|------------------------------
`ACPI/Add` | Simply add ACPI tables to `EFI/Clover/ACPI/patches`
`ACPI/Patch`| `ACPI/DSDT/Patches`
`DeviceProperties` | `Devices/Properties`
`Kernel/Patch` | `Kernel and Kext Patches`
`Booter/Quirks`</br>`Kernel/Quirks`</br>`Kernel/Scheme`|`Quirks`
`Misc/Security/SecureBootModel`| `RTVariables/HWTarget`
`NVRAM`| `Boot/Arguments`, `RTVariables/CsrActiveConfig` and other parameters
`PlatformInfo/Generic` | `SMBIOS`, `RT Variables`

#### 11th Gen Intel CPUs and newer
Not covered by the OpenCore Install Guide. Follow the Comet Lake Instructions from the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) and then just look for Help on Reddit or Github.

## Clover Folder structure and pkg installation
Refer to my [**Clover Upgrade Guide**](https://github.com/5T33Z0/Clover-Crate/tree/main/Upgrading_Clover) 
