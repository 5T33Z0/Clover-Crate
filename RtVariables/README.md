# RtVariables
![RTVars](https://user-images.githubusercontent.com/76865553/136703846-afb63687-ddd4-4e35-b544-9d7c2ff6d260.jpeg)

The following two parameters are intended to allow registration in iMessage service.
Starting from Clover r1129 the parameters are taken from SMBiOS and are not needed to be entered here.

### ROM
Last digits of `SmUUID` or MAC Address. Clover can detect the MAC Address of your Ethernet Adapter if `<string>UseMacAddr0</string>` is selected. The procedure does not work for everyone, so test it.

### MLB
MLB = BoardSerialNumber

### BooterConfig

### CsrActiveConfig
With the release of macOS ElCapitan in 2015, a new security feature was introduced: System Integrity Protection (SIP). By default, SIP is enabled (`0x000`) and does not allow you to load your kexts or install your system utilities. To disable it, Clover gives you the option of setting new in NVRAM.

**Recommended values for disabling SIP** (disabling SIP is not recommended):

| macOS Version     | Bitmask Size | CsrActive Config |
|------------------:|:------------:|:----------------:|
| macOS 11/12		| 12 bit       |          `0xFEF` |
| macOS 10.14/10.15 | 11 bit       |          `0x7FF` |
| macOS 10.13       | 10 bit       |          `0x3FF` |
| macOS 10.12       | 9 bit        |          `0x067` |
| macOS 10.11       | 8 bit        |          `0x067` |

### HWTarget
`HWTarget`is the latest feature added to Clover r5140. It enables System Updates for macOS Monterey. It writes the variable `BridgeOSHardwareModel` to NVRAM, which is requested by macOS Monterey. Basically, it identifies your Hackintosh at Apple servers as MacPro7,1 asking, "Can I have update, bruh?! Plzzz give me update, BRUH!" ;) Just in case you are wondering, why there is noch checkbox in Clover Configurator – the feature is not implemented yet. Use a plist Editor in the meantime to add the key to your config.plist.  This is how the key has to look:

```swift
<key>RtVariables</key>
<dict>
	<key>HWTarget</key>
	<string>j160</string>
```
To confirm that the parameter is set, enter in Terminal: `sysctl hw.target`</br>
Output should be `j160`
