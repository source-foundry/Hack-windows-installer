; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS






;--------------------------------------------------------
; FSCW Script Version: 2.11
; Inno Setup Version.: 5.5.9
; Inno Setup Type....: ANSI
;--------------------------------------------------------




; ISPP Base Path: C:\dev\git\Hack-windows-installer\

; DATA.INI Path: C:\dev\git\Hack-windows-installer\src\Data.ini







  



























; Processing section InstallFonts







;  INI position #1
;    Hack Bold
;    Hack-Bold.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Bold.ttf
;    28b45407cfdb0e9c5ea5797b5963e01c18a2c269

;  INI position #2
;    Hack
;    Hack-Regular.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Regular.ttf
;    b1cd50ba36380d6d6ada37facfc954a8f20c15ba

;  INI position #3
;    Hack Bold Italic
;    Hack-BoldItalic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-BoldItalic.ttf
;    12edfb7fc8c0a7e5b2bdb50007dd2024b02d530d

;  INI position #4
;    Hack Italic
;    Hack-Italic.ttf
;    C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Italic.ttf
;    a49b01c9fe79f45aa6e951db193c8f39c6c5e2df




; Processing section RemoveFonts








;  INI position #1
;    Hack-BoldOblique*.*
;    Hack Bold Oblique

;  INI position #2
;    Hack-RegularOblique*.*
;    Hack Oblique

;  INI position #3
;    Hack-Regular-linegap*.*
;    Hack Linegap

;  INI position #4
;    Hack-Bold-linegap*.*
;    Hack Bold Linegap

;  INI position #5
;    Hack-Italic-linegap*.*
;    Hack Italic linegap

;  INI position #6
;    Hack-BoldItalic-linegap*.*
;    Hack Bold Italic linegap









;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.
;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Bold.ttf\Hack-Bold.ttf - "Hack Bold" - 28b45407cfdb0e9c5ea5797b5963e01c18a2c269
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Regular.ttf\Hack-Regular.ttf - "Hack" - b1cd50ba36380d6d6ada37facfc954a8f20c15ba
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-BoldItalic.ttf\Hack-BoldItalic.ttf - "Hack Bold Italic" - 12edfb7fc8c0a7e5b2bdb50007dd2024b02d530d
; C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Italic.ttf\Hack-Italic.ttf - "Hack Italic" - a49b01c9fe79f45aa6e951db193c8f39c6c5e2df

;---END---



;General procedure
; a) Ready to install
; b) INSTALL (Step ssInstall)
; b1) InstallDeleteAction
; b2) BeforeInstallAction (Stop services)
; b3) Install files
; b4) AfterInstallAction (Start services)
; c) All done


[Setup]
AppId=HackWindowsInstaller
SetupMutex=HackWindowsInstaller_Mutex 

AppName=Hack Fonts

AppVersion=1.6.0
VersionInfoVersion=1.6.0

AppPublisher=Michael Hex / Source Foundry
AppCopyright=Copyright (c) 2016-2018 Michael Hex / Source Foundry

;Information displayed in Control Panel -> Add/Remove Programs applet
;---------------------------------------------------
;Displayed as "Help link:"
AppSupportURL=http://sourcefoundry.org/hack/
;Should also be displayed there, but I was unable to verify this
AppContact=Michael Hex / Source Foundry
;Displayed as "Comments" 
AppComments=Hack Fonts v3.003
;NOT USED: Displayed as "Update information:"
;AppUpdatesURL=http://appupdates.com
;---------------------------------------------------

;Store resulting exe in the \out folder
OutputDir=out\

;How to call the resulting EXE file
OutputBaseFilename=HackFontsWindowsInstaller

;Target folder settings
DefaultDirName={pf}\Hack Fonts\
;Don't warn when the taget folder exists
DirExistsWarning=no

 ;This icon is used for the icon of the resulting exe
 SetupIconFile=img\Hack-win-installer-crunch.ico

 ;This icon will be displayed in Add/Remove Programs and needs to be installed locally
 UninstallDisplayIcon={app}\Hack-win-installer-crunch.ico

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
SetupAppTitle=Hack Fonts

;SetupWindowsTitle is displayed in the setup window itself so we better include the version
SetupWindowTitle=Hack Fonts 1.6.0

;Messages for the "Read to install" wizard page
  ;NOT USED - "Ready To Install" - below title bar
  ;WizardReady=

;ReadLabel1: "Setup is now ready to begin installing ...."
ReadyLabel1=

;ReadyLabel2b: "Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the Hack Fonts v3.003 on your system.


[Icons]
;Create shortcut to the Font applet so the user can easily view the installed fonts.
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;Link to the homepage for this font
Name: "{app}\Website"; Filename: "http://sourcefoundry.org/hack/"; 


[Files]
  ;Copy license files
  Source: "license*.*"; DestDir: "{app}"; Flags: ignoreversion;

  ;Copy the icon to the installation folder in order to show it in Add/Remove Programs
  Source: "img\Hack-win-installer-crunch.ico"; DestDir: "{app}"; Flags: ignoreversion;

;------------------------
;Install font files and register them
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Bold.ttf"; FontInstall: "Hack Bold"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Regular.ttf"; FontInstall: "Hack"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-BoldItalic.ttf"; FontInstall: "Hack Bold Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "C:\dev\git\Hack-windows-installer\fonts\Hack_v3_003\Hack-Italic.ttf"; FontInstall: "Hack Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
;------------------------


; InstallDelete section is no longer used as it can not delete any file that is locked.
; See pascal scripting function "DeleteUnwantedFontFiles()" ( FillUnwantedFontFilesArray() ) for new delete code. 
;[InstallDelete]



[Registry]
;------------------------
;Remove old font names during install
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Linegap (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Linegap (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Italic linegap (TrueType)"; ValueType: none; Flags: deletevalue;
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Italic linegap (TrueType)"; ValueType: none; Flags: deletevalue;
;------------------------

;------------------------
;Check if we find a font name without "Bold" or "Italic" in it and if so, we will add (Regular) to the name and delete it during installation
;This is necessary as Windows does not expect (Regular) to be used, but sometimes the Font applet add this text anyway
       Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Regular (TrueType)"; ValueType: none; Flags: deletevalue;
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
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "1.6.0"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "Hack Fonts"


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
	end	else begin
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



function BoolToStr(Value: Boolean): String; 
begin
  if Value then Result := 'True'
           else Result := 'False';
end;


  
var

  FontFiles: array of string;
  FontFilesHashes: array of string;
  FontFilesNames: array of string;

  UnwantedFontFiles: array of string;
  
  FontFilesToBeDeleted: array of string;


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

  AddFontData('Hack-Bold.ttf', 'Hack Bold', '28b45407cfdb0e9c5ea5797b5963e01c18a2c269');
  AddFontData('Hack-Regular.ttf', 'Hack', 'b1cd50ba36380d6d6ada37facfc954a8f20c15ba');
  AddFontData('Hack-BoldItalic.ttf', 'Hack Bold Italic', '12edfb7fc8c0a7e5b2bdb50007dd2024b02d530d');
  AddFontData('Hack-Italic.ttf', 'Hack Italic', 'a49b01c9fe79f45aa6e951db193c8f39c6c5e2df');

end;



procedure AddUnwantedFontFile(fontFile:string);
var
  curSize: integer;
begin
  curSize:=GetArrayLength(UnwantedFontFiles);

  SetArrayLength(UnwantedFontFiles, curSize+1)

  UnwantedFontFiles[curSize]:=fontFile;
end;


procedure FillUnwantedFontFilesArray();
begin

  AddUnwantedFontFile('Hack-Bold_*.ttf');
  AddUnwantedFontFile('Hack-Regular_*.ttf');
  AddUnwantedFontFile('Hack-BoldItalic_*.ttf');
  AddUnwantedFontFile('Hack-Italic_*.ttf');


  AddUnwantedFontFile('Hack-BoldOblique*.*');
  AddUnwantedFontFile('Hack-RegularOblique*.*');
  AddUnwantedFontFile('Hack-Regular-linegap*.*');
  AddUnwantedFontFile('Hack-Bold-linegap*.*');
  AddUnwantedFontFile('Hack-Italic-linegap*.*');
  AddUnwantedFontFile('Hack-BoldItalic-linegap*.*');

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
  LogAsImportant('---InitializeWizard---');

  ChangesRequired:=false;

  FontCacheService_Stopped:=false;
  FontCache30Service_Stopped:=false;

  BeforeInstallActionWasRun:=false;

  FillFontDataArray;
  FillUnwantedFontFilesArray;  

  title:=SetupMessage(msgWizardInstalling);
  
  subTitle:=SetupMessage(msgInstallingLabel);  

  StringChangeEx(subTitle, '[name]', 'Hack Fonts', True);
  
  customProgressPage:=CreateOutputProgressPage(title, subTitle);

  LogAsImportant('---DONE---');
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  LogAsImportant('---PrepareToInstall---');

  LogAsImportant('Font name.....: Hack Fonts');
  LogAsImportant('Font version..: 3.003');
  LogAsImportant('Setup version.: 1.6.0');
  LogAsImportant('Script version: 2.11');
  LogAsImportant('Local time....: ' + GetDateTimeString('yyyy-dd-mm hh:nn', '-', ':'));
  LogAsImportant('Fonts folder..: ' + ExpandConstant('{fonts}'));
  LogAsImportant('Dest folder...: ' + ExpandConstant('{app}'));
  LogAsImportant('--------------------------------');


  
  {
  If RegValueExists(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager', 'PendingFileRenameOperations') then begin
     result:='Pending system changes, that require a reboot, have been detected. Please restart your computer.';
     NeedsRestart:=true;
  end; 
  }

  result:='';
  LogAsImportant('---DONE---');
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


procedure PrepareListOfFontFilesToBeDeleted();
var
  i:integer;
  curFont:string;  
  foundFontFile:string;
  findRec: TFindRec;
  arraySize:integer;
begin
  
  for i := 0 to GetArrayLength(UnwantedFontFiles)-1 do begin      
      curFont:=ExpandConstant('{fonts}\'+UnwantedFontFiles[i]);

      LogAsImportant('Unwanted font file entry: ' + curFont);      
      foundFontFile:='';
      
      if FindFirst(curFont, FindRec) then begin
         try
            repeat
               if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0 then begin
                  foundFontfile:=ExpandConstant('{fonts}\'+FindRec.Name);
                  LogAsImportant('           Matching file: ' + foundFontfile);
                  
                  arraySize:=GetArrayLength(FontFilesToBeDeleted);
                  SetArrayLength(FontFilesToBeDeleted, arraySize+1)
                  FontFilesToBeDeleted[arraySize]:=foundFontFile;
               end;
            
            until not FindNext(FindRec);
         finally
           FindClose(FindRec);
         end;
      end;
      
  end;

end;


procedure PrepareInstalledFontHashes();
var
  i:integer;
  currentFont:string;
  currentFontFileNameWindows:string;

begin
  SetArrayLength(InstalledFontsHashes, GetArrayLength(FontFiles));          
  
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

end;


const
 MOVEFILE_DELAY_UNTIL_REBOOT = $00000004;

function MoveFileEx(lpExistingFileName: string; lpNewFileName: string; dwFlags: Integer): Integer;
external 'MoveFileExA@kernel32.dll stdcall';


procedure DeleteUnwantedFontFiles();
var
  i:integer;
  currentFile:string;
  returnCode:integer;
  
  errorCode:Longint;
  errorMessage:string;
  errorText:string;
  errorTextLong:string;
begin
  for i := 0 to GetArrayLength(FontFilesToBeDeleted)-1 do begin      

      currentFile:=FontFilesToBeDeleted[i];

      LogAsImportant('Deleting file: ' + currentFile);      
      if DeleteFile(currentFile)=false then begin
         LogAsImportant('   Unable to delete file - will mark it to be removed upon next reboot');
         
         returnCode:=MoveFileEx(currentFile, '', MOVEFILE_DELAY_UNTIL_REBOOT);         
         if returnCode=0 then begin //This function will return 0 if *FAILED*
            errorCode:=DLLGetLastError;
            errorMessage:=SysErrorMessage(errorCode);

            errorText:='MoveFileEx failed with error code ' + IntToStr(errorCode) + ': ' + errorMessage;
            LogAsImportant('   ' + errorText);

            errorTextLong:='Unable to delete file [' + currentFile + '] - ' + errorText; 
            
            RaiseException(errorTextLong);
         end;

         LogAsImportant('   Done');
      end;

  end;

end;


procedure BeforeInstallAction();
var
 deleteChanges:boolean;
 installChanges:boolean;
 
begin
  LogAsImportant('---BeforeInstallAction START---');

  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin         
     
     LogAsImportant('-CHECK UNWANTED FONT FILES-');
     customProgressPage.SetText('Checking if font files need to be deleted...', '');     
     PrepareListOfFontFilesToBeDeleted();
     LogAsImportant('----------------------');

     if GetArrayLength(FontFilesToBeDeleted) > 0 then begin
        deleteChanges:=true;
     end else begin
        deleteChanges:=false;
     end;
     
     
     LogAsImportant('-CALCULATE HASH FOR EXISTING FONTS-');
     customProgressPage.SetText('Calculating hashes for installed fonts...', '');     
     PrepareInstalledFontHashes();
     LogAsImportant('----------------------');

     if AtLeastOneFontRequiresInstallation then begin
        installChanges:=true;
     end else begin
        installChanges:=false;
     end;

     
     ChangesRequired:=false;
     if (deleteChanges) or (installChanges) then begin
        ChangesRequired:=true;
     end; 
     
     LogAsImportant('----------------------');     
     LogAsImportant('Font deletion required: ' + BoolToStr(deleteChanges));
     LogAsImportant('Font installation required: ' + BoolToStr(installChanges));
     LogAsImportant('Pending changes: ' + BoolToStr(ChangesRequired));
     LogAsImportant('----------------------');     

      
     FontCacheService_Stopped:=false;
     FontCache30Service_Stopped:=false;

     if ChangesRequired=true then begin
        customProgressPage.SetText('Stopping service FontCache...','');
        FontCacheService_Stopped:=StopNTService2('FontCache');

        customProgressPage.SetText('Stopping service FontCache3.0.0.0...','');
        FontCache30Service_Stopped:=StopNTService2('FontCache3.0.0.0')
     end;


     LogAsImportant('-DELETE UNWANTED FONT FILES-');
     customProgressPage.SetText('Deleting unwanted font files...', '');     
     DeleteUnwantedFontFiles();
     LogAsImportant('----------------------');

    
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

      customProgressPage.SetText('Starting FontCache service...','');
      if FontCacheService_Stopped=true then begin
         StartNTService2('FontCache');
         FontCacheService_Stopped:=false;
         customProgressPage.SetText('FontCache service was started','');
      end;
      
      customProgressPage.SetText('Starting service FontCache3.0.0.0...','');
      if FontCache30Service_Stopped=true then begin
         StartNTService2('FontCache3.0.0.0');         
         FontCache30Service_Stopped:=false;
         customProgressPage.SetText('FontCache3.0.0.0 service was started','');
      end;

      
      
      {
      ;customProgressPage.SetText('Informing Windows that fonts have changed...','');

      ;SendBroadcastMessage(29, 0, 0);
      }

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

 if CurStep=ssDone then begin
    LogAsImportant('Setup finished');
 end;

end;


{ 
	function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo, MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;		
	var		
	 text:string;		
	begin		
	 text:='';		
	 text:=text + 'Setup is now ready to install XXX vYYYY on your system' + NewLine;		
	 text:=text + NewLine;		
	 text:=text + 'Click Install to continue.' + NewLine;		
			
	 result:=text;		
	end;		
}


