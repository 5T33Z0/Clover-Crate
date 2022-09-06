# Resources for configuring your Clover `config.plist`

## Preface
One of the main (pseudo-)criticism about Clover is that there's no english documentation and no Configuration guide. Besides the fact that theses people must have been sleeping under a rock for the past 10 years, it's simply not true.

First of all, if there's no english documentation for Clover, what is this here, then? Second off all, there has been a [**Configuration Guide for Clover**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) long before OpenCore was even conceived. It's actually written by the same people who created the OpenCore Install Guide before they abandoned Clover! :fax: 

## Configuring the Clover `config.plist`

### Utilizing the OC Install Guide
Basically if you are well-versed with Hackintoshing, you can utilize the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) for Clover as well, specifically the following sections:

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

### Using the Hackintosh Vanilla Desktop Guide

#### 3rd to 9th Gen Intel Core CPUs
It's outdated but still usable. If you have a For 3rd Gen to 9th Gen Intel Core CPU you can just follow this guide to set up you Clover config.plist.

1. Follow the Instructions for your Intel CPU on [**Hackintosh Vanilla Desktop Guide**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
2. Add **ACPI Tables**, patches and Kernel Patches listed in the corresponding OpenCore Installation Guide
3. Add Quirks as explained [**here**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)

#### 2nd and 10th Gen Intel Core CPUs
Extract the Info you need from the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/)

#### 11th Gen Intel CPUs and newer
Not covered by the OpenCore Install guide. Follow the Comet Lake Instructions from the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) and then just look for Help on Reddit or Github.

#### AMD CPUs
Extract the Info you need from the [**OpenCore install Guide**](https://dortania.github.io/OpenCore-Install-Guide/)
