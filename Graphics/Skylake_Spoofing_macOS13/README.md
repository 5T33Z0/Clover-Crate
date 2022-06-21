# Enabling Skylake Graphics in macOS 13
![](/Users/5t33z0/Desktop/spoofkbl.png)

With the release of macOS 13 beta, support for 4th to 6th Gen CPUs was [dropped](https://github.com/dortania/OpenCore-Legacy-Patcher/issues/998) – on-board graphics included. In order to enable integrated graphics, you need to spoof Kaby Lake Framebuffers. The example below is from an i7 6700K.

Do the following to enable Intel HD 530 on-board graphics in macOS 13: 

- Download the latest version of [Lilu](https://dortania.github.io/builds/?product=Lilu&viewall=true) available on Dortanias Build Repo and unzip it
- [Download](https://github.com/5T33Z0/Clover-Crate/blob/main/Graphics/Skylake_Spoofing_macOS13/WhateverGreen-1.6.0-RELEASE.zip?raw=true) and unzip this specific build of Whatevergreen. It's from a different [branch](https://github.com/acidanthera/WhateverGreen/actions/runs/2495481119) of the Whatevergreen, which supports Skylake spoofing.
- Download and unzip [SKLAsKBLGraphicsInfo.kext](https://github.com/Lorys89/OC-Little-Translated/raw/main/11_Graphics/iGPU/SKLAsKBLGraphicsInfo.kext.zip)
- Mount your EFI
- Add the 3 kexts to `EFI/CLOVER/kexts/other`.
- Open the config.plist.
- Change SMBIOS to `iMac18,1`
- Under `Devices/Properties`, create a new entry 
- Name it `PciRoot(0x0)/Pci(0x2,0x0)` (if it doesn't exist already)
- Add or modify the following Keys:
	|Key Name                |Value     | Type
	-------------------------|----------|:----:
	AAPL,ig-platform-id      | 00001259 | Data
	device-id                | 12590000 | Data
- Save you config and reboot

## Verifying
Run either [VDADecoderChecker](https://i.applelife.ru/2019/05/451893_10.12_VDADecoderChecker.zip) or VideoProc. In this case, iGPU Acceleration is working fine:

![videoproc_HD530](https://user-images.githubusercontent.com/76865553/174106261-050c342d-66f9-4f98-b63c-c4bbea3f7f28.png)

## CREDITS
- PMheart for the Patch 
- Acidanthera for the kexts
- Slice et. al. for Clover
- Cyberdevs for the [settings](https://www.insanelymac.com/forum/topic/351969-pre-release-macos-ventura/?do=findComment&comment=2785675)
