# Graphics
![Graphics](https://user-images.githubusercontent.com/76865553/136713622-7300a5e5-de05-413a-b748-579b95a36d58.jpeg)

This group of parameters serves to inject Properties for various graphics cards, on-board and discrete. There are many parameters that are actually injected, but they are mostly constants, some are calculated, some are defined in the internal table and only very few parameters are entered via config.

**ATTENTION!** Most of the options available in this section are obsolete in 2021. Instead, framebuffer patches are entered via `Devices/Properties`. The only settings which are still useful are the entries in the dropdown menu of `ig-platform-id` for Intel iGPUs (up to Coffeelake).

## Inject
Can inject two dozens of parameters, which are calculated not only based on the card model, but also on its internal characteristics after analyzing the video bios of a GPU. 

For Nvidia cards, `NVCAP` is calculated, for Intel on-board graphics, dozens of parameters are applied, for ATI cards parameters for connectors are injected. To list all of them would take another two hundred pages. Moreover, for modern discrete GPUs you don't need these any more, since Apple ensured that they work out of the box.

You can enable the injection of parameters based on vendors:

- `Inject ATI`
- `Inject Intel`
- `Inject NVidia` 

**NOTE**: These parameters were used before the advent of `Whatevergreen.kext` (WEG). Now that the WEG does most of the graphics customization work for you, it is recommended to disable all of these injections.

## Dual Link
The default value is `1`, but for some older configurations this will cause issues. In this case, set it to `0`.

## EDID
Extended Display Identification Data (EDID) is a metadata format for display devices to describe their capabilities to a video source (e.g. graphics card). The data format is defined by a standard published by the Video Electronics Standards Association (VESA). Sometimes this value is necessary to fix issues like graphical glitches, etc.

The following parameters can be adjusted:

- `VendorID`
- `ProductID`
- `HorizontalSyncPulseWidth`: Fixes the eight apples issue. See `EightApple` Fix in &rarr; Kernel Kext and Patches.
- `VideoInputSignal`

## FB Name
This parameter is specific to ATI Radeon Cards, for which about three dozens different framebuffers exist which don't follow any specific pattern. Clover automatically chooses the most appropriate name from the table on most known cards. 

However, other users of the exact same card are challenged, they want a different name. So select one from the dropdown menu.

## Load VBios
Loads video bios from a file. It must be present in `EFI/CLOVER/OEM/xxx/ROM` or `EFI/CLOVER/ROM` and named `vendor_device.rom`, e.g. `1002_68d8.rom`. This sometimes makes sense if you use a patched Vbios. Since r3222, longer file names including sub-vendor and sub-revision are supported as well. For example `10de_0f00_1458_3544.rom`.

This can also be used to inject device information of mobile Radeon cards into the system, if macOS cannot detect it. Clover will grab the VBios from the legacy memory at address `0xc0000` injects it into the system and the mobile radeon turns on!

For computers with UEFI-only BIOS, there is no Vbios on the legacy address. Let's put it on file and wait for new solutions…

## NVCAP
This parameter is for Nvidia video cards and configures types and usage of video ports.
This line has 40 hexadecimal digits in capital letters. 

## NvidiaGeneric
If enabled, then instead of the name "Gigabyte Geforce 7300LE", "NVIDIA Geforce 7300LE" will be used.

## NvidiaSingle
For systems with more than one Nvidia graphics cards. If enabled, only one Nvidia GPU is injected.

## NvidiaNoEFI
Adds NVDA property to the Nvidia injector. Explained [here](https://www.insanelymac.com/forum/topic/306156-clover-problems-and-solutions/page/84/?tab=comments#comment-2443062).

## PatchVbios
Fixes the VBios at address `0xC0000`, so that it supports the maximal resolution for the connected display. For example, the `EDID` of the monitor has a 1920x1080 mode, but the VBios does not. Clover will prescribe it as the first mode and start using it. If the monitor itself does not provide an `EDID`, it can be injected as described above. 

There have been cases where turning this patch on has caused a panic, black screen when trying to boot. For the first attempt, turn this setting off. Either use the value from the config.plist file for the patch. If the automation made a mistake, you can write the VideoBios patch manually, using the standard Find/Replace algorithm.

## RadeonDeInit
This key works with ATI/AMD Radeon cards 6xxx and higher. Or maybe 5xxx, haven't seen any reviews. It fixes the contents of GPU registers so that the card becomes properly initialized and MacOSX drivers work with it as intended.

## ig-platform-id
This parameter is required to configure "Intel HD Graphics xxxx" on-board video cards. Select the correct id for your CPU from the dropdown menu in Clover Configurator.</br> **NOTE**: As of 2021, on-board graphics are configured in `Devices/Properties`, using the correct ig-platform-id amongst additional parameters to configure connectors, used VRam, etc.

## VRAM
The amount of video memory in MB. In fact, it is detected automatically, but you can adjust it manually. In reality, I cannot remember a single case where this parameter has helped anyone in any way. If you see 7Mb, don't try to change this parameter, it's useless. You need to get a video card. For example for mobile Radeon there is a trick to use `LoadVBios=true` and the memory will be correct.
