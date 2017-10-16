; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS






; ISPP Base Path: C:\dev\git\Hack-windows-installer\




























; Processing section InstallFonts






;  INI position #1
;    Hack Bold
;    Hack-Bold.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Bold.ttf
;    12022be7e047f0ec26517084d5fc6d444a2511ac

;  INI position #2
;    Hack
;    Hack-Regular.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Regular.ttf
;    8f7271c506e5fc5b6ad69ec00845f10d0a4ee146

;  INI position #3
;    Hack Bold Italic
;    Hack-BoldItalic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-BoldItalic.ttf
;    e41d5b385511295d1f771f2c647e9151dbf72012

;  INI position #4
;    Hack Italic
;    Hack-Italic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Italic.ttf
;    593a16309b9fe89ce600ef688cb53d5747054ab3




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











;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.
;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Bold.ttf\Hack-Bold.ttf - "Hack Bold" - 12022be7e047f0ec26517084d5fc6d444a2511ac
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Regular.ttf\Hack-Regular.ttf - "Hack" - 8f7271c506e5fc5b6ad69ec00845f10d0a4ee146
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-BoldItalic.ttf\Hack-BoldItalic.ttf - "Hack Bold Italic" - e41d5b385511295d1f771f2c647e9151dbf72012
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Italic.ttf\Hack-Italic.ttf - "Hack Italic" - 593a16309b9fe89ce600ef688cb53d5747054ab3

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

AppVersion=1.4.0
VersionInfoVersion=1.4.0

AppPublisher=Michael Hex / Source Foundry
AppCopyright=Copyright © 2016 Michael Hex / Source Foundry

;Information displayed in Control Panel -> Add/Remove Programs applet
;---------------------------------------------------
;Displayed as "Help link:"
AppSupportURL=http://sourcefoundry.org/hack/
;Should also be displayed there, but I was unable to verify this
AppContact=Michael Hex / Source Foundry
;Displayed as "Comments" 
AppComments=Hack fonts v3.000
;Displayed as "Update information:" -NOT USED RIGHT NOW-
;AppUpdatesURL=http://appupdates.com
;---------------------------------------------------

;Store resulting exe in the \out folder
OutputDir=out\

;How to call the resulting EXE file
OutputBaseFilename=HackWindowsInstaller

;Target folder settings
DefaultDirName={pf}\Hack Windows Installer\
;Don't warn when the taget folder exists
DirExistsWarning=no

 ;This icon is used for the icon of the resulting exe
 SetupIconFile=img\Hack-installer-icon.ico

 ;This icon will be displayed in Add/Remove Programs and needs to be installed locally
 UninstallDisplayIcon={app}\Hack-installer-icon.ico

;Source folder is the base path
SourceDir=C:\dev\git\Hack-windows-installer\

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

;As we install to {fonts}, we require admin privileges
PrivilegesRequired=admin

;Ignore some screens
DisableWelcomePage=yes
DisableDirPage=yes
DisableProgramGroupPage=yes

;You can't stop me.
AllowCancelDuringInstall=False


;Patching default Windows/App text
[Messages]
;SetupAppTitle is displayed in the taskbar
SetupAppTitle=Hack Windows Installer

;SetupWindowsTitle is displayed in the setup window itself so we better include the version
SetupWindowTitle=Hack Windows Installer 1.4.0

;Messages for the "Read to install" wizard page
  ;NOT USED - "Ready To Install" - below title bar
  ;WizardReady=

;ReadLabel1: "Setup is now ready to begin installing ...."
ReadyLabel1=

;ReadyLabel2b: "Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the Hack fonts v3.000 on your system.


[Icons]
;Create shortcut to the Font applet so the user can easily view the installed fonts.
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;Link to the homepage for this font
Name: "{app}\Website"; Filename: "http://sourcefoundry.org/hack/"; 


[Files]
  ;Copy license files
  Source: "license*.*"; DestDir: "{app}"; Flags: ignoreversion;

  ;Copy the icon to the installation folder in order to show it in Add/Remove Programs
  Source: "img\Hack-installer-icon.ico"; DestDir: "{app}"; Flags: ignoreversion;

;------------------------
;Install font files and register them
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Bold.ttf"; FontInstall: "Hack Bold"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Regular.ttf"; FontInstall: "Hack"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-BoldItalic.ttf"; FontInstall: "Hack Bold Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_000\Hack-Italic.ttf"; FontInstall: "Hack Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
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
;Remove old font files during install
  Type: files; Name: "{fonts}\Hack-BoldOblique.ttf"; 
  Type: files; Name: "{fonts}\Hack-RegularOblique.ttf"; 
  Type: files; Name: "{fonts}\Hack-BoldOblique.otf"; 
  Type: files; Name: "{fonts}\Hack-RegularOblique.otf"; 
;------------------------


[Registry]
;------------------------
;Remove old font names during install
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
;------------------------

;------------------------
;Delete any entry found in FontSubsitutes for each of the fonts that will be installed
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Bold (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Bold Italic (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "Hack Italic (TrueType)"; ValueType: none; Flags: deletevalue;
;------------------------

 
[INI]
;Create an ini to make detection for enterprise deployment tools easy
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "1.4.0"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "Hack Windows Installer"


[UninstallDelete]
;Delete install Info
Type: files; Name: "{app}\InstallInfo.ini"
;Delete log files
Type: files; Name: "{app}\Log*.txt"



[Code]


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


  AddFontData('Hack-Bold.ttf', 'Hack Bold', '12022be7e047f0ec26517084d5fc6d444a2511ac');
  AddFontData('Hack-Regular.ttf', 'Hack', '8f7271c506e5fc5b6ad69ec00845f10d0a4ee146');
  AddFontData('Hack-BoldItalic.ttf', 'Hack Bold Italic', 'e41d5b385511295d1f771f2c647e9151dbf72012');
  AddFontData('Hack-Italic.ttf', 'Hack Italic', '593a16309b9fe89ce600ef688cb53d5747054ab3');

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

  LogAsImportant('--------------------------------');
  LogAsImportant('Font name.....: Hack fonts');
  LogAsImportant('Script version: 2.02');
  LogAsImportant('Setup version.: 1.4.0');
  LogAsImportant('Font version..: 3.000');
  LogAsImportant('Local time....: ' + GetDateTimeString('yyyy-dd-mm hh:nn', '-', ':'));
  LogAsImportant('Fonts folder..: ' + ExpandConstant('{fonts}'));
  LogAsImportant('Dest folder...: ' + ExpandConstant('{app}'));
  LogAsImportant('--------------------------------');

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


{ 
	function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;		
	var		
	 text:string;		
	begin		
	 text:='';		
	 text:=text + 'Setup is now ready to install Hack v2.XXX on your system' + NewLine;		
	 text:=text + NewLine;		
	 text:=text + 'Click Install to continue.' + NewLine;		
			
	 result:=text;		
	end;		
}


