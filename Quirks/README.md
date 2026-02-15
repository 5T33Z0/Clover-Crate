# Quirks

`Quirks` is a set of features to configure Booter and Kernel Settings in Clover. The underlying technology is OpenCore's `OpenRuntime.efi` which has been fully integrated into Clover since r5126. It replaces the previously used `AptioMemoryFixes` which are no longer capable of booting newer macOS past Catalina. So an upgrade to r5126 or newer is mandatory in order to be able to install and boot macOS Big Sur and beyond with Clover.

Besides [misleading claims](https://www.insanelymac.com/forum/topic/351590-intel-uhd-graphics-630-help/?do=findComment&comment=2781905) that Clover will "assign default value[s] for all absent keys [–] *even for Quirks*", you *still* have to configure them *correctly* so your system will boot!

<details>
<summary><strong>Background: From Aptio Memory Fixes to Quirks</strong></summary>

The development of a driver for adjusting the memory of AMI's Aptio UEFI BIOS by Dmazar marked the beginning of the UEFI Boot era for Clover.

This BIOS allows to allocate memory in the lower registers, but to boot macOS, the lower memory has to be freed. This issue not only affected memory but also `boot.efi`, address virtualization, pointers, functions, etc. It was Dmazar who figured out how to resolve the issues which resulted in the `OsxAptioFixDrv.efi` drivers.

After Dmazar left, no one touched this driver for a very long time until vit9696 decided to overhaul it. First, he made changes to the driver so that it could utilize native NVRAM on many chipsets, which was not possible before. Next, he broke the new driver (`OpenRuntime.efi`) down into sections of **semantic expressions (quirks), which could then be turned on and off by the user as needed when using the OpenCore Bootloader**.

ReddestDream, a programmer who decided to make `OpenRuntime.efi` work with Clover somehow, created a separate driver (`OcQuirks.efi`), which worked in conjunction with `OpenRuntime.efi` and an additional `OcQuirks.plist` to store all the settings. This construct could then be utilized by Clover.

Next, Slice integrated the `OpenRuntime.efi` source code into his repo, so he could do bisectioning. Finally, he integrated the quirks section into Clover's `config.plist`, so that the separate OcQuirks.plist was no longer required and Quirks could also be changed on the fly from within the bootloader GUI.
</details>

In order to conifgure Quirks correctly, you need to follow the instruction for your CPU family in the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) – specifically, these sections:

- [**Booter/Quirks**](#booter-quirks)
- [**Kernel Quirks, Emulate and Scheme**](#kernel-quirks-emulate-and-scheme)
- [**UEFI/Quirks**](#uefi-quirks)
- **UEFI/Output/`ProvideConsoleGop`**: Located under "GUI" in Clover config.

## `AutoModernCPUQuirks` (added in Clover r5168)

While it sounds fancy, it's basically just a preset, that enables all Comet Lake Quirks plus a fake CPU-ID to use 11th Gen Intel Core CPUs and newer as well as AMD Zen 3+ – you will still need the Kernel Patches for AMD CPUs, though!

&rarr; See [PR #792](https://github.com/CloverHackyColor/CloverBootloader/pull/792/changes#diff-59b330deadfcb3b2377d6a9d70756f790143f1797bb7710bc415458fdaf1fafeR367-R417) for details 

## Booter Quirks
The following screenshot shows the Booter Quirks subsection which has been introduced in Clover 5.19.00:

![Booter](https://user-images.githubusercontent.com/76865553/148212620-62387a7a-d56a-4df7-b8bb-ad6b0131ebf5.png)

You can find the required Booter Quirks in the Booter section of [Dortania's OpenCore Install Guide](https://dortania.github.io/OpenCore-Install-Guide/) – use the  ones required for your CPU family!

**New Quirk**: `ClearTaskSwitchBit` (added in r5167)

## Kernel Quirks, Emulate and Scheme
If you click on "Kernel" you will find Kernel Quirks, Emulation and Scheme Settings:

![Quirkz](https://user-images.githubusercontent.com/76865553/156524793-98e3f7c1-9058-4742-ab34-8ed7689c70bb.png)

You will find the corresponding settings for your CPU in the "Kernel" section of the Dortania Guide as mentioned earlier. Unfortunately, some Kernel Quirks are not located in the `Quirks` section but in the "Kext and Kernel Patches" instead and also have different names:

![Qnames](https://user-images.githubusercontent.com/76865553/139507628-4dbc5d58-a823-4cd7-a739-9945dd3a2e94.png)

Users of Clover < r5126 can follow my [**Clover Upgrade Guide**](https://github.com/5T33Z0/Clover-Crate/tree/main/Update_Clover) to replace the outdated `AptioMemoryFixes` by `OpenRuntime.efi` and add necessary Quirks.

**New Quirk**: `DisableIoMapperMapping` (added in r5167)

## UEFI Quirks

![UEFI_Quirks](https://user-images.githubusercontent.com/76865553/203743139-961fc413-887a-471e-b41a-30e73821ef56.png)

### TscSyncTimeout
Added in r5150. This is an experimental quirk provided by OpenCore. The timeout has to be entered as an integer in µs. Xeon E5-2650v2 need a value of `750000`. Before playing with this value, it's recommended to use one of the existing kexts for fixing TSC Sync issues instead (like [CpuTscSync](https://github.com/acidanthera/CpuTscSync)). 

**New Quirk**: `ResizeGpuBars` (added ib r5167)

> [!NOTE]
> 
> Update Clover Configurator to the latest version (5.24.0.0 or newer) to find the new UEFI Tab in the Quirks section!

## Additional Quirks
This section lists Quirks which are new, undocumented or unavailable in Clover Configurator yet or are noteworthy otherwise.

### ForceAquantiaEthernet
Introduced in Clover r5156. Enables Aquantia AQtion based 10GbE network cards support, which used to work natively before macOS 10.15.4. 

**Config requirements**:

- `VT-d` must be enabled in BIOS
- `DisableIoMapper` Quirk must be unselected
- Some mainboards (e.g. Z490) may require dropping/replacing `DMAR` Table in order to make AppleVTD work in macOS (&rarr; see ["Notes for dropping DMAR for ForceAuqantiaEthernet"](https://github.com/acidanthera/OpenCorePkg/commit/24414555f2c07e06a3674ec7a2aa1ce4860bbcc7#commitcomment-70530145)).

### ForceOcWriteFlash
Added in r5142 beta. It's another OpenCore Quirk integrated into Clover. Description from the OpenCore Documentation:

> Enables writing to flash memory for all NVRAM system variables handled by OpenRuntime.efi. This value should be disabled on most types of firmware but is left configurable to account for firmware that may have issues with volatile variable storage overflows or similar. Boot issues across multiple OSes can be observed on e.g. Lenovo ThinkPad T430 and T530 without this quirk. Apple variables related to Secure Boot and hibernation are exempt from this for security reasons. Furthermore, some OpenCore variables are exempt for different reasons, such as the boot log due to an available user option, and the TSC frequency due to timing issues. When toggling this option, a NVRAM reset may be required to ensure full functionality.

### Provide Console Gop
`ProvideConsoleGop` is another a OpenCore Quirk which has been implemented into Clover. Until r5128, it resided in the `Quirks` section as `ProvideConsoleGopEnable`. Since then, it has been relocated to the `GUI` section because it's related to the User Interface. To find out if you need it or not, check the OpenCore install Guide, specifically the `UEFI/Output` section. **Hint**: it's always enabled.

### ProvideCurrentCpuInfo
This quirk works differently depending on the CPU to the macOS Kernel:
- For Microsoft Hyper-V it provides the correct TSC and FSB values to the kernel, as well as disables CPU topology validation (10.8+).
- For KVM and other hypervisors it provides precomputed MSR 35h values solving kernel panic with -cpu host.
- For Intel CPUs it adds support for asymmetrical SMP systems (e.g. Intel Alder Lake) by patching core count to thread count along with the supplemental required changes (10.14+).

### ResizeAppleGPUBars
`ResizeAppleGpuBars` is the latest Quirk added to Clover in r5142. It limits the GPU PCI BAR sizes for macOS up to the specified value or lower if it is unsupported. When the bit of is Set, it indicates that the Function supports operating with the BAR sized to (2^Bit) MB. `ResizeGpuBars` must be an integer value between `-1` to `19`.

> [!WARNING]
> 
> Do not set `ResizeAppleGpuBars` to anything but `0` if you have resize bar enabled in BIOS. `9` and `10` will cause sleep wake crashes, and 8 will cause excessive memory usage on some GPUs without any useful benefit. It shall always be `0`. It does not matter which GPU you have, they all support this feature since early 2010s, just give no performance gain.
>
> **Source**: [Vit9696](https://www.insanelymac.com/forum/topic/349485-how-to-opencore-074-075-differences/?do=findComment&comment=2770810)

**Formula**: 2^Bit = ApppleGPUBars Size in MB

| PCI BAR Size | VALUE in OC |
| -----------: | :---------: |
|     Disabled |     -1      |
|         1 MB |      0      |
|         2 MB |      1      |
|         4 MB |      2      |
|         8 MB |      3      |
|        16 MB |      4      |
|        32 MB |      5      |
|        64 MB |      6      |
|       128 MB |      7      |
|       256 MB |      8      |
|       512 MB |      9      |
|        1 GB° |     10°     |
|         2 GB |     11      |
|         4 GB |     12      |
|         8 GB |     13      |
|        16 GB |     14      |
|        32 GB |     15      |
|        64 GB |     16      |
|       128 GB |     17      |
|       256 GB |     18      |
|       512 GB |     19      |

`°`Maximum for macOS.

> [!IMPORTANT]
> 
> Before changing any of these values, chek if your GPU supports BAR Resize with tools like `HWiNFO` in Windows.
