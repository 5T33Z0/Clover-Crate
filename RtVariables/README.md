# RtVariables
![RTvarsnu](https://user-images.githubusercontent.com/76865553/140332564-944c61eb-6168-4a12-b580-0f0744fd4fdf.png)

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
| macOS 11/12       | 12 bit       |          `0xFEF` |
| macOS 10.14/10.15 | 11 bit       |          `0x7FF` |
| macOS 10.13       | 10 bit       |          `0x3FF` |
| macOS 10.12       | 9 bit        |          `0x067` |
| macOS 10.11       | 8 bit        |          `0x067` |

### HWTarget
`HWTarget`is the latest feature added to Clover r5140. It enables System Updates for macOS Monterey which use SMBIOSes of Macs with a T2 Chip. It writes the variable `BridgeOSHardwareModel` to NVRAM, which is requested by macOS Monterey. 

Basically, it identifies your Hackintosh at Apple servers as MacPro7,1 asking, "Can I have update, bruh?! Plzzz give me update, BRUH!" ;).

#### Valid values for `HWTarget`
If you use a SMBIOS of one of the Mac models listed below, copy the corresponding value and paste it in the `HWTarget` field of your `config.plist`.

- MacBookPro15,1 (`J680AP`), 15,2 (`J132AP`), 15,3 (`J780AP`), & 15,4 (`J213AP`)
- MacBookPro16,1 (`J152FAP`), 16,3 (`J223AP`), & 16,4 (`J215AP`)
- MacBookPro16,2 (`J214KAP`)
- MacBookAir8,1 (`J140KAP`) & 8,2 (`J140AAP`) 
- MacBookAir9,1 (`J230KAP`) 
- Macmini8,1 (`J174AP`)
- iMac20,1 (`J185AP`) & 20,2 (`J185FAP`) 
- iMacPro1,1 (`J137AP`)
- MacPro7,1 (`J160AP`)

To confirm that the parameter is set, enter in Terminal: `sysctl hw.target`</br>
It should return the same value for HWTarget you entered in the config.
