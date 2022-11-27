# A better `config-sample.plist`

:warning: Don't use the `config-sample.plist` that comes with the Clover Package!

**TABLE OF CONTENTS**

- [Preface](#preface)
- [ACPI Section](#acpi-section)
- [Boot Section](#boot-section)
- [Boot Graphics Section](#boot-graphics-section)
- [CPU Section](#cpu-section)
- [Devices Section](#devices-section)
- [Disable Drivers](#disable-drivers)
- [GUI](#gui)


## Preface
Unfortunately, the config sample included in the Clover Package is a complete mess. It seems to me that in order to populate every section of the config, settings were enabled randomly without applying any common sense whatsoever.

Therefore, my advice is: don't use it! Instead, open Clover Configurator and create a new empty config by pressing **CMD+N** and follow the [Clover Desktop Guide](https://hackintosh.gitbook.io/r-hackintosh-vanilla-desktop-guide/) and add the missing Quirks. This way the config also gets a lot smaller in size which which improves the boot process.

Next, see each section for setting I recommend.

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

## [GUI](https://github.com/5T33Z0/Clover-Crate/tree/main/GUI)
- Set `Mode` to `Custom` and select:
	- Entries
	- Tools 

To be continued…
