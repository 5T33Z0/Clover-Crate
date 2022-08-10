# Tools Section
The Tools Section of Clover Configurator is pretty straight forward and self-explanatory. But there are a few additional things you may want to know. Some of the tools don't work if you don't install Clover via the .pkg installer. 

## Mount EFI
Lists the available Disks, Volumes and EFI partitions it detects and allows you to mount them.

## Boot.log
Lets you generate a Boot log if you are using Clover Bootmanager.

## Generate Config
This tools is useful if you didn't have a `config.plist` to begin with and used the Bootmenu GUI to configure the system which is totally possible although it is a rather uncommon approach for configuring a Hackintosh. 

A more common scenario would be: you messed up your config and after a reboot can't get back into macOS. And since you don't have a back up of your config to boot from, you have to tinker with the settings from the bootmenu GUI until you get back into macOS. And now you need to make the changes permanent by adding them to the config.plist.

So once your back in macOS, open Clover Configurator and run this tool to create a config.plist. This way you get a nearly complete configuration file with the parameters used to successfully load the OS. Some more manual work is needed to finish it.

:waring: Requires `clover-genconfig` to be present in `usr/local/bin`. Therefore you need to install Clover via the .pkg Installer. Copying it there manually doesn't cut it.

## Themes Editor
Gives you access to the `themes.plist` that comes with every theme and lets you edit it.

## Install/Update Clover
Does what it says. You can either use it to download the lates .pkg Installer or the latest `CLOVERX64.efi` file.

## Install Drivers
Lets you download and instal additional drivers in `EFI/Clover/drivers`.

## NVRAM
Gives you access to some NVRAM parameters like setting a theme

## HEX Converter
Useful for creating ACPI and Kernel patches. Supported conversions: 

- Base64 <-> Hex
- Text <-> Hex
- Decimal <-> Hex

## Text Mode
Let's you edit the config in text mode. Useful if someone posts sections of a config or patches as raw text. Then you can paste it into the text mode window and sync the config. But be careful when using this mode: if you paste text at the wrong location or the file structure/hierarchy is incorrect you might mess up the config.

## Kext Installer
Lets you install and more importantly: update kexts. Just make sure, you select the correct folder, i.e. "OS Version" from the drop down menu. And since the primary folder for kexts is the "Other" folder, you should select this. 

Unfortunately Clover Configurator supports has a rather limited list of available kexts and you cannot add any repos to it, unlike OCAT.

## Clover Cloner
Allows you to clone your EFI folder to another EFI partition. A really unneccessary feature, but well, it's there if you need it.

:warning: Doesn't work for legacy boot, only UEFI!

## Clover Validator
:waring: Requires `CloverConfigPlistValidator` to be present in `usr/local/bin`. You need to install Clover via the .pkg Installer. Simply copying it there manually doesn't cut it.

Therefore, you have to download the validator from the [Clover github repo](https://github.com/CloverHackyColor/CloverBootloader/releases) unpack it and verify the config manually:

1. Open Terminal
2. Drag CloverConfigPlistValidator into the Terminal window, leave a space
3. Drag in your `config.plist` 
4. Hit Enter to validate it:</br>![CCVLDTE2](https://user-images.githubusercontent.com/76865553/184026365-0c0750a7-9a9e-4e81-aaa5-54bbbc13d8eb.png)
5. Fix any config errors the tool might report
6. Validate it again until you get this message:</br>![CCVLDTE](https://user-images.githubusercontent.com/76865553/184026420-54bf7b1e-c8df-4a3d-95dc-0ed78a505e03.png)

## :warning: Caution
If you plan to use both, OpenCore and Clover in parallel, don't install Clover via the .pkg Installer. Build, update and maintain your Clover EFI folder manually as explained in my EFI Update guide! 
