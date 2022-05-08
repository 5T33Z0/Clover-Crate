# Graphics
![Graphics](https://user-images.githubusercontent.com/76865553/136713622-7300a5e5-de05-413a-b748-579b95a36d58.jpeg)

This group of parameters serves to inject Properties for various graphics cards, on-board and discrete. There are many parameters that are actually injected, but they are mostly constants, some are calculated, some are defined in the internal table and only very few parameters are entered via config.

Since this menu is very convoluted I will group parameters together by vendor (Intel, ATI/AMD and NVIDIA)

**ATTENTION!** Most of the options available in this section are obsolete in 2021. Instead, framebuffer patches are entered via `Devices/Properties`. The only settings which are still useful are the entries in the dropdown menu of `ig-platform-id` for Intel iGPUs (up to Coffeelake).

## Inject
The Inject feature is a remnent of the Chameleon era where it was called `GraphicsEnabler`. 
It can inject about two dozen parameters, which are calculated not only based on the card model, but also on its internal characteristics after analyzing the VBIOS of a GPU.

For Nvidia cards, `NVCAP` is calculated, for Intel on-board graphics dozens of parameters are applied, for ATI/AMD cards parameters for connectors are injected. To list all of them would exceed the scope of this guide. Moreover, for most modern GPUs, you don't even need to the inject features in most cases, since Apple ensured that they work out of the box.

You can enable the injection of parameters based on vendors:

- `Inject Intel` &rarr; For Intel on-board graphics. See "[**ig-platform-id**](https://github.com/5T33Z0/Clover-Crate/tree/main/Graphics#ig-platform-id)" for details.
- `Inject ATI` &rarr; For ATI/AMD GPUs. See "[**FB Name**](https://github.com/5T33Z0/Clover-Crate/tree/main/Graphics#fb-name)" for details.
- `Inject NVidia` &rarr; For older NVIDIA Cards, **not** requiring on NVIDIA WebDrivers.</br> Kepler cards and newer (e.g. Maxwell or Pascal) rely on WebDrivers. These can only be installed in post-install. Therefore, you need to do the following:
	- Use boot-arg `nv_disable=1` to disable the card and use the software renderer to display an image during the macOS installation instead. 
	- Once macOS is running, [**download**](https://www.tonymacx86.com/nvidia-drivers/) and install the appropriate WebDriver for your macOS build (supported up to macOS High Sierra only). 
	- Next, delete the `nv_disable=1` boot-arg 
	- In the **System Parameters** Section, enable **NvidiaWeb**
	- Save your `config.plist` and reboot. Graphics acceleration should work now.</br>
	For more details about using NVIDIA cards, please refer to the [**Nvidia GeForce FAQs**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.GeForce.en.md).

**NOTES**: 

- The `Inject` feature is a remnant of the era before `Whatevergreen.kext` (WEG) existed. Since WEG handles most of the neccessary adjustments to get graphics cards working with macOS nowadays, it is recommended to disable them (except for `Inject ATI` which is still useful in macOS 12 to address performance issues).
- When using Intel on-board graphics on modern systems, using `Inject Intel` is not recommended. Instead, follow Whatevergreen's [Intel HD Graphics FAQ](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md) to configure the framebuffer for your CPU in the `Devices/Properties` section manually. 
- **Hint**: The `config.plists` included in the [Desktop Configs](https://github.com/5T33Z0/Clover-Crate/tree/main/Desktop_Configs) and [Laptop Configs](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs) sections contain a lot of Framebufer patches for various Intel CPU families already which might be useful to get your Intel HD/UHD graphics up and running.

## Inject Intel
Listed below are all parameters related to the `Inject Intel` feature.

### ig-platform-id
Property used by macOS to determine the framebuffer profile for Ivy Bridge and newer Intel CPUs with integrated graphics, aka "Intel (U)HD Graphics xxxx". Select the corresponding framebuffer from the `ig-platform-id` dropdown menu in Clover Configurator (supported up Intel UHD Graphics 630 for Coffee Lake).

Nowaday using Device Properties is the recommended method for configuring integrated graphics, including type of connectors (e.g. if you want to connect an external monitor to a Laptop), setting thr allocated/stolen memory, etc.

For furter instruction on how to configure on-board graphics for supported Intel CPUs, please refer to Whatevergreen's extensive [**Intel HD Grpahics FAQ**](https://github.com/acidanthera/WhateverGreen/blob/master/Manual/FAQ.IntelHD.en.md).

**NOTES**

- For 10th Gen Intel Core CPUs and newer, it's recommended to configure the framebuffer using the `Devices/Properties` section instead, entering the correct `ig-platform-id` amongst additional parameters to configure connectors, amount of VRam, etc.
- Sandybridge CPUs require `AAPL,snb-platform-id` and have to be configured via `Devices/Properties` as well.
- If Clover detects an Intel iGPU, it _automatically_ enables Intel Injection if the `Graphics` section doesn't exist in the `config.plist`. To prevent this, you can explicitly disable it by clicking the "Inject Intel" button once to enable it and again to disable it which sets the `Inject` key to `false`:</br>
	```
	<key>Graphics</key>
    <dict>
        <key>Inject</key>
        <false/>
    </dict>
    ```

## Inject ATI
Listed below are all parameters related to the `Inject ATI` feature.

### FB Name
**Framebuffer Name**. Specific to ATI/AMD Video Cards. More than 70 different framebuffer names exist for various AMD Video Controller kexts. Each has a unique name to identify it (check the extensive list in Clover Configurator) and contains different video output mappings as defined in the `IOKitPersonalities` of the repsective kexts' `info.plist`. Here is an example from `AMD9500Controller.kext` located in S/L/E:

![FB_name](https://user-images.githubusercontent.com/76865553/166189455-06fe0e53-3f3b-4675-9972-d828872b5d57.png)

To find the Controller kext used by your AMD/ATI card, run Hackintool, click on the "PCIe" Tab and look for it ("Class" is "Display Controller"). Once you find it, click on the magnifying class icon at the beginning of the entry. This takes you stright to the kext in Finder. Right-click it and select "Show Package Contents". Inside you will find the `info.plist`.

Usually, Clover automatically picks an appropriate Framebuffer for common cards it detects. However, you can choose a custom one from the dropdown menu or enter a name manually if the dection fails or the default Framebuffer causes issues. Just make sure it matches the Controller used in your ATI/AMD Card (Hackintool is your friend).

OpenCore users have to do this via `DeviceProperties`: 
- Add the PCIRoot Address entry for the GPU (use Hackintool to export the device list)
- Add the corresponfing `AAPL,slot-name` (check `pcidevices.plist`)
- Add its `device-id` (this determines which Controller kext will be used)
- Add `fb_name` property with the name of the desired Framebuffer as a String.</br>
**Example**:</br>
![DEVPROP](https://user-images.githubusercontent.com/76865553/166193678-e009e15d-f065-4e4f-adf0-b6350e042181.png)

**NOTES**: 
- You only need to enter something in "FB Name" if you don't use `Whatevergreen.kext`, which handles all this stuff nowadays.
- Injecting "FB name" it might cause conflicts when WhateverGreen is active, because WEG uses the default AMDRadeonFramebuffer to do its magic.

#### `Inject ATI` and `FB Name` in macOS Monterey
Since Clover r5145, commit 89658955f, the Framebuffer Patches for ATI/AMD were updated for better performance under macOS Monterey 12.3+ with newer GPUs. Do the following to enable the correct framebuffer for your AMD GPU:

1. Enable `Inject ATI`
2. Under `FB Name`, enter ther name of the Framebuffer Patch matching the Controller in your GPU or select one from the dropdown menu:
	- **RX6900** &rarr; `Carswell`
	- **RX6800** &rarr; `Belknap`
	- **RX6600** &rarr; `Henbury` 
	- **RX5700** &rarr; `Adder`
	- **RX5500** &rarr; `Python`
	- **RX570** &rarr; `Orinoco`

**Source**: [**Clover Changes**](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?do=findComment&comment=2778575)

#### Patching ATI/AMD Connectors
ATI/AMD framebuffers can be patched to assign different connectors to output the video signal. You can follow [this guide](https://www.insanelymac.com/forum/topic/282787-clover-v2-instructions/#comment-1853099) if you have need to do this. But keep in mind that this guide is from 2012 so I don't know if it is still relevant today. 

OpenCore users need to use DeviceProperties to do this. Check the [**Clover Conversion Guide**](https://github.com/dortania/OpenCore-Install-Guide/blob/master/clover-conversion/Clover-config.md#graphics) for details.

### RadeonDeInit
This key works with ATI/AMD Radeon GPUs (6xxx and higher and possibly 5xxx). It fixes the contents of GPU registers so that the card becomes properly initialized so macOS drivers work as intended.

## Inject Nvidia
Listed below are all parameters related to the `Inject Nvidia` feature.

### NVCAP
This parameter is for legacy NVIDIA video cards and configures types and usage of video ports. The value consists of 40 hexadecimal digits which have to be calculated based on  your video card's VBIOS which has to be analyzed to do so. You can follow [**this guide**](https://dortania.github.io/OpenCore-Post-Install/gpu-patching/nvidia-patching/#nvcap) to calculate the correct NVCAP value for your card.

**Examples**:

![NVCAP](https://user-images.githubusercontent.com/76865553/162608389-85c00cf3-2b10-49fe-8a0e-7f63c7f3f646.png)

### NvidiaGeneric
If enabled, then instead of the name "Gigabyte Geforce 7300LE", "NVIDIA Geforce 7300LE" will be used.

### NvidiaSingle
For systems with more than one Nvidia graphics cards. If enabled, only one Nvidia GPU is injected.

### NvidiaNoEFI
Adds `NVDA` property to the Nvidia injector. Explained [here](https://www.insanelymac.com/forum/topic/306156-clover-problems-and-solutions/page/84/?tab=comments#comment-2443062).

## Dual Link
The default value is `1`, but for some older configurations this will cause issues. In this case, set it to `0`.

## EDID
Extended Display Identification Data (EDID) is a metadata format for display devices to describe their capabilities to a video source (e.g. graphics card). The data format is defined by a standard published by the Video Electronics Standards Association (VESA). Sometimes this value is necessary to fix issues like graphical glitches, etc.

The following parameters can be adjusted:

- `VendorID`
- `ProductID`
- `HorizontalSyncPulseWidth`: Fixes the eight apples issue. See `EightApple` Fix under &rarr; Kernel and Kext Patches.
- `VideoInputSignal`

## Load VBios
Loads video bios from a file. It must be present in `EFI/CLOVER/OEM/xxx/ROM` or `EFI/CLOVER/ROM` and its name must consist of `vendor_device.rom`, e.g. `1002_68d8.rom`. Since r3222, longer file names including sub-vendor and sub-revision are supported as well. For example `10de_0f00_1458_3544.rom`. This option is useful if you want to load a patched Vbios when running macOS.

This can also be used to inject device information of mobile Radeon cards into the system, if macOS cannot detect it. Clover will grab the VBios from the legacy memory at address `0xc0000` injects it into the system so the mobile Radeon card turns on!

For computers with UEFI-only BIOS, there is no Vbios on the legacy address.

## PatchVbios
Fixes the VBios at address `0xC0000`, so that it supports the highest possible resolution for the connected display. For example, the `EDID` of the monitor supports 1920x1080, but the VBios does not. Clover will prescribe it as the first mode and start using it. If the monitor itself does not provide an `EDID`, it can be injected as described above.

There have been cases where enabling this patch would cause a black screen when trying to boot. In this case, disable this setting. Use the value from the config.plist file for the patch instead. If the automation made a mistake, you can write the VBios patch manually, using the standard Find/Replace algorithm (not covered here).

## VRAM
The amount of video memory in MB. In fact, it is detected automatically, but you can adjust it manually. But in reality, I cannot remember a single case where this parameter has helped anyone in any way other than for mobile Radeon cards: if you set `LoadVBios=true` the correct amount of memory will be displayed.

If you see "7Mb", don't try to change this parameter, it's useless. In this case you need to either adjust the framebuffer patch of the Intel iGPU or get a discrete video card instead.
