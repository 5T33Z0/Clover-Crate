# Clover Desktop Configs (UEFI only)
This section contains pre-configured config.plists for running macOS on Desktop PCs with  2nd to 10th Gen Intel CPUs. The configs are based on Corpnewt's Vanilla Hackintosh Clover Guide but I created additional configs for 10th Gen Intel, Device Properties and added necessary Quirks so they are compatible with the new Clover and the latest macOS Monterey as well.

They are not an all-in-all solution since I donn't know which additional hardware and peripherals you are using but they should get you started easily.

## Building your EFI Folder
- Download or update [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/)
- Download the prepared Clover EFI Package and unpack it
- Copy the config for the CPU family of your Choice to `EFI\CLOVER`
- Copy the included SSDT files for the chosen CPU to `EFI\CLOVER\ACPI\patched` 
- Continue reading the "About the configs" section for your CPU…
 
## About the configs
This chapter lists all the included Configs and their variations, covering multiple setups, like using the integrated graphics (iGPU) for driving a monitor or using it for computing tasks only when a discrete graphics card (dGPU) is connected to a monitor instead. That's why the included Device Properties (mostly Framebuffer Patches) and what they do are listed as well. It also lists the required SSDT Hotpatches for each CPU family.

Depending on your setup you might need to disable (add a `#` in front of the PCI patch or key) or enable certain entries (delete the `#`).

### About Audio
Since I don't know which Board you are using, you need to find out which Audio CODEC is used on your board and then change the injected Layout ID in `Devices > Audio` accordingly. Here's a list of audio codecs supported by AppleACL and the corresponding layout IDs: https://github.com/acidanthera/AppleALC/wiki/Supported-codecs.

### About Kexts
Depending on the hardware components used on your mainboard, you may need to add different kexts for LAN/WiFi/Bluetooth, NVME, etc. Please find out if you need different/additional kexts and add them *before* using this EFI folder. 

Check the documentation of your mainboard to find out which components are used, then find the correct kexts for it and add them to the `EFI\CLOVER\kexts\other` folder.

#### Included Kexts
The EFI folder included in this repo uses a minimum set of enabled kexts to boot the system:

- AppleALC
- IntelMausi
- Lilu
- VirtualSMC
- WhateverGreen

Additional kexts are available but stored in the "Off" folder - to enable any of them move them from the "Off" to the "Other" folder. Read the `EFI_Info.md` included in the EFI folder to find out more about these additional kexts and whether or not you need any them.

For more info about additional kexts read this in-depth explanation on [Gathering Files](https://dortania.github.io/OpenCore-Install-Guide/ktext.html#kexts)

#### CsrActiveConfig values
:warning: Disabling System Integrity Protection is not recommended! If you still need/want to disable SIP you have to pick the correct value based on the macOS version you are using from the following table:

| macOS Version     | Bitmask Size  | CsrActiveConfig |
|------------------:|:-------------:|:---------------:|
| macOS 11/12       | 12 bits       |`0xFEF`
| macOS 10.14/10.15 | 11 bits       |`0x7FF`
| macOS 10.13       | 10 bits       |`0x3FF`
| macOS 10.12       | 9 bits        |`0x1FF`
| macOS 10.11       | 8 bits        |`0x0FF`

More: https://github.com/5T33Z0/Clover-Crate/tree/main/RtVariables
___
### 10th Gen Intel Core i5/i7/i9 Comet Lake
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches
- SSDT-AWAC-DISABLE.aml
- SSDT-DMAC.aml
- SSDT-EC-USBX.aml
- SSDT-PLUG.aml
- SSDT-PMC.aml

#### Included Configs
|Config.plist         |SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Comet_Lake_iMac20,1|iMac20,1|10.15 and newer|For Intel i5/i7 CPUs|
|Comet_Lake_iMac20,2|iMac20,2|10.15 and newer|For Intel i7/i9 CPUs|

#### Included Device Properties
|Devices > Properties entry|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|:--:|:-----------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|Intel UHD 630|0300C89B|iGPU is used for computational tasks only.
|#PciRoot(0x0)/Pci(0x2,0x0)|Intel UHD 630|07009B3E|iGPU is used for driving a display.
|#PciRoot(0x0)/Pci(0x1C,0x1)/Pci(0x0,0x0)|||For Intel I225-V Network Controller. Only required for macOS 10.15 to macOS 11.3. Enable the included Kext Patch to make the whole construct work.|

#### Quirks and Kernel Patches Deviations

- `KernelPM` &rarr; Not needed if you can disable CFGLock in BIOS.
- `XhciPortLimit` &rarr; Uncheck for macOS 11.3 and newer. Create a USB Port Map instead.
</details>

### 8th and 9th Gen Intel Core i5/i7/i9 Coffee Lake
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches
- SSDT-AWAC-DISABLE.aml
- SSDT-EC-USBX.aml
- SSDT-PLUG.aml
- SSDT-PMC.aml

#### Included Configs
|Config.plist         |SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Coffee_Lake_iMac18,3|iMac18,3|10.13 and newer|For High Sierra and older.
|Coffee_Lake_iMac19,1|iMac19,1|10.13 and newer|For Mojave and newer.

#### Included Device Properties
|Devices > Properties entry|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|:----:|:---------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|Intel UHD 630|07009B3E| Uses iGPU for driving a display. Use AAPL,ig-platform-id `00009B3E`, if you get a black screen after booting.
|#PciRoot(0x0)/Pci(0x2,0x0)|Intel UHD 630|0300913E|When the iGPU is used for computational tasks only. Disabled by default.

#### Quirks and Kernel Patches Deviations
- `KernelPM` &rarr; Not needed if you can disable CFGLock in BIOS.
- `ProtectUefiServices` &rarr; Only required for Z390 Boards. Disable if you use a board with a different chipset.
- `XhciPortLimit` &rarr; Disable for macOS 11.3 and newer – create a USB Port Map instead!
</details>

### 7th Gen Intel Core i5/i7 Kaby Lake
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches
- SSDT-EC-USBX.aml
- SSDT-PLUG.aml

#### Included Configs
|Config.plist|SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Kaby_Lake_iMac18,1|iMac18,1|10.12 and newer| Using iGPU for driving a diplay
|Kaby_Lake_iMac18,3|iMac18,3|10.12 and newer| Used for computers using a dGPU for displaying, and an iGPU for computing tasks only

#### Included Device Properties
|Framebuffer Patches|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|:----:|:-----------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|Intel HD 630|00001259|For using the iGPU for driving a display.
|PciRoot(0x0)/Pci(0x2,0x0)|Intel HD 630|03001259|For using the iGPU for computational taks only.
</details>

### 6th Gen Intel Core i5/i7 Skylake
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches
- SSDT-EC-USBX.aml
- SSDT-PLUG.aml

#### Included Configs
|Config.plist|SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Skylake_iMac17,1|iMac17,1|10.11 and newer|

#### Included Device Properties
|Framebuffer Patches|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|:----:|:-----------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)| Intel HD 530|00001219|iGPU is used to drive a display. For CPUs using Intel HD P530 graphics instead, un-comment the `device-id`.
|#PciRoot(0x0)/Pci(0x2,0x0)|Intel HD 530|01001219|iGPU is used for computational tasks only. Entry Disabled by default.
</details>

### 4th and 5th Gen Intel Core i5/i7 Haswell and Broadwell
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it

#### Required ACPI Hotpatches
- SSDT-EC.aml
- SSDT-PLUG.aml

#### Included Configs
|Config.plist|SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Haswell_iMac14,4|iMac14,4|10.8 - 11.6.x|For Haswell CPUs using the iGPU for driving a display|
Haswell_iMac15,1|iMac15,1| 10.8 - 11.6.x|For Haswell CPUs using a dGPU for displaying and the iGPU for computing tasks.
|Haswell_iMac16,2|iMac16,2| 10.8 - 12.x|For Broadwell CPUs Broadwell with iGPU only.
|Haswell_iMac17,1|iMac17,1| 10.8 - 12.x|For Broadwell CPUs Broadwell with dGPU only-

#### Included Device Properties
|Framebuffer Patches|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|:----:|:---------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|Intel HD 4400/4600|0300220D|Haswell iGPU is used for driving a display.
|PciRoot(0x0)/Pci(0x2,0x0)|Intel HD 4400/4600|04001204|Haswell iGPU is used for computing tasks only.
|PciRoot(0x0)/Pci(0x2,0x0)|Intel Iris Pro 6200|07002216|Broadwell iGPU is used for driving a display. Disable entry when using SMBIOS iMac17,1
</details>

### 3rd Gen Intel Core i5/i7 Ivy Bridge
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it
- In Post-Install, create `SSDT-PM.aml `using [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) and add it to `EFI\CLOVER\ACPI\` to enable proper CPU Power Management

#### Required ACPI Hotpatches
- SSDT-EC.aml
- SSDT-PM.aml (generate in Post-Install)

#### Included Configs
|Config.plist|SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Ivy_Bridge_iMac13,1|iMac13,1|10.7 - 10.15.7|For computers using the iGPU for driving a display|
|Ivy_Bridge_iMac13,2|iMac13,2|10.7 - 10.15.7|For computers using a dGPU for displaying and the iGPU for computing tasks only.
|Ivy_Bridge_iMac14,1|iMac14,4|11.6.x|For computers using the iGPU for driving a display|
|Ivy_Bridge_iMac15,1|iMac15,1|11.6.x|For computers using a dGPU for displaying and the iGPU for computing tasks only|
|Ivy_Bridge_MacPro6,1|MacPro6,1|12.x|Intel HD 4000 Drivers have to be patched-in in Post-Install using [**Patch HD4000 Monterey**](https://github.com/chris1111/Patch-HD4000-Monterey). By default, iGPU is disabled, so a discrete GPU is required (and recommended). You need to disable SIP as well if you use this patch.

#### Included Device Properties
|Devices > Properties entry|iGPU|AAPL,ig-platform-id|Description|
|--------------------------|----|-------------------|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|HD4000|0A006601|iGPU is used to drive a display (default)|
|#PciRoot(0x0)/Pci(0x2,0x0)|HD4000|07006201|iGPU is used for computational tasks only (disabled)|
|#PciRoot(0x0)/Pci(0x16,0x0)|||IMEI device (disabled). Only required when using Sandy Bridge CPUs with a 7 Series Mainboard. Remove `#` to enable.
</details>

### 2nd Gen Intel Core i5/i7 Sandy Bridge
<details>
<summary><strong>Click to reveal content</strong></summary>

- Open the config of your choice in Clover Configurator
- In **SMBIOS** Section, select the corresponding Product Model from the dropdown menu on the right to generate Serials, FirmwareData, etc.
- In **RtVariables** Section, copy the **MLB** from the **Info** Window into the corresponding `MLB` field.
- Adjust `RtVariables` > `CsrActiveConfig` based on used macOS accordingly (see table above)
- Rename config to `config.plist`and add it to `EFI\CLOVER` folder
- Add files in ACPI folder to `EFI\CLOVER\ACPI\patched`
- Add additional Kexts necessary for your Hardware and peripherals to `EFI\CLOVER\kexts\other`
- Copy the EFI Folder to a FAT32 formatted flash drive and try booting from it
- In Post-Install, create `SSDT-PM.aml `using [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) and add it to `EFI\CLOVER\ACPI\` to enable proper CPU Power Management

#### Required ACPI Hotpatches
- SSDT-EC.aml
- SSDT-PM.aml (generate in Post-Install)

#### Included Configs
|Config.plist|SMBIOS|supported macOS|Notes|
|---------------------|------|---------------|-----|
|Sandy_Bridge_iMac12,2|iMac12,2|≤ 10.13|Most Sandy Bridge Boards don't support UEFI boot. So if your board does use a traditional BIOS, this guide is not for you.
|Sandy_Bridge_MacPro6,1|MacPro6,1|10.14 and newer|iGPU must be disabled in BIOS

#### Included Device Properties
|Devices > Properties entry|iGPU|AAPL,snb-platform-id|Description|
|--------------------------|:----:|:----------------:|-----------|
|PciRoot(0x0)/Pci(0x2,0x0)|HD3000|10000300|iGPU is used to drive a display (default)|
|#PciRoot(0x0)/Pci(0x2,0x0)|HD3000|00000500|iGPU is used for computational tasks only (disabled)|
|#PciRoot(0x0)/Pci(0x16,0x0)|-|-|IMEI device (disabled). Only required when using Sandy Bridge CPUs with a 7 Series Mainboard (B75, Q75, Z75, H77, Q77 or Z77)|
</details>

## Credits
- Slice for [Clover Bootloader](https://github.com/CloverHackyColor/CloverBootloader)
- Corpnewt for original [Vanilla Desktop Guide and Configs](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
- Dortania for [OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/)