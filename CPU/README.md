# CPU
This group of parameters helps with determining the CPU when the internal algorithms fail. This section is only covered here for the sake of completeness. The bottom line is: **you don't change anything here unless it's unavoidable and you know what you are doing!** 

![CPU](https://user-images.githubusercontent.com/76865553/136802820-de658522-dad5-494c-b8a0-1362202f94ad.jpeg)

### Frequency MHz
Describes the base frequency in MHz displayed in the System-Profiler. In other words: its effects are purely cosmetic. Usually, Clover automatically calculates this value based on the ACPI timer, but if it gets it wrong, you can correct it through this key. 

### Bus Speed in kHz
Describes the base bus frequency in **kHz**. The bus frequency is critical for stable operation of the system. It's handed over from the bootloader to the kernel. If the frequency is wrong, the kernel won't start at all. If the frequency is slightly off, there can be problems with the clock, resulting in strange system behavior.

Starting with Clover r1060, there the bus frequency is detected automatically based on data from the ADC Timer which calculates these values ​​more precisely than the value which is stored in the DMI (Desktop Management Interface). 

### Latency
Describes the delay for turning on the C3 state. The critical value is **0x3E8** = **1000**. Less and Speedstep turns on, more and it does not turn on. On real Macs, it is always set to **0x03E9** (1001) which disables Speedstep. On Hacks, we can choose if we want to behave it like a Mac or if we want to turn on power management. A reasonable value for the latter is **0x00FA** (250), which is found on some laptops (MacPro5.1 = 17, MacPro6.1 = 67, iMac13.2 = 250).

### C2, C4, C6
Parameters related to C-state. **ATTENTION!** This section is deprecated and has since been moved to &rarr; [**ACPI**](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI#enable-c2-c4-c6-and-c7)

- `C2`: Set to false on modern computers
- `C4`: According to the specification, either use C3 or C4. We choose C4. For IvyBridge, set it to false. 
- `C6`: only for mobile computers. However, you can try to enable it on desktops as well. Set to true on IvyBridge and Haswell.

Note that with these C-States, people often complain about issues with sound/graphics and sleep. So be careful, or exclude them altogether. 

### QEMU
When testing Clover in the QEMU virtual machine, developers discovered that it did not correctly emulate the Intel CPU. As a temporary measure, this key was created.

### QPI
In the System Profiler, this value is called "Processor Bus Speed" ​​or simply "Bus Speed". For Clover, an algorithm has been developed to calculate the correct value based on data sheets from Intel. In the source code of the `AppleSmbios` kernel, two methods of setting this value are available: the value either exists in SMBIOS already, prescribed by the manufacturer, or BusSpeed * 4 is simply calculated. After much debate, this value has been added to the config - write what you like (in MHz). 

This does not affect work in any way - it's pure cosmetics. **According to the latest information, QPI makes sense only for CPUs of the Nehalem family**. For everyone else here you need to have BusSpeed ​​* 4. Or nothing at all. If you force 0, then DMI table 132 will not be generated at all.

### Type
This parameter was invented by Apple and is used in the "About this Mac" window to display information about the used CPU, which internally translates into a processor designation. Otherwise, "Unknown processor" will be displayed. 

Basically, Clover knows all the ciphers, but since progress does not stand still, it is possible to manually change this value. Correcting this this changes what's displayed in the  "About this Mac" window - purely cosmetic. There is information from vit9696: [AppleSmBIOS](https://github.com/acidanthera/OpenCorePkg/blob/master/Include/Apple/IndustryStandard/AppleSmBios.h)

### TDP
Describes the Thermal Design Power (in Watts), taken into account in the P-States when generating the Processor Power Management tables. You can find the TDP for your CPU on [Intel's Product Specifications Website](https://ark.intel.com/content/www/us/en/ark.html#@Processors)

### SavingMode
Another interesting parameter for controlling [Speedstep](https://en.wikipedia.org/wiki/SpeedStep). It affects the MSR `0x1B0` register and determines the behavior of the processor:

- `0`: Maximum Performance
- `15`: Maximum Energy Saving

### HWPEnable
Starting with Clover r3879, Intel Speed ​​Shift technology has been introduced in Skylake CPUs. If enabled, then `1` is written to the MSR `0x770` register. Unfortunately, if the computer enters sleep and then wakes up, the MSR value `0x770` will be reset to `0` and Clover cannot re-enable it. But with a help of the [**HWPEnable.kext**](https://github.com/headkaze/HWPEnable) this can be fixed.  

### HWPValue
This value turned out to be the most appropriate. It value will be written to MSR register `0x774`, but only if MSR `0x770` is set to `1`. Otherwise, this register is unavailable. 

### UseARTFrequency
Processors of the Intel Skylake family have a new base frequency parameter which changes in smaller increments than the bus frequency, the so-called `ARTFrequency`. Its value is usually `24 MHz`. Clover can calculate it and commit it to the core. In practice, the calculated frequency leads to inaccurate operation, so it can simply be disabled. In this case the system core will act in its own way. In newer versions of Clover, this figure is rounded, as vit9696 believes there can be only three values, and they are round, up to `1 MHz`.

### TurboDisable
Disable Intel Turbo Boost Technology. Useful for Notebooks so they don't overheat.
