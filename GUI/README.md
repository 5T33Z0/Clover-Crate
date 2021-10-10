# GUI
![GUI](https://user-images.githubusercontent.com/76865553/136699874-f3d49b90-90fe-4e40-8d38-4e189d4b2c98.png)

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
Enabling this key will load the icon from the of the partition itself, instead of using the icon defined by the theme. It has to be located in the root of the volume and has to be this file: `VolumeIcon.icns`. You can assign your own icons to each volume, and you can use different icons for different volumes.

### EmbeddedThemeType
Select between `Dark` and `Light` variant of the embedded themee. If left unset, the variants are picked based by the real time clock – light during the day, dark at night. Introduced in r4773.

### KbdPrevLang
Select your prefered Keyboard Layout for macOS if you want to save the system language when upgrading macOS with native NVRAM.

In combination with `Language`, this can used to fix an issue when installing beta versions of macOS. These sometimes do not include other languages besides english. In this case you will just see a gray screen where there the install assistant should be. Just set `Language` to `en-US:0` and you will be fine. 

### Language
At of now moment, setting the language makes sense only for the "Help" menu called by the F1 Key. However, this value is sent to the system and can affect the default language.

### PlayAsync
Clover r4833 added audio-support for the Bootmenu via the `AudioDxe.efi` driver. `PlayAsync` determines whether the sound plays synchronously or asynchronously. With synchronous playback (default), nothing happens boot-wise until the sound playback ends. 

If `PlayAsync` is enabled, the boot process will run parallel to the audio playback. if the `sound.wav` file is too long it will be cut at some stage during the boot process, when macOS takes over control of the audio driver.

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

![CustomEntries](https://user-images.githubusercontent.com/76865553/136699902-97579045-ba7f-48e0-a95f-31019613f524.png)

Here you can change a lot of things. The most important one being the dropdown menu for selecting the "Volume" the custom entry should represent:

![GUID](https://user-images.githubusercontent.com/76865553/136699942-79efe2a9-2995-48fe-a6fd-aad342ae259a.png)
