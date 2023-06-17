# SMBIOS

**TABLE of CONTENTS**

- [About](#about)
- [Example: Generating SMBIOS data with Clover Configurator](#example-generating-smbios-data-with-clover-configurator)
- [About "Update Firmware Only"](#about-update-firmware-only)
- [About "Extended Firmware Features"](#about-extended-firmware-features)
- [Slots (AAPL Injections)](#slots-aapl-injections)
- [Exchanging SMBIOS Data between OpenCore and Clover](#exchanging-smbios-data-between-opencore-and-clover)
	- [Manual method](#manual-method)
	- [SMBIOS Data Import/Export with OCAT](#smbios-data-importexport-with-ocat)
	- [1-Click-Solution for Clover Users](#1-click-solution-for-clover-users)
	- [Troubleshooting](#troubleshooting)
- [Running macOS on unsupported platforms](#running-macos-on-unsupported-platforms)
	- [Workaround (macOS 11.3+ only)](#workaround-macos-113-only)
- [Notes](#notes)

## About
>**SMBIOS** stands for **System Management BIOS**. It defines data structures (and access methods) that can be used to read management information produced by the BIOS of a computer. This eliminates the need for the operating system to probe hardware directly to discover what devices are present in the computer. The SMBIOS specification is produced by the Distributed Management Task Force (DMTF), a non-profit standards development organization. The DMTF estimates that two billion client and server systems implement SMBIOS. **SOURCE**: [Wikipedia](https://en.wikipedia.org/wiki/System_Management_BIOS#From_UEFI)

This section is needed to mimic your PC as a Mac and to be able to install and run macOS. The entered `ProductName` is of special significance here. Not only does it define the range of macOS versions it can run, moreover it sets a lot of system parameters for the hardware used in the chosen model. So picking a model which is close to the specs of your hardware gets you a lot closer to having a well-working Hackintosh. The most important point of reference for picking an appropriate SMBIOS is the CPU you are using.

I won't be covering each individual field of the SMBIOS section here, since it is tedious and completely unnecessary, as you will find out soon. Instead, I will focus only on the important ones: `ProductName`, `SerialNumber`, `Board-ID` and `SmUUID`.

## Example: Generating SMBIOS data with Clover Configurator

If you find an EFI folder for your System on a Forum or on GitHub this section might look like this:

![SMBIOS](https://user-images.githubusercontent.com/76865553/139639731-4eeb5cd4-9484-4477-ad0c-593c743293e0.png)

As you can see, the `ProductName` is set to `MacBookPro11,4` (which is the minimum System Requirement for running macOS Monterey on a Laptop, btw). Now, do the following to generate your own SMBIOS Section:

1. Click on this little symbol next to the "Update Firmware only" checkbox. This one:
	
	![Dropdown](https://user-images.githubusercontent.com/76865553/136689944-182b5c46-ef9a-4495-bb4a-c9618cd1192c.png)

2. Next you will be confronted with a huge list of Mac models to choose from: 
	
	![models](https://user-images.githubusercontent.com/76865553/136689980-3d8739d2-5d22-4535-9c99-355b33191344.png)

3. Select a Mac model based on the family of Intel CPU you are using. In this example, the actual MacBookPro model uses an Intel i7 `4770HQ`. In Intel's nomenclature, the first digit of the CPU model name describes the generation (or family) it belongs to. In this case it's a `4` for 4th Gen Intel "i" CPU (first gen models only use 3 digits). So pick a Mac Model which is close to yours in terms of CPU (desktop/mobile, generation, max clock speed).
4. After you've picked a model, Clover Configurator will automatically generate a valid SMBIOS for you (don't copy these values, generate your own!):

	![SMBIOS_11,4](https://user-images.githubusercontent.com/76865553/139640510-0140ff1e-759b-4d75-846d-205db078197a.png)

	**IMPORTANT**: Fields highlighted in cyan *should always be deleted before sharing your `config.plist`*. Also, if you get an error message about outdated firmware during macOS installation, click on "Update Firmware only" and then select the same Mac Model from the dropdown menu again. This keeps your Serial, etc. and will only update the firmware information, so you can install macOS successfully.
5. Once you have generated your `SMBIOS`, head over to the `RTVariables` section.
6. Copy the number for `MLB` (=Board Serial Number) shown in the "Info" windows to the `MLB` field and select "UseMacAddr0" from the dropdown menu. This is a must for enabling FaceTime.

**DONE**.

## About "Update Firmware Only"
![FWONLY](https://user-images.githubusercontent.com/76865553/167351554-835f91e4-b952-4303-b2d8-a2b19878739a.png)

Use this feature if macOS installation fails due to firmware issues. macOS checks if the BIOS and Firmware requirement of real Macs are met to ensure that the OS will be working fine. If the firmware is out of date, installation will quit with a notification.

By setting the latest BIOS and Firmware version in the SMBIOS section this hurdle is overcome. It will only update the BIOS and Firmware sections of the SMBIOS without generating a new serial:

- Select "Update Firmware Only"
- From the dropdown menu right to it, select your Mac model (the one located under "Product Name") and click on the entry
- Save

This updates your BIOS and Firmware Data, so now you can continue your macOS installation successfully.

## About "Extended Firmware Features"
![extfirmw](https://user-images.githubusercontent.com/76865553/150670638-9bfac516-9038-479c-bb12-d62afa0d2cc9.png)

Expands the existing Firmware Features mask from 32 up to 64 bits which is required for newest Macs and macOS Monterey. Clover has the ability to set some default values for keys absent in config.plist. These are set automatically based on hardware characteristics or the selected mac model in SMBIOS. `iMacPro1,1` uses different values for `ExtendedFirmwareFeatures` and `ExtendedFirmwareFeaturesMask` than `iMac20,2`, for example.

For reference values, check the files in the Mac models [database](https://github.com/acidanthera/OpenCorePkg/tree/master/AppleModels/DataBase) of the OpenCore repo.

## Slots (AAPL Injections)
![Slots](https://user-images.githubusercontent.com/76865553/162909263-82c199bb-6117-415a-9083-953095401693.png)

`AAPL,slot-name` injector. Allows you to manually add devices to the `PCI` section of the System Profiler:

![SysInfo](https://user-images.githubusercontent.com/76865553/162909344-a6ea67e5-7d3d-47c4-b7af-5610a911d385.png)

By default, the `AAPL,slot-name` is is injected into macOS by system's `DSDT` or Device `Properties` in your `config.plist`. For macOS to list and categorize PCIe devices, it requires the `Name (_SUN, 0xXX)` field for a device to be present inside the `DSDT`, as shown in this example:

```asl
Device (GIGE)
{
    Name (_ADR, 0x00050000)  // _ADR: Address
    Name (_SUN, 0x02)  // _SUN: Slot User Number
```

But if you use 3rd party PCIe cards, this entry will most likely not be present in your `DSDT`, so the device(s) will not appear in the `PCI` category of the System Profiler (unless you use a patched one with added `_SUN` descriptions).

Clover can generate `AAPL-slot,name` entries for certain types of devices, if the `_SUN` method does not exist in your `DSDT`. You must set the patch mask for these devices using any one byte number but `0` and `1` since they are reserved for compiler-related operations, so generating the `AAPL,slot-name `entries might fail.
 
Four parameters are required to create a custom `AAPL,slot-name` entry in your config:

* **Device**: Select the type of device you want assign a `AAPL,slot-name` to. Supported device types are: `ATI`, `NVidia`, `IntelGFX`, `LAN`, `WIFI`, `Firewire`, `HDMI`, `USB` and `NVME`. For other device types use the `Devices/Properties` section instead.
* **ID**: Must be the same number as defined in the Device's description inside your `DSDT` under `Name (_SUN, 0xXX`), where `XX` is a placeholder for a number.
* **Name** - Enter the name for the slot. Sets how the entry will be named in System Profiler 
* **Type** - Select the type of PCIe Slot (number of lanes) the device is connected to from the dropdown menu (`PCIe` to `PCIe x16`)

**NOTES**

* `AAPL,slot-name` is mostly a cosmetic property (despite what some users may think)
* In order for the `Slots` section to be present in the config.plist, a SMBIOS has to be generated because Slots is a sub-category of the SMBIOS dictionary.
* As long as I have been using Clover, I've never used this section whatsoever. I always use Device Properties to define a device and call it a day. Especially since Hackintool can create all these device property entries with the correct AAPL,slot-names for you.

## Exchanging SMBIOS Data between OpenCore and Clover
### Manual method
Exchanging existing SMBIOS data between OpenCore Clover can be a bit confusing since both use different names and locations for data fields. 

Transferring SMBIOS data correctly is important because otherwise you have to enter your AppleID and Password again which in return will register your computer as a new device in the Apple Account. On top of that you have to re-enter and 2-way-authenticate the system every single time you switch between OpenCore and Clover, which is incredibly annoying. So in order to prevent this, you have to do the following:

1. Copy the Data from the following fields to Clover Configurator's "SMBIOS" and "RtVariables" sections:

PlatformInfo/Generic (OpenCore)| SMBIOS (Clover)      |
|------------------------------|----------------------|
| SystemProductName            | ProductName          |
| SystemUUID                   | SmUUID               |
| ROM                          | ROM (under `RtVariables`). Select "from SMBIOS" and paste the ROM address|
| N/A in "Generic"             | Board-ID             |
| SystemSerialNumber           | Serial Number        |
| MLB                          | 1. Board Serial Number (under `SMBIOS`)</br>2. MLB (under `RtVariables`)|
N/A in OpenCore                | Custom UUID (=Hardware UUID). Leave empty.

2. Next, tick the "Update Firmware Only" box.
3. From the Dropdown Menu next to it to, select the Mac model you used for "ProductName". This updates fields like BIOS and Firmware to the latest version.
4. Save config and reboot with Clover.

You know that the SMBIOS data has bee transferred correctly, if you don't have to re-enter your Apple-ID and password.

### SMBIOS Data Import/Export with OCAT
Besides manually copying over SMBIOS data from your OpenCore to your Clover config and vice versa, you could use [**OpenCore Auxiliary Tools**](https://github.com/ic005k/OCAuxiliaryTools/releases) instead, which has a built-in import/export function to import SMBIOS Data from Clover as well as exporting function SMBIOS data into a Clover config:

![ocat](https://user-images.githubusercontent.com/76865553/162971063-cbab15fa-4c83-4013-a732-5486d4f00e31.png)

**IMPORTANT**

- If you did everything correct, you won't have to enter your AppleID Password after switching Boot Managers and macOS will let you know, that "This AppleID is now used with this device" or something like that.
- But if macOS asks for your AppleID Password and Mail passwords etc. after switching Boot Managers, you did something wrong. In this case you should reboot into OpenCore instead and check again. Otherwise, you are registering your computer as a new/different Mac.

### 1-Click-Solution for Clover Users
If you've used the real MAC Address of your Ethernet Controller ("ROM") when generating your SMBIOS Data for your OpenCore config, you can avoid possible SMBIOS conflicts altogether. In the "Rt Variables" section, click on "from System" and you should be fine!

### Troubleshooting
If you have to re-enter your Apple ID Password after changing from OpenCore to Clover or vice versa, the used SMBIOS Data is either not identical or there is another issue, so you have to figure out where the mismatch is. You can use Hackintool to do so:

- Mount the EFI
- Open the config for the currently used Boot Manager
- Run Hackintool. The "System" section shows the currently used SMBIOS Data: </br> ![SYSINFO](https://user-images.githubusercontent.com/76865553/166119425-8970d155-b546-4c91-8daf-ec308d16916f.png)
- Check if the framed parameters match the ones in your config.
- If they don't, correct them and use the ones from Hackintool 
- If they do mach the values used in your config, open the config from your other Boot Manager and compare the data from Hackintool again and adjust the data accordingly.
- Save the config and reboot
- Change to the other Boot Manager and start macOS
- If the data is correct you won't have to enter your Apple ID Password again (double-check in Hackintool to verify).

## Running macOS on unsupported platforms
Unlike real Macs, which are limited to a certain range of supported macOS versions, you can trick macOS into running on CPU models it doesn't support officially – at least, if the used SMBIOS are not too far off from the specs of your hardware. 

For example, you can use an SMBIOS intended for a Haswell CPU (4th Gen) with an Ivy Bridge CPU (3rd Gen), thereby expanding the range of macOS versions you can install and run (&rarr; check the [**SMBIOS Compatibility Chart**](https://github.com/5T33Z0/Clover-Crate/tree/main/Compatibility_Charts) to find one).

But since this "higher" SMBIOS was designed for a different CPU, it actually does not perform as well with the older CPU, especially on Notebooks. So you have to make a descision: do you want to run the latest version of macOS or do you want to get the most out of your system in terms of compatibility and performance? 

### Workaround (macOS 11.3+ only)
Luckily, there's a workaround which allows booting newer macOS versions with an unsupported SMBIOS/board-id and installing updates which wouldn't be possible otherwise. Since this fix makes uses of virtualization capabilities only present in macOS 11.3 and newer (Kernel 20.4.0+), you can't apply it in macOS Catalina and older.

**Here's how it works**:

- After installing macOS 11.3+ using the required SMBIOS, switch back to SMBIOS best suited for your CPU model
- Add `-no_compat_check` to boot arguments. Otherwise you will be greeted with the "forbidden" sign instead of the Apple logo the next time you are trying to boot. The downside is that this also disables System Updates.
- Add `RestrictEvents.kext` and `revpatch=sbvmm` boot-arg, which force-enables the `VMM-x86_64` board-id. This allows System Updates.

**Now you finally can**:

- Boot macOS with an unsupported SMBIOS/board-id,
- Have proper CPU Power Management since you can use the correct SMBIOS for your CPU and 
- Get System Updates with Clover – which was impossible before!

When I was booting macOS Ventura on my Ivy Bridge Laptop with Clover using SMBIOS `MacBookPro10,1`, `-no_compat_check`, `RestrictEvent.kext` and `revpatch=sbvmm`, I was offered System Updates, which is pretty damn cool.

## Notes
- Check the attached macOS Compatibility Charts to find out which macOS version is compatible with which SMBIOS
