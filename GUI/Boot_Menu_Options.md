# Clover Boot Menu Options
This sections is all about the options Clover provides from the Boot Menu – and it's a lot of options. You have almost as much control over Clover from the Boot Menu as you would have when editing the config.plist directly which is really helpful to change settings on the fly temporarly if you have any issues and want to try things. 

:warning: Most of the settings you can change in Clover's Boot Menu are *temporary* only.

## Navigating the Boot Menu

- Use Arrow Keys or Mouse Cursor to navigate
- Press [SPACEBAR] to select options
- Press [ENTER] or Mouse Click to enter a menu
- Press [ESCAPE] to return to the previous menu
- Page UP/DOWN to change GUI resolution

## Function Keys
- **F1**: Help Menu (multilingual)
- **F2**: Save preboot.log
- **F4**: Save (OEM) ACPI tables in `/EFI/CLOVER/ACPI/origin`
- **F5**: To test DSDT patching
- **F6**: Saves VBIOS in `/EFI/CLOVER/misc`
- **F10**:  Take Screenshot
- **F11**: Reset NVRAM
- **F12**: Eject optical media

## Available options for the selected Volume

### Volume Info
![screenshot0](https://user-images.githubusercontent.com/76865553/181207018-4603c879-1fb9-462a-a158-30ac468a870d.png)


If you highlight a Volume as shown above and press the [SPACE] bar, you will see the following screen:

![screenshot1](https://user-images.githubusercontent.com/76865553/181207085-175752e4-a6a1-4d1b-8aaf-a377191c560f.png)


The sections framed in cyan shows details about the selected Volume. The green section shows boot options (only available for bootable macOS Volumes).

### Boot options

You can set various boot-args in this menu. A prime use case example for changing boot-args on the fly is enabing `nv_disabke=1` after a macOS update to run my NVIDIA GPU in VESA mode so you have a picture and can update the NVIDIA Webdrivers to the latest versions. Because otherwise the screen won't turn on after a system update.

### Blocking Kexts

If you select "Block injected Kexts" you cam navigate the Kexts folder:

![blockkexts](https://user-images.githubusercontent.com/76865553/181207132-57afcacd-4c1d-4651-8d25-257274cd1662.png)

And enable/disable kexts:

![kexts01](https://user-images.githubusercontent.com/76865553/181207219-30c374e1-40c5-48c4-8d58-f8b89a016227.png)

## Clover Boot Options
![screenshot2](https://user-images.githubusercontent.com/76865553/181207309-e6ef598f-626f-4cd3-9d0c-6475e55674e6.png)

Clover Boot Options shows the PCI path of the selected Volume and allows you to add an entry for the selected Volume to the Boot Menu of your BIOS/UEFI. 

![screenshot3](https://user-images.githubusercontent.com/76865553/181207372-8dd33de4-9932-4ad4-9558-5c2819b7c102.png)

## Options
![screenshot4](https://user-images.githubusercontent.com/76865553/181207448-a66ebd54-41a0-4a31-95a6-d22a6f858f74.png)

The "Options" menu basically lets you control almost every parameter of Clover. **The following Options are accessible:**:

![screenshot5](https://user-images.githubusercontent.com/76865553/181207496-065e086b-ea79-4b2b-ab6d-7f9d53e41f9c.png)

### Boot-args
Enter the boot-args you want to set

### Configs
If you have more than one config.plist you can switch to a different one here:

![screenshot7](https://user-images.githubusercontent.com/76865553/181207526-4428fb34-723d-470c-a3ab-130df093cbf8.png)

### GUI Tuning
In this sub-menu you can change the behavior of he mouse pointer and switch themes (if you have any installed):

![screenshot9](https://user-images.githubusercontent.com/76865553/181207569-6d0a5814-7f66-482d-8146-dc4f8a6be3b0.png)

![screenshot10](https://user-images.githubusercontent.com/76865553/181207612-49d7178a-f7eb-4eff-9ae7-ed17946f1801.png)

### ACPI patching
In this menu, you basically have control over any ACPI-related parameter:

![screenshot11](https://user-images.githubusercontent.com/76865553/181207662-520ee3d9-fb7a-4299-ac62-a4c5fccc9f29.png)

#### Debug DSDT
Enables a debugging feature for the DSDT.

#### DSDT Name
Here you can enter the name of your patched `DSDT` file if you use one.

#### Tables Dropping
Lets you disable (or drop) ACPI Tables present in your system:

![screenshot12](https://user-images.githubusercontent.com/76865553/181207695-0487e2af-d987-467b-a095-270678814de1.png)

#### DSDT Fix Mask
Lets you choose DSDT fixes to apply:

![screenshot13](https://user-images.githubusercontent.com/76865553/181207751-a581fd58-3ceb-4af8-9a85-890c572f3bfb.png)

#### Custom DSDT Patches
To do…

### SMBIOS
Displays the currently used SMBIOS data.

### Binaries Patching
This menu gives you access to Clover's Kernel and Kext Patch section:

![screenshot19](https://user-images.githubusercontent.com/76865553/181207798-b3172b4e-cec7-42a5-b7a9-781e0d78e8f5.png)

### Quirks Mask
Gives you access to the Quirks settings:

![screenshot21](https://user-images.githubusercontent.com/76865553/181207856-72be85a4-6497-4cdd-9046-c26ae9230593.png)

### Graphics Injector
Shows the detected number of Video Cards and allows you to inject EDIDs and Fremabuffers: 

![screenshot23](https://user-images.githubusercontent.com/76865553/181207916-4afcba8a-4658-498c-ad89-12c830b1a42b.png)

### PCI Devices
Allows access to PCI devices and Properties

![screenshot25](https://user-images.githubusercontent.com/76865553/181207958-86550c16-3102-4b84-849b-b649a0a44bd7.png)

### CPU Tuning
Lists CPU infos and options:

![screenshot27](https://user-images.githubusercontent.com/76865553/181207984-58a13036-07a2-4413-9e1c-e1abb8f812a0.png)

### Audio Tuning
List availabke Audio Devices and additional options:

![screenshot29](https://user-images.githubusercontent.com/76865553/181208017-ad9706ef-7d80-44ae-8ca7-c22715445cd4.png)

### Startup Sound Output
Change Boot Chime and Audio Device

### System Parameters
Block kexts, Change CSR Active Config and other settings:

![screenshot32](https://user-images.githubusercontent.com/76865553/181208057-9ef87261-603a-4bc3-85d7-909549bcb019.png)

