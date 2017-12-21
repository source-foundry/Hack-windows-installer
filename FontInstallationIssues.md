# Font Installation Issues

When creating this setup, and when deploying this setup to 200+ machines, I faced some issues that come from the fact that Windows is not very smart when handling fonts. This file lists the issues I'm aware of.


## Font files can be damaged

For whatever reason, sometimes the *.ttf files are broken and depending how exactly they are broken can lead to all sorts of effects, from "Font can't be used" to "Some glyphs are broken".

*HackWindowsInstaller* uses SHA-1 hashes to compare the files that should be installed with the files actually installed. This has the side effect that always the files included with the setup are installed, even if one font file was already manually updated to a newer version. 


## The FONTS applet might save fonts as (Fontname)_X.ttf

When copying TTF files by simply dropping them onto the *Fonts* applet from Control Panel and the file that is copied is currently locked in *C:\WINDOWS\FONTS*, the applet will just append `_0` to the filename without extension and register this new file to the registry. For example, dropping `Hack-Regular.ttf` to FONTS when this file is locked will save the file as `Hack-Regular_0.ttf` to *C:\WINDOWS\FONTS*. 

Depending on the application and the caching method it can happen that the application continues to use the old font file.
 
*HackWindowsInstaller* will delete any *(Fontname)_X.ttf* for each font file it installs. However, if a font file was renamed, *HackWindowsInstaller* won’t delete the old _0.ttf file because this deletion is executed upon installation and depends on the current font names.


## Font files can be locked

As soon as a font is used, the TTF file for it is locked and can’t be updated to a newer version.

*HackWindowsInstaller* will try to replace any locked file five times and if this doesn’t work, it will use `PendingFileOperations` to replace the file in question upon next boot.

For files that only need to be deleted (not updated), *HackWindowsInstaller* will also use `PendingFileOperations` if they can not be deleted. 


## The FontCache service can lock fonts during installation

For performance reasons, Windows includes a cache for all installed fonts. Because it is sometime to “eager” to read the information from a file, the installation can fail because the file is locked during the installation.

*HackWindowsInstaller* will stop `FontCache` (and `FontCache3.0.0.0` for .NET if it exists) during installation.


## The font data in the registry and the font files can be different

Depending what else has gone wrong, the font registration data (Name and File) inside the registry can be different from the actual fonts installed in *C:\WINDOWS\FONTS*. When this happens, the fonts can go “crazy” - see issue [#152 for Hack](https://github.com/chrissimpkins/Hack/issues/152).

*HackWindowsInstaller* will ensure that the files and the registration data are exactly as desired and reinstall the font if this is not the case.


## Java based programs will try to combine Font registry data and all available font files

Java based programs not just relay on the font data found in the registry, they will also enumerate all font found in *C:\WINDOWS\FONTS*. This can lead to a situation where Java has more than one font file available for the same variant (Bold, Italic etc.) and causing massive display errors (see [issue 345](https://github.com/source-foundry/Hack/issues/345#issuecomment-340385407) and [issue 362](https://github.com/source-foundry/Hack/issues/362) for Hack). 

Windows programs that relay only on the font data in the registry do not have any issues in this case as they do check the \Fonts folder directly.

*HackWindowsInstaller* will delete any additional Hack files we are aware off, for example files from Hack v2 or the special *linegap* files to make sure only the main Hack files are found in *C:\WINDOWS\FONTS*.  


## The regular variant of a font can be registered as "Regular"

When installing a font using the *Fonts* applet from Control Panel it sometimes registers this variant as “Regular” although Windows does not expect “Regular” to be used. This can lead to a situation where two font files are registered for the “Regular” variant and causing display issues.

*HackWindowsInstaller* will delete any found registry entry for “Hack Regular”. 


## A font subsitute could be defined

It is possible using the registry location *HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes* to define an "alias" for a font that is mapped to a different font. For example, it is possible to define that Windows will use "Arial" when the font "Hack (Italic)" is requested. This can cause all sort of display problems.

*HackWindowsInstaller* will delete any found substitutes for the font that is installed.   


## A font cannot be updated without restart

The [MSDN  docs](https://msdn.microsoft.com/en-us/library/windows/desktop/dd183326%28v=vs.85%29.aspx) say that a call to RemoveFontResource() requires a restart before this font is really removed. However, it does not say anything if updating a font also requires this. Based on the current findings, I think it is required.

*HackWindowsInstaller* will always request a restart when the installation is finished. 

## Not fixed: A new font is not visible directly after installation

When a new font is installed, Windows expects the broadcast message [WM_FONTCHANGE](https://msdn.microsoft.com/en-us/library/windows/desktop/dd145211(v=vs.85).aspx) before the font can be used.

When sending this message during installation we learned that this can cause the installer to hang (see [issue #11](https://github.com/source-foundry/Hack-windows-installer/issues/11)), so the installer will not sent this message.

As we request a restart after installation, the negative impact should be minimal.  

## Not fixed: The cache files of the FontCache service can be corrupted

This issue is not yet fixed by *HackWindowsInstaller* mostly because I never experienced this defect. 

Both font cache services (FontCache and FontCache3.0.0.0) use cache files stored in *C:\Windows\ServiceProfiles\LocalService\AppData\Local\*. When these files become corrupted, the services might hang and the entire font handling goes haywire. 

The solution in this case is to stop both services, delete the file `FontCache3.0.dat` as well as renaming the folder `FontCache` and recreating a new empty folder with the same name. 

After that, restart the computer. 


----------
2016-04-25 (Updated 2017-12-21)

~Michael 'Tex' Hex

