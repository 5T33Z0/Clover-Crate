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
![](/Users/steezonics/Desktop/misc/screenshot0.png)

If you highlight a Volume as shown above and press the [SPACE] bar, you will see the following screen:

![](/Users/steezonics/Desktop/misc/screenshot1.png)

The sections framed in cyan shows details about the selected Volume. The green section shows boot options (only available for bootable macOS Volumes).

### Boot options

You can set various boot-args in this menu. A prime use case example for changing boot-args on the fly is enabing `nv_disabke=1` after a macOS update to run my NVIDIA GPU in VESA mode so you have a picture and can update the NVIDIA Webdrivers to the latest versions. Because otherwise the screen won't turn on after a system update.

### Blocking Kexts

If you select "Block injected Kexts" you cam navigate the Kexts folder:

![](/Users/steezonics/Desktop/misc/blockkexts.png)

And enable/disable kexts:

![](/Users/steezonics/Desktop/misc/kexts01.png)

## Clover Boot Options
![](/Users/steezonics/Desktop/misc/screenshot2.png)

Clover Boot Options shows the PCI path of the selected Volume and allows you to add an entry for the selected Volume to the Boot Menu of your BIOS/UEFI. 

![](/Users/steezonics/Desktop/misc/screenshot3.png)

## Options
![](/Users/steezonics/Desktop/misc/screenshot4.png)

The "Options" menu basically lets you control almost every parameter of Clover. **The following Options are accessible:**:

![](/Users/steezonics/Desktop/misc/screenshot5.png)

### Boot-args
Enter the boot-args you want to set

### Configs
If you have more than one config.plist you can switch to a different one here:

![](/Users/steezonics/Desktop/misc/screenshot7.png)

### GUI Tuning
In this sub-menu you can change the behavior of he mouse pointer and switch themes (if you have any installed):

![](/Users/steezonics/Desktop/misc/screenshot9.png)

![](/Users/steezonics/Desktop/misc/screenshot10.png)

### ACPI patching
In this menu, you basically have control over any ACPI-related parameter:

![](/Users/steezonics/Desktop/misc/screenshot11.png)

#### Debug DSDT
Enables a debugging feature for the DSDT.

#### DSDT Name
Here you can enter the name of your patched `DSDT` file if you use one.

#### Tables Dropping
Lets you disable (or drop) ACPI Tables present in your system:

![](/Users/steezonics/Desktop/misc/screenshot12.png)

#### DSDT Fix Mask
Lets you choose DSDT fixes to apply:

![](/Users/steezonics/Desktop/misc/screenshot13.png)

#### Custom DSDT Patches
To do…

### SMBIOS
Displays the currently used SMBIOS data.

### Binaries Patching
This menu gives you access to Clover's Kernel and Kext Patch section:

![](/Users/steezonics/Desktop/misc/screenshot19.png)

### Quirks Mask
Gives you access to the Quirks settings:

![](/Users/steezonics/Desktop/misc/screenshot21.png)

### Graphics Injector
Shows the detected number of Video Cards and allows you to inject EDIDs and Fremabuffers: 

![](/Users/steezonics/Desktop/misc/screenshot23.png)

### PCI Devices
Allows access to PCI devices and Properties

![](/Users/steezonics/Desktop/misc/screenshot25.png)

### CPU Tuning
Lists CPU infos and options:

![](/Users/steezonics/Desktop/misc/screenshot27.png)

### Audio Tuning
List availabke Audio Devices and additional options:

![](/Users/steezonics/Desktop/misc/screenshot29.png)

### Startup Sound Output
Change Boot Chime and Audio Device

### System Parameters
Block kexts, Change CSR Active Config and other settings:

![](/Users/steezonics/Desktop/misc/screenshot32.png)