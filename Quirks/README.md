# Quirks

`Quirks` is a set of features to configure Booter and Kernel Settings of Clover. The underlying technology is OpenCore's `OpenRuntime.efi` which has been fully integrated into Clover since r5126. It replaces the previously used `AptioMemoryFixes` which are no longer capable of booting newer macOS versions.So an upgrade to r5126 or later is mandatory in order to be able to install and boot macOS Big Sur and newer with Clover.

The following Screenshot shows, which Quirk does what:

![Quirks1](https://user-images.githubusercontent.com/76865553/135844035-1689a11a-6512-4008-80ea-e89f07a55367.png)

Unfortunately, some of the Kernel Quirks are not located in the `Quirks` section but in the "Kext and Kernel Patches" section instead and – to add even more confusion – have different names than in OpenCore:

![Quirks2](https://user-images.githubusercontent.com/76865553/135844067-29e9879c-1d70-431e-ae91-a87d9aae4682.png)

In oder to set these Quirks up correctly, you need a documentation. Therefore check the following sections of the [**OpenCore Install Guide**](https://dortania.github.io/OpenCore-Install-Guide/) for your CPU family:

**Booter > Quirks**</br>
**Kernel > Quirks**</br>
**Kernel > Scheme**</br>
