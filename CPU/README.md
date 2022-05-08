# CPU
![CeePiiU](https://user-images.githubusercontent.com/76865553/148276037-6eadf7bf-f040-41c2-bf02-5ea5493e14d9.jpeg)

This section allows to manually set parameters for the CPU if the internal algorithms fail to auto-detect the correct parameters. This section is only covered for the sake of completeness. The bottom line is: **you don't change anything here unless it's unavoidable and you know what you are doing!** 

## Frequency (in MHz)
Describes the base frequency in MHz displayed in the System-Profiler. In other words: its effects are purely cosmetic. Usually, Clover automatically calculates this value based on the ACPI timer, but if it gets it wrong, you can correct it through this key.

## Bus Speed (in kHz)
Describes the bus frequency in **kHz**. The bus frequency is critical for stable operation of the system. It's handed over from the bootloader to the kernel. If the frequency is wrong, the kernel won't start at all. If the frequency is slightly off, there can be problems with the clock, resulting in strange system behavior.

Starting with Clover r1060, the bus frequency is detected automatically based on data from the ADC Timer which calculates these values more accurate than the value stored in the Desktop Management Interface (DMI).

To check the Bus Frequency, enter in Terminal: `sysctl hw.busfrequency`. I ran this command both in Clover and OpenCore and got different results.

**Results**:

SMBIOS | Clover (Hz) | OpenCore (Hz)
:-------:|:--------:|:--------:
MacBookPro10,1| 96000000 | 400000000
iMac20,2| 100000000 |400000000

It seems that Clover uses the correct Bus Frequency reported by the system, while OpenCore uses Base Clock x 4. See `QPI` for more details.

## QPI
QPI (Intel QuickPath Interconnect) is the successor of the FSB (Front Side Bus). Unlike FSB, it's not a Bus system but a routing mechanism managing the communincation and data transfer between CPU cores and the chipset. The technology was introduced in 2010 with the release of the Nehalem CPU family. After much debate, QPI has been added to the config. Enter what you like (in MHz).This does not affect work in any way - it's purely cosmetic (except for 1st Gen Intel Core i7 CPUs).

In macOS's System Profiler, this value is called "Processor Bus Speed" or "Bus Speed". Clover automatically calculates the correct value based on data sheets from Intel. In the source code of the `AppleSmbios` kernel, two methods for setting this value are available: 1) the value either already exists in SMBIOS – as prescribed by the manufacturer, or 2) Bus Speed x4 is used instead. 

**Setting QPI only makes sense for CPUs of the Nehalem family** because Nahalem uses a really complicated method for calculating the QPI link speed based on various inter-dependent parameters. A great explanation can be found on [YouTube](https://www.youtube.com/watch?v=F24D7EZuZB4). For newer CPU families you can enter Bus Speed x4 (usually, a Base Clock of 100 mHz x4) or leave it empty. If you enter `0`, DMI table 132 will not be generated.

## Latency
Describes the delay for entering the `C3` state. The critical value is **0x3E8** = **1000**. Below 1000, Speedstep is enabled, above 1000, it does not turn on. On real Macs, it is always set to **0x03E9** (1001) which disables Speedstep. On Hacks, we can choose if we want to behave it like a Mac or if we want to turn on power management. A reasonable value for the latter is **0x00FA** (250), which is found on some laptops (MacPro5.1 = 17, MacPro6.1 = 67, iMac13.2 = 250).

## Type
This parameter is used by Apple to display information about the used CPU in the "About this Mac" window, which internally translates into a processor designation. Otherwise, "Unknown processor" will be displayed. Any value entered here only has cosmetic effect – it will not change the way the CPU operates!

Clover usually detects all CPU models correctly but you can enter a different value to change what is displayed. This can be helpful when you use a Fake CPU-ID for example and the correct CPU type is no longer detected by macOS, so it is shown as "Unknown processor". 

Check this document to find out which value you need to enter: [AppleSmBIOS](https://github.com/acidanthera/OpenCorePkg/blob/master/Include/Apple/IndustryStandard/AppleSmBios.h)

## TDP
Describes the Thermal Design Power (in Watts), taken into account in the P-States when generating the Processor Power Management tables. You can find the TDP for your CPU on [Intel's Product Specifications Website](https://ark.intel.com/content/www/us/en/ark.html#@Processors)

## SavingMode
Here, you can set `Performace Bias Range` which affects the behavior of [Intel Speedstep](https://en.wikipedia.org/wiki/SpeedStep). A lower value shifts the Bias more to performance while a higher value shifts it more towards saving Energy.

It affects the MSR `0x1B0` register and determines the behavior of the processor:

`0`: Maximum Performance</br>
`15`: Maximum Energy Saving

## HWPEnable (= Intel Speed Shift)

With the launch of the Skylake CPU family, Intel introduced [**Speed Shift**](https://coderbag.com/product/quickcpu/features/hwp/intel-speed-shift-performance-settings) technology aka HWP (Hardware p-state) or Hardware Controlled Performance. It delivers quicker responsiveness with short duration performance shifts, by allowing the processor to more quickly select its best operating frequency and voltage for optimal performance and power efficiency independent of the OS which reduces latency and in return slightly improves overall performance. 

If enabled, then `1` is written to the MSR `0x770` register. Unfortunately, if the computer enters sleep and then wakes up, the MSR value `0x770` will be reset to `0` and Clover cannot re-enable it. But with a help of the [**HWPEnable.kext**](https://github.com/headkaze/HWPEnable) this can be fixed.

<details>
<summary><strong> Board-IDs with HWP support</strong> (click to reveal)</summary>

Listed below you will find a list of Mac models supporting Instel Speed Step which can be extracted using [**freqVectorsEdit**](https://github.com/Piker-Alpha/freqVectorsEdit.sh).

```freqVectorsEdit.sh v3.2 Copyright (c) 2013-2022 by Pike R. Alpha.
-----------------------------------------------------------------
Bugs > https://github.com/Piker-Alpha/freqVectorsEdit.sh/issues <

Available resource files (plists) with FrequencyVectors:

 [  1 ] Mac-EE2EBD4B90B839A8.plist (MacBook10,1 @ 3000 HWP/3200 HWP/3600 HWP)
 [  8 ] Mac-6FEBD60817C77D8A.plist (Unknown Model @ 3800 HWP/4100 HWP)
 [ 12 ] Mac-CAD6701F7CEA0921.plist (MacBookPro14,2 @ 3500 HWP/3700 HWP/4000 HWP)
 [ 13 ] Mac-226CB3C6A851A671.plist (Unknown Model @ 3600 HWP)
 [ 17 ] Mac-27AD2F918AE68F61.plist (Unknown Model HWP)
 [ 19 ] Mac-7BA5B2DFE22DDD8C.plist (Unknown Model @ 3600 HWP/4000 HWP/4100 HWP/4500 HWP)
 [ 20 ] Mac-E7203C0F68AA0004.plist (Unknown Model @ 3900 HWP/4500 HWP)
 [ 21 ] Mac-63001698E7A34814.plist (Unknown Model @ 3600 HWP/4100 HWP/4600 HWP)
 [ 26 ] Mac-A5C67F76ED83108C.plist (MacBookPro13,3 @ 3500 HWP/3600 HWP/3800 HWP)
 [ 27 ] Mac-473D31EABEB93F9B.plist (MacBookPro13,1 @ 3100 HWP/3400 HWP)
 [ 29 ] Mac-CFF7D910A743CAAF.plist (Unknown Model @ 4500 HWP)
 [ 31 ] Mac-53FDB3D8DB8CA971.plist (Unknown Model @ 3900 HWP/4500 HWP)
 [ 33 ] Mac-1E7E29AD0135F9BC.plist (Unknown Model @ 4100 HWP/4300 HWP/4500 HWP/4600 HWP/4800 HWP/5000 HWP)
 [ 34 ] Mac-AF89B6D9451A490B.plist (Unknown Model @ 4500 HWP)
 [ 35 ] Mac-9AE82516C7C6B903.plist (MacBook9,1 @ 2200 HWP/2700 HWP/3100 HWP)
 [ 38 ] Mac-551B86E5744E2388.plist (MacBookPro14,3 @ 3800 HWP/3900 HWP/4100 HWP)
 [ 39 ] Mac-564FBA6031E5946A.plist (Unknown Model HWP)
 [ 42 ] Mac-5F9802EFE386AA28.plist (Unknown Model @ 3800 HWP/4100 HWP)
 [ 44 ] Mac-87DCB00F4AD77EEA.plist (Unknown Model @ 3200 HWP/3500 HWP/3800 HWP)
 [ 46 ] Mac-B4831CEBD52A0C4C.plist (MacBookPro14,1 @ 3400 HWP/4000 HWP)
 [ 48 ] Mac-A61BADE1FDAD7B05.plist (Unknown Model @ 4500 HWP/4800 HWP/5000 HWP)
 [ 49 ] Mac-E1008331FDC96864.plist (Unknown Model @ 4500 HWP/4800 HWP/5000 HWP)
 [ 50 ] Mac-0CFF9C7C2B63DF8D.plist (Unknown Model @ 3200 HWP/3500 HWP/3800 HWP)
 [ 51 ] Mac-66E35819EE2D0D05.plist (MacBookPro13,2 @ 3300 HWP/3500 HWP/3600 HWP)
 [ 55 ] Mac-827FB448E656EC26.plist (Unknown Model @ 3800 HWP/4100 HWP/4200 HWP/4500 HWP/4700 HWP)
 [ 56 ] Mac-827FAC58A8FDFA22.plist (Unknown Model @ 3600 HWP)
 [ 59 ] Mac-937A206F2EE63C01.plist (Unknown Model @ 4100 HWP/4300 HWP/4500 HWP/4600 HWP/4800 HWP/5000 HWP)
 [ 64 ] Mac-AA95B1DDAB278B95.plist (Unknown Model @ 4100 HWP/4300 HWP/4600 HWP/5000 HWP)
```
</details>

**NOTES**

- HWP requires Intel Skylake or newer.
- In order to make use of Intel Speed Shift, you need to pick an SMBIOS and Board-ID which supports it (usually Laptops).
- Using `HWPEnable` is outdated. Nowadays [**CPUFriendFriend**](https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/) is used to extract and modify frequency vectors included in the Board-ID plist of the selected SMBIOS. This data can then be adjusted and injected back into macOS with the help of CPUFriend and a DataProvider kext.

## HWPValue
`HWPValue` is a bitmask consistion of 3 parameters to get Intel Speed Step working properly on Skylake and newer CPUs: the Energy Performance Preference (EPP), the maximum Multiplier of the CPU and the Lowest Frequency it can run at. The value will be written to MSR register `0x774`, but only if MSR `0x770` is set to `1`. Otherwise, this register is unavailable. Check [this guide](https://www.tonymacx86.com/threads/skylake-hwp-enable.214915/) to figure out how to calculate the correct HWPValue for your CPU.

## UseARTFrequency
Processors of the Intel Skylake family have a new base frequency parameter which changes in smaller increments than the bus frequency, the so-called `ARTFrequency`. Its value is usually `24 MHz`. Clover can calculate it and commit it to the core. In practice, the calculated frequency leads to inaccurate operation, so it can simply be disabled. In this case the system core will act in its own way. In newer versions of Clover, this figure is rounded, as vit9696 believes there can be only three values, and they are round, up to `1 MHz`. You need to enable it to get speed shift working properly.

## TurboDisable
Disable Intel Turbo Boost Technology. Useful for Notebooks so they don't overheat.

## QEMU
When testing Clover in the QEMU virtual machine, developers discovered that it did not correctly emulate the Intel CPU. As a temporary measure, this key was created.

## C2, C4, C6 (deprecated)
Parameters related to C-state. This section is deprecated and has since been moved to &rarr; [**ACPI**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#enable-c2-c4-c6-and-c7)

- `C2`: Set to false on modern computers
- `C4`: According to the specification, either use C3 or C4. We choose C4. For Ivy Bridge, set it to false.
- `C6`: only for mobile computers. However, you can try to enable it on desktops as well. Set to true for Ivy Bridge and Haswell CPUs.

Note that with these C-States, people often complain about issues with sound/graphics and sleep. So be careful, or exclude them altogether.
