[TOC]
# I. ACPI

The ACPI section offers many options to affect the ACPI Tables of a system in order to assist users to make it compatible with macOS: from replacing characters in the `DSDT`, over renaming devices, enabling features to applying patches. Since this section is the centerpiece of your `config.plist`, every available option is explained here. This is how it looks like in Clover Configurator:

![ACPI_FULL](https://user-images.githubusercontent.com/76865553/135732525-5ad50aa8-6bfe-47b4-82b7-3bc3df8c6f62.png)

Throughout this chapter, this section is broken down into smaller chunks to make it more digestible.

## AutoMerge

![Bildschirmfoto](https://user-images.githubusercontent.com/76865553/135732535-ca43869b-4e97-47b2-a490-9c8aa5488fa8.png)

Merges any `DSDT` and `SSDT` changes from `/ACPI/patched` with existing ACPI tables.

If set to `true`, it changes the way files in `ACPI/patched` are handled: Instead of adding these files at the end of the `DSDT` it will replace that table, if the signature, index and `OemTableId` match an existing OEM table.

With this function – as with `DSDT` – you can fix individual SSDTs (or other tables) simply by addind the corrected file(s) into `ACPI/patched`. No need to fiddle with `DropOem` or `DropTables`. The original order is preserved. The mapping for `SSDT` is based on naming, where the naming convention used by the F4 extractor in the loader menu is used to identify the `SSDT` position in `DSDT`. 

For example, if your `ACPI/origin` folder contains a `SSDT-6-SaSsdt.aml` you could just fix it nd put it back in `ACPI/patched`, replacing the original table. This also works if you put it in `ACPI/patched` as `SSDT-6.aml`. Since some OEM ACPI sets do not use unique text in the OEM table-id field, Clover uses both the OEM table-id and the number that is part of the file name to locate the original in `XDST`. If you stick to the names provided in `ACPI/origin`, you should be fine.

## Disable ASPM

Active-state power management (ASPM) is a power management mechanism for PCI Express devices to garner power savings while otherwise in a fully active state. It is normally used on laptops and other mobile Internet devices to extend battery life.

This patch affects the settings of the ACPI system itself, such as the fact that Apple's ASPM management does not work as expected. For example when using non-native chipsets.

## FixHeaders

`FixHeaders` will check the headers of not only the `DSDT` but all ACPI tables in general, removing Chinese characters from table headers since macOS can not handle them and panics instantly. This issue has been fixed in macOS Mojave, but in High Sierra you still need it. 

Whether you have a problem with tables or not, it's safe to enable this fix. It is recommended to all users, even if you are not having to fix your DSDT. Old setting inside DSDT fixes remains for backward compatibility but I recommend to exclude it from those section.

## FixMCFG

The `MCFG` table describes the location of the PCI Express configuration space, and this table will be present in a firmware implementation compliant to this specification version 3.0 (or later).

If `FixMCFG` is enabled, the table will corrected. The author of the patch is vit9696. However, the method of discarding this table is still in stock.

## Halt Enabler

This Patch is for fixing the shutdown/sleep problem during UEFI boot. The fix is injected before calling `boot.efi`, clearing `SLP_SMI_EN` before the start of macOS. Nevertheless it is quite safe, at least on Intel systems.

## Patch APIC

Some systems can only be started using kernel parameter `cpus=1` or with a patched kernel (Lapic NMI). A simple analysis showed that their `MADT` table is missing the NMI section.`Patch APIC` fixes such tables on the fly. If the table is complete already, nothing will be changed.

## Reset Address / Reset Value

These two parameters serve a common purpose - to fix restart. They be present in the `FADT` table, but that's not always the case. Sometimes the table is shorter than necessary, so these values are missing. 

The variables are present in the `FACP` table but if they are empty, then `0x64`/`0xFE`are used, which means restart via PS2 Controller. This does not always work for everyone. Alternatively use `0x0CF9`/`0x06`, which means restart via PCI Bus. This pair is also used on native Macs, but does not always work on Hackintoshes. The difference is clear: on Hackintoshes there is also a PS2 controller which can interfere with the restart if it is not reset. Anoter combinations is `0x92`/`0x01`.

Last but not least you can set them to `0x0`/`0x0` to allow the use of default `FACP` values. If not present, the default values states above will be used instead.

## Smart UPS

This parameter affects the selected power profile, which will be written into the `FADT` table and changes it to profile `3`. The logic is as follows:

`PM=1` - Desktop , mains power </br>
`PM=2` - Notebook, mains or battery power </br>
`PM=3` - Server, powered by SmartUPS, which macOS also supports

Clover will choose between `1` and `2` based on an analysis of the mobility bit, but there is also a Mobile parameter in the SMBIOS section. You can say, for example, that we have a MacMini and that it is mobile. A value of `3` will be substituted if `smartUPS=Yes`.

## DSDT
### Patches
In this sub-section, you can add renaming rules (binary renames) to replace text inside your system's `DSDT` dynamically in binary code, represented by hex values. In other words, you replace text (characters, digits and symbols) with other text to either avoid conflicts with macOS or to make certain devices/features work within macOS by renaming them to something it knows.

![Bildschirmfoto 2021-05-16 um 07 27 17](https://user-images.githubusercontent.com/76865553/135732656-82fe792e-7225-4255-beb9-d1074eb1522b.png)

If you look at the first renaming rule, `change EHC1 to EH01`, it consists of a `Find` value of `45484331` and a `Replace` value of `45483031` which literally translates to `EHC1` and `EH01` if you decode the hex values back to text with the Hex Converter in the "Tools" section of Clover Configurator. Which renames to use when depends on your system, used macOS version, etc. and is not part of this overview.

### Rename Devices
<details>
<summary><strong>Excursion: Renaming Devices Basics</strong></summary>

**I. About binary renames**

- The following device renames are standardized in order to match device names used in real Macs and to facilitate the creation of part patches.
- Renaming devices and methods (including [`_DSM`](https://patchwork.kernel.org/project/spi-devel-general/patch/8ce38be1389dfb0527961ccd0dedb609802b59c1.1498044532.git.lukas@wunner.de/)) are applied globally to a system's `DSDT`.

Following are examples of commonly renamed devices:

| Original Device | Renamed for macOS | Description            |
|:----------------| :----------------:| -----------------------|
| EC              | EC0               | Embedded Controller
| EHC1            | EH01              | USB Controller
| EHC2            | EH02              | USB COntroller
| LPC             | LPCB              | LPC Bus
| SAT1            | SATA              | SATA Drive
| XHCI            | XHC               | USB Controller
| Keyboard        | PS2K              | Keyboard
| System Bus      | SBUS              | System Management Bus
| Cover           | LID0              | Lid device (on Laptops)
| PowerButton     | PWRB              | Power Button Device
| Sleep Button    | SLPB              | Sleep Button Device

**II. Binary Renames in Detail**

**Prerequisites**: In order to apply these renames correctly, you need a dump of your System's `DSDT`! 

Names like `_DSM` with and underscor in front of them define a method. These are usually renamed by replacing the `_` with an `X` (like `XDSM`) which basically disables the method (`XDSM`), so a differnet or custom method can be applied.

| #  | Rename      | Description                      |
|:--:| :---------: | -------------------------------- |
| 01 | _DSM to XDSM| Other Patch Requirements         |
| 02 | LPC to LPCB |In `DSDT`, search for `0x001F0000`.</br> 1: If the device name is already `LPCB`, there is no need to change the name.</br> 2: If there are multiple matches for `0x001F0000`, carefully determine whether this name change is needed or not </br>3:If ACPI includes an `ECDT.aml`, check "About ECDT correction method|
| 03 | EC to EC0   | Changes name of Embedded Controller. In DSDT, check the device belonging to `PNP0C09`.</br>1:If the device name is already `EC0`, no renaming is required </br>2:If there are multiple matches for `0PNP0C09`, confirm the real `EC` name </br>3:If ACPI package includes `ECDT.aml`, see "About ECDT and how to fix it"|.|
|04|H_EC to EC0|Same as EC|
|05|ECDV to EC0(dell)|Same as EC|
|06|EHC1 to EH01| Renames USB Controller. For machines with USB2.0, query the device name of `0x001D0000`.
|07|EHC2 to EH02| For a 2nd USB Controller
|08|XHCI to XHC| Changes name of modern USB Controller. Check the device name belonging to `0x00140000`. If the device name is already `XHC`, no binary rename is necessary|
|09|XHC1 to XHC|Same as XHCI|
|10|KBD to PS2K|Rename for Keyboard. Check the device name of `PNP0303`, `PNP030B`, `PNP0320`. If the keyboard name cannot be determined in `DSDT`, check the "BIOS name" of the keyboard in Windows Device Manager. If keyboard is named `PS2K` already, no rename is required|
|11|KBC0 to PS2K|same|
|12|KBD0 to PS2K|same|
|13|SMBU to SBUS|Renames System Management Bus. Most ThinkPads require this. </br>Before 6th gen, seach the device name belonging to "0x001F0003" </br>6th gen and later machines: search "0x001F0004" belonging to the device name </br>If the device name `SBUS` aready, a rename is not required|
|14|LID to LID0| Search the device name belonging to `PNP0C0D` and rename it to `LID0`
|15|PBTN to PWRB(dell)| Search device belonging to `PNP0C0**C**` and rename it to `PWRB`
|16|SBTN to SLPB(dell)| Sleep Button rename. Search device belonging to `PNP0C0**E**`. If the name is `SLPB` already, no need for a rename.

To convert any text to a hex you can use the Hex Converter inside of Clover Configurator
</details>

`RenameDevices` serves as a more refined method for renaming devices which is less brute force than using a simple binary rename which replaces *every* occurrence of a word/value throughout the *whole* `DSDT`, which can be problematic. The rules created here only apply to the ACPI path specified in the `Find Device` field, so these patches are more precise, less invasive and more efficient than renaming them via `DSDT` > `Patches`.

To use this section properly, you need a dump the unmodified `DSDT` and examine it with maciASL. In this case, we search for `ECH1`:

![Rename Devices](https://user-images.githubusercontent.com/76865553/135732661-ba636a72-9490-4c6f-a018-bdede3752fa6.jpg)

As you can see, the device exists and is located in `\SB_PCI0_EHC1` of the `DSDT`. Next, we tell Clover Configurator to replace the actual device name witj `EH01` by adding it in the `Rename Device` field. After the patch is applied on the fly during boot, the device name and it's dependencies have been changed:

![DSDT_patched](https://user-images.githubusercontent.com/76865553/135732669-9ac77cf7-5c5f-41a0-b98f-0ae1453411dc.png)

### TgtBridge

The `TgtBridge` is a field/function inside the `ACPI > DSDT > Patches` section of the Clover `config.plist`. It's purpose is to limit the scope of binary DSDT patches to only work within a pre-defined section/area of the `DSDT`.

For example: renaming the method `_STA`to `_XSTA` in device `GPI0`:

![TGTBridgeExample](https://user-images.githubusercontent.com/76865553/135732680-641af3ba-8140-477a-9c9e-69345d8e9b8f.png)

As shown in the example, the name of the original Method `_STA` (pink) is converted to  hex (`5F535441`), so Clover can find it in the `DSDT`. If it finds this value it is then replaced by `58535441` (blue), which is the hex equivalent of the term `XSTA` (blue). If set like this, this patch would change *any* appearance ot the term `_STA` in the whole of the `DSDT` to `XSTA` which probably would break the system. To avoid this, you can use `TgtBridge` to specify and limit the matches of this patch to a specified name/device/method/area, in this case to the device `GPI0` (Cyan). Basically, you tell Clover: "look in `GPI0`and and if the method `_STA` is present, rename it to `XSTA` but leave the rest of the `DSDT` alone!"

Which values to use in `TgtBridge` is up to you, if you know what to do. If string lengths do not match, Clover will correctly account for the length change, with one exception: make sure it doesn't happen inside an "If" or "Else" statement. If you need such a change, replace the entire operator. 

Some clarification: the Comment Field not only serves as a reminder what the patch is about, but is also used in the Clover Boot Menu to enable/disable these patches. The initial value for `ON` or `OFF` is determined by the `Disabled` lines in the `config.plist`. The default value is `Disabled=false`. If you use someone else's set of patches, it is better to set them to `Disabled=true` and then enable them from the Boot menu one by one.

**NOTE**: TgtBridge Bug (fixed since Clover r5123.1) 

Prior to revision 5123.1, Clover's `TgtBridge` had a bug, where it would not only rename matches specified by `TgtBridge` but also replaced matches in OEM's SSDTs, resulting in many devices being enabled that should not have been started.

## Fixes [1]

![Bildschirmfoto 2021-05-16 um 07 28 34](https://user-images.githubusercontent.com/76865553/135732689-dd1271db-f11d-468b-a57e-576bcf7f7d76.png)

### AddDTGP

In addition to the `DeviceProperties`, there is also a Device Specific Method (`_DSM`) specified in the `DSDT` called `DTGP` to inject custom parameters into some devices. 

`_DSM` ia a well-known method, which is included in macOS since version 10.5. It contains an array with a device description and a call to the universal `DTGP` method, which is the same for all devices. Without the `DTGP` method, modified `DSDTs` would not work well. This fix simply adds this method so that it can then be applied to other fixes. It does not work on its own alone.

### AddMCHC

Such a device of class `0x060000` is, as a rule, absent in the DSDT, but for some chipsets this device is serviceable, and therefore it must be prescribed in order to properly wire the power management of the PCI bus. The question of the need for a patch is solved experimentally. Another experience, this device was needed on a mother with a Z77 chipset, otherwise the kernel panic at the initial stage of launch. Conversely, on the G41M (ICH7) chipset, this fix causes panic. Unfortunately, there is no general rule in sight.

### FixAirport

Similar to LAN, the device itself is created, if not already registered in `DSDT`. For some well-known models, the `DeviceID` is replaced with a supported one. And the Airport turns on without other patches.

### FixDarwin

Mimics Windows XP under Darwin OS. Many sleep and brightness problems stem from misidentification of the system.

### FixDisplay

Produces a number of video card patches non-Intel video cards. Injects properties, and the devices themselves, if they are not present. Injects FakeID if ordered. Adds custom properties. The same fix adds an HDAU device for audio output via HDMI. If the FakeID parameter is specified, then it will be injected through the _DSM method. Patches for all video cards, only for non-Intel. Intel on-board graphics require other fixes.

### FixFirewire

Adds the "fwhub" property to the Firewire controller, if present. If not, then nothing will happen. You can bet if you don't know if you need to or not.

### FixHDA

Correction of the description of the sound card in the `DSDT` so that the native AppleHDA driver works. Renaming `AZAL` to `HDEF` is performed, `layout-id` and `PinConfiguration` are injected. Obsolete nowadays, since `AppleALC.kext` handles this (in combination with the correct `layout-id` entered in the `Devices` section).

### FixHPET

As already mentioned, this is the main fix needed. Thus, the minimum required `DSDT` patch mask looks like `0x0010`.

### FixIDE

In macOS 10.6.1, there was a panic on the `AppleIntelPIIXATA.kext`. Two solutions to the problem are known: use a corrected kext, or fix the device in the `DSDT`. And for more modern systems? Use it, if there is such a controller (which is highly unlikely since IDE is obsolete).

### FixIPIC

Removes the interrupt from the `IPIC` device. This fix affects the operation of the Power Button (a pop-up window with the Reset, Sleep, Shutdown options).

### FixLAN
Injection of the "built-in" property for the network card is necessary for correct operation. Also a card model is injected - for cosmetics.

### FixSATA

Fixes some problems with SATA, and removes the yellowness of disk icons in the system by mimicry under ICH6. Actually a controversial method, however, without this fix, my DVDs will not play, and for a DVD the drive should not be removable. Those. just replacing the icon is not an option! There is an alternative, solved by adding a fix with the `AppleAHCIport.kext`. See the chapter on patching kexts. And, accordingly, this bit can be omitted! One of the few bits I recommend not to use.

### FixSBus

Adds the System Management Bus Controller to the device tree, thereby removing the warning about its absence from the system log. It also creates the correct bus power management layout, which affects sleep.

### FixShutdown

A condition is added to the `_PTS` (prepare to slwwp) method: if argument = 5 (shutdown), then no other action is required. Strange, why? Nevertheless, there is repeated confirmation of the effectiveness of this patch for ASUS boards, maybe for others, too. Some `DSDT` already have such a check, in which case such a fix should be disabled. If `SuspendOverride` = `true` is set in the config, then this fix will be extended by arguments 3 and 4. That is, going to sleep (Suspend). On the other hand, if `HaltEnabler` = `true`, then this patch is probably no longer needed.

### FixUSB

Attempts to solve numerous USB problems. For the `XHCI` controller, when using the native or patched `IOUSBFamily.kext`, such a `DSDT` patch is indispensable. The Apple driver specifically uses ACPI, and the DSDT must be spelled correctly. This makes sure that there are no conflict with strings in the `DSDT`.

## Fixes [2]

![Bildschirmfoto 2021-05-16 um 08 04 15](https://user-images.githubusercontent.com/76865553/135732698-6ead0af4-304c-4570-a407-aaafb70506f2.png)

### AddHDMI

Adds an `HDAU` device to `DSDT` that matches the HDMI output on an ATI or Nvidia video card. It is clear that since the card was bought separately from the motherboard, there is simply no such device in the native DSDT. In addition, the `hda-gfx = onboard-1` or `onboard-2` property is injected into the device as appropriate:

* `1` if UseIntelHDMI = false
* `2` if there is an Intel port that occupied port 1.

### AddIMEI

Required primarily for Sandy Bridge CPUs, which adds the `IMEI` device to the device tree, if it does not exist already.

When mixing Ivy Bridge CPUs with 6 series motherboards, the IMEI device becomes incompatible with macOS. The device-id won't be recognized and this is a very important issue as macOS relies on the `IMEI` device for iGPU drivers. The same applies when mixing Sandy Bridge CPUs with 7 series motherboards.

### AddPNLF

Inserts a PNLF (Backlight) device, which is necessary to properly control the screen brightness, and, oddly enough, helps to solve the problem with sleep, including for the desktop.

### PNLF_UID

There are several sample brightness curves/graphs in the system and they have different UIDs. If some realtor used that curve, that doesn't mean that you will have the same brightness with the same processor. It depends on the panel – not the processor.

Generally speaking, It would be better to build a `PNLF` calibration system, but that's acrobatics. For now, all we're suggesting is to experiment with different values, and see if it gets better. Added in revision r5103.

### DeleteUnused

Removes unused floppy, CRT and DVI devicese - an absolute prerequisite for running IntelX3100 on Dell laptops. Otherwise black screen, tested by hundreds of users.

### FakeLPC

Replaces the DeviceID of the LPC controller so that the AppleLPC kext is attached to it. It is necessary for those cases when the chipset is not provided for macOS (for example ICH9). However, the native list of Intel and nForce chipsets is so large that the need for such a patch is very rare. It checks in the system whether the AppleLPC kext is loaded and if is not, the patch is needed.

### FixACST

Some DSDTs can have a device, method or variable named `ACST`, but this name is also used by macOS 10.8+ to control C-States! 

As a result, a completely implicit conflict with very unclear behavior can occur. This fix renames all occurrences of `ACST` to `OCST` which is safe. But check your DSDT first: search for `ACST` and check if it refers to Device `AC` and Method `_PSR`(_PSR: PowerSource) in some kind of way.

### FixADP1

Corrects the `ADP1` device (power supply), which is necessary for laptops to sleep correctly - plugged in or unplugged.

### FixDarwin7

Same as `FixDarwin`, but for Windows 7. Old `DSDTs` may not have a check for such a system. Now you have the option to.

### FixIntelGfx

Patch for Intel integrated graphics is separated from the rest of the graphics cards, that is, you can put the injection for Intel and not put for Nvidia.

### FixMutex

This patch finds all Mutex objects and replaces `SyncLevel` with `0`. We use this patch because macOS does not support proper Mutex debugging and will break on any inquiry with Mutex that has a nonzero SyncLevel. Nonzero SyncLevel Mutex objects are one of the common causes of ACPI battery method failure. Added by Rehabman in revisions r4265 to r4346.

For example, in Lenovo u430 mutexes are declared like this:

`Mutex (MSMI, 0x07)`

To make it compatible with macOS you need to change it to:

`Mutex (MSMI, 0)`

This is a very controversial patch. Use it only if you are fully aware of what you are doing.

### FixRegions

This is a very special patch. While other patches in this section are designed to fix `BIOS.aml` in order to create a good custom DSDT from scratch, this fix is designed for tuning an existing custom `DSDT.aml`.

The DSDT has regions that have their own addresses, such as:
`OperationRegion` (GNVS, SystemMemory, 0xDE6A5E18, 0x01CD). The problem is that this region address is created *dynamically* by the BIOS and it can be different from boot to boot. This was first noticed when changing the total amount of memory, then when changing BIOS settings, and on my computer it even depends on the pre-boot history, such as the amount of occupied NVRAM. Clearly, in the custom `DSDT.aml` this number is fixed, and therefore may not be true. The simplest observation is the lack of sleep. After fixing a region, sleep appears, but only until the next offset. This fix fixes all regions in the custom DSDT to values in the BIOS DSDT, and thus the mask

```swift 
<key>Fixes</key>
<dict>
	<key>FixRegions</key>
	<true/>
</dict>
```
is sufficient if you have a well-made custom DSDT with all your needed fixes. There is another patch, but it is not for DSDT specifically, but for all ACPI tables in general, so adding it in the ACPI Section is inappropriate.

### FixRTC and Rtc8Allowed

Removes interrupt from device `_RTC`. It's a required fix and it is very strange that someone would not enable it. If there is no interrupt in the original, then this patch won't cause any harm. However, the question arose about the need to edit the length of the region. To avoid clearing `CMOS`, you need to set the length to `2`, but at the same time a phrase like `"…only single bank…"` appears in the Kernel Log.

I do not know what is wrong with this message, but it can be excluded if the length is set to 8 bytes by using the Fix `Rtc8Allowed`:

```swift 
<key>ACPI</key>
<dict>
	<key>DSDT</key>
	<dict>
	<key>Rtc8Allowed</key>
	<false/>
</dict>
```

* `true` - the length of the region will remain 8 bytes, if there was one,
* `false` - will be corrected by 2 bytes, which more reliably prevents the CMOS from being reset.

As researched by vit9696 the region length should still be 8, because you need it to save the hibernation key. So the fix itself is useful. Sinc on desktops, hibernation is not needed, you may think about resetting the CMOS.

### FixS3D

Likewise, this patch solves the problem with sleep.

### FixTMR

Removes the interrupt from the _TMR timer in the same way. It is deprecated and not used by Mac.

### FixWAK

Adds Return to the `_WAK` method. It has to be, but for some reason often the `DSDT` does not contain it. Apparently the authors adhered to some other standards. In any case, this fix is completely safe.

## SSDT

![Bildschirmfoto 2021-05-16 um 19 14 17](https://user-images.githubusercontent.com/76865553/135732594-1b3cf4b8-9b3e-48e2-9cda-6f0b7d95e7cc.png)

### Double First State

In order for [Speedstep](https://en.wikipedia.org/wiki/SpeedStep) to work correctly, it is necessary to duplicate the first state of the P-states table. Although the necessity of this fix has become doubtful for newer CPUs, it is still relevant to Intel CPUs of the `Ivy Bridge` family.

### NoDynamicExtract

If set to `true`, this flag will disable the extraction of dynamic SSDTs when using `F4` in the bootloader menu. Dynamic SSDTs are rarely needed and usually cause confusion (erroneously putting them in the `ACPI/patched` Folder). Added by Rehabman in revision 4359.

### Drop OEM

Since we are going to dynamically load our own SSDT tables, we need to avoid unnecessary overlaps code to avoid conflicts. This option allows you to discard all native tables in favor of new ones. 

If you want to avoid patching SSDT tables altogether, there is another option: put the native tables with minor edits in the `EFI/OEM/xxx/ACPI/patched/` Folder, and discard the unpatched tables. However, it is recommended to use the selective Drop method mentioned above.

### Use SystemIO

If set to `true`, the SSDT section will be used to select in the generated `_CST` tables between:

```swift
Register (FFixedHW,
Register (SystemIO,
```
### NoOEMTableID

If set to `true`, the OEM table identifier is *NOT* added to the end of file name in ACPI tables dump by pressing `F4` in the Clover Boot Menu. If set to `false`, end spaces are removed from SSDT names when the OEM table ID is added as a suffix. Added by Rehabman in revisions 4265 to 4346.

### Generate

In the new Clover, this group of parameters is combined into a sub-section:

- Generate `PStates`
- Generate `CStates`
- `ASPN`
- `APLF`</br>
- `PluginType` either `true` or `false`.

**NOTE**: Since APSN/APLF are components of `PStates`, they are *only* active *if* `PStates` are enabled (`true`), whereas `PluginType` works independently of `PStates`.

**IMPORTANT**: None of the `Generate` options are needed if a custom SSDT-PM has been generated with ssdtPRGen or SSDTTime!

#### Generate PStates/CStates

Here we specify that two additional tables are generated for C-States and for P-States, according to the rules developed by the hackintosh community. For C-States the table with parameters C2, C4, C6, Latency mentioned in the CPU section. It is also possible to specify the ones in the SSDT section.

#### PluginType

For Haswell and newer CPUs you should set the key to `1`, for older ones to `0`. This key, together with the Generate → `PluginType` key, makes it possible to generate an SSDT table containing only `PluginType`, but no P-States if their generation is disabled. This key is not needed; it has been saved for backward compatibility.

### PLimit Dict

`PLimitDict` limits the maximum speed of the processor. If set to `0` - the speed is maximal, `1` - one step below maximal. If this key is missing here, the processor will be stuck at the minimum frequency.

### UnderVolt Step

Optional parameter to reduce the temperature of the processor by reducing its operating voltage. Possible values are 0 to 9. The higher the value, the lower the voltage, resulting in lower temperatures – until the computer hangs. This is where foolproof protection comes in: Clover won't let you set any value outside the specified range. However, even allowed values can result in unstable operation. The effect of undervolting is really noticeable. However, this parameter is only only applicable to Intel CPUs of the `Penryn` family.

### Min Multiplier

Minimum CPU multiplier. It itself reports 16, and prefers to run at 1600, but you should set the stats down to 800 or even 700 in the table for speedstep. Experiment with it. If your system crashes during boot, the Low Frequency is too low!

### Max Multiplier

Introduced in conjunction to Min Multiplier, but it seems to be doing nothing and should not be used. However, it somehow affects the number of P-states, so you can experiment with it, but you shouldn't do it without a special need.

### C3 Latency

This value appears in real Macs, for iMacs it's about 200, for MacPro it's about 10. In my opinion, iMacs are regulated by P-stats, MacPros are regulated by C-stats. And it also depends on the chipset, whether your chipset will adequately respond to D-state commands from the MacOS. The safest and easiest option is *not to set this parameter*, everything will work fine as it is.

### Enable C2, C4, C6 and C7

Specify which C-States you want to enable/generate.

### Debug

![Bildschirmfoto 2021-05-16 um 08 16 49](https://user-images.githubusercontent.com/76865553/135732560-dd0763b8-a4c7-463d-9d3c-c0a08e929fc6.png)

Enables Debug Log which will be stored in `EFI/CLOVER/misc/debug.log`. Enabling this feature slows down boot dramatically but helps resolving issues.

### RTC8Allowed
see "Fixes [2]" Section → "FixRTC".

### ReuseFFFF
In some cases, the attempt to patch the GPU is hindered by the presence of:

```swift 
Device (PEGP) type of device
	{
	Name (_ADR, 0xFFFFFF)
	Name (_SUN, One)
	}
```
You can change its address to `0`, but that doesn't always work. **NOTE**: This fix is deprecated an has been removed from Clover since r5116!

### SlpSmiAtWake

Adds `SLP_SMI_EN=0` at every wake. This may help to solve sleep and shutdown issues on UEFI boot. **NOTE**: This fix is deprecated and has been removed from Clover since r5134!

### SuspendOverride

The shutdown patch only works on power state `5` (shutdown). However, we may want to extend this patch to states `3` and `4` by enabling `SuspendOverride`.

This helps when going to sleep during a UEFI boot. Symptoms: the screen will turn off but the lights and fans would continue running.
Advanced Hackers can use a binary rename to fix it (not covered here).

### DSDT name: 
Here you can specify the name of your **patched** custom DSDT if it is called something other than `DSDT.aml`, so that Clover picks it up and applies it.

## Drop Tables

![Bildschirmfoto 2021-05-16 um 08 28 35](https://user-images.githubusercontent.com/76865553/135732583-c8d61605-03af-4b78-a4db-4df9d1e68d56.png)

In this array, you can list tables which should be discarded from loading. These include various table signatures, such as `DMAR`, which is often dropped because macOS does not like `VT-d` technology. Other tables to drop would would be `MATS` (fixes issues with High Sierra) or `MCFG` because by specifying a MacBookPro or MacMini model, we get severe brakes. A better method has already been developed.

### DisableAML

![Bildschirmfoto 2021-05-16 um 08 31 09](https://user-images.githubusercontent.com/76865553/135732710-df439b95-b7b9-4e88-bd47-0bc082ec63a6.png)

**Note**: No info present in the manual. I guess you can add SSDTs from the `ACPI/patched` folder which should be omitted from loading.

### Sorted Order

Creates an array to load SSDTs in the `ACPI/patched` folder in the order specified in this list once you add an SSDT to this list. Only SSDTs present in this array will be loaded, namely in the specified order.

In General, a problem with tables is their name. While it is not unusual for OEM Tabkes to use the national alphabet, or just no name, for Apple, it is inacceptable. The name has to be 4 characters of the Roman alphabet. Use "FixHeaders" to fix this issue.
