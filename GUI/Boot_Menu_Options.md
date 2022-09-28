# Clover Boot Menu Options
This sections is about the options available from Clover's Bootmenu – and there are a lot. It is unparalleled in terms of functionality. It offers almost as much control over settings as you have when editing the config.plist itself. Settings can be changed on the fly to resolve boot issues or for testing purposes without messing up your config.plist.

:warning: Most of the settings you can change from Clover's Bootmenu are *temporary* – they are only applied one time during the next boot process. So if your system wasn't booting before but it does now after changing settings from the GUI, you have to set and save them in the config.plist afterwards.

<details><summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

- [Navigating the Boot Menu](#navigating-the-boot-menu)
- [Function Keys](#function-keys)
- [Available options for the selected Volume](#available-options-for-the-selected-volume)
  - [Volume Info](#volume-info)
  - [Boot options](#boot-options)
  - [Blocking Kexts](#blocking-kexts)
- [Clover Boot Options](#clover-boot-options)
- [Options](#options)
  - [Boot-args](#boot-args)
  - [Configs](#configs)
  - [GUI Tuning](#gui-tuning)
  - [ACPI patching](#acpi-patching)
    - [Debug DSDT](#debug-dsdt)
    - [DSDT Name](#dsdt-name)
    - [Tables Dropping](#tables-dropping)
    - [DSDT Fix Mask](#dsdt-fix-mask)
    - [Custom DSDT Patches](#custom-dsdt-patches)
  - [SMBIOS](#smbios)
  - [Binaries Patching](#binaries-patching)
  - [Quirks Mask](#quirks-mask)
  - [Graphics Injector](#graphics-injector)
  - [PCI Devices](#pci-devices)
  - [CPU Tuning](#cpu-tuning)
  - [Audio Tuning](#audio-tuning)
  - [Startup Sound Output](#startup-sound-output)
  - [System Parameters](#system-parameters)
- [A word on using `F5` for patching the `DSDT`](#a-word-on-using-f5-for-patching-the-dsdt)

</details>

## Navigating the Boot Menu

- Use Arrow Keys or Mouse Cursor to navigate
- Press [SPACEBAR] to select options
- Press [ENTER] or Mouse Click to enter a menu
- Press [ESCAPE] to return to the previous menu
- Page UP/DOWN to change GUI resolution

## Function Keys
- **F1**: Help Menu (multilingual)
- **F2**: Save preboot.log
- **F3**: Show hidden Bootmenu Entries
- **F4**: Save (OEM) ACPI tables in `/EFI/CLOVER/ACPI/origin`
- **F5**: Applies selected DSDT Fixes and Patches to your OEM `DSDT` and stores it as a new file under `/EFI/Clover/ACPI/origin`
- **F6**: Saves VBIOS in `/EFI/CLOVER/misc`
- **F7**: Test Audio Device
- **F8**: Dump Audio Codec
- **F9**: Switch Screen Resolution
- **F10**: Take Screenshot
- **F11**: Reset NVRAM
- **F12**: Eject optical media

## Available options for the selected Volume

### Volume Info
![screenshot0](https://user-images.githubusercontent.com/76865553/181207018-4603c879-1fb9-462a-a158-30ac468a870d.png)


If you highlight a Volume as shown above and press the [SPACE] bar, you will see the following screen:

![screenshot1](https://user-images.githubusercontent.com/76865553/181207085-175752e4-a6a1-4d1b-8aaf-a377191c560f.png)

The sections framed in cyan shows details about the selected Volume. The green section shows boot options (only available for bootable macOS Volumes).

### Boot options

You can set various boot-args in this menu. A prime use case example for changing boot-args on the fly is enabling `nv_disabke=1` after a macOS update to run my NVIDIA GPU in VESA mode so you have a picture and can update the NVIDIA Webdrivers to the latest versions. Because otherwise the screen won't turn on after a system update.

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
Enables debugging of the DSDT. This logs what happens to `DSDT` while it is being patched. Useful if the system doesn't bot.

First, the original version is stored as `DSDT-or.aml` in the ACPI/origin folder. Then the DSDT patches will be applied and the patched DSDT is stored as `DSDT-pa0.aml` in the ACPI/origin folder as well. If the file already exists from the previous attempt, then a new one will be created: `DSDT-pa1.aml`, `DSDT-pa2.aml`, etc. Don't forget to clean the once you're done with debugging.

#### DSDT Name
Here you can enter the name of your patched `DSDT` file if you use one.

#### Tables Dropping
Lets you disable (or drop) ACPI Tables present in your system:

![screenshot12](https://user-images.githubusercontent.com/76865553/181207695-0487e2af-d987-467b-a095-270678814de1.png)

#### DSDT Fix Mask
Lets you choose DSDT fixes to apply:

![screenshot13](https://user-images.githubusercontent.com/76865553/181207751-a581fd58-3ceb-4af8-9a85-890c572f3bfb.png)

#### Custom DSDT Patches
Access all your custom DSDT fixes (like binary renames) to enable/disable them. The name displayed is based on the "Comment" you've entered in the config.plist for each entry.

![CSTMDSDT](https://user-images.githubusercontent.com/76865553/181235211-813bc1e1-6a1b-4e7c-8538-cc17ff7be92c.png)

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
Run some tests (`AudioDXE.efi` has to be present in the Drivers folder) and set the volume of the Boot chime. It goes from 0 to 100 %.

![Output](https://user-images.githubusercontent.com/76865553/181235659-7b9c6790-d8de-40f2-88c0-e2933d41af02.png)

### System Parameters
Block kexts, Change CSR Active Config and other settings:

![screenshot32](https://user-images.githubusercontent.com/76865553/181208057-9ef87261-603a-4bc3-85d7-909549bcb019.png)

**Reset SMC** was introduced in r5148 and works similar to how SMC Reset works on real Macs. Reset SMC requires `FakeSMC.kext` to work – it's not supported by VirtualSMC. Read the [**Clover Changes**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?do=findComment&comment=2789856) for more details.

In my personal tests, boot times were *significantly* slower when using FakeSMC, so I will continue using VirtualSMC. Since ECEnabler.kext doesn't work with Fake SMC's VoodooBatterySMC plugin, VirtualSMC is the better choice for hacking Laptops as well, imo.

## A word on using `F5` for patching the `DSDT`
Although one might be tempted to think "Dude, it can patch the `DSDT` for ya!", this is not the case. Clover cannot magically patch the `DSDT` by pressing a single button. This function does something else. 

**Q**: "So what does this feature do then?"</br>
**A**: "It integrates *existing* DSDT Patches and Fixes present in your config.plist in the ACPI section into your OEM DSDT and saves it as a new file."

I am talking about these Patches and Fixes:</br>![ACPI](https://user-images.githubusercontent.com/76865553/182084087-498b5157-2b10-4602-8c89-fdc4f626cbb7.png)

If you press `F5` in the Bootmenu, the ACPI Patches and Fixes will be merged into the DSDT and a new, patched DSDT will be stored in the `/EFI/Clover/ACPI/origin` folder with some digits attached to its name:</br>![patched_dsdt](https://user-images.githubusercontent.com/76865553/182084137-5664c230-0ecc-4cd0-9dd9-c73e6a0b48ad.png)

**Q**: "What am I supposed to do with this?"</br>
**A**: "Well, you can move it to `/EFI/Clover/ACPI/patched` and then you no longer need the Patches and Fixes in your config but use this partially patched `DSDT` instead:</br>

![NopatchesNofixes](https://user-images.githubusercontent.com/76865553/182084194-1cf28c13-856e-4bb8-a4ab-3ce932efba55.png)

:warning: You will still need the SSDTs present in the `ACPI/patched` folder to boot your system, since this DSDT is only *partially* patched. You could however use this partially patched `DSDT` and apply more patches to it using maciASL until you have a *fully patched* DSDT so that you no longer need the SSDTs.

But despite to some claims, all of this DSDT patching business is completely irrelevant and unnecessary nowadays since patching the DSDT and applying SSDTs on the fly during boot is much faster than replacing the whole OEM DSDT with a patched one – we are talking of replacing a few hundred lines of code (applying patches, fixes and SSDTs) vs. about 20.000 lines (patched DSDT). So my advice would be: don't bother doing it.
