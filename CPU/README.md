# CPU
This group of parameters helps with determining the CPU when the internal algorithms fail. This section is only covered here for the sake of completeness. The bottom line is: **you don't change anything here unless it's unavoidable!** 

![](/Users/kl45u5/Desktop/Neuer Ordner/CPU.jpeg)

### Frequency MHz
Describes the base frequency in MHz displayed in the System-Profiler. In other words: its effects are purely cosmetic. Usually, Clover automatically calculates this value based on the ACPI timer, but if it gets it wrong, you can correct it through this key. 

### Bus Speed in kHz
Describes the base bus frequency in **kHz**. The bus frequency is critical for stable operation of the system. It's handed over from the bootloader to the kernel. If the frequency is wrong, the kernel won't start at all. If the frequency is slightly off, there can be problems with the clock, resulting in strange system behavior.

Starting with Clover r1060, there the bus frequency is detected automatically based on data from the ADC Timer which calculates these values ​​more precisely than the value which is stored in the DMI (Desktop Management Interface). 

### Latency
Describes the delay for turning on the C3 state. The critical value is **0x3E8** = **1000**. Less and speedstep turns on, more and it does not turn on. On real Macs, it is always set to **0x03E9** (1001) which disables speedstep. On Hacks, we can choose if we want to behave it like a Mac or if we want to turn on power management. A reasonable value for the latter is **0x00FA** (250), which is found on some laptops (MacPro5.1 = 17, MacPro6.1 = 67, iMac13.2 = 250).

### C2, C4, C6
Parameters related to C-state. **ATTENTION!** This section is deprecated and has since been move to &rarr; ACPI Section!

- `C2`: Set to false on modern computers
- `C4`: According to the specification, either use C3 or C4. We choose C4. For IvyBridge, set it to false. 
- `C6` is known only on mobile computers. However, you can try to enable it on desktops as well. Set to true on IvyBridge and Haswell.

Note that with these C-States, people often complain about poor sound/graphics/sleep. So be careful, or exclude them altogether. 

### QPI

### Type

### TDP

### SavingMode

### HWPEnable

### HWPValue


