# Kernel and Kext Patches
![KernelQuirks](https://user-images.githubusercontent.com/76865553/136670474-678b7ae1-b5ec-4791-963a-7af091a833ca.png)

This is a group of parameters for creating binary patches on the fly. Note that this can only be done if the kernelcache or the `ForceKextsToLoad` parameter is loaded. If the kext is not loaded and is not in cache, these patches don't work. This section consists of 2 sub-sections: one with Kernel Patches which you can click on. Theses are primarily to make your CPU work with macOS.

**NOTE**: The ATI section is not covered here, since it's pretty much obsolete, since nobody uses ATI graphics any more and since ATI card are no longer supported by current macOS versions.

### AppleIntelCPUPM
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### AppleRTC
Obsolete! vit9696 investigated the problem, and corrected RTC operations in Clover, now the recommended key value is `false` because it affects hibernation.

### Debug
If you want to observe how the Kexts are patched &rarr; For developers.

### DellSMBIOSPatch
&rarr; See [**Quirks**](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks) Section

### FakeCPUID
Assigns a different device-ID to the used CPU. Useful when trying to run an older version of macOS with a newer CPU which isn't supported. For example, if you are trying to run macOS High Sierra or Mojave with an 10th Gen Intel Cometlake i5/i7/i9 CPU which is not supported. Instead, you just fake a Coffeelake CPU, to make macOS go: "Hey, I know you, step right in!".

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

Besides the usual `Find`/`Replace` masks there are additional modifiers: 

- `MaskFind`(HEX): If some bit=1, we look for an exact match, if=0, we ignore the difference.
- `MaskReplace` (HEX): if a bit=1, we make a replacement. If a bit=0, we leave it as is.
- `Disabled`: Disables the renaming rule.
- `Procedure`: Name of the procedure we are looking for. The real name may be longer, but the comparison is done by a substring. Make sure the substring occurs only in this procedure. In OpenCore, this is called `Base`.
- `RangeFind`: Length of codes to search. In general, just the size of this procedure, or less. This way we speed up the search without going through all the millions of strings. 
- `StartPattern` was existed before the character patch. It is the starting point from which to look for our pattern. If we know the name of the procedure, `StartPattern` is hardly needed anymore.
- `MaskStart`: Mask for the starting point, i.e. for the `StartPattern`. And then there are Find/MaskFind and Replace/MaskReplace pairs.
- `MatchOS` is set to All, since we consider this method of patching independent of the system version.
- `MatchBuild`: no explanation available (5T33Z0)
- `InfoPlistPatch`: no explanation available (5T33Z0)

### KextsToPatch
This is a commonly used section to patch kexts in order to enable certain features like enabling Trim or to disable the USB port limitations of macOS to use more than 15 ports per Controller. The patching principle is similar to the one used for patching the `DSDT`, but you patch things inside kexts instead. You enter the name of the Kext you want to patch and then you enter the value clover should find and replace. Check the dropdown menu to find a lot of patches which may be helpful.

### KernelToPatch
For applying binary patches to the Darwin kernel of macOS. This is used by developers primarily for patching Kernels or debugging. But in rare cases it's used for enabling features which wouldn't work otherwise, like enabling XCPM on IvyBridge CPUs or enabling macOS Catalina to use the Intel I-225 Ethernet Controller. 

### BootPatches
For applying binary patches to `boot.efi`
