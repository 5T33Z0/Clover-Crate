# Clover Desktop Configs (UEFI only)

<details>

<summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

* [Building your EFI Folder](desktop\_configs.md#building-your-efi-folder)
  * [Base EFI Folder Content](desktop\_configs.md#base-efi-folder-content)
* [About the configs](desktop\_configs.md#about-the-configs)
  * [About Audio](desktop\_configs.md#about-audio)
  * [About Kexts](desktop\_configs.md#about-kexts)
    * [Included Kexts](desktop\_configs.md#included-kexts)
    * [CsrActiveConfig values](desktop\_configs.md#csractiveconfig-values)
* [10th Gen Intel Core i5/i7/i9 Comet Lake](desktop\_configs.md#10th-gen-intel-core-i5i7i9-comet-lake)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches)
  * [Included Configs](desktop\_configs.md#included-configs)
  * [Included Device Properties](desktop\_configs.md#included-device-properties)
  * [Quirks and Kernel Patches Deviations](desktop\_configs.md#quirks-and-kernel-patches-deviations)
* [8th and 9th Gen Intel Core i5/i7/i9 Coffee Lake](desktop\_configs.md#8th-and-9th-gen-intel-core-i5i7i9-coffee-lake)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-1)
  * [Included Configs](desktop\_configs.md#included-configs-1)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-1)
  * [Quirks and Kernel Patches Deviations](desktop\_configs.md#quirks-and-kernel-patches-deviations-1)
* [7th Gen Intel Core i5/i7 Kaby Lake](desktop\_configs.md#7th-gen-intel-core-i5i7-kaby-lake)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-2)
  * [Included Configs](desktop\_configs.md#included-configs-2)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-2)
  * [Quirks and Kernel Patches Deviations](desktop\_configs.md#quirks-and-kernel-patches-deviations-2)
* [6th Gen Intel Core i5/i7 Skylake](desktop\_configs.md#6th-gen-intel-core-i5i7-skylake)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-3)
  * [Included Configs](desktop\_configs.md#included-configs-3)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-3)
  * [Quirks and Kernel Patches Deviations](desktop\_configs.md#quirks-and-kernel-patches-deviations-3)
* [4th and 5th Gen Intel Core i5/i7 Haswell and Broadwell](desktop\_configs.md#4th-and-5th-gen-intel-core-i5i7-haswell-and-broadwell)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-4)
  * [Included Configs](desktop\_configs.md#included-configs-4)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-4)
  * [Quirks and Kernel Patches Deviations](desktop\_configs.md#quirks-and-kernel-patches-deviations-4)
* [3rd Gen Intel Core i5/i7 Ivy Bridge](desktop\_configs.md#3rd-gen-intel-core-i5i7-ivy-bridge)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-5)
  * [Included Configs](desktop\_configs.md#included-configs-5)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-5)
  * [Quirks Deviations](desktop\_configs.md#quirks-deviations)
* [2nd Gen Intel Core i5/i7 Sandy Bridge](desktop\_configs.md#2nd-gen-intel-core-i5i7-sandy-bridge)
  * [Required ACPI Hotpatches](desktop\_configs.md#required-acpi-hotpatches-6)
  * [Included Configs](desktop\_configs.md#included-configs-6)
  * [Included Device Properties](desktop\_configs.md#included-device-properties-6)
  * [Quirks Deviations](desktop\_configs.md#quirks-deviations-1)
* [Credits](desktop\_configs.md#credits)

</details>

This section contains pre-configured config.plists for running macOS on Desktop PCs with 2nd to 10th Gen Intel CPUs. The included configs are based on Corpnewt's Vanilla Hackintosh Guide. But since this guide is no longer maintained, I took his configs and updated them. I added Device Properties and necessary Quirks so they are compatible with the new OpenCore Memory Fixes integrated in Clover since r5123. They are not an all-in-all solution since I don't know which additional hardware and peripherals you are using but they should assist you in getting your system running, especially if you are new to hackintoshing.

## Building your EFI Folder

* Download or update [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/)
* Download the [**Clover EFI Package**](../Desktop\_Configs/EFI\_Clover\_r5148.7z) and unpack it
* Copy the config for the CPU family of your choice to `EFI\CLOVER`
* Copy the included SSDT files for the chosen CPU to `EFI\CLOVER\ACPI\patched`
* Continue reading the [**"About the configs"**](https://github.com/5T33Z0/Clover-Crate/tree/main/Desktop\_Configs#about-the-configs) section for your CPU…

<details>

<summary><strong>Base EFI Folder Content</strong></summary>

#### Base EFI Folder Content

```
EFI
├── BOOT
│   └── BOOTX64.efi
├── CCPV_r5142
├── CLOVER
│   ├── ACPI
│   │   ├── WINDOWS
│   │   ├── origin
│   │   └── patched
│   ├── CLOVERX64.efi
│   ├── OEM
│   │   └── SystemProductName
│   │       ├── UEFI
│   │       │   └── config-sample.plist
│   │       └── config-sample.plist
│   ├── ROM
│   ├── drivers
│   │   ├── UEFI
│   │   │   ├── ApfsDriverLoader.efi
│   │   │   ├── AudioDxe.efi
│   │   │   ├── OpenRuntime.efi
│   │   │   └── VBoxHfs.efi
│   │   └── off
│   │       └── UEFI
│   │           ├── FSInject.efi
│   │           ├── FileSystem
│   │           │   ├── ApfsDriverLoader.efi
│   │           │   ├── Fat.efi
│   │           │   ├── VBoxExt2.efi
│   │           │   ├── VBoxExt4.efi
│   │           │   ├── VBoxHfs.efi
│   │           │   └── VBoxIso9600.efi
│   │           ├── FileVault2
│   │           │   ├── AppleImageCodec.efi
│   │           │   ├── AppleKeyAggregator.efi
│   │           │   ├── AppleKeyFeeder.efi
│   │           │   ├── AppleUITheme.efi
│   │           │   ├── FirmwareVolume.efi
│   │           │   └── HashServiceFix.efi
│   │           ├── HID
│   │           │   ├── AptioInputFix.efi
│   │           │   ├── Ps2MouseDxe.efi
│   │           │   ├── UsbKbDxe.efi
│   │           │   └── UsbMouseDxe.efi
│   │           ├── MemoryFix
│   │           │   └── OpenRuntime.efi
│   │           └── Other
│   │               ├── CsmVideoDxe.efi
│   │               ├── EmuVariableUefi.efi
│   │               ├── EnglishDxe.efi
│   │               ├── NvmExpressDxe.efi
│   │               ├── OsxFatBinaryDrv.efi
│   │               └── PartitionDxe.efi
│   ├── kexts
│   │   ├── Off
│   │   │   ├── Ethernet
│   │   │   │   ├── AtherosE2200Ethernet.kext
│   │   │   │   ├── LucyRTL8125Ethernet.kext
│   │   │   │   ├── RealtekRTL8111.kext
│   │   │   │   └── SmallTreeIntel82576.kext
│   │   │   ├── NVMeFix.kext
│   │   │   └── XHCI-unsupported.kext
│   │   └── Other
│   │       ├── AppleALC.kext
│   │       ├── IntelMausi.kext
│   │       ├── Lilu.kext
│   │       ├── RestrictEvents.kext
│   │       ├── SMCProcessor.kext
│   │       ├── SMCSuperIO.kext
│   │       ├── VirtualSMC.kext
│   │       └── WhateverGreen.kext
│   ├── misc
│   ├── themes
│   │   └── Clovy
│   │       ├── sound.wav
│   │       └── theme.svg
│   └── tools
│       ├── ControlMsrE2.efi
│       ├── Shell32.efi
│       ├── Shell64.efi
│       ├── Shell64U.efi
│       └── bdmesg.efi
└── EFI_Info.md
```

</details>

## About the configs

This chapter lists all the included Configs and their variations, covering multiple setups, like using the integrated graphics (iGPU) for driving a monitor or using it for computing tasks only when a discrete graphics card (dGPU) is connected to a monitor instead. That's why the included Device Properties (mostly Framebuffer Patches) and what they do are listed as well. It also lists the required SSDT Hotpatches for each CPU family.

Depending on your setup you might need to disable (add a `#` in front of the PCI patch or key) or enable certain entries (delete the `#`).

### About Audio

Since I don't know which mainboard you are using, you need to find out which Audio CODEC is mounted on your board and then change the injected Layout ID in `Devices/Audio` accordingly.

**Finding a suitable ALC Layout-ID**

* Visit https://github.com/dreamwhite/ChonkyAppleALC-Build
* Click on the folder name corrsponding to the vendor of your audio Codec
* Find your model, click on the folder
* See the available Layout-IDs for your Codec
* Check, if one for your specific Mainboard or Laptop exists and add it to your config.plist. Otherwise, test them.

### About Kexts

Depending on the hardware components used on your mainboard, you may need to add different kexts for LAN/WiFi/Bluetooth, NVME, etc. Please find out if you need different/additional kexts and add them _before_ using this EFI folder.

Check the documentation of your mainboard to find out which components are used, then find the correct kexts for it and add them to the `EFI\CLOVER\kexts\other` folder.

#### Included Kexts

The EFI folder included in this repo uses a minimum set of enabled kexts to boot the system:

* AppleALC
* IntelMausi
* Lilu
* VirtualSMC
* WhateverGreen

Additional kexts are available but stored in the "Off" folder - to enable any of them move them from the "Off" to the "Other" folder. Read the `EFI_Info.md` included in the EFI folder to find out more about these additional kexts and whether you need them or not.

For more info about additional kexts read this in-depth explanation on [Gathering Files](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#kexts)

#### CsrActiveConfig values

:warning: Disabling System Integrity Protection is not recommended! If you still need/want to disable SIP you have to pick the correct value based on the macOS version you are using from the following table:

|     macOS Version | Bitmask Size | CsrActiveConfig |
| ----------------: | :----------: | :-------------: |
|       macOS 11/12 |    12 bits   |     `0xFEF`     |
| macOS 10.14/10.15 |    11 bits   |     `0x7EF`     |
|       macOS 10.13 |    10 bits   |     `0x3FF`     |
|       macOS 10.12 |    9 bits    |     `0x1FF`     |
|       macOS 10.11 |    8 bits    |     `0x0FF`     |

More: https://github.com/5T33Z0/Clover-Crate/tree/main/RtVariables

***

## 10th Gen Intel Core i5/i7/i9 Comet Lake

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches

* SSDT-AWAC-DISABLE.aml
* SSDT-DMAC.aml
* SSDT-EC-USBX.aml
* SSDT-PLUG.aml
* SSDT-PMC.aml

#### Included Configs

#### Included Device Properties

#### Quirks and Kernel Patches Deviations

* `KernelPM` → Not needed if you can disable CFGLock in BIOS.
* `XhciPortLimit` → Uncheck for macOS 11.3 and newer. Create a USB Port Map instead.

</details>

## 8th and 9th Gen Intel Core i5/i7/i9 Coffee Lake

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches

* SSDT-AWAC-DISABLE.aml
* SSDT-EC-USBX.aml
* SSDT-PLUG.aml
* SSDT-PMC.aml

#### Included Configs

#### Included Device Properties

#### Quirks and Kernel Patches Deviations

* `KernelPM` → Not needed if you can disable CFGLock in BIOS.
* `ProtectUefiServices` → Only required for Z390 Boards. Disable if you use a board with a different chipset.
* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map instead!

</details>

## 7th Gen Intel Core i5/i7 Kaby Lake

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches

* SSDT-EC-USBX.aml
* SSDT-PLUG.aml

#### Included Configs

#### Included Device Properties

#### Quirks and Kernel Patches Deviations

* `KernelPM` → Not needed if you can disable CFGLock in BIOS.
* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map instead!

</details>

## 6th Gen Intel Core i5/i7 Skylake

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional kexts necessary for your hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches

* SSDT-EC-USBX.aml
* SSDT-PLUG.aml

#### Included Configs

#### Included Device Properties

#### Quirks and Kernel Patches Deviations

* `KernelPM` → Not needed if you can disable CFGLock in BIOS.
* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map

</details>

## 4th and 5th Gen Intel Core i5/i7 Haswell and Broadwell

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches

* SSDT-EC.aml
* SSDT-PLUG.aml

#### Included Configs

#### Included Device Properties

#### Quirks and Kernel Patches Deviations

* `KernelPM` → Not needed if you can disable CFGLock in BIOS.
* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map

</details>

## 3rd Gen Intel Core i5/i7 Ivy Bridge

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it
* In Post-Install, create `SSDT-PM.aml` using [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) and add it to `EFI\CLOVER\ACPI\` to enable proper CPU Power Management

#### Required ACPI Hotpatches

* SSDT-EC.aml
* SSDT-PM.aml (generate in Post-Install)

#### Included Configs

#### Included Device Properties

#### Quirks Deviations

* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map

</details>

## 2nd Gen Intel Core i5/i7 Sandy Bridge

<details>

<summary><strong>Click to reveal content</strong></summary>

* Open the config of your choice in Clover Configurator
* In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
* In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
* Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
* Rename config to `config.plist`and add it to `EFI\CLOVER` folder
* Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
* Add additional kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
* Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it
* In Post-Install, create `SSDT-PM.aml` using [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) and add it to `EFI\CLOVER\ACPI\` to enable proper CPU Power Management

#### Required ACPI Hotpatches

* SSDT-EC.aml
* SSDT-PM.aml (generate in Post-Install)

#### Included Configs

#### Included Device Properties

#### Quirks Deviations

* `XhciPortLimit` → Disable for macOS 11.3 and newer – create a USB Port Map

</details>

## Credits & Thank Yous

* Acidanthera for tons of kexts
* corpnewt for original [Vanilla Desktop Guide and Configs](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
* Dortania for [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)
* Dreamwhite for [ChonkyAppleALC](https://github.com/dreamwhite/ChonkyAppleALC-Build)
* Slice for [Clover Boot Manager](https://github.com/CloverHackyColor/CloverBootloader)
