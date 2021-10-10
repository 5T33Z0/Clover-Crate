# System Parameters
![sysparams](https://user-images.githubusercontent.com/76865553/136677062-ef979281-d50b-44a6-9b28-363c8cb70175.png)

## Backlight Level
Monitor brightness level. However, only few systems will be affected by this parameter. It also is read from NVRAM. By default a value given by the system is used. Specifying it in the configuration file will override it.

## CustomUUID
Unique identification number of your computer. If you don't put this key in, some of the hardware information will be generated, but if you want full control over what happens, hit "Generate New" to create your own or "Get it from system".

## InjectKexts
This key defines the global policy regarding kext injection:

- `Yes`: Always inject kexts from `/EFI/CLOVER/kexts/` 
- `No`: Never inject kexts

Since Clover r5125, loading of Kexts is handled by OpenCore, so `FSInject` is obsolete.

## InjectSystemID
For Chameleon users switching over to Clover!? – not covered here, obsolete don't care, leave disabled and carry on!

## NoCaches
If enabled, the cache will be skipped on each boot. And just like `InjectKexts`, this key defines the global rule, so the value defined on Custom Entries will override this one.

## NvidiaWeb
If key value is true, it will allow access to load and use Nvidia WebDriver kexts from MacOS 10.12 onwards. You still need to install Nvidia Webdrivers of course, which are only supported up to macOS High Siera (10.13.6).

