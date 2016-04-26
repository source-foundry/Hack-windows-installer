# Hack Windows Installer

A Windows installer for the [Hack](https://github.com/chrissimpkins/Hack) typeface.


## Why is a Windows Font Installer Necessary?

While it might seem like overkill to use a Windows installer for fonts, there is good reason for this on the Windows platform.  A number of things can go wrong when one tries to install or update frequently updated fonts manually (see [issue #152](https://github.com/chrissimpkins/Hack/issues/152) in the Hack repository).

This installer addresses most of these issues. A (not complete) list of things that can go wrong can be found in [FontInstallationIssues.md](https://github.com/source-foundry/Hack-windows-installer/blob/master/FontInstallationIssues.md).


## Usage

- Download `HackWindowsInstaller.exe` from [Releases](https://github.com/source-foundry/Hack-windows-installer/releases/latest)
- Double click `HackWindowsInstaller.exe`
- Follow the installation instructions


## Silent Installation

To install silently, use the following command:

 ``start /wait HackWindowsInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /NORESTARTAPPLICATIONS``

To remove it silently:

 ``C:\Program Files\Hack Windows Installer\unins000.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART``


## Installer Source

You may review the comment annotated installer source in [HackWindowsInstaller.iss](https://github.com/source-foundry/Hack-windows-installer/blob/master/src/HackWindowsInstaller.iss).

We release the compiled installer with its SHA256 hash digest and [VirusTotal](https://virustotal.com/en/) malware scan report link in [Releases](https://github.com/source-foundry/Hack-windows-installer/releases).


## Troubleshooting

The installer creates a log file on the path C:\Users\ (Username) \AppData\Local\Temp\Setup Log (Year-Month-Day) #<XXX>.txt.

If you are using EMET: If the "Only trusted fonts" option is activated, you need to declare Hack as trusted or it will not be usable.


## Contributions

Any constructive contribution is very welcome! If you have any question or encounter a bug, please create a new [issue](https://github.com/source-foundry/Hack-windows-installer/issues/new).


## Build from Source

To build this setup yourself, download the most recent ANSI (not Unicode) version of [Inno Setup](http://www.jrsoftware.org/isdl.php). Install it and activate the option to install the [Inno Setup Preprocessor](http://www.jrsoftware.org/ispphelp/).

Double-click `HackWindowsInstall.iss` (from folder `src`), which will load it in Inno Setup and then select *Build* - *Compile*.


## License
Copyright © 2016 [Michael Hex](http://www.texhex.info/) / Source Foundry. Licensed under the **MIT License**. For details, please see [LICENSE.txt](https://github.com/source-foundry/Hack-windows-installer/blob/master/LICENSE.txt).
