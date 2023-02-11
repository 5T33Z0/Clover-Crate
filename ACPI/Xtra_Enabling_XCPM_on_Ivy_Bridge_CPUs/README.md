# Enabling `XCPM` for Ivy Bridge CPUs (Clover)
>Compatibility: macOS Catalina (10.15.5+) to Ventura

## Background
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS a few years back. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management, although `XCPM` is supported by Ivy Bridge CPUs natively. But there isn't much info about how to re-enable it in OpenCore's documentation:

>Note that the following configurations are unsupported by XCPM (at least out of the box): Consumer Ivy Bridge (0x0306A9) as Apple disabled XCPM for Ivy Bridge and recommends legacy power management for these CPUs. `_xcpm_bootstrap` should manually be patched to enforce XCPM on these CPUs […].

So that's exactly what we are going to do: re-enable `XPCM` with a kernel patch and inject C-States and P-Stated with a Hotpatch (***SSDT-XCPM.aml***) for use with the `X86PlatformPlugin` (i.e. setting Plugin Type to `1`) in order to fix CPU Power Management in macOS Monterey and newer.

**NOTE**: I developed and tested this guide using a Laptop. If you're on a desktop you have to use a different System Definition – `iMac13,1`/`iMac13,2` for Ivy Bridge along with boot-arg `-no_compat_check`.

## Requirements

* **CPU**: 3rd gen Intel Core CPU (Codename **Ivy Bridge**)
* **Firmware** with unlocked `MSR 0xE2` register so CFG Lock is disabled (required for macOS 13+ only )
* **SMBIOS**: `iMac13,1`/`iMac13,2` for Desktops and `MacBookPro9,x` or `MacBookPro10,x` for Laptops
* **Kexts**:
	* [**CryptexFixup**](https://github.com/acidanthera/CryptexFixup) (optional) &rarr; required for installing/booting macOS Ventura
	* [**AppleIntelCPUPowerManagement**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc) (optional) and [**AppleIntelCPUPowerManagementClient**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc) (optional) &rarr; Required for enabling ACPI CPU Power Management in macOS 13
	* [**RestrictEvents**](https://github.com/acidanthera/RestrictEvents) &rarr; required for getting OTA system udates if `-no_compat_check` is enabled – [more details](https://github.com/5T33Z0/OC-Little-Translated/tree/main/09_Board-ID_VMM-Spoof)
* **Boot-args**:
  * `-no_compat_check` to boot Big Sur and newer with unsupported hardware
  * `sbvmm`: Boot-arg provided by RestrictEvents to enable VMM board-id spoof &rarr; enables OTA System Updates in macOS 11.3 and newer
* **Tools**: Terminal, ssdtPRGEN, ProperTree, MaciASL

## How-To

### 0. Backup, backup, backup
Create a backup of your currently working EFI folder just in case something goes wrong and your system won't boot:

* Mount your ESP 
* Copy your EFI folder to a FAT32 formatted USB flash drive 

### 1. Force-enable `XCPM` for Ivy Bridge

* Open [**XCPM_IvyBridge_Clover.plist**](https://raw.githubusercontent.com/5T33Z0/Clover-Crate/main/ACPI/Xtra_Enabling_XCPM_on_Ivy_Bridge_CPUs/XCPM_IvyBridge_Clover.plist)
* Press <kbd>CMD</kbd><kbd>A</kbd> followed by <kbd>CMD</kbd><kbd>C</kbd>
* Run [**ProperTree**](https://github.com/corpnewt/ProperTree)
* Press <kbd>CMD</kbd><kbd>V</kbd>
* Copy the entries in each section to the corresponding section of you `config.plist`
* Save the changes and reboot

### 2. Generate a modified `SSDT-PM` for Plugin Type `1`

Next, we need to generate an `SSDT-XCPM` with Plugin-Type set to "1". To do this, we will use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh). Since it generate SSDTs without XCPM support by default, we have to modify the command line. 

In Terminal, enter: 

```shell
sudo ~/ssdtPRGen.sh -x 1
```

The generated `ssdt.aml` and `ssdt.dsl` will be located at: `~/Library/ssdtPRGen`

The generated ssdt.aml file contains a summary of all settings used for the SSDT. If there is a "1" in the last line, everything is correct:

> Debug = "machdep.xcpm.mode.....: 1"

- Rename the`ssdt.aml` to `SSDT-XCPM.aml`
- Copy it to `EFI/CLOVER/ACPI/patched`
- Disable/Delete `SSDT-PM.aml` or any equivalent thereof, if present.

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

- Change `SystemProductName` to `MacBookPro11,1` (for Laptops) or `iMac14,4`, `iMac15,1`, or `MacPro6,1` for Desktops 
- Set `csr-active-config` to `67080000`
- Disable `-no_compat_check` boot-arg (put a `#` in front of it)
- Save your config and reboot
- Reset NVRAM
- Boot macOS
- Check for System Updates and install them
- Once the installation is finished, revert to SMBIOS `MacBookPro10,1` or `iMac13,1`/`iMac13,2` for desktops
- Re-enable `-no_compat_check`
- Save and reboot

## macOS Monterey
With the release of macOS Monterey, Apple dropped the Plugin-Type check, so that the `X86PlatformPlugin` is loaded by default. For Haswell and newer this is great, since you no longer need `SSDT-PLUG` to enable Plugin-Type `1`. But for Ivy Bridge and older, you now need to select Plugin-Type `0`. If you've previously generated an `SSDT-PM` with ssdtPRGen, it's already configured to use Plugin-Type `0`, so ACPI CPU Power Management is still working. For macOS Ventura, it's a different story…

## Re-enabling ACPI Power Management in macOS Ventura
When Apple released macOS Ventura, they removed the actual `ACPI_SMC_PlatformPlugin` *binary* from the `ACPI_SMC_PlatformPlugin.kext` itself, rendering `SSDT-PM` generated for Plugin-Type 0 useles since it cannot enable a plugin that does no longer exist. As in macOS Monterey, the `X86PlaformPlugin` is loaded by default as well. Therefore, CPU Power Management doesn't work correctly out of the box (no Turbo states, incorrect LFM frequency).

So when switching to macOS Ventura, you either have to:

- **Force-enable XCPM**, as explained above or 
- Re-enable ACPI CPU Power Management (**recommended**, requires disabled CFG Lock)

In order to re-enable and use ACPI CPU Power Management on macOS Ventura, you need:

- A BIOS where the **MSR 0x2E** register is **unlocked** so CFG Lock is disabled (run `ControlMsrE2.efi` from BootPicker to check if it is unlocked or not). This is mandatory since the `AppleCpuPmCfgLock` Quirk doesn't work when injecting the necessary kexts for CPU Power Management into macOS Ventura, causing a kernel panic (as discussed [**here**](https://github.com/5T33Z0/Lenovo-T530-Hackintosh-OpenCore/issues/31#issuecomment-1368409836)). Otherwise you have to stop right here and force-enable `XCPM` instead.
- Boot-arg `-no_compat_check`
- [**Kexts from OCLP**](https://github.com/dortania/OpenCore-Legacy-Patcher/tree/main/payloads/Kexts/Misc):
	- `AppleIntelCPUPowerManagement.kext` (set `MinKernel` to 22.0.0)
	- `AppleIntelCPUPowerManagementClient.kext` (set `MinKernel` to 22.0.0)
- [**CrytexFixup** ](https://github.com/acidanthera/CryptexFixup) &rarr; required for installing/booting macOS Ventura an pre-Haswell systems
- [**RestrictEvents.kext**](https://github.com/acidanthera/RestrictEvents) 
- Additional **boot-args**:
	- `sbvmm` &rarr; Enables `VMM-x86_64` Board-id which allows installing system updates on unsupported systems 
	- `revblock=media` &rarr; Blocks `mediaanalysisd` service on Ventura+ which fixes issues on Metal 1 iGPUs. Firefox won't work without this.
	- `ipc_control_port_options=0` &rarr; Fixes crashes with Electron apps like Discord
	- `amfi_get_out_of_my_way=1` &rarr; Required to execute the Intel HD4000 iGPU driver installation with OpenCore Patcher App.
- Disable Kernel Patch: `_xcpm_bootstrap` (if enabled)
- Disable Kernel Patch and Quirk: `KernePM` and `AppleXcpmExtraMsrs` (if enabled)
- Save and reboot

Once the 2 Kexts are injected, ACPI Power Management will work in Ventura and you can use your `SSDT-PM` like before. For tests, enter in Terminal:

```shell
sysctl machdep.xcpm.mode
```
The output should be `0`, indicating that the `X86PlatformPlugin` is not loaded so ACPI CPU Power Management is used. To verify, run Intel Power Gadget and check the behavior of the CPU.

## Notes

- **ssdtPRGen** includes lists with settings for specific CPUs sorted by families. These can be found under `~/Library/ssdtPRGen/Data`. They are in .cfg format which can be viewed with TextEdit.
- ⚠️ macOS Ventura users: you cannot install macOS Security Response Updates (RSR) on pre-Haswell systems. They will fail to install (more info [**here**](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/1019)).
- Check the **Configuration.pdf** included in the OpenCorePkg for details about unlocking the MSR 0xE2 register (&rarr; Chapter 7.8: "AppleCpuPmCfgLock"

## Credits
- Piker Alpha for ssdtPRGen
- Intel for Intel Power Gadget
- Acidanthera for porting maciASL to 64 bit
- Corpnewt for ProperTree
