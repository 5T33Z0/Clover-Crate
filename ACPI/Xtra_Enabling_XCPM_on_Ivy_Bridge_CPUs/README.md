# Enabling `XCPM` for Ivy Bridge CPUs (Clover)
> Compatibility: macOS Catalina (10.15.5+) to Ventura

## Background
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS a few years back. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management, although `XCPM` is supported by Ivy Bridge CPUs natively. But re-enabling it requires changing some config settings, a kernel patch and a Hotpatch (***SSDT-XCPM.aml***) to inject C-States and P-States in order to fix CPU Power Management in macOS Monterey and newer.

## Requirements

* **CPU**: 3rd gen Intel Core CPU or Xeon E5 (**Ivy Bridge/Ivy Bridge-EP**)
* **SMBIOS**: `iMac13,1`/`iMac13,2` for Desktops, `MacPro6,1` (for Xeon E5) and `MacBookPro9,x` or `MacBookPro10,x` for Laptops
* **Kexts**:
	* [**CryptexFixup**](https://github.com/acidanthera/CryptexFixup) (optional) &rarr; required for installing/booting macOS Ventura
	* [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc) (optional) and [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc) (optional) &rarr; Required for enabling ACPI CPU Power Management in macOS 13
	* [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) &rarr; required for getting OTA system udates if `-no_compat_check` is enabled – [more details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
* **Boot-args**:
  * `-no_compat_check` to boot Big Sur and newer with unsupported hardware
  * `sbvmm`: Boot-arg provided by RestrictEvents to enable VMM board-id spoof &rarr; enables OTA System Updates in macOS 11.3 and newer
* **Tools**: Terminal, ssdtPRGEN, ProperTree, MaciASL

## Instructions

### 0. Backup your current EFI folder
Create a backup of your currently working EFI folder just in case something goes wrong and your system won't boot:

* Mount your ESP 
* Copy your EFI folder to a FAT32 formatted USB flash drive

### 1. Config Adjustments to Force-enable `XCPM`

* Open [**XCPM_IvyBridge_Clover.plist**](https://github.com/5T33Z0/Clover-Crate/blob/main/ACPI/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs/XCPM_IvyBridge_Clover.plist)
* Click on the Download button on the right
* Open the file with [**ProperTree**](https://github.com/corpnewt/ProperTree) or the Plist editor of your choice
* Copy the entries in each section to the corresponding section of your `config.plist`
* Save the changes and reboot

### 2. Generate `SSDT-XCPM`

Next, we need to generate an `SSDT-XCPM` with Plugin-Type set to `1`. To do this, we will use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh). Since it generate SSDTs without XCPM support by default, we have to modify the command line. 

In Terminal, enter: 

```shell
sudo ~/ssdtPRGen.sh -x 1
```

The generated `ssdt.aml` and `ssdt.dsl` will be located at: `~/Library/ssdtPRGen`. It contains a summary of all settings used for the SSDT. If there is a "1" in the last line, everything is correct:

> Debug = "machdep.xcpm.mode.....: 1"

- Rename the`ssdt.aml` to `SSDT-XCPM.aml`
- Copy it to `EFI/CLOVER/ACPI/patched`
- Disable/Delete `SSDT-PM.aml` (or equivalent), if present!
- Reboot

To verify that XCPM is working, open Terminal and enter: 

```shell
sysctl machdep.xcpm.mode
```

If the output is `1`, the `X86PlatformPlugin` is active, if the output is `0` it is not.

To verify CPU Power Management is working correctly, install and run [**Intel Power Gadget**](https://www.intel.com/content/www/us/en/developer/articles/tool/power-gadget.html) and monitor your CPU's performance. If the CPU frequency operates withing the lower and upper limit of its specs (Turbo states included), you should be fine.

## macOS Big Sur users
Since Big Sur requires `MacBookPro11,x` to boot, `ssdtPRGen` fails to generate SSDT-PM, because it relies on Board-IDs containing data for Plugin-Type 0. As a workaround, you can either:

* Use `SSDTTime` to generate a `SSDT-PLUG.aml` **or** 
* Stay on an SMBIOS with Ivy Bridge support, but add `-no_compat_check` to `Boot/Arguments`.

**Advantages** of using `MacBookPro10,1` with `-no_compat_check`:

- You can boot Big Sur **and** use ssdtPRGen. 
- The CPU runs at lower clock speeds in idle since this SMBIOS was written for Ivy Bridge, while 11,x was written for Haswell CPUs. Therefore the CPU produces less heat and the machine runs quieter.
- Another benefit of using `MacBookPro10,1` is that you get the correct P-States and C-States for your CPU from ssdtPRGen.

**Disadvantages** of using `MacBookPro10,1` or equivalent iMac Board-ID supporting Ivy Bridge: you won't be able to install System Updates because you won't be notified about them. But there's a simple **workaround**:

- Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) 
- Add Boot Argument `sbvmm` &rarr; Enables `VMM-x86_64` Board-id which allows installing system updates on unsupported systems 
- Save and reboot

## macOS Monterey
With the release of macOS Monterey, Apple dropped the Plugin-Type check, so that the `X86PlatformPlugin` is loaded by default. For Haswell and newer this is great, since you no longer need `SSDT-PLUG` to enable Plugin-Type `1`. But for Ivy Bridge and older, you now need to select Plugin-Type `0`. If you've previously generated an `SSDT-PM` with ssdtPRGen, it's already configured to use Plugin-Type `0`, so ACPI CPU Power Management is still working. For macOS Ventura, it's a different story…

## Re-enabling ACPI Power Management in macOS Ventura and newer
When Apple released macOS Ventura, they removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself, rendering `SSDT-PM` generated for Plugin-Type 0 useles since it cannot utilize a plugin that no longer exists. As in macOS Monterey, the `X86PlaformPlugin` is loaded by default as well. Therefore, CPU Power Management doesn't work correctly out of the box (no Turbo states, incorrect LFM frequency).

So when switching to macOS Ventura and newer, you either have to:

- **Force-enable XCPM**, as explained above or 
- Re-enable ACPI CPU Power Management (**recommended**)

In order to re-enable and use ACPI CPU Power Management on macOS Ventura and newer, you need to do the following:

- Add [**Kexts from OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc):
    - `AppleIntelCPUPowerManagement.kext` (set `MinKernel` to 22.0.0)
    - `AppleIntelCPUPowerManagementClient.kext` (set `MinKernel` to 22.0.0)
    - [**AMFIPass.kext**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Acidanthera) &rarr Allows using AMFI with lowered/disabled SIP
- Add [**CrytexFixup** ](https://github.com/acidanthera/CryptexFixup) &rarr; required for installing/booting macOS Ventura an pre-Haswell systems
- Add [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) &rarr; Enables special board-id that makes macOS think that it is running in a Virtual Machine that allows installing OTA Updates which would not be possible otherwise
- Add **boot-args**:
	- `-no_compat_check`
	- `revpatch=sbvmm` &rarr; Enables `VMM-x86_64` Board-id which allows installing system updates on unsupported systems 
	- `revblock=media` &rarr; Blocks `mediaanalysisd` service on Ventura+ which fixes issues on Metal 1 iGPUs. Firefox won't work without this.
	- `ipc_control_port_options=0` &rarr; Fixes crashes with Electron apps like Discord
	- `amfi=0x80` &rarr; Disables AMFI. Required to execute the Intel HD4000 iGPU driver installation with OpenCore Legacy Patcher. Disable afterwards.
- Disable Kernel Patch: `_xcpm_bootstrap` (if enabled)
- Disable Kernel Patch and Quirk: `KernePM` and `AppleXcpmExtraMsrs` (if enabled)
- Save and reboot

Once the Kexts are injected, ACPI Power Management will work in macOS 13+ and you can use your `SSDT-PM` like before. For tests, enter in Terminal:

```shell
sysctl machdep.xcpm.mode
```
The output should be `0`, indicating that the `X86PlatformPlugin` is not loaded so ACPI CPU Power Management is used. To verify, run Intel Power Gadget and check the behavior of the CPU.

## NOTES
- For installing macOS 13+ on Ivy Bridge systems, additional config adjustments are necessary. You can follow my [Ivy Bridge configuration guide](https://github.com/5T33Z0/OC-Little-Translated/blob/main/14_OCLP_Wintel/Ivy_Bridge-Ventura.md) to do so.
- **ssdtPRGen** includes lists with settings for specific CPUs sorted by families. These can be found under `~/Library/ssdtPRGen/Data`. They are in .cfg format which can be viewed with TextEdit.
- ⚠️ macOS Ventura users: you cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)).

## Credits
- Piker Alpha for ssdtPRGen
- Intel for Intel Power Gadget
- Acidanthera for porting maciASL to 64 bit
- Corpnewt for ProperTree
- Dortania for OpenCore Legacy Patcher
