# SMBIOS
>**SMBIOS** stands for **System Management BIOS**. It defines data structures (and access methods) that can be used to read management information produced by the BIOS of a computer. This eliminates the need for the operating system to probe hardware directly to discover what devices are present in the computer. The SMBIOS specification is produced by the Distributed Management Task Force (DMTF), a non-profit standards development organization. The DMTF estimates that two billion client and server systems implement SMBIOS. 
[**SOURCE**: Wikipedia](https://en.wikipedia.org/wiki/System_Management_BIOS#From_UEFI)

This section is needed to mimic your PC as a Mac. The entered `ProductName` is of special significance here. Not only does it define the range of macOS versions it can run, moreover it sets a lot of system parameters for the hardware used in the chosen model. So picking a model which is close to the specs of your hardware gets you a lot closer to having a well-working Hackintosh. And the the most important point of reference for picking an appropriate SMBIOS is the CPU you are using.

I won't be covering each individual field of the SMBIOS section here, since it is tedious and completely unnecessary, as you will find out soon. Instead I will focus only on the importants ones: `ProductName`, `SerialNumber`, `Board-ID` and `SmUUID`.

## Example: Generating SMBIOS data with Clover Configurator

If you find an EFI folder for your System on a Forum or on Github this section might look like this:

![](/Users/kl45u5/Desktop/SMBIOS_empty.png)

As you can see, the `ProductName` is set to `MacBookPro11,4` (which is the minimum System Requirement for running macOS Monterey on a Laptop, btw). Now, do the following to generate your own SMBIOS Section:

1. Click on this little symbol next to the "Update Firmware only" checkbox. This one: 
	
	![](/Users/kl45u5/Desktop/Dropdown.png)
2. Next you will be confronted with a huuuge list of Mac models to choose from: 
	
	![](/Users/kl45u5/Desktop/models.png)
3. Select a Mac model based on the family of Intel CPU you are using. In this example, the actual MacBookPro model uses an Intel i7 `4770HQ`. In Intel's nomenclature, the first digit of the CPU model name describes the generation (or family) it belongs to. In this case it's a `4` for 4th Gen Intel "i" CPU (first gen models only use 3 digits). So pick a Mac Model which is close to yours in terms of CPU (dektop/mobile, generation, max clock speed).
4. After you've picked a model, Clover Configurator will automatically generate a valid SMBIOS for you:

	![](/Users/kl45u5/Desktop/Generated.png)
	
	**IMPORTANT**: Fields highlighted in cyan *should always be deleted before sharing your `config.plist`*. Also, if you get an error message about outdated firmware during macOS installation, click on "Update Firmware only" and then select the same Mac Model from the dropdown menu again. This keeps your Serial, etc. and will only update the firmware informmation, so you can install macOS successfully.
5. Once you have generated your `SMBIOS`, head over to the `RTVariables` section. 
6. Copy the number for `MLB` (=Board Serial Number) shown in the "Info" windows to the `MLB` field and select "UseMacAddr0" from the dropdown menu. This is a must for enabling FaceTime.
