# Enabling `XCPM` for Ivy Bridge CPUs
> By 5T33Z0. Compatibility: macOS Catalina (10.15.5+) to Ventura

## Background
Apple deactivated the `X86PlatformPlugin` support for Ivy Bridge CPUs in macOS a few years back. Instead, the `ACPI_SMC_PlatformPlugin` is used for CPU power management, although `XCPM` is supported by Ivy Bridge CPUs natively. But there isn't much info about how to re-enable it in OpenCore's documentation:

>Note that the following configurations are unsupported by XCPM (at least out of the box): Consumer Ivy Bridge (0x0306A9) as Apple disabled XCPM for Ivy Bridge and recommends legacy power management for these CPUs. `_xcpm_bootstrap` should manually be patched to enforce XCPM on these CPUs […].

So that's exactly what we are going to do: re-enable `XPCM` with a kernel patch and inject C-States and P-Stated with a Hotpatch (***SSDT-XCPM.aml***) for use with the `X86PlatformPlugin` (i.e. setting Plugin Type to `1`) in order to fix CPU Power Management in macOS Monterey and newer.

**NOTE**: I developed and tested this guide using a Laptop. If you're on a desktop you have to use a different System Definition – `iMac13,1`/`iMac13,2` for Ivy Bridge along with boot-arg `-no_compat_check`.

## Requirements

* System with a 3rd gen Intel Core CPU (Codename **Ivy Bridge**)
* Tools: Terminal, ssdtPRGEN, ProperTree, MaciASL
* SMBIOS for Ivy Bridge CPUs: `iMac13,1`/`iMac13,2` for Desktops and `MacBookPro9,x` or `MacBookPro10,x` for Laptops
* Boot-arg `-no_conmpat_check` to run Big Sur and newer on unsupported Hardware

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
* Copy the entries listed under `ACPI/DropTables`, `Boot`, `KernelAndKextPatches`, `KernelToPatch` and `Quirks` to your `config.plist`
* Save the changes and reboot

### 2. Generate a modified `SSDT-PM` for Plugin Type `1`

Next, we need to generate an `SSDT-XCPM` with Plugin-Type set to "1". To do this, we will use [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh). Since it generatea SSDTs without XCPM support by default, we have to modify the command line. 

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

## For mac Big Sur/Monterey Users
Since Big Sur requires `MacBookPro11,x` to boot, `ssdtPRGen` fails to generate SSDT-PM, because it relies on Board-IDs containing data for Plugin-Type 0. As a workaround, you can either:

* Use `SSDTTime` to generate a `SSDT-PLUG.aml` **or** 
* Stay on an SMBIOS with Ivy Bridge support, but add `-no_compat_check` to `Boot/Argumrnts`.

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

## macOS Ventura and legacy CPUs

Since macOS Ventura removed the `AppleIntelCPUPowerManagement.kext` which housed the `ACPI_SMC_PlatformPlugin`, `SSDT-PM` tables generated for 'plugin-type' 0 can no longer attach to the now mising plugin. Therefore, CPU Power management won't work corectly (no turbo states). So when switching to macOS Ventura, force-enabling XCPM and re-generating your `SSDT-PM` with 'plugin type' 1 enabled is mandatory!

## Credits
- Piker Alpha for ssdtPRGen
- Intel for Intel Power Gadget
- Acidanthera for porting maciASL to 64 bit
- Corpnewt for ProperTree
