# Fixing "About this Hack" App Bootloader Info if Clover is used

## About
If you are using a Clover EFI folder that you set-up manually without using the .pkg installer, the new "About this Hack" app does show the used Clover version. Instead it simply says "Apple UEFI":

![Clover](https://github.com/0xCUB3/About-This-Hack/assets/76865553/21af2758-de06-45b9-9acb-72ad59f8417b)

This is because it requires a little helper called "bdmesg". It is installed when running the Clover.pkg installer, so it's missing if you didn't use the installer (which you definitely should not do if you plan to use Clover alongside OpenCore).

## The fix
- Download [utils.zip](https://github.com/CloverHackyColor/CloverBootloader/releases/download/5156/utils.zip) and unpack it
- Copy `bdmesg`
- In Finder, press <kbd>CMD</kbd> + <kbd>SHIFT</kbd> + <kbd>.</kbd> (dot) to show hidden files and folders
- Navigate to `usr/local/bin`
- Paste the `bdmesg` file
- Press <kbd>CMD</kbd> + <kbd>SHIFT</kbd> + <kbd>.</kbd> (dot) again to hide hidden files and folders
- Reboot into Clover
- Perform an NVRAM Reset (`F11`)
- Boot into macOS.

Now the Bootloader entry will be displayed correctly:

![Bildschirmfoto 2023-10-25 um 10 18 11](https://github.com/0xCUB3/About-This-Hack/assets/76865553/28d9fd18-77da-407b-8380-12ba1dc2b837)

## Credits
matpxa for the [fix](https://github.com/0xCUB3/About-This-Hack/issues/74)
