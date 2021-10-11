# GUI
![GUI](https://user-images.githubusercontent.com/76865553/136703745-7ec35d11-5458-482c-a8c8-ccaf48d9650d.jpeg)

This section is for configuring the look and behavior of Clover's Bootmenu GUI as well as defining which Volumes are displayed.

## Mouse
### Enabled
`Enabled` - self explanatory. Disable the mouse if it causes issues in the Bootmenu

### Speed
`Speed` – Sets the speed of the cursor, reasonable values are 2 to 8. Some mice require negative speed, moving in the opposite direction. A value of 0 means that the mouse is disabled.

### Mirror
Inverts the mouse speed to correct inverted mouse movement.

## Scan
![GUI_Scan](https://user-images.githubusercontent.com/76865553/136699885-281deddd-0151-4e06-a489-4299669fe4d3.png)

### Entries (To do)
### Kernel (To do)
### Legacy (To do)
### Tool (To do)

### CustomIcons
Enabling this key will use custom disk icons stored in in the root folder of the volumes  themselved, instead of using the disk icon from a theme. It is this file: `.VolumeIcon.icns` which is a hidden file. To show all files in Finder, use:

`defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder`

After you're done with your changes, set it to `FALSE` again:

`defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder`

### EmbeddedThemeType
Select between `Dark` and `Light` variant of the embedded themee. If left unset, the variants are picked based by the real time clock – light during the day, dark at night. Introduced in r4773.

### KbdPrevLang
Select your prefered Keyboard Layout for macOS if you want to save the system language when upgrading macOS with native NVRAM.

In combination with `Language`, this can used to fix an issue when installing beta versions of macOS. These sometimes do not include other languages besides english. In this case you will just see a gray screen where there the install assistant should be. Just set `Language` to `en-US:0` and you will be fine. 

### Language
At of now moment, setting the language makes sense only for the "Help" menu called by the F1 Key. However, this value is sent to the system and can affect the default language.

### PlayAsync
Clover r4833 added audio support for the Bootmenu via the `AudioDxe.efi` driver. `PlayAsync` determines the playback mode of the boot chime: either sequential or simultaneously. With synchronous playback (default), the boot process is sequential: chime first, then the bootloader kicks in. If `PlayAsync` is enabled, the boot process will run parallel or simultaneously to the audio playback. The chime has to called `sound.wav` and need to be placed in the root folder of the used theme.
</br>**NOTE**: If the file is too long it will be cut at some stage during boot, when macOS takes over control of the audio driver. In my (5T33ZO) opinion, they should have called this feature "PlaySimult" instead, because that what it does. Using the term `asynchronous` in the context of audio always ewokes a feeling an issue rather than a feature.

### ProvideConsoleGop
Creates a GOP protocol for console mode, i.e. for text output not in text mode, as you are used to doing in PC BIOS, but in graphical mode, as Apple does.

In revisions prior to r5128, this setting was also present in Quirks as `ProvideConsoleGopEnable` but has since been removed to avoid duplicate parameters.

`ProvideConsoleGop` from GUI will override `ProvideConsoleGopEnable` from the `Quirks` section  – just in case you forgot to remove this parameter from the config when updating the Clover.

### ScreenResolution
Here you can change the default Screen Resolution of the Bootmenu GUI. The default is 1024x768 px. Clover detects the highest possible resolution, but it can be wrong, so you can pick the correct or desired value from the dropdown menu.

### ShowOptimus
Enables an on-screen notifictaion in the Bootmenu which about which GPUs are enabled, so you can disabled discrete Optimus GPUs on the fly since they are not supprted by macOS. If on-board and Disrete GPU are enabled, the noifictaion `Intel Discrete` is displayed.

### TextOnly
Text-only menu mode for a minimal GUI and faster loading times (like it was 1984 all over again).

## Custom Entries
In this section you can add your own entries to the Bootmenu GUI. This is useful if an entry is missing or if you want to customize it. Click on the "+" sybol to add an entry to the list. After double Clicking the entry, a sub-menu is opened: 

![Custom_Entry](https://user-images.githubusercontent.com/76865553/136745225-5c06bd82-b7a8-4459-b29d-52870742941e.png)

Here you can change a lot of things. The most important one being the dropdown menu for selecting the "Volume" the custom entry should represent:

![GUID](https://user-images.githubusercontent.com/76865553/136699942-79efe2a9-2995-48fe-a6fd-aad342ae259a.png)

Enter a custom name in the `Title` field, set `Type` and `Volume Type` and it should work.
