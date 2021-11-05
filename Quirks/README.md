# Quirks

`Quirks` is a set of features to configure Booter and Kernel Settings in Clover. The underlying technology is OpenCore's `OpenRuntime.efi` which has been fully integrated into Clover since r5126. It replaces the previously used `AptioMemoryFixes` which are no longer capable of booting newer macOS versions. So an upgrade to r5126 or later is mandatory in order to be able to install and boot macOS Big Sur and newer with Clover.

<details>
<summary><strong>Background: From Aptio Memory Fixes to Quirks</strong></summary>

The development of a driver for adjusting the memory that UEFI BIOS Aptio (by AMI) by Dmazar marked the beginning of the UEFI Boot era for Clover.
The Allocate function in this BIOS allocates memory in the lower registers, but to boot macOS, the lower memory has to be free. This issue not only affected memory but also `boot.efi`, address virtualization, pointers, functions, etc. It was Dmazar who figured out how to resolve them. This became the `OsxAptioFixDrv.efi` driver.

For a long time after Dmazar left, no one touched this driver until vit9696 undertook to overhaul it. First of all, he made changes to the driver so that it could utilize native NVRAM on many chipsets (BIOS), which was not possible before. Next, he broke the new driver (`OpenRuntime.efi`) down into **semantic expressions (quirks), which could be turned on and off by the user if the OpenCore loader was used**. 

ReddestDream, a programmer who decided to make `OpenRuntime.efi` work with Clover somehow, created a separate driver (`OcQuirks.efi`), which worked in conjunction with `OpenRuntime.efi` and an additional `OcQuirks.plist` to store all the settings. This combination could then be utilized by Clover.

Next, I (Slice) integrated the `OpenRuntime.efi` source code into my repo since it is Open Source, so I could do bisectioning. Finally, I copied and modernized them so that instead of a separate .plist file, the same Clover `config.plist` can be used, and Quirks can also be changed from within the bootloader GUI. 
</details>

In oder to set up these Quirks correctly, you need to follow the instruction for your CPU family in the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/). Specifically, these sections:

- **Booter > Quirks**
- **Kernel > Quirks**
- **Kernel > Scheme**
- **UEFI > Output: `ProvideConsoleGop`**: Located under "GUI" in Clover config.

## Booter Quirks
The following screenshot shows the Booter Quirks sub-section which is new in Clover Configurator 5.19.0, which makes it a lot easier to handle than in earlier versions:

![Booter_Qs](https://user-images.githubusercontent.com/76865553/139507534-9ee16773-9319-4b10-8437-c76bdb644c0d.png)

The example above shows Booter Quirks for a 10th Gen Intel Cometlake Desktop CPU taken from [this section](https://dortania.github.io/OpenCore-Install-Guide/config.plist/comet-lake.html#booter) of the OpenCore Install Guide.

## Kernel Quirks, Emulate and Scheme
If you click on "Kernel" you will see these Quirks (also for 10 Gen Cometlake):

![KernelQ](https://user-images.githubusercontent.com/76865553/139507546-7c49d3da-85c6-4253-ae8b-865e39ddcb3b.png)

You will find the corresponding settings for your CPU in the "Kernel" section of the Dortania Guide as mentioned earlier. Unfortunately, some of the Kernel Quirks are not located in the `Quirks` section but in the "Kext and Kernel Patches" section instead and – to add even more confusion – have different names than in OpenCore:

![Qnames](https://user-images.githubusercontent.com/76865553/139507628-4dbc5d58-a823-4cd7-a739-9945dd3a2e94.png)

Users of Clover < r5126 can follow my [**Clover Upgrade Guide**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover) to replace the outdated `AptioMemoryFixes` by `OpenRuntime.efi` and add necessary Quirks.

## Additional Quirks
### Provide Console Gop
`ProvideConsoleGop` is another a OpenCore Quirk which has been implemented into Clover. Until r5128, it resided in the `Quirks` section as `ProvideConsoleGopEnable`. Since then it has been been relocated to the `GUI` section because it's related to the User Interface. To find out if you need it or not, check the OpenCore install Guide, specifically the `UEFI > Output` section. **Hint**: it's always enabled.

### ResizeAppleGPUBars
`ResizeAppleGpuBars` Quirk is the latest Quirk added to Clover in r5142. You need to manually copy it from the sample-config.plist to your config since it's not implemeted in Clover Configurator yet.

This quirk limits the GPU PCI BAR sizes for macOS up to the specified value or lower if it is unsupported. When the bit of Capabilities Set, it indicates that the Function supports operating with the BAR sized to (2^Bit) MB.

:warning: **WARNING**:
> Do not set `ResizeAppleGpuBars` to anything but `0` if you have resize bar enabled in BIOS. `9` and `10` will cause sleep wake crashes, and 8 will cause excessive memory usage on some GPUs without any useful benefit. It shall always be `0`. It does not matter which GPU you have, they all support this feature since early 2010s, just give no performance gain.
> 
> **Source**: [Vit9696](https://www.insanelymac.com/forum/topic/349485-how-to-opencore-074-075-differences/?do=findComment&comment=2770810)

**Formula**: 2^Bit = ApppleGPUBars Size in MB

| PCI BAR Size | VALUE in OC|
|-------------:|:----------:|
| Disabled|-1|
|1 MB|0|
| 2 MB|1|
| 4 MB|2| 
| 8 MB|3|
| 16 MB|4|
| 32 MB|5|
| 64 MB|6|
| 128 MB|7|
| 256 MB|8|
| 512 MB|9|
| 1 GB*|10*|
| 2 GB|11|
| 4 GB|12|
| 8 GB|13|
| 16 GB|14|
| 32 GB|15|
| 64 GB|16|
| 128 GB|17|
| 256 GB|18|
| 512 GB|19|

`*`Maximum for macOS.

Before you change any of these values, research if your GPU supports BAR Resize and check the supportedt size with tools like HWiNFO on PC.