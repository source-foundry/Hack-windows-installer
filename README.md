# Hack Windows Installer

A Windows installer for [Hack](https://github.com/chrissimpkins/Hack).

## Usage

- Download from [Releases](https://github.com/source-foundry/Hack-windows-installer/releases/)
- Run HackWindowsInstaller.exe
- Follow the instructions
- Enjoy 

## Silent Installation

To install silently, use the following command:

 ``start /wait HackWindowsInstaller.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS /NORESTARTAPPLICATIONS``

To remove it silently: 

 ``C:\Program Files\Hack Windows Installer\unins000.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART``

## Troubleshooting

The installer always creates a log file as C:\Users\ (Username) \AppData\Local\Temp\Setup Log (Year-Month-Day) #<XXX>.txt.

If you are using EMET: If the "Only trusted fonts" option is activated, you need to declare Hack as trusted or they will not be visible.

## Contributions

Any constructive contribution is very welcome! 

If you encounter a bug with the installation, please create a new issue, describing how to reproduce the bug and I will try to fix it.

In case you want the setup to include another font, please also open an issue and I will consider adding it. Please note: I will not accept fonts without any project activity for more than a year. 

## About
Copyright © 2016 [Michael Hex](http://www.texhex.info/) for Source Foundry. Licensed under the **MIT License**. For details, please see LICENSE.
