# Clover Optionen erklärt

Stand: 02.10.2021, by 5T33Z0
>
>**Disclaimer**: Die hier präsentierten Informationen basieren im Wesentlichen auf Übersetzungen von Auszügen aus dem russischen Handbuch zu Clover r5129 sowie aus der P-Little Repo von daliansky (chinesisch). die ich mit Hilfe von deepL, yandex und google translate ins Deutsche übersetzt habe und trotz genauer Revision Fehler beinhalten können!

Dieser Guide schildert die Funktionen des Clover Bootloaders anhande der im Clover Configurator verfügbaren Optionen. Die Gliederung folgt dabei grob der durch die `config.plist` und dem Clover Configurator vorgegebenen Struktur.

<details>
<summary><strong>Table of Contents</strong></summary>

[TOC]

</details>
<details>
<summary><strong>ACPI</strong></summary>

## I. ACPI
Die folgenden Erläturungen beziehen sich auf den Abschnitt ACPI des Clover Configurtaors: 

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/ACPI_FULL.png)

Dieser Abschnitt spielt eine zentrale Roller bei der Konfigurtaion von Clover und somit eines Hackintoshes. Daher wird hier auf jede einzelne Option dieses Abschbitts eingegangen.

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto.png)

### Patch APIC

Einige Computer können nur mit `cpus=1` oder mit einem gepatchten Kernel (Lapic NMI Patch) gebootet werden, die ihre `MADT`-Tabelle falsch ist und NMI-Partitionen fehlen. Mit `Patch APIC` werden solche Tabellen automatisch korrigiert. Bei einem funktuonierenden System Computer wird nichts Schlimmes passieren, wenn dieser Fix aktiviert ist.

### Smart UPS

Dieser Patch ändert das Leistungsprofil in der `FADT`-Tabelle auf `3`. Die Logik ist wie folgt:

`PM=1` - Desktop, Netzstrom </br>
`PM=2` - Notebook, Netz- oder Batteriestrom </br>
`PM=3` - Server mit USV (wird von macOS unterstützt)

Clover wählt zwischen `1` und `2` auf der Grundlage einer Analyse des Mobilitätsbits, aber es gibt auch einen Parameter Mobile im SMBIOS-Abschnitt. Sie können zum Beispiel sagen, dass wir einen MacMini haben und dass er mobil ist. Ein Wert von `3` wird ersetzt, wenn `smartUPS=Yes`.

### Halt Enabler

Dieser Fix behebt das Shutdown/Sleep-Problem während eines UEFI-Boots. Der Fix wird nur einmal injiziert, vor dem Aufruf von `boot.efi`, sodass eine 100%ige Effizienz nicht garantiert werden kann. Dennoch ist er ziemlich sicher, zumindest auf Intel-Systemen.

### AutoMerge

Kombiniert alle `DSDT'- und `SSDT`-Änderungen aus `ACPI/patched` mit bestehenden ACPI-Dateien.
Wenn es auf `true` gesetzt ist, ändert es die Art und Weise, wie mit Dateien in `ACPI/patched` verfahren wird: Anstatt diese Dateien ans Ende der `DSDT` einzufügen, werden die Tabellen stattdessen ersetzt, wenn die Signatur, der Index und die OemTableId mit existierenden OEM-Tabellen übereinstimmen.

Das bedeutet, dass man damit nicht nur die original DSDT durch eine gepatchte ersetzen kann, somdern auch andere SSDTs die beim dumpen der ACPI Tabellen erhalten hat. Wenn in `ACPI/origin` zum Beispiel `SSDT-6-SaSsdt.aml` enthält, könnte man diese fixen und in ACPI/patched ablegen als `SSDT-6.aml`, die dann bei Booten die Originaltabelle ersezen würde.

Da einige OEM ACPI Sets keinen eindeutigen Text im OEM table-id Feld verwenden, benutzt Clover sowohl die OEM table-id als auch die Nummer, die Teil des Dateinamens ist, um das Original in XDST zu finden. Wenn Sie sich an die in ACPI/origin angegebenen Namen halten, sollte alles in Ordnung sein. Hinzugefügt von Rehabman in r4265 bis 4346.

### FixHeaders

`FixHeaders` überprüft die Header aller ACPI-Tabellen und entfernt chinesische Zeichen aus den Tebellen-Header, da macOS diese nicht verarbeiten kann, was zu Kernel Panics führe. Dieses Problem wurde in macOS Mojave behoben, aber in High Sierra wird der Fix benötigt. 

Egal, ob ein Problem mit Tabellen-Headern vorhanden ist oder nicht, es ist okay, diese Korrektur zu aktivieren. Sie wird allen Benutzern empfohlen, auch wenn Sie Ihre DSDT nicht reparieren müssen. Alte Einstellungen innerhalb der DSDT-Fixes bleiben aus Gründen der Abwärtskompatibilität erhalten, aber ich empfehle, sie aus diesen Abschnitten auszuschließen.

### FixMCFG

Wenn aktiviert, wird die Tabelle nicht verworfen, sondern korrigiert. Der Autor des Patches ist vit9696.

### Disable ASPM

Dies betrifft die Einstellungen des ACPI-Systems selbst, z.B. die Tatsache, dass Apples ASPM-Management nicht wie erwartet funktioniert. Insbesondere bei Verwendung von nicht unterstützten Chipsätzen. In welchen Fällen es notwendig ist, dies zu aktivieren, und was es bewirkt, weiß ich nicht mehr. 

> Anmerkung von 5T33Z0: Ich zitiere hier immer noch aus dem Clover Handbuch – dies sind nicht meine Worte! ;)

### Reset Address / Reset Value

Beide Parameter dienen zum Fixen des Neustarts. Diese Werte sollten in der `FADT` Tabelle stehen, aber aus irgendeinem Grund sind sie nicht immer vorhanden, außerdem ist die Tabelle selbst manchmal kürzer als nötig, so viel kürzer, dass diese Werte verworfen werden. 

Der Standardwert ist bereits in `FACP` vorhanden, aber wenn dort nichts steht, wird das Paar `0x64/0xFE` verwendet, was Neustart über PS2 Controller bedeutet. Die Praxis hat gezeigt, dass dies nicht immer bei allen funktioniert. Ein weiteres mögliches Wertepaar ist `0x0CF9/0x06`, was einen Neustart über den PCI-Bus bedeutet. Dieses Paar wird auch auf nativen Macs verwendet, funktioniert aber nicht immer auf Hackintoshes. Der Unterschied ist klar, auf Hackintoshes gibt es auch einen PS2-Controller, der den Neustart stören kann, wenn er nicht zurückgesetzt wird. Eine andere Möglichkeit ist `0x92/0x01`, ich weiß nicht, ob das jemandem hilft.

## DSDT

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 08.16.49.png)

### Debug
Aktiviert das Debugging Log, das unter `EFI/CLOVER/misc/debug.log` gespeichert wird. Aktivieren dieser Funktion verlangsamt den Bootvorgang erheblich, hilft aber bei der Lösung von Problemen.

### RTC8Allowed
siehe "Fixes [2]" Abschnitt → "FixRTC".

### ReuseFFFF
In einigen Fällen wird der Versuch, die GPU zu patchen, durch das Vorhandensein von:

```Swift 
Gerät (PEGP) Typ des Geräts
	{
	Name (_ADR, 0xFFFFFF)
	Name (_SUN, One)
	}
```
Man kann die Adresse auf `0` ändern, aber das funktioniert nicht immer. 

**HINWEIS**: Dieser Fix ist veraltet und wurde in r5116 aus Clover entfernt!

### SlpSmiAtWake

Fügt `SLP_SMI_EN=0` bei jedem Aufwachen hinzu. Dies kann helfen, Probleme mit dem Sleep und Shutdown beim UEFI-Boot zu lösen. **HINWEIS**: Dieser Fix ist veraltet und wurde seit r5134 aus Clover entfernt!

### SuspendOverride

Der Shutdown-Patch funktioniert nur im Energiestatus `5` (Shutdown). Wir können diesen Patch jedoch auf die Zustände `3` und `4` ausweiten, indem wir `SuspendOverride` aktivieren.

Dies hilft beim Einschlafen während eines UEFI-Boots. Symptome: Der Bildschirm schaltet sich aus, aber die Beleuchtung und die Lüfter laufen weiter. Fortgeschrittene Hacker können das Problem durch eine Umbenennung der Binärdatei beheben (hier nicht beschrieben).

### DSDT-Name: 
Hier muss der Namen der **gepatchten** `DSDT` angeben werden, falls sie anders als `DSDT.aml` heißt, sodass Clover sie anwendet.

## DSDT Patches

<Details>
<summary><strong> Exkursion: Geräte Umbenennen (Basics)</strong></summary>

### I. Über Binary Renames

- Die folgenden Geräteumbenennungen sind standardisiert, um mit den in echten Macs verwendeten Gerätenamen übereinzustimmen und die Erstellung von Teilpatches zu erleichtern.
- Die Umbenennung von Geräten und Methoden (einschließlich `_DSM`) wird global auf die `DSDT` eines Systems angewendet.

Nachfolgend finden sich Beispiele für häufig umbenannte Geräte:

| Originalgerät | Umbenannt für macOS | Beschreibung|
|:---------------:| :----------------:| -----------|
| EC | EC0 | Eingebetteter Controller
| EHC1 | EH01 | USB-Controller
| EHC2 | EH02 | USB-Controller
| LPC | LPCB | LPC Bus. Verbindet Geräte mit niedriger Bandbreite mit der CPU
| SAT1 | SATA | SATA-Laufwerk
| XHCI | XHC | USB-Steuerung
| Tastatur|PS2K| Tastatur
| Systembus|SBUS| Systemverwaltungsbus
| Abdeckung|LID0 | Nur für Laptops relevant. Steuert, was beim Öffnen/Schließen des Deckels passiert.
| PowerButton|PWRB| Zum Hinzufügen von Power Button Device
| Ruhetaste| SLPB | Zum Hinzufügen eines Ruhetastengeräts

### II. Binäre Umbenennungen im Detail 

**Voraussetzungen**: Um diese Umbenennungen korrekt durchführen zu können, benötigen man einen Dump der `DSDT` des Systems! 

Namen wie `_DSM` mit einem vorangestellten Unterstrich definieren eine Methode. Diese werden normalerweise umbenannt, indem man das `_` durch ein `X` ersetzt (z.B. `XDSM`), was im Grunde die Methode deaktiviert, sodass stattdessen eine andere oder benutzerdefinierte Methode angewendet werden kann.

| # | Umbenennen | Beschreibung |
|:-:| :----: | ----------- |
|01|_DSM nach XDSM|Deaktiviert Methode `_DSM`|
|02|LPC zu LPCB|In `DSDT`, suchen Sie nach `0x001F0000`. </br> 1: Wenn der Gerätename bereits `LPCB` ist, ist es nicht notwendig, den Namen zu ändern.</br> 2: Wenn es mehrere Treffer für `0x001F0000` gibt, bestimmen Sie sorgfältig, ob diese Namensänderung notwendig ist oder nicht </br>3:Wenn ACPI eine `ECDT.aml` enthält, überprüfen Sie "Über die ECDT`Korrekturmethode".|
|03|EC zu EC0| Ändert den Namen des Embedded Controllers. Überprüfen Sie in DSDT das Gerät, das zu `PNP0C09` gehört.</br>1:Wenn der Gerätename bereits `EC0` ist, ist keine Umbenennung erforderlich </br>2:Wenn es mehrere Übereinstimmungen für `0PNP0C09` gibt, bestätigen Sie den echten `EC`-Namen </br>3:Wenn das ACPI-Paket `ECDT.aml` enthält, lesen Sie "Über ECDT und wie man es korrigiert"|.|.
|04|H_EC zu EC0|Gleich wie EC|
|05|ECDV zu EC0(dell)|Gleich wie EC|
|06|EHC1 zu EH01| Benennt USB-Controller um. Bei Rechnern mit USB2.0, fragen Sie den Gerätenamen `0x001D0000` ab.
|07|EHC2 zu EH02| Für einen 2. USB-Controller
|08|XHCI zu XHC| Ändert den Namen des modernen USB-Controllers. Prüfen Sie den Gerätenamen, der zu `0x00140000` gehört. Wenn der Gerätename bereits `XHC` ist, ist keine binäre Umbenennung notwendig.
|09| XHC1 zu XHC| wie XHCI
|10|KBD zu PS2K|Umbenennen für Tastatur. Überprüfen Sie den Gerätenamen von `PNP0303`, `PNP030B`, `PNP0320`. Wenn der Tastaturname in `DSDT` nicht ermittelt werden kann, prüfen Sie den "BIOS-Namen" der Tastatur im Windows-Geräte-Manager. Wenn die Tastatur bereits `PS2K` heißt, ist keine Umbenennung erforderlich.
|11|KBC0 nach PS2K|gleich|
|12|KBD0 in PS2K|gleich|
|13|SMBU zu SBUS|Benennt den System Management Bus um. Die meisten ThinkPads benötigen dies. </br>Vor der 6. Generation suchen Sie den Gerätenamen, der zu "0x001F0003" gehört </br>6. Generation und spätere Geräte: suchen Sie "0x001F0004", das zum Gerätenamen gehört </br>Wenn der Gerätename `SBUS` bereits vorhanden ist, ist eine Umbenennung nicht erforderlich|
|14|LID zu LID0| Suche den zu `PNP0C0D` gehörenden Gerätenamen und benenne ihn in `LID0` um
|15|PBTN zu PWRB(dell)| Suche nach dem Gerät, das zu `PNP0C0**C**` gehört und benenne es um in `PWRB`
|16|SBTN zu SLPB(dell)| Ruhetaste umbenennen. Suchen Sie das Gerät, das zu `PNP0C0**E**` gehört. Wenn der Name bereits `SLPB` lautet, ist eine Umbenennung nicht erforderlich.

Um einen beliebigen Text in eine Hexadezimalzahl umzuwandeln, können Sie den Hex-Konverter im Clover Configurator verwenden
</details>

In diesem Abschnitt können Sie Umbenennungsregeln (binäre Umbenennungen) hinzufügen, um Text innerhalb der `DSDT` Ihres Systems dynamisch als Binärcode, dargestellt durch Hex-Werte, zu ersetzen. Mit anderen Worten, Sie ersetzen Text, Ziffern und Symbole durch anderen Text, entweder um Konflikte mit macOS zu vermeiden oder um bestimmte Geräte innerhalb von macOS zum Laufen zu bringen, indem Sie sie in etwas umbenennen, das macOS kennt. 

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 07.27.17.png)

Wenn Sie sich die erste Umbenennungsregel "EHC1 in EH01 ändern" ansehen, besteht sie aus einem "Find"-Wert von "45484331" und einem "Replace"-Wert von "45483031", was wörtlich übersetzt "EHC1" und "EH01" bedeutet.

### Geräte umbenennen

RenameDevices" dient als eine verfeinerte Methode für Umbenennungsregeln, die weniger brutal ist als eine einfache binäre Umbenennung, die *jedes* Vorkommen eines Wortes/Wertes in der *gesamten* DSDT ersetzt, was problematisch sein kann. Die hier erstellten Regeln gelten nur für den ACPI-Pfad, der im Feld "Gerät suchen" angegeben ist, so dass diese Patches eine viel sauberere, weniger invasive und effizientere Methode sind, um Geräte zu patchen, die in der "DSDT" definiert sind. 

Um diesen Abschnitt richtig zu nutzen, müssen Sie einen Dump der unmodifizierten `DSDT` erstellen und sie mit maciASL untersuchen. In diesem Fall suchen wir nach `ECH1`:

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Rename Devices.jpg)

Wie Sie sehen können, existiert das Gerät und ist in `\SB_PCI0_EHC1` der `DSDT` untergebracht. Als nächstes weisen wir Clover Configurtor an, den aktuellen Gerätenamen durch `EH01` zu ersetzen, indem wir ihn in das Feld `Rename Device` eintragen. Nachdem der Patch während des Bootens angewendet wurde, sind der Gerätename und seine Abhängigkeiten geändert worden:

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/DSDT_patched.png)

### TgtBridge Erläutert

TgtBridge" ist ein Feld bzw. eine Funktion innerhalb des Abschnitts "ACPI > DSDT > Patches" der Clover "config.plist". Es dient dazu, den Anwendungsbereich von binären DSDT-Patches so einzuschränken, dass sie nur innerhalb eines vordefinierten Abschnitts/Bereichs der `DSDT` funktionieren.

Zum Beispiel: Umbenennung der Methode `_STA` in `_XSTA` im Gerät `GPI0`:

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/TGTBridgeExample.png)

Wie im Beispiel gezeigt, wird der Name der ursprünglichen Methode `_STA` (rosa) in Hex umgewandelt (`5F535441`), damit Clover ihn in der `DSDT` finden kann. Wenn dieser Wert gefunden wird, wird er durch `58535441` (blau) ersetzt, was das hexadezimale Äquivalent des Begriffs `XSTA` (blau) ist. Wenn er so eingestellt ist, würde dieser Patch *jedes* Auftauchen des Begriffs `_STA` in der gesamten `DSDT` in `XSTA` ändern, was wahrscheinlich das System zerstören würde. Um dies zu vermeiden, können Sie `TgtBridge` verwenden, um die Übereinstimmungen dieses Patches auf einen bestimmten Namen/Gerät/Methode/Bereich einzuschränken, in diesem Fall auf das Gerät `GPI0` (Cyan). Im Grunde sagst du Clover: "Schau in `GPI0`und wenn die Methode `_STA` vorhanden ist, benenne sie in `XSTA` um, aber lass den Rest des `DSDT` in Ruhe!"

Welche Werte in `TgtBridge` verwendet werden sollen, ist Ihnen überlassen, wenn Sie wissen, was zu tun ist. Wenn die Längen der Zeichenketten nicht übereinstimmen, wird Clover die Längenänderung korrekt berücksichtigen, mit einer Ausnahme: Stellen Sie sicher, dass dies nicht innerhalb einer "If"- oder "Else"-Anweisung geschieht. Wenn Sie eine solche Änderung benötigen, ersetzen Sie den gesamten Operator. 

Zur Klarstellung: Das Kommentarfeld dient nicht nur als Erinnerung daran, worum es bei dem Patch geht, sondern wird auch im Clover-Bootmenü verwendet, um diese Patches zu aktivieren/deaktivieren. Der Anfangswert für `ON` oder `OFF` wird durch die `Disabled` Zeilen in der `config.plist` bestimmt. Der Standardwert ist `Disabled=false`. Wenn Sie die Patches eines anderen Herstellers verwenden, ist es besser, sie auf `Disabled=true` zu setzen und sie dann nacheinander über das Boot-Menü zu aktivieren.

**HINWEIS**: TgtBridge Bug (behoben seit Clover r5123.1) 

Vor Revision 5123.1 hatte Clover's `TgtBridge` einen Fehler, bei dem es nicht nur von `TgtBridge` angegebene Übereinstimmungen umbenannte, sondern auch Übereinstimmungen in OEM's SSDTs ersetzte, was dazu führte, dass viele Geräte aktiviert wurden, die nicht hätten gestartet werden dürfen. TgtBridge wurde seit Clover r5123.1 behoben, so dass keine weiteren Workarounds erforderlich sind.

## Fixes [1]

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 07.28.34.png)

### AddDTGP

Zusätzlich zu den `DeviceProperties` gibt es auch eine gerätespezifische Methode (`_DSM`) in der `DSDT`, die `DTGP` genannt wird, um benutzerdefinierte Parameter in einige Geräte zu injizieren. 

`_DSM` ist eine bekannte Methode, die in macOS seit Version 10.5 enthalten ist. Sie enthält ein Array mit einer Gerätebeschreibung und einen Aufruf der universellen DTGP-Methode, die für alle Geräte gleich ist. Ohne die DTGP-Methode würden modifizierte `DSDTs` nicht gut funktionieren. Diese Korrektur fügt lediglich diese Methode hinzu, so dass sie dann auf andere Korrekturen angewendet werden kann. Sie funktioniert nicht alleine.

### FixDarwin

Imitiert Windows XP unter Darwin OS. Viele Schlaf- und Helligkeitsprobleme rühren von einer falschen Identifizierung des Systems her.

### FixShutdown

Die Methode `_PTS` wird um eine Bedingung erweitert: wenn argument = 5 (shutdown), dann ist keine weitere Aktion erforderlich. Seltsam, warum? Nichtsdestotrotz gibt es eine wiederholte Bestätigung der Wirksamkeit dieses Patches für ASUS-Boards, vielleicht auch für andere. Einige `DSDT` haben bereits eine solche Prüfung, in diesem Fall sollte ein solcher Fix deaktiviert werden. Wenn `SuspendOverride` = `true` in der Konfiguration gesetzt ist, dann wird dieser Fix um die Argumente 3 und 4 erweitert. Das heißt, es wird in den Ruhezustand versetzt (Suspend). Andererseits, wenn `HaltEnabler` = `true`, dann wird dieser Patch wahrscheinlich nicht mehr benötigt.

### AddMCHC

Ein solches Gerät der Klasse `0x060000` ist in der Regel nicht in der DSDT enthalten, aber für einige Chipsätze ist dieses Gerät brauchbar, und deshalb muss es vorgeschrieben werden, um das Power-Management des PCI-Busses richtig zu verdrahten. Die Frage nach der Notwendigkeit eines Patches wird experimentell gelöst. Eine andere Erfahrung war, dass dieses Gerät auf einem Mother mit einem Z77-Chipsatz benötigt wurde, da sonst der Kernel in der Anfangsphase des Starts in Panik geriet. Umgekehrt, auf dem G41M (ICH7) Chipsatz, verursacht dieser Fix Panik. Leider ist keine allgemeine Regel in Sicht.

### FixHPET

Wie bereits erwähnt, ist dies der wichtigste benötigte Fix. Daher sieht die minimal erforderliche `DSDT`-Patch-Maske wie `0x0010` aus.

### FakeLPC

Ersetzt die DeviceID des LPC-Controllers, so dass das AppleLPC-Kext mit ihm verbunden ist. Dies ist notwendig, wenn der Chipsatz nicht für macOS bereitgestellt wird (z.B. ICH9). Allerdings ist die Liste der nativen Intel- und nForce-Chipsätze so umfangreich, dass die Notwendigkeit eines solchen Patches sehr selten ist. Es prüft im System, ob das AppleLPC-Kext geladen ist, wenn nicht, wird der Patch benötigt.

### FixIPIC

Entfernt den Interrupt vom `IPIC` Gerät. Dieser Fix wirkt sich auf die Funktion des Power-Buttons aus (ein Popup-Fenster mit den Optionen Reset, Sleep, Shutdown).

### FixSBus

Fügt den SMBusController zum Gerätebaum hinzu, wodurch die Warnung über sein Fehlen aus dem Systemprotokoll entfernt wird. Außerdem wird das korrekte Layout für die Bus-Energieverwaltung erstellt, was sich auch auf den Ruhezustand auswirkt.

### FixDisplay

Erzeugt eine Reihe von Grafikkarten-Patches. Injiziert Eigenschaften und die Geräte selbst, wenn sie nicht vorhanden sind. Injiziert FakeID, wenn bestellt. Fügt benutzerdefinierte Eigenschaften hinzu. Die gleiche Korrektur fügt ein HDAU-Gerät für die Audioausgabe über HDMI hinzu. Wenn der FakeID-Parameter angegeben wird, dann wird er durch die _DSM-Methode injiziert. Patches für alle Grafikkarten, nur für Nicht-Intel. Für eingebaute Intel wird ein anderes Bit verwendet.

### FixDisplay

Erzeugt eine Reihe von Patches für die Video-Non-Intel-Grafikkarten. Injiziert Eigenschaften und die Geräte selbst, wenn sie nicht vorhanden sind. Injiziert die FakeID, wenn bestellt. Fügt benutzerdefinierte Eigenschaften hinzu. Die gleiche Korrektur fügt auch ein HDAU-Gerät für die Audioausgabe über HDMI hinzu. Wenn der FakeID-Parameter gesetzt ist, wird er über die _DSM-Methode injiziert. Intel On-Board-Grafiken erfordern weitere Korrekturen.

### FixIDE

Im System 10.6.1 kam es zu einer Panik in der AppleIntelPIIXATA.kext. Es gibt zwei Lösungen für das Problem: die korrigierte kext verwenden oder das Gerät in der DSDT reparieren. Und für modernere Systeme? Verwenden Sie es, wenn es einen solchen Controller gibt (was sehr unwahrscheinlich ist, da IDE nicht mehr verwendet wird).

### FixSATA

Behebt einige Probleme mit SATA und beseitigt die Gelbfärbung der Festplattensymbole im System durch Nachahmung unter ICH6. Eigentlich eine umstrittene Methode, aber ohne diesen Fix werden meine DVDs nicht abgespielt, und für eine DVD sollte das Laufwerk nicht entfernbar sein. Die. einfach das Symbol zu ersetzen ist keine Option! Es gibt eine Alternative, die durch Hinzufügen eines Fixes mit der AppleAHCIport.kext gelöst wird. Siehe das Kapitel über das Patchen von Kexts. Und dementsprechend kann dieses Bit weggelassen werden! Eines der wenigen Bits, die ich empfehle, nicht zu verwenden.

### FixFirewire

Fügt dem Firewire-Controller die Eigenschaft "fwhub" hinzu, falls vorhanden. Wenn nicht, wird nichts passieren. Sie können darauf wetten, wenn Sie nicht wissen, ob Sie es brauchen oder nicht.

### FixAirport

Ähnlich wie bei LAN wird das Gerät selbst erstellt, wenn es nicht bereits in `DSDT` registriert ist. Bei einigen bekannten Modellen wird die `DeviceID` durch eine unterstützte ersetzt. Und der Flughafen schaltet sich ohne weitere Patches ein.

### FixLAN
Die Injektion der Eigenschaft "built-in" für die Netzwerkkarte ist für den korrekten Betrieb notwendig. Auch ein Kartenmodell wird injiziert - für die Kosmetik.FixSBUS

Fügt den SMBus-Controller in den Gerätebaum ein, wodurch die Warnung über sein Fehlen aus dem Systemprotokoll entfernt wird. Außerdem wird die korrekte Bus-Power-Management-Route erstellt. Wirkt sich auch auf den Ruhezustand aus.

### FixHDA

Korrektur der Beschreibung der Soundkarte in der DSDT, damit der native AppleHDA-Treiber funktioniert. Umbenennung AZAL -> HDEF wird durchgeführt, Layout-Id und PinConfiguration werden injiziert.

### FixUSB

Versucht, zahlreiche USB-Probleme zu lösen. Für den `XHCI`-Controller ist bei Verwendung des nativen oder gepatchten `IOUSBFamily.kext` ein solcher `DSDT`-Patch unerlässlich. Der Apple-Treiber verwendet speziell ACPI, und das DSDT muss korrekt geschrieben werden. Dies stellt sicher, dass es keine Konflikte mit Zeichenketten in der `DSDT` gibt.

## Fixes [2]

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 08.04.15.png)

### FixDarwin7

Dasselbe wie `FixDarwin`, aber für Windows 7. Alte `DSDTs` haben möglicherweise keine Prüfung für ein solches System. Jetzt haben Sie die Möglichkeit dazu.

### FixRTC und Rtc8Allowed

Entfernt den Interrupt vom Gerät `_RTC`. Es ist ein erforderlicher Fix und es ist sehr seltsam, dass jemand ihn nicht aktiviert hat. Wenn es im Original keinen Interrupt gibt, dann wird dieser Patch keinen Schaden anrichten. Es kam jedoch die Frage auf, ob die Länge der Region geändert werden muss. Um zu vermeiden, dass `CMOS` gelöscht wird, muss man die Länge auf `2` setzen, aber gleichzeitig erscheint ein Satz wie `"...only single bank..."` im Kernel Log.

Ich weiß nicht, was mit dieser Meldung los ist, aber sie kann ausgeschlossen werden, wenn die Länge auf 8 Bytes gesetzt wird, indem man den Fix `Rtc8Allowed` verwendet:

```Swift 
<key>ACPI</key>
<dict>
	<key>DSDT</key>
	<dict>
	<key>Rtc8Allowed</key>
	<false>
</dict>
```

* `true` - die Länge der Region bleibt bei 8 Bytes, falls es eine gab,
* `false` - wird um 2 Bytes korrigiert, was zuverlässiger verhindert, dass das CMOS zurückgesetzt wird.

Wie von vit9696 recherchiert, sollte die Länge der Region immer noch 8 sein, weil man sie braucht, um den Hibernation-Schlüssel zu speichern. Der Fix selbst ist also nützlich. Da auf Desktops der Ruhezustand nicht benötigt wird, kann man über ein Zurücksetzen des CMOS nachdenken.

### FixTMR

Entfernt den Interrupt des _TMR-Timers auf die gleiche Weise. Es ist veraltet und wird von Mac nicht verwendet.

### AddIMEI

Erforderlicher Patch für Sandy Bridge CPUs und höher, der das Gerät `IMEI` zum Gerätebaum hinzufügt, falls es noch nicht vorhanden ist.

### AddHDMI

Fügt ein `HDAU`-Gerät zu `DSDT` hinzu, das dem HDMI-Ausgang einer ATI- oder Nvidia-Grafikkarte entspricht. Es ist klar, dass, da die Karte separat vom Motherboard gekauft wurde, es einfach kein solches Gerät im nativen DSDT gibt. Zusätzlich wird die Eigenschaft "hda-gfx = onboard-1" oder "onboard-2" in das Gerät injiziert, je nach dem:

* `1` wenn UseIntelHDMI = false
* `2` wenn es einen Intel-Port gibt, der Port 1 belegt.

### FixRegions

`FixRegions` ist ein sehr spezieller Patch. Während andere Patches in diesem Abschnitt dazu gedacht sind, `BIOS.aml` zu reparieren, um eine gute benutzerdefinierte `DSDT` von Grund auf zu erstellen, ist dieser Fix dazu gedacht, eine *existierende* custom `DSDT.aml` zu optimieren.

**Hintergrund**: Die `DSDT` verfügt über Bereiche, die eigenen Adressen haben, wie z.B.:
`OperationRegion` (GNVS, SystemMemory, 0xDE6A5E18, 0x01CD). Diese Adressen werden teilweise *dynamisch* vom BIOS erstellt und könen von Boot zu Boot variieren. Die einfachste Beobachtung ist das Fehlen von Sleep. Nachdem eine Region fixiert wurde, erscheint sleep, aber nur bis zum nächsten Offset. Dieser Fix fixiert alle Regionen in der benutzerdefinierten `DSDT` auf die Werte in der BIOS-DSDT. Der fix reicht aus, falls man eine gut gepatchte Custom `DSDT` mit allen benötigten Fixes hat. 

**HINWEIS**: Es gibt noch einen weiteren Patch dafür, diesesr bezoieht sich jedoch nicht auf die `DSDT`, sondern auf alle ACPI-Tabellen im Allgemeinen, sodass es unpassend wäre, ihn in im ACPI-Abschnitt zu platzieren.

### FixMutex

Dieser Patch findet alle Mutex-Objekte und ersetzt `SyncLevel` durch `0`. Wir verwenden diesen Patch, das macOS kein Mutex-Debugging unterstützt und bei jeder Anfrage mit Mutex, die einen SyncLevel ≠ Null hat, abbrechen wird. Mutex-Objekte mit einem SyncLevel ≠ Null sind eine der häufigsten Ursachen für das Versagen der ACPI-Batteriemethode. Hinzugefügt von Rehabman in den Revisionen r4265 bis r4346.

**HINWEIS**: Dies ist ein sehr umstrittener Patch. Er sollte nur verwendet werden, wenn man genau weiß, was man tut!

### FixIntelGfx

Fix für integrierte Intel-Grafikkarten. Kann nicht Nvidia GPUs verwendet werden.

### FixWAK

Fügt `Return` zur Methode `_WAK` hinzu. Sie muss vorhanden sein, aber aus irgendeinem Grund enthalten die DSDTs sie oft nicht. Offenbar haben sich die Autoren an andere Normen gehalten. In jedem Fall ist dieser Fix absolut sicher.

### FixADP1

Korrigiert das "ADP1"-Gerät (Stromversorgung), das notwendig ist, damit Laptops korrekt schlafen können - egal ob eingesteckt oder nicht.

### DeleteUnused

Entfernt unbenutzte Floppy-, CRT- und DVI-Geräte - eine absolute Voraussetzung für den Betrieb von IntelX3100 auf Dell-Laptops. Ansonsten schwarzer Bildschirm, getestet von Hunderten von Nutzern.

### AddPNLF

Fügt ein `PNLF` (Backlight)-Gerät ein, das notwendig ist, um die Helligkeit des Bildschirms richtig zu steuern. Seltsamerweise hilft es auch Problem mit dem Ruhezustand zu lösen – auch bei Desktop PCs.

### PNLF_UID

Es gibt mehrere Helligkeitskurven im System, die unterschiedliche UIDs verwenden. Es kommt auf das Panel an - nicht auf den Prozessor, ob und wie die Kurven funktionieren.

Generell wäre es besser, ein "PNLF"-Kalibrierungssystem zu bauen, aber das ist Kunstflug. Im Moment schlagen wir nur vor, mit verschiedenen Werten zu experimentieren, um zu sehen, ob es besser wird. Hinzugefügt in Revision r5103.

### FixS3D

Dieser Patch behebt ebenfalls Probleme mit dem Schlaf.

### FixACST

Einige DSDTs können ein Gerät, eine Methode oder eine Variable mit dem Namen `ACST` beinhalten. Allerdings wird dieser Name wird auch von macOS 10.8+ zur Steuerung von C-States verwendet! 

Infolgedessen kann ein Konflikt mit sehr unklarem Verhalten auftreten. Dieser Fix benennt alle Vorkommen von `ACST` in `OCST` um, was sicher ist. Vor Verwendung dieses Fixes sollte zunächst in der `DSDT` geprüft werden, ob sich `ACST`in irgendeiner Weise auf Device `AC` und Method `_PSR` (=PowerSource) bezieht. Falls ja, diesen Patch nicht verwenden!

## DisableAML

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 08.31.09.png)

**Hinweis**: Keine Info im Handbuch vorhanden. Ich vermute, dass man SSDTs aus dem Ordner `ACPI/patched` hinzufügen kann, die beim Laden weggelassen werden sollten.

## Sorted Order

Erzeugt ein Array, um SSDTs im Ordner `ACPI/patched` in der in dieser Liste angegebenen Reihenfolge zu laden, sobald Sie ein SSDT zu dieser Liste hinzufügen. Nur SSDTs, die in diesem Array vorhanden sind, werden geladen, und zwar in der angegebenen Reihenfolge.

Im Allgemeinen ist ein Problem mit Tabellen ihr Name. Während es für OEM-Tabkes nicht ungewöhnlich ist, das nationale Alphabet oder einfach keinen Namen zu verwenden, ist dies für Apple inakzeptabel. Der Name muss aus 4 Zeichen des römischen Alphabets bestehen. Verwenden Sie "FixHeaders", um dieses Problem zu beheben.

## Drop Tables

![Bildschirmfoto 2021-05-16 um 08.28.35](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 08.28.35.png)

In diesem Array können Tabellen aufgelistet, die beim Systemstart verworfen werden sollen. Dazu gehören verschiedene Tabellensignaturen, wie `DMAR`, die oft verworfen wird, weil macOS die `VT-d` Technologie nicht mag. Andere zu verwerfende Tabellen wären `MATS` (behebt Probleme mit High Sierra) oder `MCFG`, weil die Angabe eines MacBookPro- oder MacMini-Modells zu starken Bremsen führt. Eine bessere Methode ist bereits entwickelt worden.

## SSDT

![](/Users/kl45u5/Desktop/Docs/Guides/Clover_Configurator_Settings_Explained.assets/Bildschirmfoto 2021-05-16 um 19.14.17.png)

### Double First State

Es hat sich herausgestellt, dass es für die korrekte Funktion von Speedstep notwendig ist, den ersten Zustand der P-States-Tabelle zu duplizieren. Nach der Einführung anderer Parameter ist die Notwendigkeit dieser Korrektur zweifelhaft geworden. Diese Korrektur ist für Intel-CPUs der "Ivy Bridge"-Familie relevant.

### Drop OEM

Da wir unsere eigenen SSDT-Tabellen dynamisch laden, müssen wir unnötige Coeüberschneidungen vermeiden, Konflikten vorzubeigen. Diese Option ermöglicht ee, alle nativen Tabellen zugunsten neuer/eigener Tabellen zu verwerfen. 

Wenn Sie das Patchen von SSDT-Tabellen ganz vermeiden wollen, gibt es eine weitere Möglichkeit: Legen Sie die nativen Tabellen mit kleineren Änderungen in den Ordner `EFI/OEM/xxx/ACPI/patched/` und verwerfen Sie die nicht gepatchten Tabellen. Es wird jedoch empfohlen, die oben erwähnte selektive Drop-Methode zu verwenden.

### Use SystemIO

Wenn auf `true` gesetzt, wird dieser SSDT-Abshnitt benutzt, um in den erzeugte `_CST`-Tabellen zu wählen zwischen:

```Swift
Register (FFixedHW,
Register (SystemIO,
```
### NoOEMTableID

Wenn auf `true` gesetzt, wird die OEM-Tabellenkennung *NICHT* an das Ende des Dateinamens in ACPI-Tabellen angefügt, die durch Drücken von `F4` im Clover-Boot-Menü ausgegeben werden. Wenn auf `false` gesetzt, werden Leerzeichen am Ende von SSDT-Namen entfernt, wenn die OEM-Tabellenkennung als Suffix hinzugefügt wird. Hinzugefügt von Rehabman in den Revisionen 4265 bis 4346.

### NoDynamicExtract

Wenn dieses Flag auf `true` gesetzt ist, wird die Extraktion von dynamischen SSDTs bei Verwendung von `F4` im Bootloader-Menü deaktiviert. Dynamische SSDTs werden selten benötigt und verursachen normalerweise Verwirrung (sie werden fälschlicherweise in den `ACPI/patched`-Ordner gelegt). Hinzugefügt von Rehabman in Revision 4359.

### PLimitDict

`PLimitDict` begrenzt die maximale Geschwindigkeit des Prozessors. Wenn er auf `0` gesetzt ist, ist die Geschwindigkeit maximal, `1` liegt eine Stufe unter dem Maximum. Wenn dieser Schlüssel hier fehlt, bleibt der Prozessor bei der minimalen Frequenz stecken.

### UnderVolt Step

Optionaler Parameter, um die Temperatur des Prozessors durch Verringerung seiner Betriebsspannung zu senken. Mögliche Werte sind 0 bis 9. Je höher der Wert, desto niedriger die Spannung, was zu niedrigeren Temperaturen führt - bis sich der Computer aufhängt. An dieser Stelle kommt der narrensichere Schutz ins Spiel: Clover lässt Sie keinen Wert außerhalb des angegebenen Bereichs einstellen. Aber selbst erlaubte Werte können zu einem instabilen Betrieb führen. Die Auswirkung einer Unterdrosselung ist deutlich spürbar. Dieser Parameter ist jedoch nur für Intel-CPUs der `Penryn`-Familie anwendbar.

### Min Multiplier

Minimaler CPU-Multiplikator. Er selbst gibt 16 an und bevorzugt einen Wert von 1600, aber Sie sollten die Werte in der Tabelle für Speedstep auf 800 oder sogar 700 heruntersetzen. Experimentieren Sie damit. Wenn Ihr System beim Booten abstürzt, ist die Niederfrequenz zu niedrig!

### Max Multiplier

Wurde in Verbindung mit Min Multiplier eingeführt, scheint aber nichts zu bewirken und sollte nicht verwendet werden. Er wirkt sich jedoch auf die Anzahl der P-States aus, so dass Sie damit experimentieren können, es aber nicht ohne besonderen Bedarf tun sollten.

### C3 Latency

Dieser Wert tritt bei echten Macs auf, bei iMacs liegt er bei 200, bei MacPro bei 10. Meiner Meinung nach werden iMacs durch P-Stats geregelt, MacPros durch C-Stats. Und es hängt auch vom Chipsatz ab, ob Ihr Chipsatz adäquat auf D-State-Befehle des MacOS reagieren wird. Die sicherste und einfachste Option ist es, diesen Parameter *nicht zu setzen*, alles wird so funktionieren, wie es ist.

### Enable C2, C4, C6 und C7

Geben Sie an, welche C-States erzeugt werden sollen.

### Generate Options

Im neuen Clover ist diese Gruppe von Parametern zu einem Abschnitt zusammengefasst:

- Generate `PStates` 
- Generate `CStates`
- `ASPN`
- `APLF`</br>
- `PluginType` entweder `true` oder `false`

**HINWEIS**: Da APSN/APLF Bestandteile von `PStates` sind, sind diese *nur* aktiv, *wenn* `PStates` aktiviert (`true`) sind, während `PluginType` unabhängig von `PStates` funktioniert.

**WICHTIG**: Keine der "Generate"-Optionen wird benötigt, wenn eine benutzerdefinierte SSDT-PM mit ssdtPRGen oder SSDTTime erzeugt wurde!

#### Generate PStates/CStates

Hier legen wir fest, dass zwei zusätzliche Tabellen für C-States und für P-States generiert werden, entsprechend den von der Hack-Community entwickelten Regeln. Für C-States die Tabelle mit den Parametern C2, C4, C6, Latency, die im Abschnitt CPU erwähnt werden. Es ist auch möglich die im Abschnitt SSDT anzugeben.

#### PluginType

Für Haswell und neuere CPUs sollten Sie der Key auf `1` gesetzt werden, für älter auf `0`. Dieser Schlüssel, zusammen mit dem Schlüssel Generate → `PluginType`, ermöglicht es, eine SSDT-Tabelle zu generieren, die nur `PluginType` enthält, aber keine P-States, wenn deren Generierung deaktiviert ist. Dieser Schlüssel wird nicht benötigt; er wurde aus Gründen der Abwärtskompatibilität gespeichert.
</details>
<details>
<summary><strong>Boot</strong></summary>
</details>

## Boot
### Debug
### Default Volume
### DisableCloverHotkeys
### HibernationFixup
### Legacy
### NeverDoRecovery
### NeverHibernate
### NoEarlyProgress
### RtcHibernateAware
### SignatureFixup
### SkipHibernateTimeout
### StrictHibernate
### Timeout
### XMPDetection
