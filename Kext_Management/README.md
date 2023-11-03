# Kext Management in Clover
## About Kexts
Kexts is an abbreviation for "Kernel Extensions". They are required by macOS. Most of them are either device drivers of some sort or pseudo-drivers for devices missing from PC hardware, such as `FakeSMC` or `VirtualSMC` which emulate the all important System Management Controller which doesn't exist on PC hardware but is required by macOS to run. We need to inject these kexts since the Apple system doesn't support our devices, or we want to add new functionality. For Linux and Windows no Kexts are required.

## About the `kexts` folder used by Clover
Clover r3281 introduced conditional kext loading based on sub-folders kexts are located in. The hierarchy is as follows:

1. By default, all kexts placed in the `kexts\Other` folder are loaded first and for *any* version of macOS. You should leave all kexts that are required for macOS in general in there (like Lilu, VirtualsSMC, Whatevergreen, AppleALC, etc). Otherwise your system won't boot when trying to upgrade to a newer version of macOS.
2. Next, Kexts located in sub-folders corresponding to specific versions of macOS are loaded (e.g. `10.15`, `11`, `12`, etc.). This is useful for versions of macOS which require specific kexts or different variants or combinations of kexts to make a feature/component work (kexts like `BrcmPatchRAM` or `CryptexFixup` come to mind). This way, you don't need to jugge Kexts around between the `Off` and `Other` folder when switching between different macOS installations. Only place kexts required for specific versions of macOS in the corresponding numbered folers.

> [!NOTE]
> 
> - This approach to kext management is similar to OpenCore's `MinKernel` and `MaxKernel` parameters. It's just not as elegant: it will produce duplicate kexts, updating them requires more effort and the overall size of the EFI increases. 
> - On the other hand, you don't have to worry about kext order when using Clover – unlike OpenCore, where sorting kexts in the wrong order or listing kexts which are not present in the kexts folder inevitably result in Kernel Panics on boot.

## Example of conditional Kext Loading
In the screenshot below, you see an example of conditional kext loading used on a Laptop:
![kexts](https://user-images.githubusercontent.com/76865553/147611657-b56b13b3-0b5b-440e-9eb8-3a48849d903f.png)

As you can see, most of the kexts reside in the `kexts\Other` folder, but there are additional kexts loaded for other versions of macOS:

- for macOS `10.13`, additional kexts `BrcmPatcRAM2` and `NoTouchID` are required.
- for macOS `10.14` only `BrcmPatcRAM2.kext` is needed, since the issue that required `NoTouchID` has been fixed since macOS Mojave.
- for macOS `10.15` and `11`, my Broadcom Wifi/BT Card requires `BrcmPatcRAM3.kext` and `BrcmBluetoothInjector.kext` to work.
- for macOS `12`, only `BlueToolFixup.kext` is required for Bluetooth. Although it doesn't require `BrcmFirmwareData`, I just leave it in the `Other` folder since it is required by macOS 10.13 to 11 and doesn't cause trouble. Otherwise I would need it 4 times.

The benefit of managing kexts this way is that you don't have to create different EFI folders for running various versions of macOS on the same system. All you may need is a different `config.plist` with a different SMBIOS or additional/different patches required for that macOS version to run. Since you can switch configs from within the Clover Boot menu, this is a pretty handy way to manage various macOS versions with just one EFI Folder.
