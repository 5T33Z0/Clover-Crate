# CLOVER CRATE
[![Clover Version](https://img.shields.io/badge/Clover-r5146-lime.svg)](https://github.com/CloverHackyColor/CloverBootloader/releases)
[![Clover Configurator](https://img.shields.io/badge/Clover_Configurator-5.22.0-brightgreen.svg)](https://mackie100projects.altervista.org/download-clover-configurator/)
[![macOS](https://img.shields.io/badge/Supported_macOS-≤12.4-white.svg)](https://www.apple.com/macos/monterey/)
![Last Update](https://img.shields.io/badge/Last_Update_(yy.mm.dd):-22.05.02-blueviolet.svg)</br>
![00Main](https://user-images.githubusercontent.com/76865553/136703368-146cda4c-9a8b-4b5f-8d3e-0382f1ccd68f.jpg)

## ABOUT
Clover Crate is an unofficial documentation of the popular Clover Boot Manager and its features to help you to figure out what each option does. Its structure closely follows the hierarchy of the `config.plist` and the corresponding sections in Clover Configurator.

Almost any available setting/parameter (besides obvious ones) is explained. Special attention to detail was given to the ACPI section, as this is one of the most important interfaces for configuring a Hackintosh. In each section/chapter, you can click on the list menu on the top left to select a feature you are interested in to jump to the corresponding entry, so you don't have to scroll all the way through a document. I am talking about this one:

![TOC](https://user-images.githubusercontent.com/76865553/136510478-2bccd5ae-6cc6-4a98-8f8d-63c41de2d3b3.png)

I created this repo for several reasons:

1. **Overcoming** language barriers: Clover's official documentation (PDF, 171 pages) is only available in Russian.
2. **Condensing** available information in one place, presenting it in a more current fashion, using Markdown and GitHub.
3. **Consolidating and Unifying** sources which are scattered all over the net: the manual is only available in Russian on GitHub, the changelog is only available at insanelymac and only updated sporadically. The Clover Wiki at Source Forge hasn't been updated in years.
4. **Exemplifying** Clover's features using Clover Configurator.

<details>
<summary><strong>DISCLAIMER</strong></summary>

| :warning: | THIS is NOT a Hackintosh Guide! |
|-----------|:--------------------------------|

  The information provided in this repository is primarily based on excerpts of the official Russian documentation for Clover using AI-based translation tools (deepl, google and yandex translate). The translations were reviewed and redacted afterwards, so that they follow the rules of English grammar and spelling while preserving their meaning. Nevertheless, some facts may have been lost during the process of translation.
</details>

## TABLE of CONTENTS
- **Clover Configuration**
  - [**ACPI**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI)
  - [**Boot**](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot)
  - [**Boot Graphics**](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot_Graphics)
  - [**CPU**](https://github.com/5T33Z0/Clover-Crate/tree/main/CPU)
  - [**Devices**](https://github.com/5T33Z0/Clover-Crate/blob/main/Devices)
  - [**Graphics**](https://github.com/5T33Z0/Clover-Crate/tree/main/Graphics)
  - [**GUI**](https://github.com/5T33Z0/Clover-Crate/tree/main/GUI)
  - [**Kernel and Kext Patches**](https://github.com/5T33Z0/Clover-Crate/tree/main/Kernel_And_Kext_Patches)
  - [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)
  - [**RtVariables**](https://github.com/5T33Z0/Clover-Crate/tree/main/RtVariables)
  - [**SMBIOS**](https://github.com/5T33Z0/Clover-Crate/tree/main/SMBIOS)
  - [**System Parameters**](https://github.com/5T33Z0/Clover-Crate/tree/main/System_Parameters)
- **Appendix**
  - [**Upgrading to Clover with OpenRuntime integration**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover)
  - [**Kext Management in Clover**](https://github.com/5T33Z0/Clover-Crate/blob/main/Kext_Management/README.md)
  - [**Mapping USB Ports**](https://github.com/5T33Z0/Clover-Crate/tree/main/USB_Fixes)
  - [**Clover Laptop Configs and Hotpatches 2.0**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs)
  - [**Clover Dektop Configs**](https://github.com/5T33Z0/Clover-Crate/tree/main/Desktop_Configs)
  - [**Converting OpenCore Properties to Clover**](https://github.com/5T33Z0/Clover-Crate/tree/main/OC2Clover)
  - [**Clover Calculators**](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras)
  - [**Compatibility Charts**](https://github.com/5T33Z0/Clover-Crate/tree/main/Compatibility_Charts)
  - [**Utilities and Resources**](https://github.com/5T33Z0/Clover-Crate/tree/main/Utilities)

## CONTRIBUTIONS
If you would like to contribute to the information provided in this repo in order to improve/expand it, feel free to create an issue with a meaningful title, link to the chapter/section and describe what you like to add, change, correct or expand upon.

## CREDITS
- SergeySlice for [**Clover Boot Manager**](https://github.com/CloverHackyColor/CloverBootloader)
- Acidanthera for [**OpenCore**](https://github.com/acidanthera/OpenCorePkg)
- Khronokernel for [**Clover Desktop Guide**](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/)
- Dortania for the excellent Documentation on [**Fixing Post-Install issues**](https://dortania.github.io/OpenCore-Post-Install/) in particular
- RehabMan for [**Clover Laptop Configs**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config)
- Macki100Projects for [**Clover Configurator**](https://mackie100projects.altervista.org/download-clover-configurator/)
- daliansky for [**P-Little Repo**](https://github.com/daliansky/P-little)
- ic005k for [**PlistEDPlus**](https://github.com/ic005k/PlistEDPlus)
- uranusjr for [**MacDown**](https://macdown.uranusjr.com/)
