# Utilities and Resources
Incomplete list of useful freeware Apps, Tools and resources for hackintoshing.

## Clover-related
- [**Clover Bootloader**](https://github.com/CloverHackyColor/CloverBootloader/releases) – Bootloader for running macOS, Windows and Linux in UEFI and Legacy mode 
- [**Clover Suite Builder**](https://github.com/LAbyOne/Clover-Suite-Builder) – Tool for compiling Clover from the Source Code
- [**Bootloader Chooser**](https://github.com/jief666/BootloaderChooser) – A pre-bootloader which lets you pick the actual Boot Manager you want to run. This way, you easily switch between Clover and OpenCore.
- [**Clover-Anonymizer**](https://github.com/dreamwhite/Clover-Anonymizer) – Removes sensitive data from the `config.plist`

## Apps and Tools
### macOS (General)
- [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/) – Configurator App for editing Clover's config.plist
- [**MaciASL**](https://github.com/acidanthera/MaciASL) – ASL/AML Editor for macOS.
- [**IORegistryExplorer**](https://github.com/khronokernel/IORegistryClone) – App for gathering infos about I/O Registry.
- [**Hackintool**](https://github.com/headkaze/Hackintool) – Powerful post-install utility that everyone should have in their Hackintosh tool box
- [**Kext Updater**](https://www.sl-soft.de/kext-updater/) (great tool for keeping kexts and other files up to date)
- [**ANYmacOS**](https://www.sl-soft.de/en/anymacos/) – App for downloading current macOS, creating an USB Installer and changing the Update Seed which can help resolving issues with system updates
- [**MacCPUID**](https://www.intel.com/content/www/us/en/download/674424/maccpuid.html) –  Shows detailed information of Intel CPUs (Model, Features, Cache, etc.)
- [**DarwinDumper**](https://bitbucket.org/blackosx/darwindumper/downloads/) – App for dumping ACPI tables, I/O Registry and more from real Macs.
- [**PinConfigurator**](https://github.com/headkaze/PinConfigurator) – App for importing and editing PinConfig Data for AppleALC Layout-IDs.
- [**DevCleaner for Xcode**](https://github.com/vashpan/xcode-dev-cleaner) - App for clearing various Xcode caches to reclaim tens of gigabytes of storage.
- [**GenI2C**](https://github.com/DogAndPot/GenI2C) (Info) – Helpfu tool for enabling VoodooI2C Touchpads ([**Download**](https://github.com/quynkk5/GenI2C/blob/main/GenI2C.zip?raw=true))
- [**unpkg**](https://www.timdoug.com/unpkg/) – Utility to unpack .pkg files into a folder instead of installing them on the system.
- [**UninstallPKG**](https://www.corecode.io/uninstallpkg/index.html) – remove unwanted packages from your Mac
- [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) – Python Script to generate a SSDT for Power Management (for Ivy Bridge and older)
- [**Meld for macOS**](https://yousseb.github.io/meld/) – Very useful app for comparing two config files with one another.

### macOS Ventura
- [**StartOSInstall**](https://github.com/chris1111/Startosinstall-Ventura) – Script to turn an external SSD into a macOS Installer. For Big Sur and newer.

### macOS Monterey
- [**GeForce Kepler Patcher**](https://github.com/chris1111/Geforce-Kepler-patcher) – Tool for bringing back NVIDIA GeForce Drivers for GPUs of the Kepler family which have been removed from macOS 12.
- [**Intel HD 4000 Patcher**](https://github.com/chris1111/Patch-HD4000-Monterey) – Tool for installing Intel HD 4000 iGPU drivers which have been removed from macOS 12.

### Cross-Platform
- [**Python Installer**](https://www.python.org/downloads/) – Necessary for running a lot of the python-based tools in this list
- [**SSDTTime**](https://github.com/corpnewt/SSDTTime) – Python-based Tool for dumping DSDT and automated ACPI Hotpatch generation
- [**ProperTree**](https://github.com/corpnewt/ProperTree) – Python-based .plist Editor.
- [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus) – Cross-platform plist editor
- [**Xiasl**](https://github.com/ic005k/Xiasl) – ASL/AML Editor
- [**ACPI Rename**](https://github.com/corpnewt/ACPIRename) – Handy Python script to analyze a DSDT. It can list its Device, Method and Name Paths and can generate HEX values for binray renames.
- [**BitmaskDecode**](https://github.com/corpnewt/BitmaskDecode/) – For calculating/analyzing `CsrActiveConfig`. 
- [**gibMacOS**](https://github.com/corpnewt/gibMacOS) – Python-based Tool for downloading macOS
- [**USBToolbox**](https://github.com/USBToolBox/tool) – USB Port mapping tool. Makes port mapping under macOS 11.3+ easier.
- [**freqVectorsEdit**](https://github.com/Piker-Alpha/freqVectorsEdit.sh) – Python Script for editing frequency Vectors of Board-ID plists contained in the X86PlatformPlugin.kext

### Windows
- [**USB Device Tree Viewer**](https://www.uwe-sieber.de/usbtreeview_e.html) – Helpful tool for analyzing USB ports
- [**CrystalDiskInfo**](https://crystalmark.info/en/software/crystaldiskinfo/) – Great tool for checking the health of hard disks, SSDs and NVMEs.
- [**GPU-Z**](https://www.techpowerup.com/gpuz/) – Provides useful information about your GPU
- [**HWiNFO**](https://www.hwinfo.com/) – Great Tool for getting in-depth info about your system and components

### Web-based Applications
- [**Clover Cloud Editor**](https://www.root86.com/CCE/cce/index.php) – Online Clover Config Editor
- [**Big <> Little Endian Converter**](https://www.save-editor.com/tools/wse_hex.html)
- [**Base64 Decoder/Encoder**](https://www.base64decode.org/)

## Resources
- [**Clover Changelog and Explanations**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/)
- [**Old Clover Documentation**](https://www.insanelymac.com/forum/topic/282787-clover-v2-instructions/)
- [**Clover vs OpenCore Nomenclature**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/clover-conversion/Clover-config.md)
- [**Old Hackintosh Install Guide for Clover**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) (no Quirks included)
- [**I/O Kit Fundamentals**](https://developer.apple.com/library/archive/documentation/DeviceDrivers/Conceptual/IOKitFundamentals/Introduction/Introduction.html#//apple_ref/doc/uid/TP0000011-CH204-TPXREF101) – Includes explanations about the I/O Registry.
- **ACPI Samples**
	- **General**: included in OpenCore Package (under "Docs"): https://github.com/acidanthera/OpenCorePkg/releases
	- **Additional**: https://github.com/5T33Z0/OC-Little-Translated. Primarily for OC Users but most of the files and guides apply to Clover as well.
	- **Laptop-specific** (including updated Clover configs with Quirks): https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs
	- **Clover-specific** (in chinese): https://github.com/daliansky/P-little
