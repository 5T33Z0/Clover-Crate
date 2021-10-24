# Quirks

`Quirks` is a set of features to configure Booter and Kernel Settings in Clover. The underlying technology is OpenCore's `OpenRuntime.efi` which has been fully integrated into Clover since r5126. It replaces the previously used `AptioMemoryFixes` which are no longer capable of booting newer macOS versions. So an upgrade to r5126 or later is mandatory in order to be able to install and boot macOS Big Sur and newer with Clover.

<details>
<summary><strong>Background: From Aptio Memory Fixes to Quirks</strong></summary>

The development of a driver for adjusting the memory that UEFI BIOS Aptio (by AMI) by Dmazar marked the beginning of the UEFI Boot era for Clover.
The Allocate function in this BIOS allocates memory in the lower registers, but to boot macOS, the lower memory has to be free. This issue not only affected memory but also `boot.efi`, address virtualization, pointers, functions, etc. It was Dmazar who figured out how to resolve them. This became the `OsxAptioFixDrv.efi` driver.

For a long time after Dmazar left, no one touched this driver until vit9696 undertook to overhaul it. First of all, he made changes to the driver so that it could utilize native NVRAM on many chipsets (BIOS), which was not possible before. Next, he broke the new driver (`OpenRuntime.efi`) down into **semantic expressions (quirks), which could be turned on and off by the user if the OpenCore loader was used**. 

ReddestDream, a programmer who decided to make `OpenRuntime.efi` work with Clover somehow, created a separate driver (`OcQuirks.efi`), which worked in conjunction with `OpenRuntime.efi` and an additional `OcQuirks.plist` to store all the settings. This combination could then be utilized by Clover.

Next, I (Slice) integrated the `OpenRuntime.efi` source code into my repo since it is Open Source, so I could do bisectioning. Finally, I copied and modernized them so that instead of a separate .plist file, the same Clover `config.plist` can be used, and Quirks can also be changed from within the bootloader GUI. 
</details>

In oder to set up these Quirks correctly, you need to follow the instruction for your CPU family in the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/). Specifically, these sections:

- **Booter > Quirks**
- **Kernel > Quirks**
- **Kernel > Scheme**

The following screenshot shows, which Quirks relate to which category of the OC Install Guide:

![Quirks1](https://user-images.githubusercontent.com/76865553/135844035-1689a11a-6512-4008-80ea-e89f07a55367.png)
Unfortunately, some of the Kernel Quirks are not located in the `Quirks` section but in the "Kext and Kernel Patches" section instead and – to add even more confusion – have different names than in OpenCore:

![quirks2](https://user-images.githubusercontent.com/76865553/135859628-34f6be51-7a20-4461-900e-0c72fbdcba51.png)
Users of Clover < r5126 can follow my [**Clover Upgrade Guide**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover) to replace the outdated `AptioMemoryFixes` by `OpenRuntime.efi` and add necessary Quirks.

#### ProvideConsoleGop 
`ProvideConsoleGop` is the final OpenCore feature which has been implemented into Clover. Until Clover r5128 it in `Quirks` (as `ProvideConsoleGopEnable`). Since then it has been been relocated to the "GUI" Section. To find out if you need it or not, check the OpenCore install Guide, specifically the `UEFI > Output` section.
