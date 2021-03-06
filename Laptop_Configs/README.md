# Clover Laptop Configs and Hotpatches 2.0
>Based on [**Clover Laptop Config Repo**](https://github.com/RehabMan/OS-X-Clover-Laptop-Config) by Rehabman. All credits go to him!
>
>**DISCLAIMER**: This is my attempt to update Rehabman's existing Laptop configs for the new Clover version. I can't guarantee that all the configs work immediately since I do not possess a Laptop of every generation to test it.  

## About
This section contains `config.plist` files for common Laptops with Intel CPUs and Graphics. It's an updated version of Clover Laptop Config plists by Rehabman. All configs have been updated and conform to the new Clover with OpenCore's OpenRuntime integration in the form of Quirks (for Clover r5123 and newer).

To understand and modify the included config.plists, please refer to these accompanying Guides by Rehabman:

- [Booting the macOS Installer on Laptops with Clover](http://www.tonymacx86.com/el-capitan-laptop-support/148093-guide-booting-os-x-installer-laptops-clover.html)
- [Using Clover to "hotpatch" ACPI](https://www.tonymacx86.com/threads/guide-using-clover-to-hotpatch-acpi.200137). Included in this package are some handy SSDTs for use with Clover ACPI hotpatching. If you understand ACPI, you may find the SSDTs (in conjunction with additional plists with patches) quite useful.

### Config Upgrade Notes
In order to make these configs compatible with the latest Clover release (r5141), I had to change the following so they would pass validation in Clover Config Plist Validator (CCPV):

- Removed deprecated Keys like `DropOEM_DSM`
- Put `#` in front of Comments where they are not supported to avoid errors in CCPV
- Commented-out `#DropTables`. Enable if needed
- Deleted `ACPI/DropTables/DMAR` → covered by `DisableIoMapper` Quirk
- Deleted `ACPI/DropTables/MCFG` → covered by `FixMCFG` 
- Added Quirks for 2nd to 9th Gen Intel CPUs

## Brief description of included SSDT Hotpatches

| SSDT-…        | DESCRIPTION |
|:-------------:|-------------|
|**ALS0**| Injects a fake Ambient Light Sensor which fixes problems with restoring brightness upon reboot.
|**DDGPU**| Provides an `_INI` method which will call `_OFF` for a discrete GPU in a switched/dual GPU scenario. This SSDT can be used to disable an Nvidia or AMD graphics device, if the path matches (or is modified to match) and your `_OFF` method code path has no EC related code. Refer to the hotpatch guide for a complete example.
|**DEHCI**| Can disable both EHCI controllers. It is assumed both have been renamed to EH01/EH02 (typically, original names are `EHC1`/`EHC2`)
|**DEH01/DEH02**| Each of these SSDTs is just SSDT-DEHCI.dsl broken down to only disable EH01 or only EH02. Use as appropriate depending on which EHCI controllers are active/present in your ACPI set. 
|**GPRW, UPRW**| This SSDT works in conjunction with the `GPRW to XPRW` or `UPRW to XPRW` patch. Used together, this SSDT can fix "instant-wake" by disabling "wake on USB". It overrides the `_PRW` package return for GPE indexes `0x0d` or `0x6d`. Potential companion patches are provided in hotpatch/config.plist.
|**IGPU**| Injects Intel iGPU properties depending on the configuration data in `SSDT-RMCF` and the device-id that is discovered on the system. It assumes the iGPU is named `IGPU` (typically, it's `GFX0` by default. In this case, renaming it to `IGPU` is required). Configured with RMCF.TYPE, RMCF.HIGH, RMCF.IGPI, and SSDT-SKLSPF.aml.
|**IMEI**|Injects fake device-id as required for IMEI when using mixed HD3000/7-series or HD4000/6-series. Be sure to read the comments within carefully, as customization is required if your system already has an IMEI identity in ACPI.
|**LANCPRW**| Also part of fixing "instant wake", but this is for `_PRW` on the Ethernet device. Potential companion patches are provided in hotpatch/config.plist.
|**LPC**| Injects properties to force `AppleLPC` to load for various unsupported LPC device-ids. It assumes the LPC device is named `LPCB`.
|**PNLF**|Injects a PNLF device that works with `IntelBacklight.kext` or `AppleBacklight.kext`+ `AppleBacklightFixup.kext`. Configured with RMCF.BKLT, RMCF.LMAX, RMCF.FBTP. See [Laptop backlight control using AppleBacklightFixup.kext](https://www.tonymacx86.com/threads/guide-laptop-backlight-control-using-applebacklightinjector-kext.218222/)
|**PTSWAK**| Provides overrides for both `_PTS` and `_WAK` methods. When combined with the appropriate companion patches from hotpatch/config.plist, these methods can provide various fixes. The actions are controlled by RMCF.DPTS, RMCF.SHUT, RMCF.XPEE, RMCF.SSTF. Refer to `SSDT-RMCF.dsl` for more information on those options.
|**RMCF**|Rehabman Configuration File. Provides configuration data for SSDT-IGPU, SSDT-PNLF, SSDT-PTSWAK and SSDT-HDEF/HAUD. Read the comments within the SSDT for more information.|
|**RMDT**|Adds `RMDT` (RehabMan Debug Trace) device. This SSDT is for use with `ACPIDebug.kext`. Instead of patching your `DSDT` to add the `RMDT` device, you can use this SSDT and refer to the methods with External. See `ACPIDebug.kext` documentation for more information regarding the RMDT methods.|
|**SATA**| This SSDT injects properties (Fake device-id, compatible) to enable the SATA controller with certain unsupported SATA controllers. It assumes the SATA device is named `SATA` (typical is `SAT0`, thus requiring a `SAT0` to `SATA` binary rename).
|**SKLSPF**|Optional SSDT which can be paired with `SSDT-IGPU`. When present, SSDT-IGPU uses its data as overrides for various Kaby Lake iGPUs to spoof them as Skylake devices. Prior to 10.12.6, Skylake spoofing was the only option for Kaby Lake graphics to work. Keep in mind that complete Skylake spoofing required `FakePCIID.kext` and `FakePCIID_Intel_HD_Graphics.kext`.</br> **NOTE**: This is completely irrelevant nowadays, since Kaby Lake has been fully supported since the initial release of these configs in 2018!
|**SMBUS**|Injects the missing `DVL0` device. Mostly used with Sandy Bridge and Ivy Bridge systems.
|**SSDT-XCPM**| Onjects "plugin-type"=1 on `CPU0`. It assumes ACPI Processor objects are in Scope `_PR`. It can be used to enable native CPU power management on Haswell and later CPUs. See [Native Power Management for Laptops](https://www.tonymacx86.com/threads/guide-native-power-management-for-laptops.175801/) 
|**HDEF/HDAU**| Injects `layout-id`, `hda-gfx`, and PinConfiguration properties on `HDEF` and `HDAU` in order to implement audio with patched AppleHDA.kext Configured with: RMCF.AUDL
|**EH01, EH02, XHC**| These SSDTs inject USB power properties and control over FakePCIID_XHCIMux (depending on SSDT-DEH*.dsl).
|**XOSI**|This SSDT provides the `XOSI` method, which is a replacement for the system provided `_OSI` object when the `_OSI to XOSI` patch is being used. This is actually one of the examples in the Clover ACPI hotpatch guide, linked above.
|**XWAK, XSEL, ESEL**| Each of these SSDTs provides an empty `XWAK`, `XSEL`, and `ESEL` method (respectively). Use with the appropriate companion patch from hotpatch/config.plist. Typically, these methods are disabled (by having no code in them) to disable certain actions native ACPI may be doing on wake from sleep or during startup that cause problems with the XHCI/EHCI configuration.
