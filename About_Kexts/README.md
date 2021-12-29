# Kexts and the `kexts` folder
## About Kexts
Kexts is an abbreviation for "Kernel Extensions". Kexts are required by the mac Operating System. Most of them are either device drivers of some sort or pseudo-drivers for devices missing from PC hardware, such as `FakeSMC` or `VirtualSMC` which emulate the all important System Management Controller which doesn't exist on PC hardware but is required by macOS to run. We need to inject these kexts since the Apple system doesn't support our devices, or we want to add new functionality. For Linux and Windows no Kexts are required.

## About the `kexts` folder used by Clover
Since revision 3281, Clover loads kexts conditionally, based on the folders kexts are located in. The hierarchy is as follows:

1. By default, all kexts placed in the `kexts\Other` folder are loaded first and for *any* version of macOS.
2. Next, Kexts located in sub-folders corresponding to specifc macOS versions are loaded (e.g. `10.15`, `11`, `12`, etc.). This is a pretty handy feature since some macOS versions require different variants and combinations of kexts to make a feature/component work (networking kext like `BrcmPatchRAM` come to mind, for example). This way you don't have to worry about juggling Kexts around between the `Off` and `Other` folders when using differnt versions of macOS.

**NOTE**: This method of kext management is similar to the `MinKernel` and `MaxKernel` parameters used by OpenCore. Although not as elegant, since this will create duplicate kexts which all have to be updated once a new version of a kext is available.

## Example of conditional Kext Loading
![kexts](https://user-images.githubusercontent.com/76865553/147611657-b56b13b3-0b5b-440e-9eb8-3a48849d903f.png)
