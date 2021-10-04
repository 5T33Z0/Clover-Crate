# Quirks

`Quirks` is a set of features to configure Booter and Kernel Settings of Clover. The underlying technology is OpenCore's `OpenRuntime.efi` which has been fully integrated into Clover since r5126. It replaces the previously used `AptioMemoryFixes` which are no longer capable of booting newer macOS versions. So an upgrade to r5126 or later is mandatory in order to be able to install and boot macOS Big Sur and newer with Clover.

The following Screenshot shows, which Quirk does what:

![Quirks1](https://user-images.githubusercontent.com/76865553/135844035-1689a11a-6512-4008-80ea-e89f07a55367.png)

Unfortunately, some of the Kernel Quirks are not located in the `Quirks` section but in the "Kext and Kernel Patches" section instead and – to add even more confusion – have different names than in OpenCore:

![quirks2](https://user-images.githubusercontent.com/76865553/135859628-34f6be51-7a20-4461-900e-0c72fbdcba51.png)

In oder to set these Quirks up correctly, you need a documentation. Therefore check the following sections of the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) for your CPU family:

- **Booter > Quirks**
- **Kernel > Quirks**
- **Kernel > Scheme**

Users of Clover < r5126 can follow my [**Clover Update Guide**](https://www.insanelymac.com/forum/topic/345789-guide-how-to-update-clover-for-bigsur-compatibility-and-beyond-using-openruntime-and-quirks-r5123) on insanelymac.com to replace the outdated `AptioMemoryFixes` by `OpenRuntime.efi`.
