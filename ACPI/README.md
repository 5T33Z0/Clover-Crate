# ACPI
![ACPI](https://user-images.githubusercontent.com/76865553/148648883-a0d3984c-254a-4a73-b02b-16439c6bc9a1.png)

The **ACPI** section not only is the first but also the most important one (along with Kernel Patches and Quirks). It offers many options to affect the ACPI tables of your system in order to make it compatible with macOS: from replacing characters in the `DSDT`, renaming devices, enabling features to applying patches. Since this section is the centerpiece of your `config.plist`, every available option is explained in detail.

<details><summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

- [AutoMerge](#automerge)
- [Disable ASPM](#disable-aspm)
- [FixHeaders](#fixheaders)
- [FixMCFG](#fixmcfg)
- [Halt Enabler](#halt-enabler)
- [Patch APIC](#patch-apic)
- [Reset Address / Reset Value](#reset-address--reset-value)
- [Smart UPS](#smart-ups)
- [DSDT](#dsdt)
	- [Patches](#patches)
		- [DropOEM\_DSM](#dropoem_dsm)
	- [TgtBridge](#tgtbridge)
		- [About the `TgtBridge` Bug (fixed since Clover r5123.1)](#about-the-tgtbridge-bug-fixed-since-clover-r51231)
	- [Rename Devices](#rename-devices)
		- [Using the `RenameDevices` feature for renaming Methods](#using-the-renamedevices-feature-for-renaming-methods)
			- [Comparison: renaming Methods with `TgtBridge` vs. `RenameDevices`](#comparison-renaming-methods-with-tgtbridge-vs-renamedevices)
		- [Excursion: Renaming Devices Basics](#excursion-renaming-devices-basics)
	- [Fixes](#fixes)
		- [AddDTGP](#adddtgp)
			- [DTGP Explained](#dtgp-explained)
		- [AddHDMI](#addhdmi)
		- [AddIMEI](#addimei)
		- [AddMCHC](#addmchc)
		- [AddPNLF](#addpnlf)
		- [PNLF\_UID](#pnlf_uid)
		- [DeleteUnused](#deleteunused)
		- [FakeLPC](#fakelpc)
		- [FixACST](#fixacst)
		- [FixADP1](#fixadp1)
		- [FixAirport](#fixairport)
		- [FixDarwin](#fixdarwin)
		- [FixDarwin7](#fixdarwin7)
		- [FixDisplay](#fixdisplay)
		- [FixFirewire](#fixfirewire)
		- [FixHDA](#fixhda)
		- [FixHPET](#fixhpet)
		- [FixIDE](#fixide)
		- [FixIPIC](#fixipic)
		- [FixIntelGfx](#fixintelgfx)
		- [FixLAN](#fixlan)
		- [FixMutex](#fixmutex)
		- [FixRTC](#fixrtc)
		- [FixRegions](#fixregions)
		- [FixS3D](#fixs3d)
		- [FixSATA](#fixsata)
		- [FixSBus](#fixsbus)
		- [FixShutdown](#fixshutdown)
		- [FixTMR](#fixtmr)
		- [FixUSB](#fixusb)
		- [FixWAK](#fixwak)
- [SSDT](#ssdt)
	- [C3 Latency](#c3-latency)
	- [Double First State](#double-first-state)
	- [DropOEM](#dropoem)
	- [Enable C2, C4, C6 and C7](#enable-c2-c4-c6-and-c7)
	- [Generate Options](#generate-options)
		- [APSN/APLF](#apsnaplf)
		- [CStates](#cstates)
		- [PStates](#pstates)
		- [PluginType](#plugintype)
	- [Min Multiplier](#min-multiplier)
	- [Max Multiplier](#max-multiplier)
	- [NoDynamicExtract](#nodynamicextract)
	- [NoOEMTableID](#nooemtableid)
	- [PLimit Dict](#plimit-dict)
	- [Use SystemIO](#use-systemio)
	- [UnderVolt Step](#undervolt-step)
- [Drop Tables](#drop-tables)
- [DisabledAML](#disabledaml)
- [Sorted Order](#sorted-order)
	- [Debug](#debug)
	- [ReuseFFFF (Deprecated)](#reuseffff-deprecated)
	- [RTC8Allowed](#rtc8allowed)
	- [SuspendOverride](#suspendoverride)
	- [DSDT Name](#dsdt-name)
- [Resources](#resources)
</details>

## AutoMerge

![AutoMerge](https://user-images.githubusercontent.com/76865553/135732535-ca43869b-4e97-47b2-a490-9c8aa5488fa8.png)

Merges any `DSDT` and `SSDT` changes from `/ACPI/patched` with existing ACPI tables.

If set to `true`, it changes the way `.aml` files in the `ACPI/patched` folder are applied. Instead of appending these tables at the end of the `DSDT` they will replace existing tables, if their signature, index and `OemTableIds` match existing OEM tables. In other words, they will be merged with existing ACPI tables.

With this function – as with `DSDT` – you can fix individual SSDTs (or other tables) simply by adding the corrected file(s) into `ACPI/patched`. No need to fiddle with `DropOem` or `DropTables`. The original order is preserved. The mapping for `SSDT` is based on naming, where the naming convention used by the F4 extractor in the loader menu is used to identify the `SSDT` position in `DSDT`.

For example, if your `ACPI/origin` folder contains a `SSDT-6-SaSsdt.aml` you could just fix it and place it in `ACPI/patched`. This also works if you rename it (for example `SSDT-6.aml`). Since some OEM ACPI sets do not use unique text in the OEM table-id field, Clover uses both the OEM table-id and the number that is part of the file name to locate the original in `XDST`. As long as you stick to the names provided in `ACPI/origin`, you should be fine.

This way, you could find the SSDT containing all the 26 Ports for your board in the dumped ACPI, fix it, place it in the `ACPI/patched` folder and boom: no more `USBports.kext` required. 

**TIP**: `AutoMerge` can also be useful in cases where dropping a table fails for unknown reasons. While I was trying to figure out why my 3rd party Ethernet Card wouldn't connect to the internet when using Clover (it worked fine when using OpenCore), I noticed that the `DMAR` table wasn't dropped when using maciASL's "New from ACPI" feature. Instead, two `DMAR` tables were present: the original one and my modified version located under `ACPI/patched`. After enabling `AutoMerge` and a reboot, there was only one `DMAR` table (the corrected one) and internet worked. So if you can't drop a table, you can always replace it with a corrected one by merging, as long as the Table Signature/OEM Table ID matches.

## Disable ASPM

Active-state power management (ASPM) is a power management mechanism for PCI Express devices to garner power savings while otherwise in a fully active state. It is normally used on laptops and other mobile Internet devices to extend battery life.

This patch affects the settings of the ACPI system itself, such as the fact that Apple's ASPM management does not work as expected. For example when using non-native chipsets. You can also modify ASPM settings via [device properties](https://github.com/5T33Z0/OC-Little-Translated/tree/main/04_Fixing_Sleep_and_Wake_Issues/Setting_ASPM_Operating_Mode).

**OpenCore** equivalent: Use DeviceProperty `pci-aspm-default` | Type: `Data` | Value: `00`

## FixHeaders

`FixHeaders` will check the table headers of all ACPI tables for illegal characters (like Chinese characters) and removes them since macOS can't handle them and panics instantly. This issue has been fixed in macOS Mojave, but in High Sierra you may still need it.

Whether you have a problem with tables or not, it's safe to enable this fix. It is recommended for all users, even if you are not having to fix your `DSDT`. Old settings inside DSDT/Fixes section remain for backward compatibility, but I recommend deleting them.

## FixMCFG

The `MCFG` (Memory Mapped Configuration Table) describes the location of the PCI Express configuration space. It will be present in firmware implementations compliant with ACPI specs 3.0 (or later). This fix might be helpful when using a MacBook or MacBookPro SMBIOS. The author of the patch is vit9696.

If `FixMCFG` is enabled, the `MCFG` table will be corrected. However, discarding this table is also possible by using the "Drop Tables" feature. 

**Verifying procedure**: To check if you need this fix, enable it and reboot. Once you're back in macOS, open the original MCFG table (stored in EFI/CLOVER/ACPI/origin) and compare it with the fixed one: in maciASL, click on "File" > "New from ACPI" and select "MCFG". If both tables are identical (in terms of values), you don't need this fix. 

This procedure applies to all fixes aimed at specific tables in general (apart from the ones affecting the `DSDT`)!

## Halt Enabler

This patch fixes shutdown/sleep issues caused by incorrectly initialized chipsets during UEFI boot. Symptoms: the system doesn't enter sleep state (the screen turns off, but the fans don't).

The fix is injected before calling `boot.efi`, clearing `SLP_SMI_EN` before booting macOS. Nevertheless, it is quite safe, at least on Intel systems.

**OpenCore** equivalent: `ACPI/Quirks/FadtEnableReset`.

## Patch APIC 

`APIC` stands for Advanced Programmable Interrupt Controller. Its parameters are defined in the `MADT` (Multiple APIC Description Table). If this table is missing the "NMI" section, the system can only boot by setting the kernel parameter `cpus=1` or with a patched kernel (Lapic NMI). `Patch APIC` fixes this table on the fly so the system can boot. If the table is complete already, nothing will be changed.

## Reset Address / Reset Value

These two parameters serve a common purpose - to fix restart. They should be present in the `FACP`/`FADT` table, but that's not always the case. Sometimes the table is shorter than expected, so both values are missing. In OpenCore, the equivalent is `ACPI/Quirks/FadtEnableReset`.

- `Reset Address`: lets you change the `Address` in `Reset Register` section of the `FACP` table (example):
	
	```asl
	...
	[074h 0116  12]               Reset Register : [Generic Address Structure]
	[074h 0116   1]                     Space ID : 01 [SystemIO]
	[075h 0117   1]                    Bit Width : 08
	[076h 0118   1]                   Bit Offset : 00
	[077h 0119   1]         Encoded Access Width : 00 [Undefined/Legacy]
	[078h 0120   8]                      Address : 0000000000000CF9 // THIS WILL BE CHANGED BY `Reset Address`
	...
	```
- `Reset Value`: lets you change the value in the `Value to cause reset` section of the `FACP` table:

	```asl
	...
	[080h 0128   1]         Value to cause reset : 06
	...
	```

**Possible combinations**:

Reset Address /</br>Reset Value | Description
:-------------------------------:|------------
`0x0`/`0x0` </br>(or empty) | Uses the default method defined in the `FACP` table, if present.  Otherwise `0x64`/`0xFE` are set as defaults.
`0x0CF9`/`0x06` | Resets the system via **System Management Mode** (SMM) of the PCI bus – just like a real Mac. This is fast since the SMM operates at a higher level of privilege than the operating system and is capable of bypassing certain hardware and software layers. But this does not work on all systems.
`0x64`/`0xFE` | Resets the System via the **PS/2 Controller**. Default if  `Reset Address` and `Reset Value` are left empty. Resetting the system via the PS/2 controller may be faster than resetting it via software, as the PS/2 controller is a hardware device that is directly connected to the CPU and is responsible for handling keyboard and mouse input.
`0x92`/`0x01` | Resets the system via the **Programmable Interrupt Controller (PIC)**. The PIC is responsible for routing IRQs from various devices, such as the keyboard and mouse, to the CPU for processing. This may be faster than resetting via software, as the PIC is responsible for managing interrupt requests (IRQs) in the system and directing them to the appropriate processing units.

:bulb: **TIPS**

- Check the pre-defined value in the `FACP` table before changing them
- You only need to change these values if shutdown/reset takes really long or doesn't work at all
- Try all 3 methods to figure out which one works best for you. I have had good results by resetting via SMM. Resetting via PIC and PS/2 did quit macOS but didn't reset/shutdown the system.

## Smart UPS

This parameter affects the selected power profile, which will be written into the `FADT` table and changes it to profile `3`. The logic is as follows:

`PM=1` - Desktop , mains power </br>
`PM=2` - Notebook, mains or battery power </br>
`PM=3` - Server, powered by SmartUPS, which macOS also supports

Clover will choose between `1` and `2` based on an analysis of the mobility bit, but there is also a Mobile parameter in the SMBIOS section. You can say, for example, that we have a MacMini and that it is mobile. A value of `3` will be substituted if `smartUPS=Yes`.

## DSDT
### Patches
In this sub-section of `ACPI`, you can add renaming rules (binary renames) to replace text inside your system's `DSDT` dynamically in binary code, represented by hex values. In other words, you replace text (characters, digits and symbols) with other text to either avoid conflicts with macOS or to make certain devices/features work within macOS by renaming them to something it knows.

![Bildschirmfoto 2021-05-16 um 07 27 17](https://user-images.githubusercontent.com/76865553/135732656-82fe792e-7225-4255-beb9-d1074eb1522b.png)

If you look at the first renaming rule, `change EHC1 to EH01`, it consists of a `Find` value of `45484331` and a `Replace` value of `45483031` which literally translates to `EHC1` and `EH01` if you decode the hex values back to text with the Hex Converter in the "Tools" section of Clover Configurator. Which renames to use when depends on your system's ACPI Tables, used macOS version, etc. and is not part of this overview.

:bulb: During my tests I realized that the rename rules created here are *not* limited to the `DSDT` – they apply system-wide! If you want to restrict renames to the `DSDT` only, you probably have to make use of the `TgtBridge`.

#### DropOEM_DSM
>Deprecated since r5116. 

OEM DSDTs often contain `_DSM` methods which were written for Windows and don't work reliably in macOS. These methods can't be present if we want to write own `_DSM` methods. The patch `DropOEM_DSM` assumes that the user check's which DSM he wants to drop from devices. But nobody used it! 

The best way is to rename all OEM `_DSM` occurrences to `ZDSM` instead:

```
Comment: change _DSM to ZDSM
Find: 5F44534D
Replace: 5A44534D
```

### TgtBridge

The `TgtBridge` (= Target Bridge) can be used to limit the scope of a binary rename to a specific device within the `DSDT`. It's located in the `ACPI/DSDT/Patches` section of the Clover config. Using the `TgtBridge` is recommended to avoid that widely-used methods (like `_STA, _CRS` or `_INI` for example) are renamed in the whole of the DSDT which would otherwise most likely break it.

**Example**: renaming the method `_STA`to `_XSTA` in device `GPI0`:

![TGTBridgeExample](https://user-images.githubusercontent.com/76865553/135732680-641af3ba-8140-477a-9c9e-69345d8e9b8f.png)

As shown above, the name of the original Method `_STA` (pink) is converted to  hex (`5F535441`), so Clover can find it in the `DSDT`. If it finds this value it is then replaced by `58535441` (blue), which is the hex equivalent of the term `XSTA` (blue). If set like this, this patch would change *any* match ot the term `_STA` in the whole of the `DSDT` to `XSTA` which probably would break the system. To avoid this, you can use `TgtBridge` to specify and limit the matches of this patch to a specified name/device/method/area, in this case to the device `GPI0` (Cyan). Basically, you tell Clover: "In device `GPI0`, look for the method `_STA`. If it's present, rename it to `XSTA` but leave the rest of the `DSDT` alone!"

Which values to use in `TgtBridge` is up to you. If string lengths do not match, Clover will correctly account for the length change, with one exception: make sure it doesn't happen inside an "If" or "Else" statement. If you need such a change, replace the entire operator. Usually, you rename methods in devices just to disable them or to redefine them within a custom SSDT later.

The `Comment` field not only serves as a reminder about what a patch does, it is also serves as an item/entry in the Clover Boot Menu to enable/disable a patch. The initial value for `ON` or `OFF` is determined by the `Disabled` lines in the `config.plist`. The default value is `Disabled=false`. If you use someone else's set of patches, it is better to set them to `Disabled=true` and then enable them from the Boot menu one by one.

**OpenCore** equivalent: `Base` parameter in `ACPI/Patch` section

#### About the `TgtBridge` Bug (fixed since Clover [r5123.1](https://github.com/CloverHackyColor/CloverBootloader/releases/tag/5123.1))

Prior to the release of r5123.1, the `TgtBridge` had a bug, where it would not only rename matches found in the DSDT but also in all OEM SSDTs which was not intended. With the release of Clover r5123.1 (the last release supporting Aptio Memory Fixes), this bug was finally fixed.

To workaround this bug, users would have to create restore rules for every instance which utilized the TgtBridge to reverse the renames for all other matches as shown in this example:

![TgtBrige_workaround](https://user-images.githubusercontent.com/76865553/163777028-951e0d8e-abf2-4f2d-9612-3704aaf9f6e9.png)

In this example, you would tell Clover to look for `XSTA` and rename it `STA` for any devices which are not `GPIO`. I imagine that this workaround slows down boot times significantly since all tables have to be scanned up an down to replace and restore values. So if you are still using the "pre-OC" version of Clover with the bugged TgtBridge, you should definitely update it and disable/delete all these restore rules.

### Rename Devices
`RenameDevices` serves as a more refined method for renaming devices (and methods) which is less brute force than using a simple binary rename which replaces *every* occurrence of an expression throughout the *entirety* of ACPI tables, which can be problematic.

The rules created here apply to a `Device (xxxx)` or `Method (xxxx)` specified in the `Find Device` field and all sub-sequent occurrences of it in all other ACPI tables so that the device/method names remain congruent across the whole system while [avoiding false positives](https://www.insanelymac.com/forum/topic/304530-clover-change-explanations/?do=findComment&comment=2613951). 

In my opinion, `RenameDevice` is one of the best yet least utilized features of Clover, simply because people think it's for renaming devices only and because it's "hidden" in a 2nd Tab in Clover Configurator no one ever clicks on.

To use this section properly, you need a dump the unmodified `DSDT` and examine it with maciASL. In this case, we search for `ECH1`:

![Rename Devices](https://user-images.githubusercontent.com/76865553/135732661-ba636a72-9490-4c6f-a018-bdede3752fa6.jpg)

As you can see, the device exists and is located in `\SB_PCI0_EHC1` of the `DSDT`. Next, we tell Clover Configurator to replace the actual device name with `EH01` by adding it in the `Rename Device` field. After the patch is applied on the fly during boot, the device name and its dependencies have been changed:

![DSDT_patched](https://user-images.githubusercontent.com/76865553/135732669-9ac77cf7-5c5f-41a0-b98f-0ae1453411dc.png)

#### Using the `RenameDevices` feature for renaming Methods
It's not really documented, but can use the `RenameDevices` feature to rename Methods based on their ACPI path as well. It basically work's the same way as using the Target Bridge in the patch section. But instead of using the device name as reference, you enter the complete ACPI path to the method you want to rename which is even more precise. In my test, using `TgtBridge` vs. `RenameDevices` produced identical results.

##### Comparison: renaming Methods with `TgtBridge` vs. `RenameDevices`
Using the Target Bridge is the intended method for renaming methods inside of different devices, in this case 2 different devices, `TPM` and `VID`.
 
**DSDT Patches**:</br>![method_TGT_Bridge](https://user-images.githubusercontent.com/76865553/183251766-17bbf2c6-b1d9-417e-b3e8-b7b290502a9a.png)</br>
**Outcome in DSDT**:</br>![DSDT_TGT](https://user-images.githubusercontent.com/76865553/183251790-1effb6d5-9c44-4ce6-9ded-241fab89dc68.png)

But you can achieve the same simply by adding the ACPI path(s) to the method(s) you want to rename inside of a device the `RenameDevices` section instead without having to create a find and replace rule which requires converting words to HEX, etc.

**Rename Devices** Rules: </br>![Rendev](https://user-images.githubusercontent.com/76865553/183251818-221b4451-5f97-44bc-976b-3d79561d4a86.png)</br>
**Outcome in DSDT**:</br>![Rename_Devices](https://user-images.githubusercontent.com/76865553/183251834-bc70e0c1-f070-49b8-9cbf-aafdcca0841d.png)

So, which approach you apply is up to you. Using DSDT patches section has the advantage, that you can turn this rules as needed, which you can't do when using the `RenameDevices`feature. But on the other hand, you can specify exact locations to apply a patch to.

<details>
<summary><strong>Excursion: Renaming Devices Basics</strong> (click to reveal)</summary>

#### Excursion: Renaming Devices Basics

**I. About binary renames**

- The following device renames are standardized in order to match device names used in real Macs and to facilitate the creation of part patches.
- Renaming devices and methods (including [`_DSM`](https://patchwork.kernel.org/project/spi-devel-general/patch/8ce38be1389dfb0527961ccd0dedb609802b59c1.1498044532.git.lukas@wunner.de/)) are applied globally to a system's `DSDT`.

Following are examples of commonly renamed devices:

| Original Device | Renamed for macOS | Description            |
|:----------------| :----------------:| -----------------------|
| EC              | EC0               | Embedded Controller. Not recommended!
| EHC1            | EH01              | USB Controller
| EHC2            | EH02              | USB Controller
| LPC             | LPCB              | LPC Bus
| SAT1            | SATA              | SATA Drive
| XHCI            | XHC               | USB Controller
| Keyboard        | PS2K              | Keyboard
| System Bus      | SBUS              | System Management Bus
| Cover           | LID0              | Lid device (on Laptops)
| PowerButton     | PWRB              | Power Button Device
| Sleep Button    | SLPB              | Sleep Button Device

**II. Binary Rename examples**

**Prerequisites**: In order to apply these renames correctly, you need a dump of your System's `DSDT`!

Names like `_DSM` with and underscore in front of them define a method. These are usually renamed by replacing the `_` with a `X` (like `XDSM`) which basically disables the method (`XDSM`), so a different or custom method can be applied.

| Rename      | Description                      |
| :---------: | -------------------------------- |
| **_DSM to XDSM**| Other Patch Requirements         |
| **LPC to LPCB** |In `DSDT`, search for `0x001F0000`.</br> 1: If the device name is already `LPCB`, there is no need to change the name.</br> 2: If there are multiple matches for `0x001F0000`, carefully determine whether this name change is needed or not </br>3:If ACPI includes an `ECDT.aml`, check "About `ECDT` correction method|
| **EC to EC0**   | Changes name of Embedded Controller. In DSDT, check the device belonging to `PNP0C09`.</br>1:If the device name is already `EC0`, no renaming is required </br>2:If there are multiple matches for `0PNP0C09`, confirm the real `EC` name </br>3:If ACPI package includes `ECDT.aml`, see "About ECDT and how to fix it"|.|
|**H_EC to EC0**|Same as EC|
|**ECDV to EC0** (dell)|Same as EC|
|**EHC1 to EH01**| Renames USB Controller. For machines with USB2.0, query the device name of `0x001D0000`.
|**EHC2 to EH02**| For a 2nd USB Controller
|**XHCI to XHC_**| Changes name of modern USB Controller. Check the device name belonging to `0x00140000`. If the device name is already `XHC`, no binary rename is necessary|
|**XHC1 to XHC_**|Same as XHCI|
|**KBD to PS2K**|Rename for Keyboard. Check the device name of `PNP0303`, `PNP030B`, `PNP0320`. If the keyboard name cannot be determined in `DSDT`, check the "BIOS name" of the keyboard in Windows Device Manager. If keyboard is named `PS2K` already, no rename is required|
|**KBC0 to PS2K**|same|
|**KBD0 to PS2K**|same|
|**SMBU to SBUS**|Renames System Management Bus. Most ThinkPads require this. </br>Before 6th Gen, search the device name belonging to "0x001F0003" </br>6th Gen and later machines: search "0x001F0004" belonging to the device name </br>If the device name `SBUS` already, a rename is not required|
|**LID to LID0**| Search the device name belonging to `PNP0C0D` and rename it to `LID0`
|**PBTN to PWRB** (dell)| Search device belonging to `PNP0C0**C**` and rename it to `PWRB`
|**SBTN to SLPB** (dell)| Sleep Button rename. Search device belonging to `PNP0C0**E**`. If the name is `SLPB` already, no need for a rename.

To convert any text to a hex you can use the HEX Converter inside of Clover Configurator.
</details>

### Fixes

![Bildschirmfoto 2021-05-16 um 07 28 34](https://user-images.githubusercontent.com/76865553/135732689-dd1271db-f11d-468b-a57e-576bcf7f7d76.png)
![Bildschirmfoto 2021-05-16 um 08 04 15](https://user-images.githubusercontent.com/76865553/135732698-6ead0af4-304c-4570-a407-aaafb70506f2.png)

The `DSDT` (Differentiated System Description Table) is the largest and most complex of the ACPI tables included in your mainboard's BIOS/Firmware. It describes devices and methods of accessing them. Access methods can contain arithmetic and logical expressions. To correct this table manually, profound knowledge of programming in the ACPI Source Language (ASL) is mandatory.

Fortunately, Clover provides automated, selectable `Fixes`, which can be applied to the DSDT on the fly during boot to add/rename devices or fix common problems which need to be addressed before macOS is happy with the provided DSDT. This method is not as clean as patching every issue via a SSDT (like OpenCore requires), but it's an easily accessible and valid approach to fix your DSDT.

Listed below are the included DSDT `Fixes` provided by Clover (about 30) and what they do. Note that these fixes have been accumulated over the years – some of them might be deprecated nowadays. Remember: just because a fix is available, it doesn't mean that you need it or that it still works with current hardware or macOS versions.

To get a better understanding for fixes that are still relevant in 2022, take a look at my [**Desktop**](https://github.com/5T33Z0/Clover-Crate/tree/main/Desktop_Configs) and [**Laptop**](https://github.com/5T33Z0/Clover-Crate/tree/main/Laptop_Configs) configs before getting all click-happy and just randomly enable every available fix!

**TIP**: Use `Fixes` sparsely. Instead, apply SSDT hotpatches included in the OpenCore package or from my [**OC-Little Repo**](https://github.com/5T33Z0/OC-Little-Translated) to fix your `DSDT`.

#### AddDTGP

Enabling `AddDTGP` injects the `DTGP` method into the  `DSDT` during boot, so that it can be utilized by other fixes and patches. It doesn't do anything on its own.

**NOTE**: OpenCore users can add `SSDT-DTGP.aml` instead. But since OC heavily relies on self-contained SSDT hotpatches to make devices work instead of patched DSDTs, the `DTGP` method is rarely used/required. 

##### DTGP Explained

In addition to `DeviceProperties`, you can also use the method `_DSM` (Device Specific Method) to do so. It contains properties for a device and makes use of the method `DTGP` which is universal for all devices. It is specified in the `DSDT` of real Macs. Its purpose is to inject custom parameters into some devices. Without this method, patched `DSDTs` would not work well. 

Basically, macOS won't actually read/merge device properties from ACPI unless a Buffer of `0x03` is returned when it asks for this property (`Arg0` = UUID, `Arg1` = 1 and `Arg2` = 0).

`DTGP` passes through calls to device-specific methods on various Device objects, unless a specific `UUID` is provided that indicates that macOS is calling the `_DSM`. macOS has a non-standard device enumeration behavior: it first probes each ACPI Device's `DSM` by passing over only 2 arguments (one of which is the `UUID`). macOS then expects the `_DSM` to return the number of additional arguments that can be used. It's fine if the device returns more arguments than expected, but not less, so it's best to return the maximum, which is three (`Arg0` to `Arg2`). 

macOS will call `_DSM` methods of Device objects with only two arguments at first. When this occurs, the method should return `3`. So all you need to do is check if `Arg2` exists (is non-zero). If it doesn't, return `3`. If it does, return whatever properties you want macOS to use for that device.

In other words, `store` is saving information you want to hand over to macOS as a local variable via the `DTGP` method. So its whole purpose is to handle macOS-specific behavior without breaking non-macOS behavior - like running Windows on real Macs (with Boot Camp) for example.

#### AddHDMI

Contrary to what the name of this fix suggests, it *does not* enable HDMI ports for video. Instead, it adds an `HDAU` audio device to the `DSDT` to enable digital audio over HDMI for ATI and Nvidia GPUs. Since a discrete GPU is a separate piece of hardware there's simply no such device present in your mainboard's `DSDT` file. Additionally, the `hda-gfx = onboard-1` or `onboard-2` property is injected into the `HDAU` device:

- `1` if `UseIntelHDMI` = false
- `2` if there is an Intel port that occupies port 1

Nowadays, this fix is covered by **Whatevergreen.kext**.

#### AddIMEI

Adds Intel Management Engine (IMEI) device to the device tree, if it does not exist in the `DSDT`. IMEI is required for proper hardware video decoding on Intel iGPUs. Adding IMEI is only required in two cases:

- Sandy Bridge CPUs running on 7-series mainboards or
- Ivy Bridge CPUs running on 6-series mainboards

#### AddMCHC

Adds MCHC device which is related to the Memory Controller and is usually combined with `FixSBUS` to get the System Management Bus Controller working. In general, a device of the `0x060000` class is absent in the DSDT, but for some chipsets this device is serviceable, and therefore it must be attached to I/O Reg in order to properly wire the power management of the PCI bus.

#### AddPNLF

Inserts a PNLF (Backlight) device, which is necessary to properly control the screen brightness, and, oddly enough, helps to solve problems with sleep, even on desktop systems.

In my experience this is no longer working on macOS. Use [`SSDT-PNLF`](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Brightness_Controls_(SSDT-PNLF)) instead.

#### PNLF_UID

There are several sample brightness curves/graphs in the system, and they have different UIDs. If some vendor uses that curve, it doesn't mean that you will have the same brightness with the same processor. It depends on the panel – not the processor. 

This option is deprecates as well. It doesn't work correctly any more (the brightness will reset to max after a reboot), so using aforementioned `SSDT-PNLF.aml` is recommended in this case as well.

#### DeleteUnused

Removes unused Floppy, CRT and DVI devices from the DSDT – a necessity for getting the Intel GMA X3100 to work on Dell Laptops. Otherwise, you'll get a black screen. Tested by hundreds of users.

#### FakeLPC

Replaces the DeviceID of the LPC Bus Controller so that the AppleLPC kext is attached to it. It is necessary for chipsets which are not supported by macOS (for example ICH9). However, the native list of Intel and nForce chipsets is so large that the need for this patch is very rare. It checks whether or not the AppleLPC kext is loaded and applies the patch if needed.

#### FixACST

Some DSDTs can have a device, method or variable named `ACST`, but this name is also used by macOS 10.8+ to control C-States!

As a result, a completely implicit conflict with very unclear behavior can occur. This fix renames all occurrences of `ACST` to `OCST` which is safe. But check your `DSDT` first: search for `ACST` and check if it refers to Device `AC` (= Power Adapter) and method `_PSR` (= PowerSource) in some kind of way.

#### FixADP1

Corrects the `ADP1` device (power supply), which is necessary for laptops to sleep correctly - plugged in or unplugged.

#### FixAirport

Similar to LAN, the device itself is created, if not already registered in `DSDT`. For some well-known models, the `DeviceID` is replaced with a supported one. And the Airport turns on without other patches. 

**NOTE**: This fix is deprecated nowadays and doesn't work any longer. Use `AirportBrcmFixup.kext` instead.

#### FixDarwin

Mimics Windows XP under Darwin OS. Many sleep and brightness problems stem from misidentification of the system.

#### FixDarwin7

Same as `FixDarwin`, but for Windows 7. Old `DSDTs` may not have a check for such a system. Now you have the option to.

#### FixDisplay

Produces a number of video card patches for non-Intel video cards (Intel on-board graphics require different fixes):

- Injects properties and the devices themselves (if not present).
- Can inject a FakeID. If a FakeID parameter is specified, then it will be injected through the `_DSM` method.
- Adds custom properties.
- Adds a `HDAU` device for audio output via HDMI.

**NOTE**: Pretty much deprecated. WhateverGreen handles most of it nowadays. Use manual framebuffer patching via Devices/Properties instead.

#### FixFirewire

Adds `fwhub` property to the FireWire controller, if present. If not, then nothing will happen. You can bet if you don't know if you need to or not.

#### FixHDA

Corrects the description of the sound card in the `DSDT` so that the native AppleHDA driver works. Renaming `AZAL` to `HDEF` is performed, `layout-id` and `PinConfiguration` are injected. Obsolete nowadays, since `AppleALC.kext` handles this (in combination with the correct `layout-id` added in the `Devices` section).

**NOTE**: Handled by AppleALC.kext nowadays.

#### FixHPET

As already mentioned, this is the main fix needed. Thus, the minimum required `DSDT` patch mask looks like `0x0010`.

**OpenCore** equivalent: Generate `SSDT-HPET` and IRQ fixes using SSDTTime

#### FixIDE

In macOS 10.6.1, there was a panic on the `AppleIntelPIIXATA.kext`. Two solutions to the problem are known: use a corrected kext, or fix the device in the `DSDT`. And for more modern systems? Use it, if there is such a controller (which is highly unlikely since IDE is obsolete).

#### FixIPIC

Removes the interrupt from the `IPIC` device. Fixes the Power button, so that holding it for a few seconds brings up a dialog window with the to Reset, Sleep, or Shutdown the system.

Also required for fixing Audio on pre Skylake systems. Usually needs to be combined with `FixHPET`, `FixIPIC`, `FixTMR` and `FixRTC`.

**OpenCore** equivalent: Generate `SSDT-HPET` and IRQ fixes with SSDTTime

#### FixIntelGfx

Patch for Intel integrated graphics is separated from the rest of the graphics cards, that is, you can put the injection for Intel and not put for Nvidia.

#### FixLAN

Injection of the "built-in" property for the network card is necessary for correct operation. Also, a card model is injected - for cosmetics.

#### FixMutex

This patch finds all Mutex objects and replaces `SyncLevel` with `0`. We use this patch because macOS does not support proper Mutex debugging and will break on any inquiry with Mutex that has a non-zero SyncLevel. Non-zero SyncLevel Mutex objects are one of the common causes of ACPI battery method failure. Added by RehabMan in revisions r4265 to r4346.

For example, in Lenovo u430 mutexes are declared like this:

`Mutex (MSMI, 0x07)`

To make it compatible with macOS you need to change it to:

`Mutex (MSMI, 0)`

This is a very controversial patch. Use it only if you are fully aware of what you are doing.

#### FixRTC

Removes interrupt from device `_RTC`. It's a required fix, and it is very strange that someone would not enable it. If there is no interrupt in the original, then this patch won't cause any harm. However, the question arose about the need to edit the length of the region. To avoid clearing `CMOS`, you need to set the length to `2`, but at the same time a phrase like `"…only single bank…"` appears in the Kernel Log.

Why this message appears is unknown, but it can be fixed if the length is set to 8 bytes by using the Fix &rarr; `Rtc8Allowed`.

#### FixRegions

While other patches in this section are designed to fix your system's `DSDT.aml` on the fly during boot, this fix is designed for tuning an existing custom `DSDT.aml` which already includes all the necessary fixes.

The DSDT has regions that have their own addresses, such as:
`OperationRegion` (GNVS, SystemMemory, 0xDE6A5E18, 0x01CD). The problem is that this region address is created *dynamically* by the BIOS. It can vary from boot to boot. But when using a custom `DSDT.aml` this values is no longer created dynamically and therefore may be incorrect.

A symptom that this might be the case is that supposedly fixed sleep issues reappear after the next boot. If `FixRegions` is enabled, it will set all regions in the custom DSDT to fixed values used in the BIOS DSDT at that moment. There is another patch, but it is not for DSDT specifically, but for all ACPI tables in general, so adding it to the ACPI Section was inappropriate.

#### FixS3D

Attempts to fix Sleep/Wake issues by correcting `_S3D` methods in the DSDT.

#### FixSATA

Fixes some SATA issues and removes the yellow disk icon which indicated that an external disk is used when in fact it's connected internally. This is a controversial fix and not recommended. But in some cases DVD drives (remember those?) won't play back DVDs. Alternatively, this could be resolved by adding `AppleAHCIport.kext`.

OpenCore equivalent: `Kernel/Quirks/ExternalDiskIcons` &rarr; YES

#### FixSBus

Adds System Management Bus Controller to the device tree, thereby removing the warning about its absence from the system log. It also creates the correct bus power management layout, which affects sleep. To check if the SBUS is working correctly, enter the following command in Terminal:

`kextstat | grep -E "AppleSMBusController|AppleSMBusPCI"` 

If the Terminal output contains the following 2 drivers, your SMBus is working correctly: 

```
com.apple.driver.AppleSMBusPCI
com.apple.driver.AppleSMBusController
```

**OpenCore** equivalent: Use `SSDT-SBUS-MCHC`.

#### FixShutdown

A condition is added to the `_PTS` (prepare to sleep) method: if argument = 5 (shutdown), then no other action is required. Strange, why? Nevertheless, there is repeated confirmation of the effectiveness of this patch for ASUS boards, maybe for others, too. Some `DSDT` already have such a check, in which case such a fix should be disabled. If `SuspendOverride` = `true` is set in the config, then this fix will be extended by arguments 3 and 4. That is, going to sleep (Suspend). On the other hand, if `HaltEnabler` = `true`, then this patch is probably no longer needed.

#### FixTMR

Removes the interrupt from the `_TMR` timer in the same way. It is no longer used on newer Macs but on Ivy Bridge it is still required to resolve IRQ conflicts so sound works (combine with `FixHPET`, `FixIPIC`, and `FixRTC`).

**OpenCore** equivalent: Generate `SSDT-HPET` and IRQ fixes using SSDTTime

#### FixUSB

Attempts to solve numerous USB problems. For the `XHCI` controller, when using the native or patched `IOUSBFamily.kext`, such a `DSDT` patch is indispensable. The Apple driver specifically uses ACPI, and the DSDT must be spelled correctly. This makes sure that there are no conflict with strings in the `DSDT`.

#### FixWAK

Adds Return to the `_WAK` method. It has to be, but for some reason often the `DSDT` does not contain it. Apparently the authors adhered to some other standards. In any case, this fix is completely safe.

## SSDT
![SSDT](https://user-images.githubusercontent.com/76865553/136655891-edd9c38d-852f-476e-9ca7-4295cdb4ec38.png)

This section is for enabling/fixing/optimizing [**CPU Power Management**](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management). It's rarely used nowadays, since tools like [**ssdtPRGen**](https://github.com/Piker-Alpha/ssdtPRGen.sh) or [**SSDTTime**](https://github.com/corpnewt/SSDTTime) can generate a dedicated `SSDT` for it instead.

### C3 Latency

This value appears in real Macs, for iMacs it's about 200, for MacPro it's about 10. In my opinion, iMacs are regulated by P-stats, MacPros are regulated by C-stats. And it also depends on the chipset, whether your it will adequately respond to D-state commands from the MacOS. The safest and easiest option is to ***not set this parameter*** and everything will work fine as is.

### Double First State

In order for [**Intel SpeedStep**](https://en.wikipedia.org/wiki/SpeedStep) to work correctly, it is necessary to duplicate the first state of the P-states table. Although the necessity of this fix has become doubtful for newer CPUs, it is still relevant when using 3rd Gen Intel CPUs (codename `IvyBridge`).

In my test however, this didn't fix CPU Power Management for Ivy Bridge. THe CPU was stuck in base clock and no Turbo states were available. So therefore, generating an SSDT-PM with ssdtPRGen is recommended.

### DropOEM

The `DropOEM` option excludes certain OEM tables from being loaded into memory during boot which can help to address compatibility issues or conflicts with macOS that may arise with certain hardware configurations. Since we are going to dynamically load our own SSDTs, we can use this option to avoid unnecessary code overlaps to avoid aforemnetioned conflicts. 

If you want to avoid patching SSDT tables altogether, there is another option: put the native tables with minor edits in the `EFI/OEM/xxx/ACPI/patched/` Folder, and discard the unpatched tables. However, it is recommended to use the selective Drop method mentioned above.

### Enable C2, C4, C6 and C7

Specify which C-States you want to enable/generate.

### Generate Options
![Generate_Options](https://user-images.githubusercontent.com/76865553/136794188-a2fac646-48bb-469d-87f9-ca47afe00622.png)

In the new Clover, this group of parameters is combined into one section, and `PluginType` is now just `true` or `false`. The other `PluginType` key (the one with the dropdown menu) is obsolete and only kept for backwards compatibility purposes!

#### APSN/APLF

`APSN` stands for "Apple Processor Sleep Number." It is an integer value that is used to specify the sleep state that the processor should enter when it is not needed. Processor sleep states are low-power modes that allow the processor to enter a dormant state in order to conserve power and extend battery life in portable devices.

`APLF` stands for "Apple Low Frequency Mode." It is an integer value that is used to enable or disable a low-frequency mode for the processor. When low-frequency mode is enabled, the processor's clock speed is reduced in order to conserve power and reduce heat generation.

Both parameters seem to affect Intel SpeedStep. As a prerequisite, `Generate PStates` needs to be enabled for them to be available, whereas PluginType works independently of the Generate PStates status.

#### CStates
Automatic SSDT table generation, which extends the processor section with `_CST` methods for each core. `_CST` generation is affected by parameters `EnableC2`, `EnableC4`, `EnableC6`, and `C3Latency`.

#### PStates
Automatic SSDT table generation, which extends the processor section with `_PCT`, `_PPC` and `_PSS` methods:

- `_PCT`: Performance control. Controls `SpeedStep` functions
- `_PPC`: Performance Present Capabilities. `SpeedStep` capabilities. This method returns a value limiting the frequency. Look further for PLimitDict.
- `_PSS`: Performance Supported States. An array containing possible CPU states - P-States. `PLimitDict`, `UnderVoltStep` and `Turbo` will be taken into consideration when generated this array.

#### PluginType

For Haswell and newer CPUs you should set the key to `1`, for older ones to `0`. This key, together with the Generate → `PluginType` key, makes it possible to generate an SSDT table containing only `PluginType`, but no P-States if their generation is disabled. This key is not needed; it has been saved for backward compatibility.

**IMPORTANT**

- None of the `Generate` options are needed if a custom `SSDT-PM.aml` or `SSDT-PLUG` has been generated with ssdtPRGen or SSDTTime!
- In order to get CPU Power Management working under macOS Ventura using Ivy Bridge CPUs, you either have to be force-enable `XCPM` or [re-enable ACPI CPU Power Management](https://github.com/5T33Z0/OC-Little-Translated/blob/main/01_Adding_missing_Devices_and_enabling_Features/CPU_Power_Management/CPU_Power_Management_(Legacy)/README.md#re-enabling-acpi-power-management-in-macos-ventura) (recommended).

### Min Multiplier

Minimum CPU multiplier. It itself reports 16, and prefers to run at 1600, but you should set the stats down to 800 or even 700 in the table for SpeedStep. Experiment with it. If your system crashes during boot, the Low Frequency is too low!

### Max Multiplier

Introduced in conjunction to Min Multiplier, but it seems to be doing nothing and should not be used. However, it somehow affects the number of P-states, so you can experiment with it, but you shouldn't do it without a special need.

### NoDynamicExtract

If set to `true`, this flag will disable the extraction of dynamic SSDTs when using `F4` in the bootloader menu. Dynamic SSDTs are rarely needed and usually cause confusion (erroneously putting them in the `ACPI/patched` Folder). Added by Rehabman in r4359.

### NoOEMTableID

If set to `true`, the OEM table identifier is *NOT* added to the end of file name in ACPI tables dump by pressing `F4` in the Clover Boot Menu. If set to `false`, end spaces are removed from SSDT names when the OEM table ID is added as a suffix. Added by Rehabman in r4265 to r4346.

### PLimit Dict

`PLimitDict` limits the maximum speed of the processor. If set to `0` - the speed is maximal, `1` - one step below maximal. If this key is missing here, the processor will be stuck at the minimum frequency.

### Use SystemIO

If set to `true`, the SSDT section will be used to select in the generated `_CST` tables between:

```asl
Register (FFixedHW,
Register (SystemIO,
```

### UnderVolt Step

Optional parameter to lower the CPU temperature by reducing its operating voltage. Possible values are `0` to `9`. The higher the value, the lower the voltage, resulting in lower temperatures – until the computer crashes. This is where foolproof protection kicks in: Clover won't let you set any value outside the specified range. However, even allowed values can result in unstable operation. The effect of undervolting is really noticeable.

**NOTE**: This feature is only available Intel CPUs of the `Penryn` family (Intel Core 2 Duo and some Pentiums/Celerons).

## Drop Tables

![Bildschirmfoto 2021-05-16 um 08 28 35](https://user-images.githubusercontent.com/76865553/135732583-c8d61605-03af-4b78-a4db-4df9d1e68d56.png)

In this array, you can list tables which should be prohibited from loading (in other words "dropped"). These include various table signatures (as templates), such as `DMAR`, which is often dropped because macOS does not like `VT-d` technology and can cause issues with network cards. Other tables to drop would be `MATS` (fixes issues with High Sierra) or `MCFG` when using MacBookPro or MacMini SMBIOS.

Other tables that can be dropped (presets): 

| Table    |Description|
|:--------:|-----------|
`SSDT`		 |Drops SSDT. TableID must be specified.
`HPET` 	 |High Precision Event Timer. Using `FixHPET` is preferred.
`ECDT`		 |Embedded Controller Description Table. Using `FixTMR`, `FixIPIC` and `FixRTC` is preferred.
`BGRT` 	 |Boot Graphics Resource Table. `ResetLogoStatus`in OpenCore addresses this table
`MCFG` 	 |Drops MCFG Table. Using `FixMCFG` is preferred.
`DMAR` 	 |DMA Remapping Table. Using Quirk `DisableIoMapper` is preferred over dropping it to disable VT-d support. Since macOS Mojave, VT-d is working fine, so there really is no need to drop this table unless you are facing issues with network cards.
`APIC` 	 |Advanced Programmable Interrupt Controller. Using `PatchAPIC` is preferred.
`ASFT`		 | n/a
`SBST`		 | Smart Battery Table.
`SLIC`		 | Microsoft Software Licensing Table
`MATS`		 | Drop when using macOS High Sierra: https://alextjam.es/debugging-appleacpiplatform/

## DisabledAML

![Bildschirmfoto 2021-05-16 um 08 31 09](https://user-images.githubusercontent.com/76865553/135732710-df439b95-b7b9-4e88-bd47-0bc082ec63a6.png)

Yo can add SSDTs from the `ACPI/patched` folder which should be blocked from loading when booting the system. The whole name of the SSDT (including .aml) has to be entered.

## Sorted Order

Creates an array to load SSDTs in the `ACPI/patched` folder in the order specified in this list once you add an SSDT to it. Only SSDTs present in this array will be loaded, namely in the specified order.

In General, a problem with tables is their name. While it is not unusual for OEM Tables to use the national alphabet, or just no name, for Apple, it is unacceptable. The name has to be 4 characters of the Roman alphabet. Use "FixHeaders" to fix this issue.

### Debug

![Debug](https://user-images.githubusercontent.com/76865553/136655999-a2c369e4-14d3-4410-87ad-7473da46c749.png)

Enables Debug Log which will be stored in `EFI/CLOVER/misc/debug.log`. Enabling this feature slows down boot dramatically but helps to resolve issues.

**NOTE**: If you delete `EFI/CLOVER/misc` from the folder structure then the `Debug` features will no longer work!

### ReuseFFFF (Deprecated)

In some cases, the attempt to patch the GPU is hindered by the presence of:

```asl
Device (PEGP) type of device
	{
	Name (_ADR, 0xFFFFFF)
	Name (_SUN, One)
	}
```
You can change its address to `0`, but that doesn't always work.

**NOTE**: This fix is deprecated and has been removed from Clover since r5116!

### RTC8Allowed

As researched by vit9696, the region length should `8`, because you need it to save the hibernation key. So the fix itself is useful. 
If set to `true` - the length of the region will remain 8 bytes, if it exists. When set to `false`, the region will be corrected by 2 bytes, which more reliably prevents the CMOS from being reset.

### SuspendOverride
Influences the `FixShutdown` fix and extends it. Normally, the shutdown patch only works on power state `S5` (Shutdown). However, one may want to extend this patch to states `S3`(Sleep) and `S4` (Hibernate) by enabling `SuspendOverride`.

This helps when going to sleep during a UEFI boot. Symptoms: the screen will turn off but the lights and fans would continue running. Advanced Hackers can use a binary rename to fix it (not covered here).

### DSDT Name

Here you can specify the name of your **patched** custom DSDT if it is called something other than `DSDT.aml`, so that Clover picks it up and applies it.

## Resources
- [**ACPI Specs**](https://uefi.org/specifications)
- ASL Tutorial by acpica.org ([**PDF**](https://acpica.org/sites/acpica/files/asl_tutorial_v20190625.pdf)). Good starting point if you want to get into fixing your `DSDT` with `SSDT` hotpatches.
- If you are eager to find out how each of the automated `DSDT` patches and fixes in this sections are realized, you can delve deep into the [**source code**](https://github.com/CloverHackyColor/CloverBootloader/blob/81f2b91b1552a4387abaa2c48a210c63d5b6233c/rEFIt_UEFI/Platform/FixBiosDsdt.cpp).
