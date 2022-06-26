# Kernel and Kext Patches
![KernelQuirks](https://user-images.githubusercontent.com/76865553/136670474-678b7ae1-b5ec-4791-963a-7af091a833ca.png)

A group of parameters for creating binary patches on the fly. Note that this can only be done if the kernel cache or the `ForceKextsToLoad` parameter is loaded. If the kext is not loaded and is not in cache, these patches don't work. This section consists of 2 categories: one with Kernel Patches which you can click to enable. These are primarily for making your CPU work with macOS. The second category is for creating your own patches which can be applied to kexts and kernels themselves. 

<details><summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

- [ATI Section](#ati-section)
  - [ATIConnectorsController](#aticonnectorscontroller)
  - [ATIConnectorsData](#aticonnectorsdata)
  - [ATIConnectorsPatch](#aticonnectorspatch)
- [FakeCPUID](#fakecpuid)
- [Kernel Patches](#kernel-patches)
  - [AppleIntelCPUPM](#appleintelcpupm)
  - [AppleRTC](#applertc)
  - [Debug](#debug)
  - [DellSMBIOSPatch](#dellsmbiospatch)
  - [EightApple](#eightapple)
  - [KernelLapic](#kernellapic)
  - [KernelPm](#kernelpm)
  - [KernelXCPM](#kernelxcpm)
- [About Patching Masks](#about-patching-masks)
  - [KextsToPatch](#kextstopatch)
  - [KernelToPatch](#kerneltopatch)
  - [BootPatches](#bootpatches)
</details>


## ATI Section
This section applies to macOS 10.7 and newer using ATI/AMD Graphics Cards. There are 3 fields where data has to be entered to get the card and its connectors fully working in macOS:

- `ATIConnectorsController`: here you enter the identifier of the card. In this example, we use an AMD Radeon 6000.
- `ATIConnectorsData` and `ATIConnectorsPatch` require data which has to be calculated to provide macOS with info about the output(s) and connector(s) of the GPU.

To find out how these values are calculated, you can read this [**thread**](https://www.insanelymac.com/forum/topic/249642-editing-custom-personalities-for-ati-radeon-hd45xx/) by bcc9 (english). For current Radeon, RX, Vega and other cards, you can follow this [**guide**](http://www.applelife.ru/threads/Завод-ati-hd-6xxx-5xxx-4xxx.28890/) by Xmedik (russian).

### ATIConnectorsController
To fully run ATI/AMD Radeon 5000 and 6000 series cards, injecting device properties is not enough, you must also adjust the connectors in the corresponding controller.
In this example we patch the controller of an AMD Radeon 6000, so we enter `6000`. Next, values for `ATIConnectorsData` and `ATIConnectorsPatch` must be provided.

### ATIConnectorsData
The Connectors Data has to be provided as `<string>`. In this example for a 6000-series card the value is: `00040000040300000001000021030204040000001402000000010000000004031000000010000000
0001000000000001`

### ATIConnectorsPatch
The Connectors Patch data has to be provided as `<string>`. In this example for a 6000-series card the value is: 
`04000000140200000001000000000404000400000403000000010000110201050000000000000000
0000000000000000`

**NOTE**: In macOS 10.12, the connectors used in this example will be different, so the data used in this example is not representative, although the method for calculating the correct values for `ATIConnectorsData` and `ATIConnectorsPatch` remains the same. 

## FakeCPUID
Assigns a different Device-ID to the used CPU. Useful when trying to run older versions of macOS with a newer CPU which isn't supported. For example, if you are trying to run macOS High Sierra or Mojave with a Comet Lake CPU which is not supported prior to macOS 10.15, you can use a Fake CPU-ID of the Coffee Lake CPU family, to make macOS accept it.

Unfortunately, the list of fake CPU-IDs in Clover Configurator is outdated and ends at Kaby Lake. Below you'll find additional IDs for Coffee Lake and newer CPUs:

| CPU Generation | Initial macOS support | Last supported version | Notes | CPUID |
| :--- | :---: | :---: | :--- | :--- |
| [Coffee Lake](https://en.wikipedia.org/wiki/Coffee_Lake) | 10.12.6 | ^^ |  | **0x0906EA** (S/H/E) **0x0806EA** (U)|
| [Amber](https://en.wikipedia.org/wiki/Kaby_Lake#List_of_8th_generation_Amber_Lake_Y_processors), [Whiskey](https://en.wikipedia.org/wiki/Whiskey_Lake_(microarchitecture)), [Comet Lake](https://en.wikipedia.org/wiki/Comet_Lake_(microprocessor)) | 10.14.1 | ^^ |  | **0x0806E0** (U/Y) |
| [Comet Lake](https://en.wikipedia.org/wiki/Comet_Lake_(microprocessor)) | 10.15.4 | ^^ |  | **0x0906E0** (S/H)|
| [Ice Lake](https://en.wikipedia.org/wiki/Ice_Lake_(microprocessor)) | ^^ | ^^ |  | **0x0706E5** (U) |
| [Rocket Lake](https://en.wikipedia.org/wiki/Rocket_Lake) | ^^ | ^^ | Requires Comet Lake CPUID | **0x0A0671** |
| [Tiger Lake](https://en.wikipedia.org/wiki/Tiger_Lake_(microprocessor)) | <span style="color:red"> N/A </span> | <span style="color:red"> N/A </span> | <span style="color:red"> Untested </span> | **0x0806C0** (U)|

**SOURCE**: [**Dortania**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/macos-limits.md)

## Kernel Patches
These boxes have to be checked when setting-up the required quirks &rarr; [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) for the used CPU. Usually, you need `AppleIntelCPUPM` for older Intel CPUs (up to Ivy Bridge) or `KernelPM` (Haswell and newer).

### AppleIntelCPUPM
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### AppleRTC
Obsolete! vit9696 investigated the problem, and corrected RTC operations in Clover, now the recommended key value is `false` because it affects hibernation.

### Debug
If you want to observe how the Kexts are patched &rarr; For developers.

### DellSMBIOSPatch
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### EightApple
On some systems, the progress bar break down into 8 apples during boot. No confirmation yet if the patch works. Added in r5119.

### KernelLapic
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### KernelPm
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### KernelXCPM
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

## About Patching Masks
![KnKPatches](https://user-images.githubusercontent.com/76865553/136670510-106715c6-884d-4e6a-b151-34d45d9b231a.png)

Starting with r5095, the ability to create binary patches following renaming rules with a complex patching mask has been introduced for the following:

- `KextPatches`
- `KernelPatches` 
- `BootPatches`

Besides the basic `Find`/`Replace` masks, there are several additional modifiers you can utilize for applying Kernels and Kext patches. In the table below, you find the available options and differences in nomenclature between OpenCore and Clover:

| OpenCore    | Clover         | Description (where applicable) |
|:-----------:|:--------------:|--------------------------------|
| Identifier  | Name           | Name of the Kext/Kernel the patch should be applied to.
| Base        | Procedure      | Name of the procedure we are looking for. The real name may be longer, but the comparison is done by a substring. Make sure the substring occurs only in "Procedure".
| Comment     | Comment        | Besides using it as a reminder what a patch does, this field is also used for listing the available patches in Clover's boot menu.
| Find		    | Find           | Value to find
| Replace     | Replace        | Value to replace the found value by
| Mask        | MaskFind       | If some bit=1, we look for an exact match, if the bit=0, we ignore the difference.
| ReplaceMask | MaskReplace    | If a bit=1, we make a replacement. If a bit=0, we leave it as is.
| –           | MaskStart      | Mask for the starting point, i.e. for the `StartPattern`. And then there are Find/MaskFind and Replace/MaskReplace pairs.
| –           | StartPattern   | Remnant of a time before character patching was implemented. It marks the starting point from which to look for a replacement pattern. If we know the name of the procedure, `StartPattern` is hardly needed anymore.
| –           | RangeFind      | Length of code to search. In general, just the size of this procedure, or less. This speeds up the search query without going through all the millions of strings.
| MinKernel   | –              | &rarr; see "MatchOS"
| MaxKernel   | –              | &rarr; see "MatchOS"
| Count       | Count          | Number of times a replacement is made
| Limit       | –              | 
| Skip        | Skip           | Number of times a match is skipped
| Enabled     | Disabled       | Disables the renaming rule (obviously)
| Arch        | –              | 
| –           | MatchOS        |Although there is no equivalent to `MinKernel` and `MaxKernel` in Clover, you can use `MatchOS` to limit a patch to specific versions of macOS. But instead of setting a range of Darwin kernels, you just set the macOS version(s) it applies to. For example: `10.13,10.14,10.15` (without blanks). You can also use masked strings like `11.5.x` (= for all 11.5 and subsequent variants, like 11.5.4), `12.x` (= for all variants of macOS 12), etc.
| –           | MatchBuild     | Applies/Limits a patch to a specific system build of macOS, such as `21D5025F`, for example. You can list multiple builds separated by commas. If no value for `MatchBuild` is set, the patch applies to all builds. In general, patching kexts or kernels based on the build version is not very common and rarely needed.
| –           | InfoPlistPatch | Applies patches to parameters inside `plists` of kexts defined in the `Name` field. The search can include multiple strings, excluding all invisible characters, such as line feeds and tabs. The search should be set as `<data>`, because the service characters such as "<" can not be set in text form. The lengths of the search and replacement strings can be different, but need to have the same length (fill one mask with spaces to match the length of the other one if necessary).

### KextsToPatch
This is a commonly used section to patch kexts in order to enable features like Trim or use USB port patches to use more than 15 ports per Controller (which are no longer required since you can use the `XhciPortlimit` Quirk for that now). 

The patching principle is similar to the one used for patching the `DSDT`, but you patch things inside kexts instead. You enter the name of the Kext you want to patch, and then you enter the value clover should find and replace. Check the dropdown menu to find a lot of patches which may be helpful.

### KernelToPatch
For applying patches to the Darwin Kernel of macOS. This is primarily used by developers for patching Kernels or for debugging purposes. In rare cases it's used for enabling features which wouldn't work otherwise, like enabling XCPM on Ivy Bridge CPUs or enabling the Intel I-225 Ethernet Controller in macOS Catalina.

### BootPatches
For applying binary patches to `boot.efi`
