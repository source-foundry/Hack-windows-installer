; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS






; ISPP Base Path: C:\dev\git\Hack-windows-installer\














; Processing section InstallFonts






;  INI position #1
;    Hack Bold
;    Hack-Bold.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Bold.ttf
;    a7bb6faacd609145b55ed15ca238755544c03af5

;  INI position #2
;    Hack
;    Hack-Regular.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Regular.ttf
;    664cfe2a64de1486c0ace8073ceeb6d9281e8b78

;  INI position #3
;    Hack Bold Italic
;    Hack-BoldItalic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-BoldItalic.ttf
;    c428004a2fe3570450c6d03442052b1a9989c58b

;  INI position #4
;    Hack Italic
;    Hack-Italic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Italic.ttf
;    efdae4b94858b98eab6dcf2cb8e3cc3d28263cc2




; Processing section RemoveFonts








;  INI position #1
;    Hack-BoldOblique.ttf
;    Hack Bold Oblique

;  INI position #2
;    Hack-RegularOblique.ttf
;    Hack Oblique

;  INI position #3
;    Hack-BoldOblique.otf
;    Hack Bold Oblique

;  INI position #4
;    Hack-RegularOblique.otf
;    Hack Oblique











;#define public AppName 'Hack Windows Installer'










;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.
;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
; C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Bold.ttf\Hack-Bold.ttf - "Hack Bold" - a7bb6faacd609145b55ed15ca238755544c03af5
; C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Regular.ttf\Hack-Regular.ttf - "Hack" - 664cfe2a64de1486c0ace8073ceeb6d9281e8b78
; C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-BoldItalic.ttf\Hack-BoldItalic.ttf - "Hack Bold Italic" - c428004a2fe3570450c6d03442052b1a9989c58b
; C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Italic.ttf\Hack-Italic.ttf - "Hack Italic" - efdae4b94858b98eab6dcf2cb8e3cc3d28263cc2

;---END---




;General procedure
; a) Ready to install
; b) INSTALL
; b1) InstallDelete
; b2) BeforeInstallAction (Stop services)
; b3) Install files
; b4) AfterInstallAction (Start services)
; c) All done


  

[Setup]
AppId=HackWindowsInstaller
SetupMutex=HackWindowsInstaller_Mutex 

AppName=Hack Windows Installer
AppVersion=1.2.1
VersionInfoVersion=1.2.1

;This is displayed on the "Support" dialog of the Add/Remove Programs Control Panel 
AppPublisher=Michael Hex / Source Foundry
AppCopyright=Copyright © 2016 Michael Hex / Source Foundry

AppContact=Michael Hex / Source Foundry
AppSupportURL=https://github.com/source-foundry/Hack-windows-installer
;AppUpdatesURL=

AppComments=Hack font installer

;This icon is used for the icon of HackWindowsInstaller.exe itself
SetupIconFile=img\Hack-installer-icon.ico
;This icon will be displayed in Add/Remove programs and needs to be installed locally
UninstallDisplayIcon={app}\Hack-installer-icon.ico

;Folder configuration
SourceDir=C:\dev\git\Hack-windows-installer\
OutputDir=out\
OutputBaseFilename=HackWindowsInstaller

;Target folder settings
DefaultDirName={pf}\Hack Windows Installer\
DirExistsWarning=no

;Always create a log to aid troubleshooting. The file is created as:  
;C:\Users\<YourUsername>\AppData\Local\Temp\Setup Log Year-Month-Day #XXX.txt
SetupLogging=Yes

;enable 64bit Mode so the files are installed to C:\Program Files in x86 and x64 mode
ArchitecturesInstallIn64BitMode=x64 

;Only allow the installer to run on Windows 7 and upwards
MinVersion=6.1

;It should be uninstallable
Uninstallable=Yes 

Compression=lzma2/ultra
SolidCompression=yes

PrivilegesRequired=admin

;Ignore some screens
DisableWelcomePage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes
AllowCancelDuringInstall=False


;Patching default Windows/App text
[Messages]
;SetupAppTitle is displayed in the taskbar
SetupAppTitle=Hack Windows Installer

;SetupWindowsTitle is displayed in the setup window itself so we better include the version
SetupWindowTitle=Hack Windows Installer 1.2.1

;Messages for the "Read to install" wizard page
  ;NOT USED - "Ready To Install" - below title bar
  ;WizardReady=

;ReadLabel1: "Setup is now ready to begin installing ...."
ReadyLabel1=

;ReadyLabel2b: "Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the Hack fonts v2.020 on your system.


[Icons]
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;Link to the Hack homepage 
Name: "{app}\Hack Homepage"; Filename: "http://sourcefoundry.org/hack/"; 


[Files]
;Copy license files - always copied
Source: "license*.*"; DestDir: "{app}"; Flags: ignoreversion;

;Copy the icon to the installation folder in order to show it in Add/Remove programs
Source: "img\Hack-installer-icon.ico"; DestDir: "{app}"; Flags: ignoreversion;

;------------------------
;Install font files and register them to the registry
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Bold.ttf"; FontInstall: "Hack Bold"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Regular.ttf"; FontInstall: "Hack"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-BoldItalic.ttf"; FontInstall: "Hack Bold Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v2_020\Hack-Italic.ttf"; FontInstall: "Hack Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
;------------------------


[InstallDelete]
;Helper macro to add a string at the end of filename, but before the extension

;------------------------
;If a user copies *.TTF files to the "Fonts" applet and a font file with the same name already exists, 
;Windows will simply append "_0" (or _1) to the font file and copy it.
;These "ghost" files need to be exterminated!
  Type: files; Name: "{fonts}\Hack-Bold_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-Regular_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-BoldItalic_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-Italic_*.ttf"; 
;------------------------

;------------------------
;Remove any font files that should be removed during install
  Type: files; Name: "{fonts}\Hack-BoldOblique.ttf"; 
  Type: files; Name: "{fonts}\Hack-RegularOblique.ttf"; 
  Type: files; Name: "{fonts}\Hack-BoldOblique.otf"; 
  Type: files; Name: "{fonts}\Hack-RegularOblique.otf"; 
;------------------------


[Registry]
;------------------------
;Remove any font names that should be removed during install
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
;------------------------

;------------------------
;Delete any entry found in FontSubsitutes for each of the fonts that will are installed
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Bold (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Bold Italic (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Italic (TrueType)"; ValueType: none; Flags: deletevalue;
;------------------------

 
[INI]
;Create an ini to make detection for enterprise deployment tools easy
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "1.2.1"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "Hack Windows Installer"


[UninstallDelete]
;Delete install Info
Type: files; Name: "{app}\InstallInfo.ini"
;Delete log files
Type: files; Name: "{app}\Log*.txt"



[Code]

//--- START incl_ServiceControlManager-definition.iss ---

type
	SERVICE_STATUS = record
    	dwServiceType				: cardinal;
    	dwCurrentState				: cardinal;
    	dwControlsAccepted			: cardinal;
    	dwWin32ExitCode				: cardinal;
    	dwServiceSpecificExitCode	: cardinal;
    	dwCheckPoint				: cardinal;
    	dwWaitHint					: cardinal;
	end;
	HANDLE = cardinal;

	
const
	SC_MANAGER_ALL_ACCESS		= $f003f;
	SERVICE_QUERY_CONFIG		= $1;
	SERVICE_CHANGE_CONFIG		= $2;
	SERVICE_QUERY_STATUS		= $4;
	SERVICE_START				= $10;
	SERVICE_STOP				= $20;
	SERVICE_ALL_ACCESS			= $f01ff;
	SERVICE_WIN32_OWN_PROCESS	= $10;
	SERVICE_WIN32_SHARE_PROCESS	= $20;
	SERVICE_WIN32				= $30;
	SERVICE_INTERACTIVE_PROCESS = $100;
	SERVICE_BOOT_START          = $0;
	SERVICE_SYSTEM_START        = $1;
	SERVICE_AUTO_START          = $2;
	SERVICE_DEMAND_START        = $3;
	SERVICE_DISABLED            = $4;
	SERVICE_DELETE              = $10000;
	SERVICE_CONTROL_STOP		= $1;
	SERVICE_CONTROL_PAUSE		= $2;
	SERVICE_CONTROL_CONTINUE	= $3;
	SERVICE_CONTROL_INTERROGATE = $4;
	SERVICE_STOPPED				= $1;
	SERVICE_START_PENDING       = $2;
	SERVICE_STOP_PENDING        = $3;
	SERVICE_RUNNING             = $4;
	SERVICE_CONTINUE_PENDING    = $5;
	SERVICE_PAUSE_PENDING       = $6;
	SERVICE_PAUSED              = $7;
	
//--- END incl_ServiceControlManager-definition.iss ---
	

  
var

  FontFiles: array of string;
  FontFilesHashes: array of string;
  FontFilesNames: array of string;
  
  InstalledFontsHashes: array of string;

  FontCacheService_Stopped:boolean;
  FontCache30Service_Stopped:boolean;

  BeforeInstallActionWasRun:boolean;

  ChangesRequired:boolean;

  FontStateBuffer: array of string;


//--- START incl_ServiceControlManager-functions.iss ---

function OpenSCManager(lpMachineName, lpDatabaseName: string; dwDesiredAccess :cardinal): HANDLE;
external 'OpenSCManagerA@advapi32.dll stdcall';

function OpenService(hSCManager :HANDLE;lpServiceName: string; dwDesiredAccess :cardinal): HANDLE;
external 'OpenServiceA@advapi32.dll stdcall';

function CloseServiceHandle(hSCObject :HANDLE): boolean;
external 'CloseServiceHandle@advapi32.dll stdcall';

function StartNTService(hService :HANDLE;dwNumServiceArgs : cardinal;lpServiceArgVectors : cardinal) : boolean;
external 'StartServiceA@advapi32.dll stdcall';

function ControlService(hService :HANDLE; dwControl :cardinal;var ServiceStatus :SERVICE_STATUS) : boolean;
external 'ControlService@advapi32.dll stdcall';

function QueryServiceStatus(hService :HANDLE;var ServiceStatus :SERVICE_STATUS) : boolean;
external 'QueryServiceStatus@advapi32.dll stdcall';


function OpenServiceManager() : HANDLE;
begin
	if UsingWinNT() = true then begin
		Result := OpenSCManager('','ServicesActive',SC_MANAGER_ALL_ACCESS);
		if Result = 0 then
			MsgBox('the servicemanager is not available', mbError, MB_OK)
	end
	else begin
			MsgBox('only nt based systems support services', mbError, MB_OK)
			Result := 0;
	end
end;

function IsServiceInstalled(ServiceName: string) : boolean;
var
	hSCM	: HANDLE;
	hService: HANDLE;
begin
	hSCM := OpenServiceManager();
	Result := false;
	if hSCM <> 0 then begin
		hService := OpenService(hSCM,ServiceName,SERVICE_QUERY_CONFIG);
        if hService <> 0 then begin
            Result := true;
            CloseServiceHandle(hService)
		end;
        CloseServiceHandle(hSCM)
	end
end;

function StartService(ServiceName: string) : boolean;
var
	hSCM	: HANDLE;
	hService: HANDLE;
begin
	hSCM := OpenServiceManager();
	Result := false;
	if hSCM <> 0 then begin
		hService := OpenService(hSCM,ServiceName,SERVICE_START);
        if hService <> 0 then begin
        	Result := StartNTService(hService,0,0);
            CloseServiceHandle(hService)
		end;
        CloseServiceHandle(hSCM)
	end;
end;

function StopService(ServiceName: string) : boolean;
var
	hSCM	: HANDLE;
	hService: HANDLE;
	Status	: SERVICE_STATUS;
begin
	hSCM := OpenServiceManager();
	Result := false;
	if hSCM <> 0 then begin
		hService := OpenService(hSCM,ServiceName,SERVICE_STOP);
        if hService <> 0 then begin
        	Result := ControlService(hService,SERVICE_CONTROL_STOP,Status);
            CloseServiceHandle(hService)
		end;
        CloseServiceHandle(hSCM)
	end;
end;

function IsServiceRunning(ServiceName: string) : boolean;
var
	hSCM	: HANDLE;
	hService: HANDLE;
	Status	: SERVICE_STATUS;
begin
	hSCM := OpenServiceManager();
	Result := false;
	if hSCM <> 0 then begin
		hService := OpenService(hSCM,ServiceName,SERVICE_QUERY_STATUS);
    	if hService <> 0 then begin
			if QueryServiceStatus(hService,Status) then begin
				Result :=(Status.dwCurrentState = SERVICE_RUNNING)
        	end;
            CloseServiceHandle(hService)
		    end;
        CloseServiceHandle(hSCM)
	end
end;

function StartNTService2(serviceName:string):boolean;
begin
   if IsServiceInstalled(serviceName) then begin
      if IsServiceRunning(serviceName)=false then begin
         log('Starting service ' + serviceName);
         StartService(serviceName);
         sleep(1500); //give the service some seconds
         result:=true;
      end; 
   end;
end;

function StopNTService2(serviceName:string):boolean;
begin
   if IsServiceInstalled(serviceName) then begin
      if IsServiceRunning(serviceName) then begin
         log('Stopping service ' + serviceName);
         StopService(serviceName);
         sleep(1500);
         result:=true;
      end; 
   end;
end;



//--- END incl_ServiceControlManager-functions.iss ---
	



procedure AddFontData(fontFile, fontName, fontHash :string);
var
  curSize: integer;
begin
  curSize:=GetArrayLength(FontFiles);

  SetArrayLength(FontFiles, curSize+1)
  SetArrayLength(FontFilesHashes, curSize+1)
  SetArrayLength(FontFilesNames, curSize+1)
  

  FontFiles[curSize]:=fontFile;
  FontFilesHashes[curSize]:=fontHash;
  FontFilesNames[curSize]:=fontName;
end;


procedure FillFontDataArray();
begin


  AddFontData('Hack-Bold.ttf', 'Hack Bold', 'a7bb6faacd609145b55ed15ca238755544c03af5');
  AddFontData('Hack-Regular.ttf', 'Hack', '664cfe2a64de1486c0ace8073ceeb6d9281e8b78');
  AddFontData('Hack-BoldItalic.ttf', 'Hack Bold Italic', 'c428004a2fe3570450c6d03442052b1a9989c58b');
  AddFontData('Hack-Italic.ttf', 'Hack Italic', 'efdae4b94858b98eab6dcf2cb8e3cc3d28263cc2');

end;

procedure LogAsImportant(message:string);
var
  curSize: integer;
begin

  log(message);

  curSize:=GetArrayLength(FontStateBuffer);  
  SetArrayLength(FontStateBuffer, curSize+1); 
  FontStateBuffer[curSize]:=message;
end;

var
  customProgressPage: TOutputProgressWizardPage;


procedure InitializeWizard;
var
  title, subTitle:string;
begin
  ChangesRequired:=false;
  FontCacheService_Stopped:=false;
  FontCache30Service_Stopped:=false;

  BeforeInstallActionWasRun:=false;

  FillFontDataArray;

  title:=SetupMessage(msgWizardPreparing);
  subTitle:=SetupMessage(msgPreparingDesc);
  
  StringChangeEx(subTitle, '[name]', 'Hack Windows Installer', True);
  customProgressPage:=CreateOutputProgressPage(title, subTitle);
end;


function IsSetupFontSameAsInstalledFont(fileName:string):boolean;
var
  i:integer;
  entryFound:boolean;
  registryFontValue:string;
  expectedFontValue:string;
begin
  LogAsImportant('IsSetupFontSameAsInstalledFont(): ' + fileName);

  result:=false;
  entryFound:=false;
  
  for i := 0 to GetArrayLength(FontFiles)-1 do begin

      if FontFiles[i]=fileName then begin         
         entryFound:=true;                  


         expectedFontValue:=FontFilesNames[i]+' (TrueType)';
         LogAsImportant('   Checking for font name in registry: ' + expectedFontValue);
         if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', expectedFontValue, registryFontValue) then begin                                         
            LogAsImportant('   Font name found');

            LogAsImportant('   Checking file name in registry. Expected: ' + fileName);
            if registryFontValue=fileName then begin                  
               LogAsImportant('   File name matches');
               
               if FontFilesHashes[i]=InstalledFontsHashes[i] then begin 
                  LogAsImportant('   File hash matches, installation is not required');
                  result:=true; //all is exactly as expected
               end else begin
                  LogAsImportant('   Hash values (Setup/Windows): ' + FontFilesHashes[i] + ' / ' + InstalledFontsHashes[i]);
                  LogAsImportant('   File hash is different!');
               end;
                                           
            end else begin                  
               LogAsImportant('   File name read: ' + registryFontValue);
               LogAsImportant('   File name in registry is different!');                  
            end;
            
          end else begin
            LogAsImportant('   Font not found in registry!');          
          end;

      end;   

   end;

   if entryFound=false then begin
      RaiseException('No entry in the internal hash arrays found for: ' + fileName);
   end; 

end;



function AtLeastOneFontRequiresInstallation():boolean;
var
  i:integer;
begin
  result:=false;

  LogAsImportant('Checking for differences between fonts in setup and this system');

  for i := 0 to GetArrayLength(FontFiles)-1 do begin        
     if IsSetupFontSameAsInstalledFont(FontFiles[i]) then begin
     end else begin
        LogAsImportant('   Found difference for file ' + FontFiles[i]);
        LogAsImportant('   Installation required.');

        result:=true;           
        break;
     end;    
  end;
end;


function FontFileInstallationRequired(): Boolean;
var
 file:string;
begin 

  if BeforeInstallActionWasRun=false then begin
     result:=true;
  end else begin 
     file:=ExtractFileName(CurrentFileName);

     if IsSetupFontSameAsInstalledFont(file) then begin
        result:=false; //No installation required
     end else begin
        result:=true; //Installation required
     end;
  end;
 
end;


procedure BeforeInstallAction();
var
  i:integer;
  currentFont:string;
  currentFontFileNameWindows:string;
 
begin
  LogAsImportant('---BeforeInstallAction START---');

  LogAsImportant('Setup version: 1.2.1');
  LogAsImportant('Font version.: 2.020');
  LogAsImportant('Local time...: ' + GetDateTimeString('yyyy-dd-mm hh:nn', '-', ':'));
  LogAsImportant('Fonts folder.: ' + ExpandConstant('{fonts}'));
  LogAsImportant('Dest folder..: ' + ExpandConstant('{app}'));


  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin         
     customProgressPage.SetText('Calculating hashes for fonts already installed...', '');
     
     SetArrayLength(InstalledFontsHashes, GetArrayLength(FontFiles));
     
     LogAsImportant('---HASH CALCULATION---');
     for i := 0 to GetArrayLength(FontFiles)-1 do begin
         currentFont:=FontFiles[i];
         LogAsImportant('Calculating hash for '+currentFont);
         LogAsImportant('   File from setup: ' +  FontFilesHashes[i]);    
         
         currentFontFileNameWindows:=ExpandConstant('{fonts}\'+currentFont);
    
         if FileExists(currentFontFileNameWindows) then begin
            InstalledFontsHashes[i]:=GetSHA1OfFile(currentFontFileNameWindows);
         end else begin
            InstalledFontsHashes[i]:='-NOT FOUND-';
         end;
     
         LogAsImportant('   File in \fonts : ' +  InstalledFontsHashes[i]);
     end;
     LogAsImportant('----------------------');
     
     
     ChangesRequired:=false;

     if AtLeastOneFontRequiresInstallation then begin
        ChangesRequired:=true;
     end;

     FontCacheService_Stopped:=false;
     FontCache30Service_Stopped:=false;

     if ChangesRequired=true then begin
        customProgressPage.SetText('Stopping service FontCache...','');
        FontCacheService_Stopped:=StopNTService2('FontCache');

        customProgressPage.SetText('Stopping service FontCache3.0.0.0...','');
        FontCache30Service_Stopped:=StopNTService2('FontCache3.0.0.0')
     end;

    
  end;
  finally
    customProgressPage.Hide;
  end;

  BeforeInstallActionWasRun:=true;
  LogAsImportant('---BeforeInstallAction END---');
end;


procedure AfterInstallAction();
var 
 appDestinationFolder:string;

begin
  log('---AfterInstallAction START---');

  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin

      customProgressPage.SetText('Starting service FontCache...','');
      if FontCacheService_Stopped=true then begin
         StartNTService2('FontCache');
         FontCacheService_Stopped:=false;
      end;

      customProgressPage.SetText('Starting service FontCache3.0.0.0...','');
      if FontCache30Service_Stopped=true then begin
         StartNTService2('FontCache3.0.0.0');         
         FontCache30Service_Stopped:=false;
      end;

      SendBroadcastMessage(29, 0, 0);

      customProgressPage.SetText('Storing font data...','');

      appDestinationFolder:=ExpandConstant('{app}');
      appDestinationFolder:=AddBackslash(appDestinationFolder);
      if DirExists(appDestinationFolder) then begin
         
         If FileExists(appDestinationFolder + 'Log-FontData.txt') then begin
            
            If FileExists(appDestinationFolder + 'Log-FontData-old.txt') then begin
               DeleteFile(appDestinationFolder + 'Log-FontData-old.txt');
            end;

            RenameFile(appDestinationFolder + 'Log-FontData.txt', appDestinationFolder + 'Log-FontData-old.txt'); 
         end;            

         log('Saving font state to ' + appDestinationFolder + 'Log-FontData.txt');
         SaveStringsToFile(appDestinationFolder + 'Log-FontData.txt', FontStateBuffer, false); //do not append 
      end;


  end;
  finally
    customProgressPage.Hide;
  end;

  log('---AfterInstallAction END---');
end;



function NeedRestart(): Boolean;
begin
 
  log('---NeedRestart---');
  if ChangesRequired then
     LogAsImportant('  Changes detected, require reboot');

  result:=ChangesRequired;
    
  log('---NeedRestart END---');
end;

function UninstallNeedRestart(): Boolean;
begin
 result:=true;
end;


procedure CurStepChanged(CurStep: TSetupStep);
begin
 
 if CurStep=ssInstall then begin
    BeforeInstallAction();
 end;

 if CurStep=ssPostInstall then begin
    AfterInstallAction(); 
 end;

end;





