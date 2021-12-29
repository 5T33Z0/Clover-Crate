# Kexts and the `kexts` folder
## About Kexts
Kexts is an abbreviation for "Kernel Extensions". Kexts are required by the mac Operating System. Most of them are either device drivers of some sort or pseudo-drivers for devices missing from PC hardware, such as `FakeSMC` or `VirtualSMC` which emulate the all important System Management Controller which doesn't exist on PC hardware but is required by macOS to run. We need to inject these kexts since the Apple system doesn't support our devices, or we want to add new functionality. For Linux and Windows no Kexts are required.

## About the `kexts` folder used by Clover
Since revision 3281, Clover loads kexts conditionally, based on the folders kexts are located in. The hierarchy is as follows:

1. By default, all kexts placed in the `kexts\Other` folder are loaded first and for *any* version of macOS.
2. Next, Kexts located in sub-folders corresponding to specifc macOS versions are loaded (e.g. `10.15`, `11`, `12`, etc.). This is a pretty handy feature since some macOS versions require different variants and combinations of kexts to make a feature/component work (networking kext like `BrcmPatchRAM` come to mind, for example). This way you don't have to worry about juggling Kexts around between the `Off` and `Other` folders when using differnt versions of macOS.

**NOTES**: This approach of kext management is similar to the `MinKernel` and `MaxKernel` parameters used by OpenCore, it's just not as elegant, since this will create duplicate kexts which all have to be updated once a new version of a kext is available.

## Example of conditional Kext Loading
In the screenshot below, you see an example of conditional kext loading used on a Laptop:
![kexts](https://user-images.githubusercontent.com/76865553/147611657-b56b13b3-0b5b-440e-9eb8-3a48849d903f.png)

As you can see, most of the kexts reside in the `kexts\Other` folder, but there are addtitonal kexts loaded for other versions of macOS:

- for macOS `10.13`, additinal kexts `BrcmPatcRAM2` and `NoTouchID` are required
- for macOS `10.14` only `BrcmPatcRAM2.kext` is needed additionally
- for macOS `10.15` and `11`, my Broadcom Wifi/BT Card requires `BrcmPatcRAM3.kext` and `BrcmBluetoothInjector.kext` to work.
- for macOS `12` on the other hand, which uses a completely new Bluetooth stack, only `BlueToolFixup.kext` is required instead.

The benefit of managing kexts this way is that you don't have to create different EFI folders just for running different versions of macOS on the same system. All that you may need is a different config.plist with maybe a different SMBIOS or additional/different patches required for that macOS version to run. Since you can change configs from the Clover Bootmenu this is a pretty comfortable methed to manage various macOS versions with just one EFI Folder.
