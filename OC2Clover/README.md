# Converting OpenCore Settings to Clover
>Work In Progress! Please supply additional info if you have it and want to contribute to this list.

This is for users planning to convert their working OpenCore Config to Clover. It’s an adaptation of the [**Clover Conversion Guide**](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion) – just the other way around (and a bit more in-depth).

The most relevant sections for converting a OpenCore config to Clover and vice versa are: "ACPI", "Device Properties", "Kernel and Kext Patches" and "Quirks", which will be covered here.

## ACPI
In general, you can use the same SSDTs (.aml) in Clover as in OpenCore. Since Clover does not inject ACPI Tables in Windows, they don't require the if OSI Darwin method. Some SSDTs which are required by OpenCore are not necessary in Clover since they are included as ACPI fixes, which are injected during boot.

### ACPI > Add
Following is an incomplete list of .aml files not needed in Clover, since it provides DSDT `Fixes` for them:

|SSDT Name | Clover DSDT Fixes
|:--------:|----------------------|
`SSDT-AC`| Use `FixAdp1` instead
`SSDT-DTGP` | Use `AddDTGP` to inject the `DTGP` method into the `DSDT` instead
`SSDT-HPET`| Use `FixHPET`, `FixIPIC`, `FixTMR` and `FixRTC` instead. You also don’t need the accompanying rename `change_CRS to XCRS` which is required in OpenCore.
`SSDT-SBUS-MCHC`|Use `AddDTGP`, `AddMCHC` and `FixSBUS`instead. AddDTGP is required because the code sippet added by Clover when FixSBUS is enabled, uses DTGP to pass through arguments. Otherwise you will find a "unknown method" compiler comment in the DSDT when searching for "DTGP".

To be continued…

### ACPI > Delete
The ACPI > Delete section is meant for deleting certain Tables from ACPI (usually combined with other SSDTs to replace them, like SSDT-PM or SSDT-PLUG for example).

In Clover Configurator, this section is located under ACPI > Drop Tables. These are the available parameters:

| OpenCore        | Clover              |
|:----------------|:--------------------|
| Table Signature | Signature           |
| OEMTableID      | Type/Key > TableID  |
| TableLength     | Type/Key > Length   |
| All             | DropForAllOS        |
| Enabled         | Disabled            |
| Comment         | –                   |

**Example**: Dropping CPU Power Management tables

- In OCAT:</br>
![OCAT_del](https://user-images.githubusercontent.com/76865553/138651510-a9d179a5-b8e3-43a4-9aff-3b536fffbbd7.png)

- In Clover Configurator:</br>
![Clover_drop](https://user-images.githubusercontent.com/76865553/138651565-3998b445-6df6-49b7-aad1-6a8914f169ef.png)

**NOTES**:

- In Clover, you enter actual names whereas in OpenCore you have to use HEX values.
- You have to use either `TableID` or `TableLength`, not both.

### ACPI > Patch
While Binary Renames work the same in OpenCore and Clover, you have a lot more options in OpenCore:

| OpenCore        | Clover    |
|:---------------:|:----------:|
| Comment         | Comment   |
| Find		  | Find      |
| Replace         | Replace   |
| Base            | use [TgtBridge](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#tgtbridge) instead|
| Enabled         | Disabled  |
| Table Signature | –       |
| OEMTableID      | –       |  
| TableLength     | –       |
| Mask            | –       |
| ReplaceMask     | –       |
| Count           | –       |
| Limit           | –       | 
| Skip            | –       |
| BaseSkip        | –       |

In Clover you also have the option "RenameDevices" which works the same as the `Base` Parameter in OpenCore with the difference that it is limited to devices:</br>
![Ren_Dev](https://user-images.githubusercontent.com/76865553/138651675-a51e51df-8249-4a79-8d75-c9de401e268c.png)

In OCAT you enter the path to a device in the `base` field (don't forget to enable them):</br>
![Dev_base](https://user-images.githubusercontent.com/76865553/138652948-fc403674-e434-4980-8062-a1ae1e787ab6.png)

### ACPI > Quirks

| OpenCore          | Clover    |
|-------------------|-----------|
| FadtEnableReset   | Reset Address / Reset Value |
| Normalize Headers | FixHeaders |
| Reset Logo Status | Drop Tables > BGRT|
| Rebase Regions    | ? |
| Reset HwSig.      | FixRegions |
| SyncTableIDs      | ?          |

## DeviceProperties
In OCAT, devices are added or modified in a straight forward "DeviceProperties" section:</br>
![OCAT_Devprops](https://user-images.githubusercontent.com/76865553/138651900-29810b55-324d-48e8-8e97-fcdda6038612.png)

In Clover Configurator these are hidden behind a button in a sub-section:</br>
![Devices](https://user-images.githubusercontent.com/76865553/138610651-c9d42248-d1b8-4e54-b16a-2819556ae60f.png)
Besides that they work the same and the data is interchangeable.

## Kernel
For users who want to convert their Kext and Kernel Patches from OpenCore to Clover. Note that Clover uses two different sections for patching: one for patching kexts ("KextsToPatch") and one for Patching the Kernel (KernelToPatch), whereas in OpenCore this is handled in the same section ("Kernel > Patch").

### Kernel > Add
In Clover, you don't have to add kexts to a list, and you don't have to worry about the kext loading sequence either. Kext dependencies are hard-coded into Clover, so Lilu and VirtualSMC will always load first.

Whereas in OpenCore you need to define which kext loads for which macOS version via `Min/MaxKernel` parameters, Clover determines this much more hands-on by using the EFI folder structure inside `EFI\CLOVER\kexts\`:

- Kexts which should load for *any* macOS version must be placed in `kexts\other`. This is the main kexts folder (although the name doesn't imply that at all).
- Kexts which should load for specific macOS versions only, must be placed in folders corresponding to the use macOS version. For example `kexts\10.15` for Catalina, `kexts\11` for Big Sur, or `kexts\12` for macOS Monterey, etc.
- To disable a Kext, move it to `kexts\Off`.

This is a lot less cumbersome than having to set `MinKernel` and `MaxKernel` values for kexts. On the other hand it makes updating kexts a bit more tedious since you have to look in any sub-folder. Additionally, managing kexts this way leads to duplicates, so the overall size of the EFI grows unnecessarily.

### Kernel > Patch
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

## NVRAM > Add > 7C436110-AB2A-4BBB-A880-FE41995C9F82
From this UUID, you probably want to transfer:

- `boot-args`: Add these to "Boot" > "Arguments" in Clover
- `csr-active-config`: Needs to be added in "RtVariables" > "CsrActiveConfig". BUT you can't use this as is, since it's Endianness (or whatever it's called) differs from the form Clover uses. For example: `FF070000` is `0x7FF` in Clover. You have to convert it: 
	
	1. Drop the last four digits (zeros); you get `FF07`
	2. Split the 4 remaining digits into pairs of two: `FF` `07`
	3. Swap the positions of the 1st and 2nd pair; you get: `07` `FF`
	4. Drop the `0`; you get: `7FF`
	6. Enter this value in "RtVariables" > `CsrActiveConfig`
	7. The resulting HEX value should look like this: `0x7FF`

**NOTE**: To calculate your own csr bitmask, you can use my [**Clover Calculators**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) spreadsheet, which also helps to understand the whole concept a lot better.

## Quirks
This is one of the most important aspects of your config. In OpenCore there are ACPI Quirks, Booter Quirks, Kernel Quirks and UEFI Quirks. A lot of them are combined in Clover's "Quirks" section.

For more details on how OpenCore's Quirks are implemented into Clover, please refer to the Chapters [**"Quirks"**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) and [**Upgrading Clover for macOS 11+ compatibility**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover).

### Kernel > Quirks
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
Exchanging existing SMBIOS data back and forth between an OpenCore and a Clover config can be a bit confusing since both use different names and locations for data fields. 

Transferring the data correctly is important because otherwise you have to enter your AppleID and Password again which in return will register your computer as a new device in the Apple Account. On top of that you have to re-enter and 2-way-authenticate the system every single time you switch betweeen OpenCore and Clover, which is incredibly annowying. So in order to prevent this, you have to do the following:

1. Copy the Data from the following fields to Clover Configurator's "SMBIOS" and "RtVariables" sections:

PlatformInfo/Generic (OpenCore)| SMBIOS (Clover)      |
|------------------------------|----------------------|
| SystemProductName            | ProductName          |
| SystemUUID                   | SmUUID               |
| ROM                          | ROM (under `RtVariables`). Select "from SMBIOS" and paste the ROM address|
| N/A in "Generic"             | Board-ID             |
| SystemSerialNumber           | Serial Number        |
| MLB                          | 1. Board Serial Number (under `SMBIOS`)</br>2. MLB (under `RtVariables`)|

2. Next, tick the "Update Firmware Only" box.
3. From the Dropdown Menu next to it to, select the Mac model you used for "ProductName". This updates other fields like BIOS and Firmware.
4. Save config and reboot with Clover.

You know that the SMBIOS data has bee transferred correctly, if you don't have to re-enter your Apple-ID and password.

### Import/export Clover SMBIOS Data with OCAT
Besides manually copying over SMBIOS data from your OpenCore to your Clover config and vice versa, you could use [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools/releases) instead, which has a built-in import/export function to import SMBIOS Data from Clover as well as exporting function SMBIOS data into a Clover config:

![ocat](https://user-images.githubusercontent.com/76865553/162971063-cbab15fa-4c83-4013-a732-5486d4f00e31.png)

**IMPORTANT**

- If you did everything correct, you won't have to enter your AppleID Password after switching bootloaders and macOS will let you know, that "This AppleID is now used with this device" or something like that.
- But if macOS asks for your AppleID Password and Mail passwords etc. after switching bootloaders, you did something wrong. In this case you should reboot into OpenCore instead and check again. Otherwise, you are registering your computer as a new/different Mac.