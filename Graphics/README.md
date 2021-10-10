# Graphics
![Graphics](https://user-images.githubusercontent.com/76865553/136713622-7300a5e5-de05-413a-b748-579b95a36d58.jpeg)

This group of parameters serves to inject Properties for various graphics cards, on-board and discrete. There are many parameters that are actually injected, but they are mostly constants, some are calculated, some are defined in the internal table and only very few parameters are entered via config.

**NOTE**: **Most of these options are completely outdated and obsolete nowadays.** Instead, framebuffer patches are entered via `Devices/Properties`. The only things which are actually still working are the entries in the dropdown menu of `ig-platform-id` for Intel IGPUs (up to Coffeelake)

## Inject
Inject two dozens of parameters, which are calculated not only based on the card model, but also on its internal characteristics after analyzing its video bios. 

For Nvidia its `NVCAP` is calculated, for Intel dozens of parameters are available, for ATI parameters depending on connectors. To list all this would take another two hundred pages. Moreover, for modern cards you don't need these any more, since Apple ensured that they work out of the box.

These injections were used before the advent of `Whatevergreen.kext` (WEG). Now that the WEG does all the graphics customization work for you, it is recommended to disable all these injections.

### ATI
### Intel
### NVidia

## Dual Link
The default value is `1`, but for some older configurations this will cause the screen to flatten. It helps to set it to 0, as in the example above.

## FB Name
This parameter is specific to ATI Radeon Cards, for which about three dozens different framebuffers exist which don't follow any specific pattern. Clover automatically chooses the most appropriate name from the table on most known cards. 

However, other users of the exact same card are challenged, they want a different name. So select one from the dropdown menu.

## RadeonDeInit
This key works with ATI/AMD Radeon cards 6xxx and higher. Or maybe 5xxx, haven't seen any reviews. It fixes the contents of GPU registers so that the card becomes properly initialized and MacOSX drivers work with it as intended.
