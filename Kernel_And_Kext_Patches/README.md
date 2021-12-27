# Kernel and Kext Patches
![KernelQuirks](https://user-images.githubusercontent.com/76865553/136670474-678b7ae1-b5ec-4791-963a-7af091a833ca.png)

This is a group of parameters for creating binary patches on the fly. Note that this can only be done if the kernelcache or the `ForceKextsToLoad` parameter is loaded. If the kext is not loaded and is not in cache, these patches don't work. This section consists of 2 categories: one with Kernel Patches which you can click to enable. These are primarily for making your CPU work with macOS. The second category is for creating your own patches which can be applied to kexts and kernels themselves. 

**NOTE**: The ATI section is not covered here, since it's pretty much obsolete, since nobody uses ATI graphics any more and since ATI cards are no longer supported by recent versions of macOS.

### AppleIntelCPUPM
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### AppleRTC
Obsolete! vit9696 investigated the problem, and corrected RTC operations in Clover, now the recommended key value is `false` because it affects hibernation.

### Debug
If you want to observe how the Kexts are patched &rarr; For developers.

### DellSMBIOSPatch
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### FakeCPUID
Assigns a different Device-ID to the used CPU. Useful when trying to run an older version of macOS with a newer CPU which isn't supported. For example, if you are trying to run macOS High Sierra or Mojave with a Comet Lake CPU which is not supported before macOS 10.15, you can use a Device-ID of the Coffee Lake CPU family, to make macOS accept it.

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

Besides the basic `Find`/`Replace` masks, there are several additional modifiers you can utilize for applying Kernels and Kext patches. In the table below, you find the availabe options and differences in nomenclature between OpenCore and Clover:

| OpenCore    | Clover         | Description (where applicable) |
|:------------|:---------------|--------------------------------|
| Identifier  | Name           | 
| Base        | Procedure      | Name of the procedure we are looking for. The real name may be longer, but the comparison is done by a substring. Make sure the substring occurs only in "Procedure".
| Comment     | Comment        | Besides using it as a reminder what a patch does, this field is also used for listing the available patches in Clover's bootmenu.
| Find		    | Find           | value to find
| Replace     | Replace        | value to replace the found value by
| Mask        | MaskFind       |If some bit=1, we look for an exact match, if=0, we ignore the difference.
| ReplaceMask | MaskReplace    |If a bit=1, we make a replacement. If a bit=0, we leave it as is.
| –           | MaskStart      | Mask for the starting point, i.e. for the `StartPattern`. And then there are Find/MaskFind and Replace/MaskReplace pairs.
| –           | StartPattern   | Remnent of a time before character patching was implemented. It marks the starting point from which to look for a replacement pattern. If we know the name of the procedure, `StartPattern` is hardly needed anymore.
| –           | RangeFind      | Length of code to search. In general, just the size of this procedure, or less. This speeds up the search query without going through all the millions of strings.
| MinKernel   | –              | see "MatchOS"
| MaxKernel   | –              | see "MatchOS"
| Count       | Count          | number of time a replacement is made
| Limit       | –              | 
| Skip        | Skip           | nummber of time a match is skipped
| Enabled     | Disabled       | Disables the renaming rule (obviously)
| Arch        | –              | 
| –           | MatchOS        |Although there are no equivalents to `MinKernel` and `MaxKernel` parameters in Clover, you can use `MatchOS`. Instead of a range of kernel versions you just use the macOS version(s) it applies to. For example: `10.13,10.14,10.15` (without blanks in between).
| –           | MatchBuild     | no explanation available
| –           | InfoPlistPatch | no explanation available

### KextsToPatch
This is a commonly used section to patch kexts in order to enable features like Trim or use USB port patches to use more than 15 ports per Controller (which are no longer required since you can use the `XhciPortlimit` Quirk for that now). 

The patching principle is similar to the one used for patching the `DSDT`, but you patch things inside kexts instead. You enter the name of the Kext you want to patch and then you enter the value clover should find and replace. Check the dropdown menu to find a lot of patches which may be helpful.

### KernelToPatch
For applying patches to the Darwin Kernel of macOS. This is primarily used by developers for patching Kernels or for debugging purposes. In rare cases it's used for enabling features which wouldn't work otherwise, like enabling XCPM on IvyBridge CPUs or enabling the Intel I-225 Ethernet Controller in macOS Catalina. 

### BootPatches
For applying binary patches to `boot.efi`
