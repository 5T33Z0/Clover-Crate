# Utilities and Resources
Incomplete list of useful freeware Apps, Tools and resources for hackintoshing.

## Boot Manager
- [**Clover Bootloader**](https://github.com/CloverHackyColor/CloverBootloader/releases) 
- [**Clover Suite Builder**](https://www.insanelymac.com/forum/topic/347872-introducing-clover-suite-builder/) – Tool for compiling Clover from Source
- [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser) – A pre-bootloader which lets you pick the actual Bootloader you want to run. This way you can have multiple "Clover" and/or "OC" folders with different configs.

## Apps and Tools
### macOS (General)
- [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/) – Configurator App for editing Clover's config.plist
- [**MaciASL**](https://github.com/acidanthera/MaciASL) – ASL/AML Editor for macOS.
- [**IORegistryExplorer**](https://github.com/khronokernel/IORegistryClone) – App for gathering infos about I/O Registry.
- [**Hackintool**](https://github.com/headkaze/Hackintool) – Powerful post-install utility that everyone should have in their Hackintosh tool box
- [**Kext Updater**](https://www.sl-soft.de/kext-updater/) (great tool for keeping kexts and other files up to date)
- [**ANYmacOS**](https://www.sl-soft.de/en/anymacos/) – App for downloading current macOS, creating an USB Installer and changing the Update Seed which can help resolving issues with system updates
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Power Management (for older Intel CPUs)
- [**MacCPUID**](https://www.intel.com/content/www/us/en/download/674424/maccpuid.html) –  Shows detailed information of Intel CPUs (Model, Features, Cache, etc.)
- [**unpkg**](https://www.timdoug.com/unpkg/) – Utility to unpack .pkg files into a folder instead of installing them on the system.

### macOS Monterey
- [**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) – Tool for bringing back NVIDIA GeForce Drivers for GPUs of the Kepler family which have been removed from macOS 12.
- [**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey) – Tool for installing Intel HD 4000 iGPU drivers which have been removed from macOS 12.

### Cross-Platform
- [**Python Installer**](https://www.python.org/downloads/) – Necessary for running a lot of the python-based tools in this list
- [**SSDTTime**](https://github.com/corpnewt/SSDTTime) – Python-based Tool for dumping DSDT and automated ACPI Hotpatch generation
- [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus) – Cross-platform plist editor
- [**QtiASL**](https://github.com/ic005k/QtiASL) – ASL/AML Editor
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode/) – For calculating/analyzing `CsrActiveConfig`. 
- [**gibMacOS**](https://github.com/corpnewt/gibMacOS) – Python-based Tool for downloading macOS
- [**USBToolbox**](https://github.com/USBToolBox/tool) – USB Port mapping tool. Makes port mapping under macOS 11.3+ easier.
- [**Clover-Anonymizer**](https://github.com/dreamwhite/Clover-Anonymizer) – Removes sensitive data from the `config.plist`

### Web-based Applications
- [**Clover Cloud Editor**](https://www.root86.com/CCE/cce/index.php) – Online Clover Config Editor

## Resources
- [**Clover Changelog and Explanations**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/)
- [**Old Clover Documentation**](https://www.insanelymac.com/forum/topic/282787-clover-v2-instructions/)
- [**Clover vs OpenCore Nomenclature**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/clover-conversion/Clover-config.md)
- [**Old Hackintosh Install Guide for Clover**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) (no Quirks included)
- [**I/O Kit Fundamentals**](https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/IOKitFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP0000011-CH204-TPXREF101) – Includes explanations about the I/O Registry.
- **ACPI Samples**:
	- **General**: included in OpenCore Package (under "Docs"): https://github.com/acidanthera/OpenCorePkg/releases
	- **Additional**: https://github.com/5T33Z0/OC-Little-Translated. Primarily for OC Users but most of the files and guides apply to Clover as well.
	- **Laptop-specific** (including updated Clover configs with Quirks): https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs
	- **Clover-specific** (in chinese): https://github.com/daliansky/P-little
