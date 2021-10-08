## Devices
![Devices](https://user-images.githubusercontent.com/76865553/136476505-cd164f1a-7ae1-4015-b902-4ed17d92ebb0.png)
In this Section, you can:

- Add Audio Layout IDs
- Fix USB issues
- Add Fake IDs to enable otherwise unsupported devices
- Add or modify Devices (via `Devices` > `Properties`)
- Add Framebuffer-Patches (via `Devices` > `Properties`)

### FakeID
A group of parameters for masking your devices as natively supported ones by macOS.

![Fake_ID](https://user-images.githubusercontent.com/76865553/136476522-a502bb4d-a183-4ef0-9516-956bb9926f99.png)

**Examples**:

- **AMD RadeonHD 7850** has the DeviceID=`0x6819`, which is not supported by OSX 10.8, but it supports DeviceID=`0x6818` instead. So add `0x6818` to the `ATI` field to change it's ID. Next, it's necessary to inject this fake somehow. For video cards there are two ways: under "Graphics", enable `Inject ATI` or  under "ACPI" enable `FixDisplay`.
- **NVidia GTX 660**: DeviceID=`0x1183`. The card works but there is no `AGPM` (Apple Graphics Power Management) for it. Add ID `0x0FE0` in the `NVidia` field and enabled the `FixDisplay` patch to inject it into the `DSDT`.
- **WiFi** – the Dell Wireless 1595 card, has the DeviceID=`0x4315`, but the real one is by Broadcom, which supports chips 4312, 4331 and some others. So enter the device ID for a supported one the enable the `FixAirport` patch in the `ACPI` section to inject it in the `DSDT`.
- The common **Marvell 80E8056** Network Card (DeviceID=`0x4353`) just doesn't work, but it works with the AppleYukon2 driver if you change the ID swap to `0x4363`. Combine woith `FixLan` DSDT Patch.
- **`IMEI`** – This device works with **Intel** **HD3000** and **HD4000**. However, it is not certain that your chipset has the correct ID. The substitutions are as follows (enable Fix `AddIMEI`):

	- SandyBridge = `0x1C3A8086`
	- IvyBridge = `0x1E3A8086`
	- Haswell = `0x8C3A8086`

This masking works in two cases: when injecting, or with the DSDT patch. However, if we don't want a full inject in the way Clover intended, we can set the following property:

### USB
![USB](https://user-images.githubusercontent.com/76865553/136476548-3c37da88-f0ad-43e2-a431-1cec1a9ec1af.png)

#### Inject
Injects USB properties if enabled. Leave unticked if you want to inject them yourself via `Properties`.

#### Add ClockID
Enable to prevent the USB controller from waking the system involuntarily. If you want to wake to wake the system via USB mouse, disble it. But be prepared that your computer will wake up spontaneously, e.g. from built-in camera, etc.

#### FixOwnership
In order for the USB controller to work in macOS, it has to be disconnected from the BIOS first, before the Darwin kernel is started. Since this is only required for legacy boot, this option is disabled by default – it is not required for UEFI boot.

#### HighCurrent
Increases current on this USB controller to charge Devices – disabled by default.

#### NameEH00


### Audio
![audio](https://user-images.githubusercontent.com/76865553/136476581-c7714448-69f9-4c3b-bfa6-13aef9483a79.png)

#### Inject
Injects Layout-ID. Combine with `AppleALC.kext`. See the documentation for this codec to pick the correct one. Not necessary if `VoodooHDA.kext` is used.

Other options available from the dropdown menu:

- `No`: Nothing is injected. For example, if you set the Layout-ID yourself via Device `Properties`
- `Detect`: Automatic detection of an installed sound card in order to use it's ID as a layout. Actually nonsense, but very popular.

#### AFGLowPowerState
Affects the `AppleHDA` driver and seems to solve the problem with clicks and pops after waking up. There is little evidence of the effectiveness of the patch, though.

#### ResetHDA
Initialize the audio codec, if enabled. This behavior can be observed after rebooting from Windows to Mac.

#### ForceHPET
Force enables HPET on systems where there isn't an option in teh BIOS to enable it.

### SetIntelBacklight

The key was introduced in r3298. In previous systems, the screen brightness was controlled by `IntelBacklight.kext` or `ACPIBacklight.kext`, but they didn't work in El Capitan. But it turned out to be very easy to do this in Clover at the stage of system startup, so no additional cakes were needed.</br>
**NOTE**: This doesn't work with current macOS versions. Use a `SSDT-PNLF.aml` instead

### Arbitrary
![Arbitrary](https://user-images.githubusercontent.com/76865553/136480147-879718e6-81eb-474d-a443-a13e0b56988a.png)

The `Arbitrary` section is an array of dictionaries, each corresponding to one device with a given PCI address. To describe each device, a `CustomProperties` array consisting of `Key`/`Value` pairs is used. These Properties can be disabled by ticking the `Disabled` checkbox. You can enable or disable a property dynamically in the Clover menu. 

- `Key` **must** be a `<string>`. 
- `Value` **can** be `<string>`, `<integer>` or `<data>`.
