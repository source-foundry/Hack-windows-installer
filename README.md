# Hack Windows Installer

A Windows installer for [Hack](https://github.com/chrissimpkins/Hack).

## Usage

- Download from [Releases](https://github.com/source-foundry/Hack-windows-installer/releases/)
- Run HackWindowsInstaller.exe
- Follow the instructions

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

## Build from source

To build this setup yourself, download the newest ANSI (not unicode)  version of [Inno Setup](http://www.jrsoftware.org/isdl.php). Install it and activate the option to install the [Inno Setup Preprocessor](http://www.jrsoftware.org/ispphelp/). 

Double-click `HackWindowsInstall.iss` (from folder `src`), which will load it in Inno Setup and then select *Build* - *Compile*.    

## About
Copyright © 2016 [Michael Hex](http://www.texhex.info/) / Source Foundry. Licensed under the **MIT License**. For details, please see [LICENSE.txt](https://github.com/source-foundry/Hack-windows-installer/blob/master/LICENSE.txt).
