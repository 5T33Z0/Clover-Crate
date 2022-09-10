# Devices
![Devices](https://user-images.githubusercontent.com/76865553/136703701-40771976-3d25-4fd7-8c63-d51d5b498224.jpeg)

<details><summary><strong>TABLE of CONTENTS</strong> (click to reveal)</summary>

- [FakeID](#fakeid)
- [USB](#usb)
	- [Inject](#inject)
	- [Add ClockID](#add-clockid)
	- [FixOwnership](#fixownership)
	- [HighCurrent](#highcurrent)
	- [NameEH00](#nameeh00)
- [Audio](#audio)
	- [Inject](#inject-1)
	- [AFGLowPowerState](#afglowpowerstate)
	- [ResetHDA](#resethda)
- [Properties](#properties)
	- [Properties (Tab)](#properties-tab)
	- [Properties (HEX)](#properties-hex)
	- [AddProperties (deprecated)](#addproperties-deprecated)
	- [Arbitrary (Tab) (deprecated)](#arbitrary-tab-deprecated)
	- [Inject](#inject-2)
	- [NoDefaultProperties](#nodefaultproperties)
	- [UseIntelHDMI](#useintelhdmi)
	- [HDMIInjection](#hdmiinjection)
	- [ForceHPET](#forcehpet)
	- [SetIntelBacklight](#setintelbacklight)
	- [LANInjection](#laninjection)
- [Addendum](#addendum)
	- [About `AAPL,slot-name`](#about-aaplslot-name)
</details>

In this Section, you can:

- Add Audio Layout IDs
- Fix USB issues
- Add Fake IDs to enable otherwise unsupported devices
- Add or modify Devices (via `Devices` > `Properties`)
- Add Framebuffer Patches (via `Devices` > `Properties`)

## FakeID
A group of parameters for masking your devices as natively supported ones by macOS.

![Fake_ID](https://user-images.githubusercontent.com/76865553/136476522-a502bb4d-a183-4ef0-9516-956bb9926f99.png)

**Examples**:

- **AMD RadeonHD 7850** has the DeviceID=`0x6819`, which is not supported by OSX 10.8, but it supports DeviceID=`0x6818` instead. So add `0x6818` to the `ATI` field to change its ID. Next, it's necessary to inject this fake somehow. For video cards there are two ways: under "Graphics", enable `Inject ATI` or under "ACPI" enable `FixDisplay`.
- **NVidia GTX 660**: DeviceID=`0x1183`. The card works, but there is no `AGPM` (Apple Graphics Power Management) for it. Add ID `0x0FE0` in the `NVidia` field and enabled the `FixDisplay` patch to inject it into the `DSDT`.
- **WiFi**: A Dell Wireless 1595 card has the DeviceID=`0x4315`, but the real one is by Broadcom, which supports chips 4312, 4331 and some others. So enter the device ID of a supported card and enable the `FixAirport` patch in the `ACPI` section to inject the fake ID into the `DSDT`.
- The common **Marvell 80E8056** Network Card (DeviceID=`0x4353`) just doesn't work, but it works with the `AppleYukon2` driver if you change the ID to `0x4363`. Combine with `FixLan` to enable it.
- **`IMEI`**: This device works with **Intel** **HD3000** and **HD4000** iGPUs. However, it is not certain that your chipset has the correct ID. The substitutions are as follows (combine with `AddIMEI` Fix):
	- Sandy Bridge = `0x1C3A8086`
	- Ivy Bridge = `0x1E3A8086`
	- Haswell = `0x8C3A8086`

	This mask works in two ways: when injecting or with the `DSDT` patch. However, if you don't want to fully inject it in the way Clover does it, you can use the `NoDefaultProperties` option instead.

## USB
![USB](https://user-images.githubusercontent.com/76865553/136476548-3c37da88-f0ad-43e2-a431-1cec1a9ec1af.png)

### Inject
Injects USB properties if enabled. Leave disabled if you want to inject them yourself via `Properties`.

### Add ClockID
Enable to prevent the USB controller from waking the system involuntarily. If you want to wake the system via USB mouse, disable it. But be prepared that your computer will wake up spontaneously, e.g. from a built-in camera, etc.

### FixOwnership
In order for the USB controller to work in macOS, it has to be disconnected from the BIOS first, before the Darwin kernel is started. Since this is only required for legacy boot, this option is disabled by default – it is not required for UEFI boot, since UEFI based systems usually have an option for enabling XHCI/EHCI handoff. But there are cases where you cannot enable XCHI/EHCI handoff in the BIOS (usually on Laptops) where `FixOwnership` comes in handy. For Desktops PCs it's usually not needed since XHCI/EHCI handoff can be enabled in the BIOS.

In OpenCore you find this setting under `UEFI/Quirks/ReleaseUSBOwnership`.

### HighCurrent
Increases current on a USB controller to charge devices – disabled by default. Irrelevant for macOS 10.11 and newer. For Skylake and newer CPUs, add SSDT-USBX instead (usually integrated in [SSDT-EC-USB](https://github.com/5T33Z0/OC-Little-Translated/tree/main/01_Adding_missing_Devices_and_enabling_Features/Embedded_Controller_(SSDT-EC))).

### NameEH00
No information available in documentation.

## Audio
![audio](https://user-images.githubusercontent.com/76865553/136476581-c7714448-69f9-4c3b-bfa6-13aef9483a79.png)

### Inject
Enter/set the Layout-ID for `AppleALC.kext`. See the documentation for your mainboard to find out which CODEC is used and then check the [list of supported CODECS](https://github.com/acidanthera/AppleALC/wiki/Supported-codecs) to pick the correct Layout-ID. Not necessary when `VoodooHDA.kext` is used.

Other options available from the dropdown menu are:

- `No`: Nothing is injected. For example, if you set the Layout-ID yourself via Device `Properties`
- `Detect`: Automatic detection of an installed sound card in order to use its ID as a layout. Actually nonsense, but very popular.

### AFGLowPowerState
Affects the `AppleHDA` driver and seems to solve the problem with clicks and pops after waking up. There is little evidence of the effectiveness of the patch, though.

### ResetHDA
Initialize the audio codec, if enabled. This behavior can be observed after rebooting from Windows to Mac. In OpenCore, the equivalent feature is located under `UEFI/Audio/ResetTrafficClass`.

## Properties 
This is where Clover and Clover Configurator get really confusing. Because there ~~are~~ were 4 different ways to inject device `Properties`. These ~~are~~ were:

1. ~~**AddProperties**~~
2. **Properties [HEX]**
3. ~~**Arbitrary** (Tab)~~
4. **Devices/Properties** (Tab)

**IMPORTANT**: With the release of Clover r5146, `AddProperties` and `Arbitrary` were retired, since using `Devices/Properties` has become the de facto standard method to add device properties. Existing entries in `Arbitrary` and `AddProperties` will still be applied if present, but it's recommended to convert them to regular Device Properties instead. 

I think removing the unused methods was a good choice since it will reduce confusion and makes transferring device properties between OpenCore and Clover configs a lot easier

### Properties (Tab)
Nowadays, using the `Devices` > `Properties` tab next to `Arbitrary` tab –  which is displayed by default (which sucks) is the recommended and de facto standard method for adding device properties. 

This method is used for injecting properties of devices into macOS based on their PCI path. It can be utilized for injecting all sorts of parameters, including: Device IDs (so macOS sees the device), Framebuffer patches for on-board Graphics Cards, Audio layouts for sound cards, Wi-Fi and Ethernet Cards, configuring Active State Power Management (ASPM), etc. It works exactly the same way as the `DeviceProperties` section in OpenCore.

In a plist editor, the structure and hierarchy of this section looks like this:

![DevProps](https://user-images.githubusercontent.com/76865553/160235331-278ad725-f2bf-4e51-81a7-a9fbc6848952.png)

In Clover Configurator, this hierarchy is represented by a split view:

![DeviceProperties](https://user-images.githubusercontent.com/76865553/160037727-7a3f81e8-b801-432e-898d-90d2ad61ffd6.png)

On the left, you can add entries as PCI paths (as `<dict>`). On the right, you can add properties for said devices (as `<Data>`, `<String>` or `<Number>`) which will then be applied to them on boot. On the bottom, there's also a handy dropdown menu with a list of common PCI Devices to choose from, so you don't have to jump through hoops to find out the PCI path of your iGPU for example.

### Properties (HEX)
![Properties_Hex](https://user-images.githubusercontent.com/76865553/136596456-88ad496b-8a38-44e9-b4ed-7f2c50573303.png)

This field creates a simple string in the config in the `Devices` Section if a hex value is entered:

![PropertiesHex2](https://user-images.githubusercontent.com/76865553/136596474-e3ce6d35-3f93-4194-b9e0-02a0231d470b.png)

**NOTE**: As soon as you add a `Device` under to the `Properties` Tab (next to `Arbitrary`), this key will be deleted.

### AddProperties (deprecated)
![AddProperties1](https://user-images.githubusercontent.com/76865553/136595982-7a5af1ab-bd37-489c-864b-4a7d9d41be29.png)

Adding entries to this list creates an `<Array>` `AddProperties` and a `<Dictionary>` for the listed device. This is how the actual structure of the array looks like when viewed with a Plist Editor:

![AddProperties2](https://user-images.githubusercontent.com/76865553/136596168-ef38a5a9-e768-4ccd-805f-c5c4297435fb.png)

The value has to be entered either as a `<data>` or a `hex string`. So instead of alphanumerical values (ABC...) you have to use hex (0x414243). Convert via Plist Editor or Xcode. The first Device key determines which device this property will be added to.

### Arbitrary (Tab) (deprecated)
![Arbitrary](https://user-images.githubusercontent.com/76865553/136480147-879718e6-81eb-474d-a443-a13e0b56988a.png)

The `Arbitrary` section is an array of dictionaries, each corresponding to one device with a given PCI address. To describe each device, a `CustomProperties` array consisting of `Key`/`Value` pairs is used. These Properties can be disabled by ticking the `Disabled` checkbox. You can enable or disable a property dynamically in the Clover menu.

- `Key` **must** be a `<string>`.
- `Value` **can** be a `<string>`, `<integer>` or `<data>`.

### Inject
If enabled, all internal injection is replaced by entering a single string of properties, which corresponds to the Apple's `APPLE_GETVAR_PROTOCOL` injection method. A string could like this one which is used on real Macs: `GUID={0x91BD12FE, 0xF6C3, 0x44FB, {0xA5, 0xB7, 0x51, 0x22, 0xAB, 0x30, 0x3A, 0xE0}}`. Old hackers called these `EFIstrings`.

### NoDefaultProperties
Prohibits the injection of default properties that are triggered when enabling the `Inject` feature. When set to `true`, the line for the injection is created, but does not contain any properties yet. This property could be a `FakeID` for example.

When combined with `Inject` &rarr; `ATI`, `NoDefaultProperties` will prevent the injection of most keys except those that are required for a `FakeID` to be applied to an AMD/ATI GPU (and probably iGPU).

**NOTE**: This method of injecting a `FakeID` is outdated. Use the `Devices/Properties` tab is recommended.
 
### UseIntelHDMI
This parameter affects the injection properties of the sound transmitted over HDMI, as well as the `DSDT` patch. However, both VoodooHDA and AppleHDA sound drivers, do not fully work with HDMI Output. According to new information, VoodooHDA only works with NVIDIA's HDMI output, and as for AMD, Apple has created a new `AppleGFXHDA.kext` driver in 10.13+ systems.

### HDMIInjection
Disable the injection of HDMI device properties altogether. Starting with r3262, there is a new way of injecting device properties not by name, but by their location on the PCI Bus.

### ForceHPET
Force enables High Precision Event Timer on systems where there isn't an option in the BIOS to enable it.

### SetIntelBacklight
The key was introduced in r3298. In previous systems, the screen brightness was controlled by `IntelBacklight.kext` or `ACPIBacklight.kext`, but they didn't work in El Capitan. But it turned out to be very easy to do this in Clover at the stage of system startup, so no additional cakes were needed.</br>

**NOTE**: This doesn't work with current macOS versions. Use a `SSDT-PNLF.aml`instead. You can find one in the Samples Folder of the OpenCore Package.

### LANInjection
By default, the built-in property is injected for the NIC. This parameter can be used to disable the injection.

## Addendum

### About `AAPL,slot-name`
`AAPL,slot-name` is a key which can be used in the Devices/Properties section. It allows device to be listed in the System Profiler. Adding this key is mostly cosmetic but some users swear that it's required for certain devices. This property that usually injected by the `DSDT` or property strings but this is a wrong way to do it.

The `AAPL,slot-name` property is set by the AppleSMBIOS system kext based on the `_SUN` (Slot User Number) ACPI property and `DMI` tables. That is, `_SUN` specifies an ID in the range of 0-255, where the SMBIOS type 9 table with the corresponding ID is located, from where the slot name and other properties are pulled from.
