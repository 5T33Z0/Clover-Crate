# Converting OpenCore Settings to Clover
>Work In Progress! Please supply additional info if you have it and want to contribute to this list.

This is for users planning to convert their working OpenCore Config to Clover. It’s an adaptation of the [**Clover Conversion Guide**](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion) – just the other way around (and a bit more in-depth).

The most relevant sections for converting a OpenCore config to Clover and vice versa are: 

- **ACPI**
- **Devices/Properties**
- **Kernel and Kext Patches** 
- **Quirks**

<details><summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

- [ACPI](#acpi)
	- [ACPI/Add](#acpiadd)
	- [ACPI/Delete](#acpidelete)
		- [Dropping CPU Power Management tables](#dropping-cpu-power-management-tables)
	- [ACPI/Patch](#acpipatch)
	- [ACPI/Quirks](#acpiquirks)
- [DeviceProperties](#deviceproperties)
- [Kernel](#kernel)
	- [Kernel/Add](#kerneladd)
	- [Kernel/Patch](#kernelpatch)
- [NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82](#nvramadd7c436110-ab2a-4bbb-a880-fe41995c9f82)
- [Quirks](#quirks)
	- [Kernel/Quirks](#kernelquirks)
- [Exchanging SMBIOS Data between OpenCore and Clover](#exchanging-smbios-data-between-opencore-and-clover)
	- [Manual method](#manual-method)
		- [Troubleshooting](#troubleshooting)
	- [SMBIOS Data Import/Export with OCAT](#smbios-data-importexport-with-ocat)
	- [1-Click-Solution for Clover Users](#1-click-solution-for-clover-users)
</details>

## ACPI
In general, you can use the same SSDTs (.aml) in Clover as in OpenCore. Since Clover does not inject ACPI Tables in Windows, they don't require the if OSI Darwin method. Some SSDTs which are required by OpenCore are not necessary in Clover since they are included as ACPI fixes, which are injected during boot.

### ACPI/Add

**Location** in Clover EFI: `EFI/CLOVER/ACPI/patched`

Following is an incomplete list of .aml files not needed in Clover, since it provides DSDT `Fixes` for them:

|SSDT Name | Clover DSDT Fixes
|:--------:|----------------------|
`SSDT-AC`| Use `FixAdp1` instead
`SSDT-DTGP` | Use `AddDTGP` to inject the `DTGP` method into the `DSDT` instead
`SSDT-HPET`| Use `FixHPET`, `FixIPIC`, `FixTMR` and `FixRTC` instead. You also don’t need the accompanying rename `change_CRS to XCRS` which is required in OpenCore.
`SSDT-SBUS-MCHC`|Use `AddDTGP`, `AddMCHC` and `FixSBUS`instead. `AddDTGP` is required because the code sippet added by Clover when FixSBUS is enabled, uses DTGP to pass through arguments. Otherwise you will find a "unknown method" compiler comment about `DTGP` the end of the `DSDT`.


To be continued…

### ACPI/Delete

**Location** in Clover: `ACPI/DropTables`

The ACPI/Delete section is meant for deleting certain Tables from ACPI (usually combined with other SSDTs to replace them, like SSDT-PM or SSDT-PLUG for example).

In Clover Configurator, this section is located under ACPI/Drop Tables. These are the available parameters:

| OpenCore        | Clover              |
|:----------------|:--------------------|
| Table Signature | Signature           |
| OEMTableID      | Type/Key > TableID  |
| TableLength     | Type/Key > Length   |
| All             | DropForAllOS        |
| Enabled         | Disabled            |
| Comment         | –                   |

#### Dropping CPU Power Management tables

- In OCAT:</br>
![OCAT_del](https://user-images.githubusercontent.com/76865553/138651510-a9d179a5-b8e3-43a4-9aff-3b536fffbbd7.png)

- In Clover Configurator:</br>
![Clover_drop](https://user-images.githubusercontent.com/76865553/138651565-3998b445-6df6-49b7-aad1-6a8914f169ef.png)

> [!NOTE]
> 
> - In Clover, you enter actual names whereas in OpenCore you have to use HEX values.
> - You have to use either `TableID` or `TableLength`, not both.

### ACPI/Patch

**Location** in Clover: `ACPI/DSDT/Patches/ArrayX` (X = starting from 0) 

While Binary Renames work the same in OpenCore and Clover, you have a lot more options in OpenCore:

| OpenCore        | Clover    |
|:---------------:|:---------:|
| Comment         | Comment   |
| Find            | Find      |
| Replace         | Replace   |
| Base            | [**TgtBridge**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#tgtbridge) or [**RenameDevices**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#rename-devices)|
| Enabled         | Disabled  |
| Table Signature | –         |
| OEMTableID      | –         |  
| TableLength     | –         |
| Mask            | –         |
| ReplaceMask     | –         |
| Count           | Count     |
| Limit           | –         | 
| Skip            | Skip      |
| BaseSkip        | –         |

> [!NOTE]
> 
> - While OpenCore uses an `Enabled` switch, Clover uses `Disabled` instead. So you cannot simply copy/paste over DSDT patches!
> - `Count` key was added in Clover r5149. `TYPE` can be `Number` or `String`. If you use `Data`, you receive a warning from CloverConfigPlistValidator: " Tag '/ACPI/DSDT/Patches[0]/Count:19' should be an integer. It's currently a data. For now, I've made the conversion. Please update."

### ACPI/Quirks

**Locations** in Clover: See table

| OpenCore          | Clover    |
|-------------------|-----------|
| FadtEnableReset   | `ACPI/ResetAddress` </br> `ACPI/ResetValue` |
| Normalize Headers | `ACPI/FixHeaders`|
| Reset Logo Status | `ACPI/DropTables`: BGRT|
| Rebase Regions    | `ACPI/DSDT/Fixes/FixRegions` |
| Reset HwSig.      | – |
| SyncTableIDs      | – |

## DeviceProperties
In OCAT, devices are added or modified in a straight forward "DeviceProperties" section:</br>
![OCAT_Devprops](https://user-images.githubusercontent.com/76865553/138651900-29810b55-324d-48e8-8e97-fcdda6038612.png)

In Clover Configurator these are hidden behind a button in a sub-section:</br>
![Devices](https://user-images.githubusercontent.com/76865553/138610651-c9d42248-d1b8-4e54-b16a-2819556ae60f.png)
Besides that they work the same and the data is interchangeable.

## Kernel
For users who want to convert their Kext and Kernel Patches from OpenCore to Clover. Note that Clover uses two different sections for patching: one for patching kexts ("KextsToPatch") and one for Patching the Kernel (KernelToPatch), whereas in OpenCore this is handled in the same section ("Kernel > Patch").

### Kernel/Add
In Clover, you don't have to add kexts to a list, and you don't have to worry about the kext loading sequence either. Kext dependencies are hard-coded into Clover, so Lilu and VirtualSMC will always load first.

Whereas in OpenCore you need to define which kext loads for which macOS version via `Min/MaxKernel` parameters, Clover determines this much more hands-on by using the EFI folder structure inside `EFI\CLOVER\kexts\`:

- Kexts which should load for *any* macOS version must be placed in `kexts\other`. This is the main kexts folder (although the name doesn't imply that at all).
- Kexts which should load for specific macOS versions only, must be placed in folders corresponding to the use macOS version. For example `kexts\10.15` for Catalina, `kexts\11` for Big Sur, or `kexts\12` for macOS Monterey, etc.
- To disable a Kext, move it to `kexts\Off`.

This is a lot less cumbersome than having to set `MinKernel` and `MaxKernel` values for kexts. On the other hand it makes updating kexts a bit more tedious since you have to look in any sub-folder. Additionally, managing kexts this way leads to duplicates, so the overall size of the EFI grows unnecessarily.

### Kernel/Patch
Besides the basic `Find`/`Replace` masks, there are several additional modifiers you can utilize for applying Kernels and Kext patches. In the table below, you find the available options and differences in nomenclature between OpenCore and Clover:

| OpenCore    | Clover         | Description (where applicable) |
|:-----------:|:--------------:|--------------------------------|
| Identifier  | Name           | Name of the Kext/Kernel the patch should be applied to.
| Base        | Procedure      | Name of the procedure we are looking for. The real name may be longer, but the comparison is done by a substring. Make sure the substring occurs only in "Procedure".
| Comment     | Comment        | Besides using it as a reminder what a patch does, this field is also used for listing the available patches in Clover's bootmenu.
| Find		    | Find           | Value to find
| Replace     | Replace        | Value to replace the found value by
| Mask        | MaskFind       | If some bit=1, we look for an exact match, if the bit=0, we ignore the difference.
| ReplaceMask | MaskReplace    | If a bit=1, we make a replacement. If a bit=0, we leave it as is.
| –           | MaskStart      | Mask for the starting point, i.e. for the `StartPattern`. And then there are Find/MaskFind and Replace/MaskReplace pairs.
| –           | StartPattern   | Remnant of a time before character patching was implemented. It marks the starting point from which to look for a replacement pattern. If we know the name of the procedure, `StartPattern` is hardly needed anymore.
| –           | RangeFind      | Length of code to search. In general, just the size of this procedure, or less. This speeds up the search query without going through all the millions of strings.
| MinKernel   | –              | &rarr; see "MatchOS"
| MaxKernel   | –              | &rarr; see "MatchOS"
| Count       | Count          | Number of times a replacement is made
| Limit       | –              | 
| Skip        | Skip           | Number of times a match is skipped
| Enabled     | Disabled       | Disables the renaming rule (obviously)
| Arch        | –              | 
| –           | MatchOS        |Although there is no equivalent to `MinKernel` and `MaxKernel` in Clover, you can use `MatchOS` to limit a patch to specific versions of macOS. But instead of setting a range of Darwin kernels, you just set the macOS version(s) it applies to. For example: `10.13,10.14,10.15` (without blanks). You can also use masked strings like `11.5.x` (= for all 11.5 and subsequent variants, like 11.5.4), `12.x` (= for all variants of macOS 12), etc.
| –           | MatchBuild     | Applies/Limits a patch to a specific system build of macOS, such as `21D5025F`, for example. You can list multiple builds separated by commas. If no value for `MatchBuild` is set, the patch applies to all builds. In general, patching kexts or kernels based on the build version is not very common and rarely needed.
| –           | InfoPlistPatch | Applies patches to parameters inside `plists` of kexts defined in the `Name` field. The search can include multiple strings, excluding all invisible characters, such as line feeds and tabs. The search should be set as `<data>`, because the service characters such as "<" can not be set in text form. The lengths of the search and replacement strings can be different, but need to have the same length (fill one mask with spaces to match the length of the other one if necessary).

## NVRAM/Add/7C436110-AB2A-4BBB-A880-FE41995C9F82
From this UUID, you probably want to transfer:

- `boot-args`: Add these to "Boot" > "Arguments" in Clover
- `csr-active-config`: Needs to be added in "RtVariables" > "CsrActiveConfig". BUT you can't use this as is, since it's Endianness (or whatever it's called) differs from the form Clover uses. For example: `FF070000` is `0x7FF` in Clover. You have to convert it: 
	
	1. Drop the last four digits (zeros); you get `FF07`
	2. Split the 4 remaining digits into pairs of two: `FF` `07`
	3. Swap the positions of the 1st and 2nd pair; you get: `07` `FF`
	4. Drop the `0`; you get: `7FF`
	6. Enter this value in "RtVariables" > `CsrActiveConfig`
	7. The resulting HEX value should look like this: `0x7FF`

> [!NOTE]
> To calculate your own csr bitmask, you can use my [**Clover Calculators**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) spreadsheet, which also helps to understand the whole concept a lot better.

## Quirks
This is one of the most important aspects of your config. In OpenCore there are ACPI Quirks, Booter Quirks, Kernel Quirks and UEFI Quirks. A lot of them are combined in Clover's "Quirks" section.

For more details on how OpenCore's Quirks are implemented into Clover, please refer to the Chapters [**"Quirks"**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) and [**Upgrading Clover for macOS 11+ compatibility**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover).

### Kernel/Quirks
While most of OpenCore's Kernel Patches are located in Clover's Quirks section, the following are located under Kernel and Kext Patches instead:

| OpenCore (Kernel > Quirks)  | Clover (Kernel and Kext Patches)|
|:----------------------------|:--------------------------------|
| AppleCpuPmCfgLock           | AppleIntelCPUPM
| AppleXcpmCfgLock            | KernelPM
| AppleXcpmExtraMsrs          | KernelXCPM
| CustomSMBIOSGuid            | DellSMBIOSPatch
| DisableRtcChecksum          | AppleRTC
| LapicKernelPanic            | Kernel LAPIC
| PanicNoKextDump             | PanicNoKextDump

## Exchanging SMBIOS Data between OpenCore and Clover
### Manual method
Exchanging existing SMBIOS data between OpenCore Clover can be a bit confusing since both use different names and locations for data fields. 

Transferring SMBIOS data correctly is important because otherwise you have to enter your AppleID and Password again which in return will register your computer as a new device in the Apple Account. On top of that you have to re-enter and 2-way-authenticate the system every single time you switch between OpenCore and Clover, which is incredibly annoying. So in order to prevent this, you have to do the following:

1. Copy the Data from the following fields to Clover Configurator's "SMBIOS" and "RtVariables" sections:
	PlatformInfo/Generic (OpenCore)| SMBIOS (Clover)      |
	|------------------------------|----------------------|
	| **SystemProductName**        | **ProductName**          |
	| **SystemUUID**               | **SmUUID**               |
	| **ROM**                      | **ROM** (under `RtVariables`). If your Serial was generated based on the real MAC Address of your Ethernet Controller you can select `UseMacAddr0` from the dropdown menu instead.
	| N/A in "Generic"             | **Board-ID**            |
	| **SystemSerialNumber**       | **SerialNumber**        |
	| **MLB**                      | 1. **BoardSerialNumber** (under `SMBIOS`)</br>2. **MLB** (under `RtVariables`)|
	N/A in OpenCore                | Custom UUID (=Hardware UUID). Leave empty.
2. Next, tick the "Update Firmware Only" box.
3. From the Dropdown Menu next to it to, select the Mac model you used for "ProductName". This updates fields like BIOS and Firmware to the latest version.
4. Save config and reboot with Clover.

You know that the SMBIOS data has bee transferred correctly, if you don't have to re-enter your Apple-ID and password.

**Screenshots**

OpenCore | Clover
---------|--------
![OC](https://github.com/user-attachments/assets/8525a2a6-fc09-4447-9655-8d8f23f6736b) | ![Clover](https://github.com/user-attachments/assets/2fd0f0a2-72ac-42b6-b33a-bc14ca8352c8)

#### Troubleshooting
If you have to re-enter your Apple ID Password after changing from OpenCore to Clover or vice versa, the used SMBIOS Data is either not identical or there is another issue, so you have to figure out where the mismatch is.

In this case, you can use Hackintool to identify the problem:

- Mount the EFI
- Open the config for the currently used Boot Manager
- Run Hackintool. The "System" section shows the currently used SMBIOS Data: </br> ![SYSINFO](https://user-images.githubusercontent.com/76865553/166119425-8970d155-b546-4c91-8daf-ec308d16916f.png)
- Check if the framed parameters match the ones in your config.
- If they don't, correct them and use the ones from Hackintool 
- If they do mach the values used in your config, open the config from your other Boot Manager and compare the data from Hackintool again and adjust the data accordingly.
- Save the config and reboot
- Change to the other Boot Manager and start macOS
- If the data is correct you won't have to enter your Apple ID Password again (double-check in Hackintool to verify).

### SMBIOS Data Import/Export with OCAT
Besides manually copying over SMBIOS data from your OpenCore to your Clover config and vice versa, you could use [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools/releases) instead, which has a built-in import/export function to import SMBIOS Data from Clover as well as exporting function SMBIOS data into a Clover config:

![ocat](https://user-images.githubusercontent.com/76865553/162971063-cbab15fa-4c83-4013-a732-5486d4f00e31.png)

> [!IMPORTANT]
> 
> - If you did everything correct, you won't have to enter your AppleID Password after switching Boot Managers and macOS will let you know, that "This AppleID is now used with this device" or something like that.
> - But if macOS asks for your AppleID Password and Mail passwords etc. after switching Boot Managers, you did something wrong. In this case you should reboot into OpenCore instead and check again. Otherwise, you are registering your computer as a new/different Mac.

### 1-Click-Solution for Clover Users
If you've used the real MAC Address of your Ethernet Controller ("ROM") when generating your SMBIOS Data for your OpenCore config, you can avoid possible SMBIOS conflicts altogether. In the "Rt Variables" section, click on "from System" and you should be fine!
