# System Parameters
![sysparams](https://user-images.githubusercontent.com/76865553/136677062-ef979281-d50b-44a6-9b28-363c8cb70175.png)

## Backlight Level
Sets and stores the user default monitor brightness level in NVRAM. However, this only works on some systems. By default, a value from macOS is used. Changing the Backlight Level in the config.plist will override the default brightness level set by macOS. 

**Format**: Hex, for example `0x0101`

## CustomUUID
Unique identification number of your system. If you don't put this key in, some hardware information will be generated, but if you want full control over what happens, hit "Generate New" to create your own or "Get it from system".

## InjectKexts (deprecated)
This key defines the global policy regarding kext injection:

- `Yes`: Injects kexts located under `/EFI/CLOVER/kexts/`
- `No`: ~~Doesn't inject kexts~~

Since the release of Clover r5125, kext injection is solely handled by `OpenRuntime` now which replaces the previously used `FSInject.efi`. 

Since the `InjectKexts` function was part of FSInject, the switch is "dead" now – so delete `FSInject.efi` from Drivers/UEFI! In other words: unless you are using Clover ≤ r5231.1 with the old Aptio Memory Fixes, leaving `InjectKexts` enabled or disabled doesn't matter at all – kexts will be injected into macOS anyway!

## InjectSystemID
Injects System ID into macOS. If this is not enabled, the System ID is missing and will be displayed as "???" in Hackintool which might lead to issues with your Apple ID when transferring over SMBIOS Data from OpenCore and vice versa. Users switching over from Chameleon also need to enable this.

## NoCaches
If enabled, the cache will be skipped on each boot. And just like `InjectKexts`, this key defines the global rule, so the value defined on Custom Entries will override this one.

## NvidiaWeb
If enabled, this will allow to load and use the Nvidia WebDriver kexts for NVIDIA GeForce Cards from macOS 10.12 onwards. You still need to install the [**Nvidia Web Drivers**](https://www.tonymacx86.com/nvidia-drivers/), which are only supported up to macOS High Sierra (10.13.6).
