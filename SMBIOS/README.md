# SMBIOS
>**SMBIOS** stands for **System Management BIOS**. It defines data structures (and access methods) that can be used to read management information produced by the BIOS of a computer. This eliminates the need for the operating system to probe hardware directly to discover what devices are present in the computer. The SMBIOS specification is produced by the Distributed Management Task Force (DMTF), a non-profit standards development organization. The DMTF estimates that two billion client and server systems implement SMBIOS.
[**SOURCE**: Wikipedia](https://en.wikipedia.org/wiki/System_Management_BIOS#From_UEFI)

This section is needed to mimic your PC as a Mac. The entered `ProductName` is of special significance here. Not only does it define the range of macOS versions it can run, moreover it sets a lot of system parameters for the hardware used in the chosen model. So picking a model which is close to the specs of your hardware gets you a lot closer to having a well-working Hackintosh. The most important point of reference for picking an appropriate SMBIOS is the CPU you are using.

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

Usually, the `AAPL,slot-name` is generated based on your system's `DSDT` or Device `Properties` in your `config.plist`. For macOS to list and categorize PCIe devices, it requires the `Name (_SUN, 0xXX)` field for a device to be present in a inside the `DSDT`, as shown in this example:

```swift
Device (GIGE)
{
    Name (_ADR, 0x00050000)  // _ADR: Address
    Name (_SUN, 0x02)  // _SUN: Slot User Number
```

But if you use 3rd party PCIe cards, this entry will most likely not be present in your `DSDT`, so the device(s) will not appear in the `PCI` category (unless you use a patched one with added `_SUN` descrptions).

Clover can generate `AAPL-slot,name` entries for certain types of devices, if the `_SUN` method does not exist in your `DSDT`. You must set the patch mask for these devices using any one byte number but `0` and `1` since they are reserved for compiler-related operations, so genereating the `AAPL,slot-name `entries might fail.
 
Four parameters are required to create a custom `AAPL,slot-name` entry in your config:

* **Device**: Select the type of device you want assign a `AAPL,slot-name` to. Supported device types are: `ATI`, `NVidia`, `IntelGFX`, `LAN`, `WIFI`, `Firewire`, `HDMI`, `USB` and `NVME`. For other device types use the `Devices/Properties` section instead.
* **ID**: Must be the same number as defined in the Device's description inside your `DSDT` under `Name (_SUN, 0xXX`), wher XX is a placeholder for a number.
* **Name** - Enter the name for the slot. Sets how the entry will be named in System Profiler 
* **Type** - Select the type/speed of PCIe Slot the Device is connected to from the Dropdown Menu (PCIe to PCIe x16)

**NOTES**

* In order for the `Slots` section to be present in the config.plist, a SMBIOS has to be generated because it's a sub-section of `SMBIOS`.
* As long as I have been using Clover, I've never used this section whatsoever. I always use Device Properties to define a device and call it a day. Especially since Hackintool can create all these device property entries with the correct AAPL,slot-names for you.

## Running macOS on unsupported platforms
Unlike real Macs which are limited to a certain range of supported macOS versions, you can trick macOS into running on CPU models it doesn't support officially – at least, if the used SMBIOS are not too far off from the specs of your hardware. 

For example, you can use an SMBIOS intended for a Haswell CPU (4th Gen) with an Ivy Bridge CPU (3rd Gen), thereby expanding the range of macOS versions you can run. But since this SMBIOS is designed for a different CPU, it actually does not perform as good, especially on Notebooks. 

In the end it's a question of what's more important to you: being able to run the latest version of macOS versus getting the most out of the machine as far as performance is concerned. A workaround to this issue is to use the SMBIOS intended for your CPU but add `-no_compat_check` to the boot arguments. The downside is that you can't install system updates this way, so you need to switch back the SMBIOS to whatever is officially supported by macOS Monterey to get updates and enable `HWTarget` in RtVariables as well (using a Plist Editor since this parameter is not yet available in Clover Configurator).
