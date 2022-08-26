# Kext Management in Clover
## About Kexts
Kexts is an abbreviation for "Kernel Extensions". They are required by macOS. Most of them are either device drivers of some sort or pseudo-drivers for devices missing from PC hardware, such as `FakeSMC` or `VirtualSMC` which emulate the all important System Management Controller which doesn't exist on PC hardware but is required by macOS to run. We need to inject these kexts since the Apple system doesn't support our devices, or we want to add new functionality. For Linux and Windows no Kexts are required.

## About the `kexts` folder used by Clover
Since revision 3281, Clover loads kexts conditionally, based on the folders kexts are located in. The hierarchy is as follows:

1. By default, all kexts placed in the `kexts\Other` folder are loaded first and for *any* version of macOS.
2. Next, Kexts located in sub-folders corresponding to specific macOS versions are loaded (e.g. `10.15`, `11`, `12`, etc.). This is a pretty handy feature since some macOS versions require different variants and combinations of kexts to make a feature/component work (networking kext like `BrcmPatchRAM` come to mind, for example). This way you don't have to worry about juggling Kexts around between the `Off` and `Other` folders when using different versions of macOS.

NOTES: This approach of kext management is similar to OpenCore's `MinKernel` and `MaxKernel` parameters. It's just not as elegant: it will produce duplicate kexts, updating them requires more effort and the overall size of the EFI increases.

## Example of conditional Kext Loading
In the screenshot below, you see an example of conditional kext loading used on a Laptop:
![kexts](https://user-images.githubusercontent.com/76865553/147611657-b56b13b3-0b5b-440e-9eb8-3a48849d903f.png)

As you can see, most of the kexts reside in the `kexts\Other` folder, but there are additional kexts loaded for other versions of macOS:

- for macOS `10.13`, additional kexts `BrcmPatcRAM2` and `NoTouchID` are required.
- for macOS `10.14` only `BrcmPatcRAM2.kext` is needed, since the issue that required `NoTouchID` has been fixed since macOS Mojave.
- for macOS `10.15` and `11`, my Broadcom Wifi/BT Card requires `BrcmPatcRAM3.kext` and `BrcmBluetoothInjector.kext` to work.
- for macOS `12`, only `BlueToolFixup.kext` is required for Bluetooth. Although it doesn't require `BrcmFirmwareData`, I just leave it in the `Other` folder since it is required by macOS 10.13 to 11 and doesn't cause trouble. Otherwise I would need it 4 times.

The benefit of managing kexts this way is that you don't have to create different EFI folders for running various versions of macOS on the same system. All you may need is a different `config.plist` with a different SMBIOS or additional/different patches required for that macOS version to run. Since you can switch configs from within the Clover Boot menu, this is a pretty handy way to manage various macOS versions with just one EFI Folder.
