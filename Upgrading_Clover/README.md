# Upgrading Clover for macOS 11+ compatibility
>:warning: The following guide is for booting in UEFI mode only!

**TABLE of CONTENTS**

- [About](#about)
	- [Who needs to upgrade (and who not)?](#who-needs-to-upgrade-and-who-not)
- [Upgrade instructions (manual method)](#upgrade-instructions-manual-method)
	- [EFI Folder adjustments](#efi-folder-adjustments)
		- [Remove obsolete and unnecessary Drivers](#remove-obsolete-and-unnecessary-drivers)
		- [Check and update Kexts](#check-and-update-kexts)
	- [Building a new EFI folder (manual Upgrade)](#building-a-new-efi-folder-manual-upgrade)
	- [Config.plist adjustments](#configplist-adjustments)
		- [Correcting the `RenameDevices` section](#correcting-the-renamedevices-section)
		- [Updating the SMBIOS (Update Firmware Only)](#updating-the-smbios-update-firmware-only)
	- [Validating the config.plist and fixing errors](#validating-the-configplist-and-fixing-errors)
	- [Testing your (new) config](#testing-your-new-config)
- [Using the .pkg Installer to upgrade Clover](#using-the-pkg-installer-to-upgrade-clover)
- [`OpenRuntime.efi` and older Clover builds (< r5142)](#openruntimeefi-and-older-clover-builds--r5142)
- [Further Resources and Troubleshooting](#further-resources-and-troubleshooting)
- [Notes](#notes)

## About
This guide is for upgrading/converting your Clover EFI folder and config from the "old" to the "new" version which utilizes OpenCore's memory fixes and the newly added "Quirks".

Clover's previously used `AptioMemoryFixes` no longer work in macOS 11 and newer. Therefore, OpenCore's memory fixes (`OpenRuntime.efi`) have been implemented to keep Clover alive. Since Clover r5126, Aptio Memory fixes are obsolete and no longer supported, so an upgrade to the latest Clover version is *mandatory* in order to install and boot macOS 11 and newer.

When upgrading Clover, there are several obstacles along the way, such as removing old memory fixes and drivers as well as configuring the newly added "Quirks" in the `config.plist`. 

Why there are no proper upgrade instructions provided on the Clover Github Repo is a mystery to me, really…

### Who needs to upgrade (and who not)?
This guide is for everyone trying to upgrade to the latest revision of Clover, so they can install and run macOS Big Sur and newer on their machines. 

Users who want to stay on macOS Catalina or older should update to [**r5123.1**](https://github.com/CloverHackyColor/CloverBootloader/releases/tag/5123.1) which is the final revision supporting the old Aptio memory fixes. It also contains the long-awaited fix for the `TgtBridge` which had been broken for a long time.

## Upgrade instructions (manual method)
Follow the steps below to successfully upgrade your EFI folder and Config so you can install macOS Big Sur and newer. Manual upgrading from the "old" to the "new" Clover version is the preferred method since it forces you to do some housekeeping so you can get rid of some old ballast you no longer need.

### EFI Folder adjustments

#### Remove obsolete and unnecessary Drivers
The following drivers are no longer necessary and have to either be deleted when updating Clover or omitted when building a new EFI folder:

|Driver(s)|Description|Action
|---------|-----------|-----|
|**`AptioMemoryFix.efi`**,</br>**`OsxAptioFixDrv.efi`**,</br>**`OsxAptioFix2Drv-free2000`**,</br> **`OsxAptioFix3Drv.efi`**,</br>**`OsxLowMemFixDrv`**,</br>**`OcQuirks.efi`** and **`OcQuirks.plist`**|Obsolete Aptio Memory Fixes and OCQuirks. OcQuirks is a relic from earlier attempts to include OpenCore Booter Quirks into Clover (≤ r5122).|Delete
**`DataHubDxe.efi`**| DataHub protocol which provides parameters like OEM Model, FSBFrequency, ARTFrequency, Clover's boot-log and many other things to macOS which it cannot obtain otherwise. It has been fully integrated into Clover since r5129. Newer versions of the Clover Package don't contain this driver anyway.|Delete
**`EmuVariableUefi.efi`** | Necessary for emulating NVRAM, if it is not available (legacy systems) or working incorrectly.|Delete
**`FSInject.efi`** | For Kext injection. Only necessary for legacy versions of macOS ≤ 10.7 (Lion) which are capable of loading individual kexts instead of Prelinkedkernel. Since r5125, OpenCore handles Kext injection, so FSInject has become obsolete|Delete
**`SMCHelper.efi`** | Deprecated since r5148, [Commit 735987a](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?do=findComment&comment=2789856). Its functionality is now embedded in Clover as a service. This change also brought a new "ResetSMC" option to the Clover Boot Menu which works similar to SMC Reset on real Macs.| Delete

#### Check and update Kexts
Outdated, incompatible and/or duplicate kexts (and variations thereof) can cause boot crashes, kernel panics and general system instability. Therefore, you should always keep your kexts up to date for maximum compatibility with macOS and Clover! You can use [**Kext-Updater**](https://www.sl-soft.de/en/kext-updater/) to download the latest kexts and other Bootloader-related files.

If you are using a lot of kexts (usually on Notebooks), have a look inside of them (right-click and select "Show package contents") to check if they include additional kexts (as "Plugins") and make sure that no duplicates exist in the "kexts" folder – kexts for HID, WiFi and Bluetooth come to mind.

:bulb: If you get panics you can not isolate, move all non-essential kexts to the "Off" folder temporarily to work around the issue by starting with a minimal set of kexts to get the system running. Once it runs, put the disabled kexts back one at a time, reboot, and repeat until you to find the culprit for the panic and look for a solution (verbose mode is your friend).

Here are some examples of kexts I've experienced issues with when updating:

- **VoodooPS2Controller.kext**: can cause Kernel Panic if one of its Plugins (VoodooInput.kext, VoodooPS2Mouse.kext, VoodooPS2Trackpad.kext and VoodooPS2Keyboard.kext) is also present at the root level of the "kexts" Folder.
- **AirportBrcmFixup.kext**: this Kext contains 2 Plugins, `AirPortBrcm4360_Injector` and `AirPortBrcmNIC_Injector.kext`. When using AirPortBrcmFixup, you are supposed to use only one of these plugins, not both! Using both can cause the boot process to stall indefinitely. On top of that, `AirPortBrcm4360_Injector` is not supported by macOS Big Sur and has to be disabled anyway. In OpenCore, you can just disable a Kext in the config. Since the Clover config does not support to take control of the kext loading sequence, you have to delete it from the Kext itself (right click on AirportBrcmFixup, select "Show package contents" > "Plugins").
- **BrcmPatchRAM** and a bad combination of it's accompanying kexts can cause issues as well. Don't use BlueToolFixup.kext and BrcmBluetoothInjector.kext together. Former is needed for enabling Bluetooth in macOS Monterey where the latter is used in earlier versions of macOS.

### Building a new EFI folder (manual Upgrade)

1. Prepare a USB flash drive. Format it to FAT32 (MBR). We'll use it for testing our updated EFI Folder first, before copying it to the ESP on the HDD.
2. Download the [latest Clover Release](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip archive for a manual update.
3. Download `CloverConfigPlistValidator.zip` as well.
4. Extract both zip archives.
5. Have a look at `CloverV2/EFI/CLOVER/drivers/off/UEFI` and its sub-folders. Inside, you will find these Drivers: </br>
![Bildschirmfoto 2021-10-05 um 10 32 30](https://user-images.githubusercontent.com/76865553/136025337-d12b41ac-b3f6-4c3f-9a31-e61294daf01a.png)</br>
6. Move the following files from "**drivers/Off**" to "**/drivers/UEFI**":</br>
	- `ApfsDriverLoader.efi`, 
	- `VBoxHfs.efi` (or `HfsPlus.efi`, which is faster) and 
	- `OpenRuntime.efi`</br> 
Now we have the *required* minimum set of Drivers (green and red):</br>
![Drivers](https://user-images.githubusercontent.com/76865553/136026914-af63dce9-a505-4b61-8ad4-0d14348fac37.png)</br>
7. **Delete unnecessary Drivers**: Files tagged in gray are pressent in the **drivers/UEFI** folder by default. They are completely unnecessary to boot UEFI-based systems! Delete them or move them into the "off" folder to disable them.
	- `AudioDXE.efi` is only needed for playing back boot chimes and for dumping the Audio Codec when pressing `F4` in the Clover Boot menu. It also slows down the initial start of Clover. So if you don't need it, delete/disable it.
	- `FSInject` is deprecated since OpenRuntime handles kext injection now, so delete/disable it (if present).
	- `SMCHelper`is unnecessary as well – it *must* be deleted if `VirtualSMC.kext` is used!
	- `EnglisdDxe.efi`: Provides a better Unicode Collation protocol used by Shell.efi. Sometimes this protocol is absent or badly implemented. Unless you plan to work in Shell a lot, delete/disabled it.
8. Next, copy over the following files/folders from your existing EFI folder:</br>
	- **Kexts** (updated to the latest available version, of course), 
	- **.aml** Files from "ACPI/patched" folder 
	- **config.plist**
9. Run Clover Configurator and update it to the latest Version. It should now include a new section at the bottom called `Quirks`.
10. Open your `config.plist`
11. Click on "Quirks". It should look like this (in the latest version of Clover Configurator, the Quirks section is divided into "Booter" and "Kernel" sections for better overview):</br>
![Booter](https://user-images.githubusercontent.com/76865553/148212620-62387a7a-d56a-4df7-b8bb-ad6b0131ebf5.png)</br>
![Kernel+scheme](https://user-images.githubusercontent.com/76865553/148212751-e8322419-59f7-4341-b5d9-59b7c85a7260.png)</br>
12. Head over to the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) and pick the guide for your CPU Family and Platform.
13. Jump to the "Booter" Section. It contains all required Booter Quirks tinted green in the screenshot. Make sure to unfold the "more in-depth info" box to see what they do. Find the options for your system and tick them away in Clover Configurator.
14. Next, jump to the "Kernel" section of Dortania's guide and copy over the settings from "Quirks" and "Scheme". Again, make sure to unfold the "more in-depth" section to find all necessary settings.</br> 
	**NOTE**: some of the OpenCore "Kernel Quirks" have different names and are located in the "Kernel and Kext Patches" section of the config. In most cases you have the correct settings enabled already, otherwise your system wouldn't have started before. But it's good to double check if you have settings enabled which may be unnecessary. These include: ![](https://user-images.githubusercontent.com/76865553/135859628-34f6be51-7a20-4461-900e-0c72fbdcba51.png)</br>
15. Finally, you can delete all the deprecated USB Port Limit Patches from your config since this is handled by the `XhciPortLimit` Quirk (for macOS ≥ Catalina you will need a `USBPort.kext` instead).
16. Once you've ticked all the necessary quirks, save your configuration file.

### Config.plist adjustments

#### Correcting the `RenameDevices` section
When upgrading Clover, you also need to adjust some config settings as well. The "Quirks" Dictionary will automatically be created once you select a Quirk in Clover Configurator and save the file

But the structure of `ACPI/RenameDevices` section has to be changed from a Dictionary to an Array and each String has to reside in its own Dictionary as well, as shown below.

**Old Config**:</br>
![Config_old](https://user-images.githubusercontent.com/76865553/180644167-b8405336-cbfa-4d4d-9363-fae1af532c51.png)

**New Config**:</br>
![Config_new](https://user-images.githubusercontent.com/76865553/180644172-bd4116d2-5f69-4d14-985f-cc5eb5a7853e.png)

You can use ProperTree to do this. The easies way without losing data is this:

- Create dictionaries for each String. 
- Move each string into it's own dictionary. 
- Finally, change the class of `RenameDevices` from "Dictionary" to "Array". 
- Save the config.plist

#### Updating the SMBIOS (Update Firmware Only)
Update the BIOS and Firmware to the latest version to prevent macOS installation failures. If the firmware version is out of date, installation will quit with an error message. To prevent this, do the following:

- Open your config.plist in Clover Configurator
- Click on "SMBIOS"
- Check "Update Firmware Only" box:</br>
![FWONLY](https://user-images.githubusercontent.com/76865553/167351554-835f91e4-b952-4303-b2d8-a2b19878739a.png)
- From the dropdown menu next to it, select your Mac model (the one listed under "Product Name") and click on its list entry
- This will update the fields for BIOS and Firmware only, leaving the Serial, MLB, etc. unchanged
- Save the config

### Validating the config.plist and fixing errors

Starting from version r5134, Clover now includes error reporting similar to OpenCore which displays configuration errors before the actual boot menu appears. Do the following to validate your config and fix configuration errors:

1. Open Terminal
2. Drag `CloverConfigPlistValidator` into it and hit the right arrow key once, so the file path is no longer highlighted
3. Next, drag and drop your clover config.plist into the terminal window. Make sure there is a blank space between the 2 file paths
4. Hit "Enter"
5. Check the results. If it says: "Your plist looks so wonderful. Well done!", then you don't have to do anything else.
6. If there are errors shown in the log, open both your `config.plist` and the `config-sample.plist` included in the Clover package in a plist editor and compare the structure of the section(s) referenced by the validator. Look for any differences (like formatting, deleted features, etc.) and fix them.
7. Save your config.
8. Re-check for errors
9. Repeat comparison, fixing, saving and re-checking until all issues are resolved

### Testing your (new) config

- Copy the new EFI Folder to the root of your USB Flash Drive and try booting from it.
- In the Clover Boot menu, perform an NVRAM Reset (F11) to clean out possible remnants of previous Aptio Memory Fixes
- Reboot again and then start macOS.

If it does boot, you can mount the ESP partition of your hard drive, backup your old EFI Folder, delete it and put in the one from your USB Flash drive to make the changes permanent.

## Using the .pkg Installer to upgrade Clover
This is for users who want to use the pkg installer instead. Don't do this if you already created your EFI folder manually!

1. Mount your EFI
2. Remove deprecated Memory fixes and drivers manually as explained previously
3. Open your config.plist with Clover Configurator and add the required Quirks for your system.
4. Save the config
5. [Download](https://github.com/CloverHackyColor/CloverBootloader/releases) and Run Clover_r5146.pkg (or newer)
6. Click "Continue" until you reach the "Installation Type" screen
7. Next, click on "Customize":</br>![Cstmz](https://user-images.githubusercontent.com/76865553/167565587-bb5e6eef-55f7-4f2b-abf4-b235a2b7df4c.png)
8. Select the following settings:
	- **Clover for UEFI Booting only**
	- **Install Clover in the ESP** (that's where the EFI folder is located)
9. In the **UEFI Drivers** section, tick the UEFI Drivers box to deselect all drivers:</br>![UEFI_none](https://user-images.githubusercontent.com/76865553/167565684-d55678cf-8d6b-48b7-842f-2b92bee9c30a.png)</br> **NOTE**: The "Recommended Drivers" are not required on UEFI systems using OpenRuntime.efi. But if you want bootchime support, enable AudioDxe!
10. Next, enable the following UEFI Drivers (these are mandatory!):</br>![ReqDrvs](https://user-images.githubusercontent.com/76865553/167565750-b80807b2-31e5-4d78-a4ac-4532d0fa65e9.png)
11. Add any additional system-specific drivers you need (HID, FileVault, etc)
13. Scroll to the end of the list and select **CloverConfigPlistValidator** as well
14. Click on "Install"
15. Once it's done, check your config.plist for errors in Clover Configurator using the Clover Validator in the "Tools" section and correct them if necessary.
16. Save your config, reboot and hope for the best

**IMPORTANT**: Make sure you have a backup of your currently working EFI folder stored on a FAT32 formatted flash drive to boot from just in case you run into issues.

## `OpenRuntime.efi` and older Clover builds (< r5142)
There is an incompatibility with `OpenRuntime.efi` and Clover: revisions prior to r5142 require `OpenRuntime.efi` version 1.1, while r5142 and newer require v1.2 (or newer). This is not really an issue for people who just want to stay up to date using the newest version of Clover and Drivers anyway. But if you want to boot using a Clover build older than r5142, you need v1.1 of OpenRuntime which will not work in r5142, of course.

To workaround this issue, a special folder `drivers/5142` can be used to place the current `OpenRuntime-v12.efi.`, while regular `drivers/UEFI` contains the old `OpenRuntime-v11.efi`:

![5142](https://user-images.githubusercontent.com/76865553/159173658-4774c7bb-8dcb-4018-82da-c424da658d0e.png)

This way, you can switch back and forth between current and older Clover builds prior to r5142 without issues. Because Clover build prior to r5142  can't see the `drivers/5142` folder while Clover 5142+ does see this folder and prioritizes the included OpenRuntime.efi (if present) over the one stored under `drivers/UEFI`.

## Further Resources and Troubleshooting

- Clover Config Guide (up to Coffee Lake, excluding Quirks): [**Hackintosh Vanilla Desktop Guide**](https://hackintosh.gitbook.io/-r-hackintosh-vanilla-desktop-guide/)
- To find out more about how OpenCore differs from Clover and see which settings, drivers and features are compatible, check out the [**Clover Conversion Guide**](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion).
- [**Clover Changelog**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/)
- If you get Kernel Panics: head over to the [**OpenCore Troubleshooting Guide**](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html) and have a look at the "OpenCore Boot issues" and "Kernelspace Issues" sections to find your error message and possible fixes to resolve it.
- Fixing Network issues after Clover Update: Have a look at [**this**](https://www.insanelymac.com/forum/topic/345789-guide-how-to-update-clover-for-bigsur-compatibility-and-beyond-using-openruntime-and-quirks-r5123/page/2/?tab=comments#comment-2751614)
- Check the [**ACPI section**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI) to learn more about the all important ACPI Section of Clover.

## Notes
- For Big Sur and newer, remove the PreBoot Volume from the "Hide" Section of the GUI because macOS requires it for booting!
- Even if you don't want to upgrade macOS past Catalina, an upgrade to the new Clover is recommended since kext injection via Open Runtime is cleaner, and you have much more control over the applied memory fixes. The system also boots faster.
