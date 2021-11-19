// Automatic injection of HDEF properties

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_HDEF", 0)
{
#endif
    External(RMCF.AUDL, IntObj)
    External(RMDA, IntObj)
    External(RMCF.DAUD, IntObj)

    // Note: If your ACPI set (DSDT+SSDTs) does not define HDEF (or AZAL or HDAS)
    // add this Device definition (by uncommenting it)
    //
    //Device(_SB.PCI0.HDEF)
    //{
    //    Name(_ADR, 0x001b0000)
    //    Name(_PRW, Package() { 0x0d, 0x05 }) // may need tweaking (or not needed)
    //}

    // inject properties for audio
    Method(_SB.PCI0.HDEF._DSM, 4)
    {
        If (CondRefOf(\RMCF.AUDL)) { If (Ones == \RMCF.AUDL) { Return(0) } }
        If (!Arg2) { Return (Buffer() { 0x03 } ) }
        Local0 = Package()
        {
            "layout-id", Buffer(4) { 2, 0, 0, 0 },
            "hda-gfx", Buffer() { "onboard-1" },
            "no-controller-patch", Buffer() { 1, 0, 0, 0 }, // disables automatic AppleALC patching
            "PinConfigurations", Buffer() { },
        }
        If (CondRefOf(\RMCF.AUDL))
        {
            CreateDWordField(DerefOf(Local0[1]), 0, AUDL)
            AUDL = \RMCF.AUDL
        }
        // the user can disable "hda-gfx" injection by defining \RMDA or setting RMCF.DAUD=0
        // assumes that "hda-gfx" is always at index 2 (eg. "hda-gfx" follows ig-platform-id)
        Local1 = 0
        If (CondRefOf(\RMDA)) { Local1 = 1 }
        If (CondRefOf(\RMCF.DAUD)) { If (0 == \RMCF.DAUD) { Local1 = 1 } }
        If (Local1) { Local0[2] = "#hda-gfx"; }
        Return(Local0)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
