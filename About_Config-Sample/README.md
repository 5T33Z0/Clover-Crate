# Clover's problematic config-sample.plist

:warning: Don't use the `config-sample.plist` that comes with the Clover Package!

**TABLE OF CONTENTS**

- [Preface](#preface)
- [ACPI Section](#acpi-section)
- [Boot Section](#boot-section)
- [Boot Graphics Section](#boot-graphics-section)
- [CPU Section](#cpu-section)
- [Devices Section](#devices-section)
- [Disable Drivers](#disable-drivers)
- [GUI Section](#gui-section)
- [Graphics](#graphics)
- [Kernel and Kext Patches Section](#kernel-and-kext-patches-section)
- [RT Variables Section](#rt-variables-section)
- [SMBIOS Section](#smbios-section)
- [System Parameters Section](#system-parameters-section)
- [Quirks Section](#quirks-section)

## Preface
Unfortunately, the config sample included in the Clover Package is a complete mess. It seems to me that in order to populate every section of the config, settings were just enabled randomly without applying any common sense whatsoever.

Therefore, my advice is: don't use it! Instead, open Clover Configurator and create a new empty config by pressing **CMD+N** and follow the [Clover Desktop Guide](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) and add the missing Quirks. This way the config also gets a lot smaller in size which which improves the boot process.

Below you find a list of issues I am having with the sample config as well as recommended settings for each section. Clicking on the headlines forwards you to the corresponding chapter which explains every option in detail.

## [ACPI Section](https://github.com/5T33Z0/Clover-Crate/tree/main/ACPI)
See the corresponding section to find out what each option/setting does!

- `DSDT/Patches`: leave empty. Most binary renames are unnecessary nowadays, since they handled by Kexts like Whatevergreen and AppleALC. Unless you have to redefine certain methods (usually required when working with laptops), Use SSDT hotfixes included in the OpenCore Package or my OC Little Repo instead.
- `DSDT/Fixes`: Most of these fixes in this section are obsolete but the following are still relevant and can be used to substitute the following SSDTs:
	|SSDT | Clover DSDT Fix(es)
	|:--------:|----------------------|
	`SSDT-AC`| Enable `FixAdp1` instead
	`SSDT-DTGP` | Enable `AddDTGP` to inject the `DTGP` method into the `DSDT` instead
	`SSDT-HPET`| Enable `FixHPET`, `FixIPIC`, `FixTMR` and `FixRTC` to fix IRQ conflicts instead. You also don’t need the accompanying rename `change_CRS to XCRS` which is required in OpenCore.
	`SSDT-SBUS-MCHC`|Enable `AddDTGP`, `AddMCHC` and `FixSBUS`instead. `AddDTGP` is required because the code snippet added by Clover when `FixSBUS` is enabled, uses `DTGP` to pass through arguments. Otherwise you will find a "unknown method" compiler comment about `DTGP` the end of your `DSDT`.
	None| Enable `DeleteUnused` to remove some unused legacy devices from the `DSDT`
- `SSDT`: leave empty. Use `SSDT-PLUG` instead
- `Disabled AML`: leave empty
- `Sorted Order`: leave empty unless you are using SSDTs which have to be loaded in a specific order
- `Drop Tables`: leave empty unless certain tables need to be dropped
- `Debug`, `Rtc8Allowed`, `ReuseFFFF`, `Suspend Override` and `DSDT Name`: leave empty
- Enable: `Fix Headers`	, `FixMCFG` (might not even be needed)

## [Boot Section](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot)
See the corresponding section to find out what each option/setting does!

- `Arguments`: enter boot arguments. For Installation, useful ones are: `-v`, `debug=0x100` and `keepsyms=1`
- `Legacy`: select an empty field from the dropdown menu
- `Default Loader`: leave empty
- `XMPDetection`: select `YES` if your RAM and BIOS supports Xtreme Memory Profiles, otherwise select `NO`
- Next, enable the following settings:
	- `No early Progress`
	- `Never hibernate`
	- `Never do Recovery`

## [Boot Graphics Section](https://github.com/5T33Z0/Clover-Crate/tree/main/Boot_Graphics#readme)

- `DefaultBackgroundColor`: delete `0xBFBFBF` unless you want your background to be this [gray](https://www.htmlcsscolor.com/hex/BFBFBF)
- `EFILoginHiDPI`: only enable if your screen supports HiDPI mode
- `UIScale`: leave at `1` for regular and Full HD displays, set to `2` for 4k Displays 
- `Flagstate`: undocumented… leave empty

## [CPU Section](https://github.com/5T33Z0/Clover-Crate/tree/main/CPU)

- Leave as is

## [Devices Section](https://github.com/5T33Z0/Clover-Crate/tree/main/Devices)

- You can add your ALC Layout ID here, if it's not set via Device Properties
- Disable `FixOwnership` since it's only required for legacy systems
- Otherwise leave as is.

## Disable Drivers

- Leave empty

## [GUI Section](https://github.com/5T33Z0/Clover-Crate/tree/main/GUI)
- Set `Scan` to `Custom` and select:
	- `Entries`
	- `Tools`
- `Hide Volume`: Add `Recovery` and additional entries which should not be shown in the Clover GUI. Don't hide the Pre-Boot Volume for Big Sur and newer since it's needed to boot the system.
- `Timezone`: only required if you are using an embedded theme like "Clovy" which supports switching between light and dark mode based on the time of day (needs to be combined with the `Daytime` option from the `EmbeddedThemeType` menu). It's based on Greenwhich Meantime (GMT), so add or subtract the number of hours for your area. **Examples**: Berlin = `1`, N.Y. = `-5`, L.A = `-8`, Tokyo = `9`

## [Graphics](https://github.com/5T33Z0/Clover-Crate/tree/main/Graphics)

- Leave empty and use Devices/Properties to add Framebuffer Patches instead!

## [Kernel and Kext Patches Section](https://github.com/5T33Z0/Clover-Crate/tree/main/Kernel_And_Kext_Patches)

- :warning: Delete `FakeCPUID` value. It's a real problem that this is even in there since it emulates another CPU which you don't want if your CPU is supported by macOS. It's a big nono that this is enable in the sample!
- Delete all the rules in the `KextToPatch` and `KernelToPatch` section that you don't need! Read the comments if you are unsure.
- Set Kernel Patches as needed for your system!

## [RT Variables Section](https://github.com/5T33Z0/Clover-Crate/tree/main/RtVariables)

- Delete `MLB` (add it AFTER generating your own serial in the SMBIOS section)
- `CsrActiveConfig`: either delete (SIP enabled) or set specific value based on macOS. You can use my [Clover Calculators Spreadsheet](https://github.com/5T33Z0/Clover-Crate/tree/main/Xtras) to do so. Regurlarly used ones to disable SIP are:
	- High Sierra: `0x3EF`
	- Mojave/Catalina: `0x7EF`
	- Big Sur and newer: `0x867` and `0xFEF` (disables SIP Completely. Not recommended since system updated don't work with this) 

## [SMBIOS Section](https://github.com/5T33Z0/Clover-Crate/tree/main/SMBIOS)

- Generate the SMBIOS for your system

## [System Parameters Section](https://github.com/5T33Z0/Clover-Crate/tree/main/System_Parameters)

- Disable `InjectKexts` &rarr; This parameter is obsolete since this option is depends on `FSInject.efi` which is no longer used to inject Kexts. Instead OpenCore's `OpenRuntime.efi` handles Kext injections now. So unless you are using legacy Clover (r5124 and older) this option does nothing at all.

## [Quirks Section](https://github.com/5T33Z0/Clover-Crate/tree/main/Quirks)

- Set Quirks as required for your combination of CPU and Mainboard. Don't leave this section as is or your system won't boot!
