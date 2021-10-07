# Devices

### SetIntelBacklight

The key was introduced in r3298. In previous systems, the screen brightness was controlled by `IntelBacklight.kext` or `ACPIBacklight.kext`, but they didn't work in El Capitan. But it turned out to be very easy to do this in Clover at the stage of system startup, so no additional cakes were needed.</br>
**NOTE**: This doesn't work with current macOS versions. Use a `SSDT-PNLF.aml` instead
