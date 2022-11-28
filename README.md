#CLOVER CRATE
[![Clover Version](https://img.shields.io/badge/Clover-r5150-lime.svg)](https://github.com/CloverHackyColor/CloverBootloader/releases) [![Clover Configurator](https://img.shields.io/badge/Clover_Configurator-5.23.01-brightgreen.svg)](https://mackie100projects.altervista.org/download-clover-configurator/) [![macOS](https://img.shields.io/badge/Supported_macOS-≤13.1_beta-white.svg)](https://www.apple.com/macos/monterey/) ![Last Update](https://img.shields.io/badge/Last_Update_(yy.mm.dd):-22.11.28-blueviolet.svg) ![00Main](https://user-images.githubusercontent.com/76865553/136703368-146cda4c-9a8b-4b5f-8d3e-0382f1ccd68f.jpg)

|:warning: CAUTION|
|:-----------------------------------------------------------|
|**AMD Users**: Clover Configurator 5.23.0 fixed "Skip" and "Count" keys being deleted from config.plist!

## ABOUT
**Clover Crate** is an unofficial documentation of the popular Clover Boot Manager and its features to help you to figure out what each option does since the whole Clover project is a mess in regards to documentation (especially in English). Its structure closely follows the hierarchy of the `config.plist` and the corresponding sections in Clover Configurator.

Every setting/parameter (besides obvious ones) is explained. Special attention to detail was given to the ACPI section, as it is one of the most important interfaces for configuring a Hackintosh. In each section/chapter, you can click on the list menu on the top left to select a feature you are interested in to jump to the corresponding entry, so you don't have to scroll all the way through a document. I am talking about this one:

![TOC](https://user-images.githubusercontent.com/76865553/136510478-2bccd5ae-6cc6-4a98-8f8d-63c41de2d3b3.png)

I created this repo for the following reasons:

1. **Overcoming language barriers**: Clover's official documentation (PDF, 171 pages) is only available in Russian.
2. **Condensing information** and presenting it in a modern way, making use of GitHub and Markdown. It's also much more focused on documentaing the actual features since it disregards all the personal anecdotal notes that the official documentation contains.
3. **Consolidating and unifying resources** which are scattered all over the internet: the manual is only available in Russian on GitHub, the changelog is only available at insanelymac and the Clover Wiki had been neglected for years until it finally got integrated into Clover's GitHub Repo in 2022 (after I started Clover Crate).
4. **Exemplifying Clover's features** using Clover Configurator: Acidanthera and Dortania did such an amazing job on documenting OpenCore that I though it was about time Clvoer gets something that at least documents its features and how to use them *properly*.

### Disclaimer
The information provided in this repository is based on excerpts of the official Russian documentation for Clover using AI-based translation tools (deepl, google and yandex translate) as well as my own extensive research. The translations were reviewed and redacted afterwards, so that they follow the rules of English grammar and spelling while preserving their meanings. Nevertheless, some details may have been lost in translation (although I doubt it).

The methods and techniques presented in this repo are based on utilizing the official Clover release and its features alongside Kexts, SSDTs, Device Properties and other tools to enable/disable devices and features in macOS to get a *proper* working system which is ACPI conform!

**Clover-Crate** does not consider patching the `DSDT` an *appropriate* measure to get the "Real Vanilla Hackintosh" experience and therefore does not support nor promote patching the `DSDT`. In fact, it's quite the opposite, as explained [**here**](https://www.insanelymac.com/forum/topic/352881-when-is-rebaseregions-necessary/?do=findComment&comment=2790870):

> MaLd0n's implications that you need a custom DSDT to add and remove (well, remove yes, but disabling is good enough in virtually all cases) devices is **incorrect**. Aside from those claims, most device rename changes (probably also things you considered „missing“) are also not needed, as they are performed by Lilu and its plug-ins. This approach is a lot safer than previous ACPI renames as dumb find-replace patches can yield false positives, the kext approach cannot.

## TABLE of CONTENTS
- **CLOVER CONFIGURATION**
  - [**ACPI**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#readme)
  - [**Boot**](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot#readme)
  - [**Boot Graphics**](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot_Graphics#readme)
  - [**CPU**](https://github.com/5T33Z0/Clover-Crate/tree/main/CPU#readme)
  - [**Devices**](https://github.com/5T33Z0/Clover-Crate/blob/main/Devices#readme)
  - [**Graphics**](https://github.com/5T33Z0/Clover-Crate/tree/main/Graphics#readme)
  - [**GUI**](https://github.com/5T33Z0/Clover-Crate/tree/main/GUI#readme)
  - [**Boot Menu Options**](https://github.com/5T33Z0/Clover-Crate/blob/main/GUI/Boot_Menu_Options.md) 
  - [**Kernel and Kext Patches**](https://github.com/5T33Z0/Clover-Crate/tree/main/Kernel_And_Kext_Patches#readme)
  - [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks#readme)
  - [**RtVariables**](https://github.com/5T33Z0/Clover-Crate/tree/main/RtVariables#readme)
  - [**SMBIOS**](https://github.com/5T33Z0/Clover-Crate/tree/main/SMBIOS#readme)
  - [**System Parameters**](https://github.com/5T33Z0/Clover-Crate/tree/main/System_Parameters#readme)
  - [**Tools Section**](https://github.com/5T33Z0/Clover-Crate/blob/main/Tools/README.md)
- **APPENDIX**
  - [**Clover's problematic config-sample.plist**](https://github.com/5T33Z0/Clover-Crate/tree/main/About_Config-Sample) 
  - [**Upgrading to Clover with OpenRuntime integration**](https://github.com/5T33Z0/Clover-Crate/tree/main/Upgrading_Clover#readme)
  - [**Preconfigured EFIs and Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/EFIs_and_Configs)
  - [**Kext Management in Clover**](https://github.com/5T33Z0/Clover-Crate/tree/main/Kext_Management#readme)
  - [**Mapping USB Ports**](https://github.com/5T33Z0/Clover-Crate/tree/main/USB_Fixes#readme)
  - [**Converting OpenCore Properties to Clover**](https://github.com/5T33Z0/Clover-Crate/tree/main/OC2Clover#readme)
  - [**Clover Calculators**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras)
  - [**Compatibility Charts**](https://github.com/5T33Z0/Clover-Crate/tree/main/Compatibility_Charts)
  - [**Utilities and Resources**](https://github.com/5T33Z0/Clover-Crate/tree/main/Utilities#readme)

## CONTRIBUTIONS
If you would like to contribute to the information provided in this repo in order to improve/expand it, feel free to create an issue with a meaningful title, link to the chapter/section and describe what you like to add, change, correct or expand upon.

## CREDITS
- SergeySlice for [**Clover Boot Manager**](https://github.com/CloverHackyColor/CloverBootloader)
- Acidanthera for [**OpenCore**](https://github.com/acidanthera/OpenCorePkg)
- CoorpNewt for [**Clover Desktop Guide**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
- Dortania for the excellent Documentation on [**Fixing Post-Install issues**](https://dortania.github.io/OpenCore-Post-Install/) in particular
- RehabMan for [**Clover Laptop Configs**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)
- Macki100Projects for [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/)
- daliansky for [**P-Little Repo**](https://github.com/daliansky/P-little)
- ic005k for [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus)
- uranusjr for [**MacDown**](https://macdown.uranusjr.com/)
