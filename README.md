# Hack Windows Installer

A Windows installer for [Hack](https://github.com/chrissimpkins/Hack).

## Usage

- Download from [Releases](https://github.com/source-foundry/Hack-windows-installer/releases/)
- Run HackWindowsInstaller.exe
- Follow the instructions

## Why this project exists

It might seem to be overkill to have an installation tool just for some fonts, but a lot of things can go wrong when trying to install or update them manually (see [issue #152](https://github.com/chrissimpkins/Hack/issues/152) in the Hack repository).

The installer can prevent most of these issues. A (not complete) list of things that can go wrong can be found in [FontInstallationIssues.md](https://github.com/source-foundry/Hack-windows-installer/blob/master/FontInstallationIssues.md).

## Silent Installation

To install silently, use the following command:

 ``start /wait HackWindowsInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /NORESTARTAPPLICATIONS``

To remove it silently: 

 ``C:\Program Files\Hack Windows Installer\unins000.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART``

## Troubleshooting

The installer always creates a log file as C:\Users\ (Username) \AppData\Local\Temp\Setup Log (Year-Month-Day) #<XXX>.txt.

If you are using EMET: If the "Only trusted fonts" option is activated, you need to declare Hack as trusted or it will not be usable.

## Contributions

Any constructive contribution is very welcome! If you have any question or encounter a bug, please create a new [issue](https://github.com/source-foundry/Hack-windows-installer/issues/new).

## Why does this 

## Build from source

To build this setup yourself, download the newest ANSI (not unicode)  version of [Inno Setup](http://www.jrsoftware.org/isdl.php). Install it and activate the option to install the [Inno Setup Preprocessor](http://www.jrsoftware.org/ispphelp/). 

Double-click `HackWindowsInstall.iss` (from folder `src`), which will load it in Inno Setup and then select *Build* - *Compile*.    

## About
Copyright © 2016 [Michael Hex](http://www.texhex.info/) / Source Foundry. Licensed under the **MIT License**. For details, please see [LICENSE.txt](https://github.com/source-foundry/Hack-windows-installer/blob/master/LICENSE.txt).
