# Tools Section (work in progress)
The Tools Section of Clover Configurator is pretty straight forward and self###explanatory. But there are a few things you may want to know.

## Included Tools
Some of the tools don't work if you don't install Clover via the .pkg installer. 

### Mount EFI
Lists the availabe Disks, Volumes and EFI partitions it detects and allows you to mount them

### Boot.log
Lets you generate a Boot log if you are using Clover Bootmanager

### Generate Config
This tools is useful if you didn't have a `config.plist` to begin with and used the Bootmenu GUI to configure the system which is totally possible although it is a rather uncommon approach for configuring a Hackintosh. 

A more common scenario would be: you messed up your config and after a reboot can't get back into macOS. And since you don't have a back up of your config to boot from, you have to tinker with the settings from the bootmenu GUI until you get back into macOS. And now you need to make the changes permanent by adding them to the config.plist.

So once your back in macOS, open Clover Configurator and run this tool to create a config.plist. This way you get a nearly complete configuration file with the parameters used to successfully load the OS. Some more manual work is needed to finish it.

:waring: Requires `clover-genconfig` to be present in `usr/local/bin`. Therefor you need to install Clover via the .pkg Installer

### Themes Editor
Gives you access to the `themes.plist` included in every theme and lets you change its parameters.

### Install/Update Clover
### Install Drivers
### NVRAM
### HEX Converter
### Text Mode
### Kext Installer
### Clover Cloner
### Clover Validator

## :warning: Caution
If you plan to use both, OpenCore and Clover in parallel, don't install Clover via the .pkg Installer. Build, update and maintain your Clover EFI folder manually as explained in my EFI Update guide! 
