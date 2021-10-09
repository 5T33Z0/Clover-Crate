# Kernel and Kext Patches
![](/Users/kl45u5/Desktop/KernelQuirks.png)

 This is a group of parameters for creating binary patches on the fly. Note that this can only be done if the kernelcache or the `ForceKextsToLoad` parameter is loaded. If the kext is not loaded and is not in cache, these patches don't work. This section consists of 2 sub-sections: one with Kernel Patches which you can click on. Theses are primarily to make your CPU work with macOS.

**NOTE**: The ATI section is not covered here, since it's pretty much obsolete, since nobody uses ATI graphics any more and since ATI card are no longer supported by current macOS versions.

## Kernel Patches
Kernel patches are necessary for making macOS compatible with your CPU. Check the Quirks section to see how they ralate to OpenCore and the have a look in the OpenCore Install Guide to find out, which ones you need for your syste. 

### AppleIntelCPUPM
&rarr; See [**Quirks**]([https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)) Section

### AppleRTC
Obsolete! vit9696 investigated the problem, and corrected RTC operations in Clover, now the recommended key value is `false` because it affects hibernation.

### Debug
If you want to observe how the Kexts are patched &rarr; For developers.

### DellSMBIOSPatch
&rarr; See [**Quirks**]([https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)) Section

### FakeCPUID
Assigns a different device-ID to the used CPU. Useful when trying to run an older version of macOS with a newer CPU which isn't supported. For example, if you are trying to run macOS High Sierra or Mojave with an 10th Gen Intel Cometlake i5/i7/i9 CPU which is not supported. Instead, you just fake a Coffeelake CPU, to make macOS go: "Hey, I know you, step right in!".

### EightApple
On some systems, the progress bar break down into 8 apples during boot. No confirmation yet if the patch works. Added in r5119.

### KernelLapic
&rarr; See [**Quirks**]([https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)) Section

### KernelPm
&rarr; See [**Quirks**]([https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)) Section

### KernelXCPM
&rarr; See [**Quirks**]([https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)) Section

### KernelToPatch
This list is for patching Kernels for debugging primarily. But in raree cases it's used for making features work that wouldn't work otherwise, like enabling XCPM on IvyBridge CPUs or enabling macOS Catalina to use the Intel I-225 Ethernet Controller. Rarely used by mere mortals.

## Kext Patches
![](/Users/kl45u5/Desktop/KnKPatches.png)
This is a commonly used section to patch kexts in order to enable certain features like enabling Trim or to disable the USB Portlimition of macOS to use more than 15 ports per Controller. 
