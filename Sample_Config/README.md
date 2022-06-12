## Plea for a better `config-sample.plist` (work in progress)

This is my attempt to provide a better and more relevant `config-sample.plist` than the one that's currently included in the Clover Package. Im my personal opinon, the current sample config is a mess – expecially in regards to the ACPI section.

### ACPI
![ACPI01_bad](https://user-images.githubusercontent.com/76865553/173228912-69daf7b3-b1ef-4e4d-97da-be3a28bd55f5.png)
![ACPI02_bad](https://user-images.githubusercontent.com/76865553/173228922-1c47e00a-ffc8-4e4e-af6b-77360c4e3658.png)

Listed below are issues with the current settings in the ACPI Section.

#### Patches
- `HECI` to `IMEI` &rarr; handled by Whatevergreen for the longest time
- `GFX0` to `IGPU` &rarr; handled by Whatevergreen as well
- Unless you are using a Notebook, you don't need *any* patches in this section by default!

#### DSDT Fixes:
- Most of the pre-selected Fixes are deprecated and don't work on modern systems and current macOS. Why they are still activated is a mystery to me (too many to name here)
- `DSDT name` field inclused name of DSDT.aml. WHY? Patched DSDTs are a thing of the past! This field is supposed to be left blank!

#### SSDT
- Plugin Type left empty… why?

### Boot
- Legacy enabled? Why?
- XMP Detection disabled?! WHy?
- No Early Progress not selected? Why? YOu like slow boot?

### Devices
#### USB
