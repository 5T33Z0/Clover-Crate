# Upgrading Clover for macOS 11+ compatibility

>**Latest Update**: November 24th, 2021. </br>
>**Applicable to**: Clover r5123 and newer (UEFI only).

## Why Upgrade?
Clover's previous `AptioMemoryFixes` are incapable of booting/installing macOS 11 and newer. Therefore, OpenCore's Memory Fixes (`OpenRuntime.efi`) have been integrated to keep Clover relevant. Since Clover r5126, Aptio Memory fixes are obsolete and no longer supported, so an upgrade to the latest Clover version is mandatory in order to be able to install and boot macOS 11 and newer.

## Who is this Guide for?
This guide is for everyone trying to upgrade to the latest revision of Clover, so they can install and run macOS Big Sur and newer on their machines. When updating Clover, there are several obstacles along the way, such as removing old memory fixes, drivers and picking the correct settings for newly added "Quirks" section of the `config.plist`. Users who don't want to run macOS Big Sur or newer on there systems don't need to update Clover – although you could, according to the [documentation](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?do=findComment&comment=2751618): "New Clover will understand old config.plist. You may not change it."

## Problem Description
If you just update your existing "old" Clover EFI by installing the latest `Clover.pkg` like you used to, this will most likely result in an inoperable bootloader due to missing boot parameters in the `config.plist` as well as residual files from the "old" Clover version which need to be removed first.

## Prerequisites: removing obsolete drivers and avoiding kext conflicts
In order to avoid the dilemma of your system not booting, you have to clean up your old EFI folder before upgrading to macOS 11+.

### Removing obsolete/unnecessary Drivers
The following drivers are no longer necessary and have to either be deleted when updating Clover or omitted when building a new EFI folder:

- **Aptio Memory Fixes**: `AptioMemoryFix.efi`, `OsxAptioFix3Drv.efi`,  `OsxAptioFixDrv.efi`
- **`OcQuirks.efi`** and **`OcQuirks.plist`** – delete if present. OcQuirks is a relic from earlier attempts to include OpenCore Booter Quirks into Clover (≤r5122).
- **`DataHubDxe.efi`** – DataHub protocol which provides parameters like OEM Model, FSBFrequency, ARTFrequency, Clover's boot-log and many other things to macOS which it cannot obtain otherwise. It has been fully integrated into Clover since r5129, so delete it. Newer versions of the Clover Package don't contain this driver anyway.
- **`EmuVariableUefi.efi`** – necessary for emulating NVRAM, if it is not available (legacy systems) or working incorrectly.
- **`FSInject.efi`** – For Kext injection. Necessary only for legacy versions of macOS ≤ 10.7 (Lion) which are capable of loading individual kexts instead of Prelinkedkernel. Since r5125, OpenCore handles Kext injection, so FSInject has become obsolete and should be deleted!
- **`SMCHelper.efi`** – Necessary only when using **`FakeSMC.kext`**. If you use it in combination with **`VirtualSMC.efi`**, it can cause instant Kernel Panics. In other words: VirtualSMC + VirtualSMC.efi = good; FakeSMC + SMCHelper.efi = good; any other combination = bad. Nowadays, using **`VirtualSMC.kext`** alone is sufficient and recommended.

### Checking and Updating Kexts
Outdated, incompatible and/or duplicate Kexts (and variations thereof) can cause boot crashes, kernel panics and general system instability. Therefore, you should always keep your kexts up to date for maximum compatibility with macOS and Clover! You can use Kext-Updater to download the latest kexts and other Bootloader-related files.

If you are using a lot of Kexts (usually on Notebooks), have a look inside of them (right-click and select "Show package contents") to check if they include additional kexts (as "Plugins") and make sure that no duplicates exist in the "kexts" folder – Kexts for HID, WiFi and Bluetooth come to mind.

If you get panics you can not isolate, move all non-essential kexts to the "Off" folder temporarily to work around the issue by starting with a minimal set of Kexts to get the system running. Once it runs, put the disabled Kexts back one at a time, reboot, and repeat until you to find the culprit for the panic and look for a solution (verbose mode is your friend). 

Here are some examples of Kexts I've experienced issues with when updating:

- **VoodooPS2Controller.kext**: can cause Kernel Panic if one of it's Plugins (VoodooInput.kext, VoodooPS2Mouse.kext, VoodooPS2Trackpad.kext and VoodooPS2Keyboard.kext) is also present at the root level of the "kexts" Folder.
- **AirportBrcmFixup.kext**: this Kext contains 2 Plugins, `AirPortBrcm4360_Injector` and `AirPortBrcmNIC_Injector.kext`. When using AirPortBrcmFixup, you are supposed to use only one of these plugins, not both! Using both can cause the boot process to stall indefinitely. On top of that, `AirPortBrcm4360_Injector` is not supported by macOS Big Sur and has to be disabled anyway. In OpenCore, you can just disable a Kext in the config. Since the Clover config does not support to take control of the kext loading sequence, you have to delete it from the Kext itself (right click on AirportBrcmFixup, select "Show package contents" > "Plugins").
- **BrcmPatchRAM** and a bad combination of it's accompanying kexts can cause issues as well. Don't use BlueToolFixup.kext and BrcmBluetoothInjector.kext together. Former is needed for enabling Bluetooth in macOS Monterey where the latter is used in earlier versions of macOS.

## Building a new EFI folder

1. Prepare a USB flash drive. Format it to FAT32 (MBR). We'll use it for testing our updated EFI Folder first, before copying it to the ESP on the HDD.
2. Download the [latest Clover Release](https://github.com/CloverHackyColor/CloverBootloader/releases) as a .zip archive for a manual update.
3. Download `CloverConfigPlistValidator.zip` as well.
4. Extract both zip archives.
5. Have a look at `CloverV2/EFI/CLOVER/drivers/off/UEFI` and its sub-folders. Inside, you will find these Drivers: </br>
![Bildschirmfoto 2021-10-05 um 10 32 30](https://user-images.githubusercontent.com/76865553/136025337-d12b41ac-b3f6-4c3f-9a31-e61294daf01a.png)</br>
6. Move the following drivers from "divers/Off" to "/drivers/UEFI":</br>
	- ApfsDriverLoader.efi, 
	- VBoxHfs.efi (or HfsPlus.efi, which is faster) and 
	- OpenRuntime.efi</br>
Now we have a minimal set of Drivers:</br>
![Drivers](https://user-images.githubusercontent.com/76865553/136026914-af63dce9-a505-4b61-8ad4-0d14348fac37.png)</br>
Files tagged gray are in there by default and are most likely unnecessary for UEFI-based systems. I would move them to the "off" folder one by one to disable them and check if the system still boots from the USB flash drive without them. `AudioDXE.efi` is only needed for playing back audio files like boot chimes - so if you don't use any, you can delete/disable it. As mentioned earlier, `SMCHelper.efi` MUST be deleted when using `VirtualSMC.kext`!
7. Next, copy over the following files/folders from your existing EFI folder:</br>
	- **Kexts** (updated to the latest available version, of course), 
	- **.aml** Files from "ACPI/patched" folder 
	- **config.plist**
8. Run Clover Configurator and update it to the latest Version. It should now include a new section at the bottom called `Quirks`.
9. Open your `config.plist`
10. Click on "Quirks". It should look like this (without descriptions of course):
![](https://user-images.githubusercontent.com/76865553/135844035-1689a11a-6512-4008-80ea-e89f07a55367.png)
11. Head over to the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/prerequisites.html) and pick the guide for your CPU Family and Platform.
12. Jump to the "Booter" Section. It contains all required Booter Quirks tinted green in the screenshot. Make sure to unfold the "more in-depth info" box to see what they do. Find the options for your system and tick them away in Clover Configurator.
13. Next, jump to the "Kernel" section of Dortania's guide and copy over the settings from "Quirks" and "Scheme". Again, make sure to unfold the "more in-depth" section to find all necessary settings.</br> 
	**NOTE**: some of the OpenCore "Kernel Quirks" have different names and are located in the "Kernel and Kext Patches" section of Clover Configurator. In most cases you have the correct settings enabled already, otherwise your system wouldn't have started before. But it's good to double check if you have settings enabled which may be unnecessary. These include: ![](https://user-images.githubusercontent.com/76865553/135859628-34f6be51-7a20-4461-900e-0c72fbdcba51.png)</br>
14. Finally, you can delete all the deprecated USB Port Limit Patches from your config since this can by handled by `XhciPortLimit` Quirk (for macOS ≥ Catalina you will need a USBPort.kext).
15. Once you've ticked all the necessary quirks, save your configuration.

### Validating config.plist and fixing errors

Starting from version r5134, Clover now includes error reporting similar to OpenCore which displays configuration errors before the actual boot menu appears. Do the following to validate your config and fix configuration errors:

1. Open Terminal
2. Drag `CloverConfigPlistValidator` into it and hit the right arrow key once, so the file path is no longer highlighted
3. Next, drag and drop your clover config.plist into the terminal window. Make sure there is a blank space between the 2 file paths
4. Hit "Enter"
5. Check the results. If it says: "Your plist looks so wonderful. Well done!", then you don't have to do anything else.
6. If there are errors shown in the log, open both your `config.plist` and the `config-sample.plist` included in the Clover package in a plist editor and compare them. Look for any differences (like formatting, deleted features, etc.) and fix them. **NOTE**:
7. Save your config.
8. Re-check for errors
9. Repeat comparison, fixing, saving and re-checking until all issues are resolved

### Testing your (new) config

- Copy the new EFI Folder to the root of your USB Flash Drive and try booting from it.
- In the Clover Boot menu, perform an NVRAM Reset (F11) to clean out possible remnants of previous Aptio Memory Fixes 
- Reboot again and then start macOS.

If it does boot, you can mount the ESP partition of your hard drive, backup your old EFI Folder, delete it and put in the one from your USB Flash drive to make the changes permanent.

## Further Resources and Troubleshooting:

- Clover Config Guide (up to Coffeelake, excluding Quirks): [**Hackintosh Vanilla Desktop Guide**](https://hackintosh.gitbook.io/-r-hackintosh-vanilla-desktop-guide/)
- To find out more about how OpenCore differs from Clover and see which settings, drivers and features are compatible, check out the [**Clover Conversion Guide**](https://github.com/dortania/OpenCore-Install-Guide/tree/master/clover-conversion).
- [**Clover Changelog**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/)
- If you get Kernel Panics: head over to the [**OpenCore Troubleshooting Guide**](https://dortania.github.io/OpenCore-Install-Guide/troubleshooting/troubleshooting.html) and have a look at the "OpenCore Boot issues" and "Kernelspace Issues" sections to find your error message and possible fixes to resolve it.
- Fixing Network issues after Clover Update: Have a look at [**this**](https://www.insanelymac.com/forum/topic/345789-guide-how-to-update-clover-for-bigsur-compatibility-and-beyond-using-openruntime-and-quirks-r5123/page/2/?tab=comments#comment-2751614)
- Check the [**ACPI section**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI) to learn more about the all important ACPI Section of Clover.

Good luck!

**NOTES**

- For booting Big Sur, you need to remove the PreBoot Volume from the "Hide" Section of the GUI because Big Sur requires booting from it.
- If your system boots correctly you can upload a screenshot with your quirks with additional Info like your Board and CPU which might be helpful for other users.
