//Hack Windows Installer 
//Copyright (C) 2016 Michael Hex 
//Licensed under the MIT License
//https://github.com/source-foundry/Hack-windows-installer

//We require InnoSetup 5.5.8
#if VER < EncodeVer(5,5,8)
  #error A more recent version of Inno Setup is required to compile this script (5.5.8 or newer)
#endif

#include <ISPPBuiltins.iss>
#pragma option -v+
#pragma verboselevel 9



//Update this when releasing a new version
#define public Version '1.2.0'

//This defines in which sub folder of this project the current files are located
#define public HackMonospaced_Sourcefolder 'Hack_v2_020'

//This definies the version of Hack monospaces
#define public HackMonospaced_Version '2.020'



//--------------------------------------------------------------------
//Get the base path of this setup. It is assumed that is located in a folder named "src" and the base path is the folder above it
#define base_path StringChange(SourcePath,'src\','') 
#emit '; ISPP: Base Path ' + base_path

//Name of this setup
#define public AppName 'Hack Windows Installer'

//URL of the project homepage for the FONT 
#define public HackMonospaced_Homepage 'http://sourcefoundry.org/hack/'       /*'https://github.com/chrissimpkins/Hack'*/

//URL of the installer homepage
#define public Installer_Homepage 'https://github.com/source-foundry/Hack-windows-installer'

//Copyright information 
#define public Copyright 'Copyright © 2016 Michael Hex / Source Foundry'


//Internal names of the services 
#define public FontCacheService 'FontCache'
#define public FontCache30Service 'FontCache3.0.0.0'

//File name of the FontState Log
#define public LogFontDataFilename 'Log-FontData.txt'
#define public LogFontDataFilenameOld 'Log-FontData-old.txt'



//Total number of font entries we have
#define total_fonts 4

//Define font array
#dim public font_source[total_fonts]
#dim public font_file[total_fonts]
#dim public font_name[total_fonts]

//Counter for array
#define cntr 0

//---------------------------------------------------------

#define font_source[cntr] HackMonospaced_Sourcefolder
#define font_file[cntr] 'Hack-Bold.ttf'
#define font_name[cntr] 'Hack Bold'
#define cntr cntr+1

#define font_source[cntr] HackMonospaced_Sourcefolder
#define font_file[cntr] 'Hack-BoldItalic.ttf'
#define font_name[cntr] 'Hack Bold Italic'
#define cntr cntr+1

#define font_source[cntr] HackMonospaced_Sourcefolder
#define font_file[cntr] 'Hack-Regular.ttf'
#define font_name[cntr] 'Hack'    /* Regular is not used by Windows, so we need to remove this from the font name */
#define cntr cntr+1

#define font_source[cntr] HackMonospaced_Sourcefolder
#define font_file[cntr] 'Hack-Italic.ttf'
#define font_name[cntr] 'Hack Italic'
#define cntr cntr+1

//---------------------------------------------------------

//Helper macro to generate a SHA1 hash for a font file
#define public GetSHA1OfFontFile(str fontFolder, str fontFile) \
  GetSHA1OfFile(base_path + 'fonts\' + fontFolder + '\' + fontFile)

;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.
#define public GetFontDataDebugOutput(str source, str fileName, str fontName) \
   source + '\' + fileName + ' - "' + fontName + '"'

;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
#define public i 0
#sub Sub_DebugFontDataOutput
  #emit '; ' + GetFontDataDebugOutput(font_source[i], font_file[i], font_name[i]) + ' (' + GetSHA1OfFontFile(font_source[i], font_file[i]) + ')'
#endsub
#for {i = 0; i < DimOf(font_file); i++} Sub_DebugFontDataOutput
#undef i

;---END---




;General procedure
; e) Ready to install
; d) INSTALL
; d1) InstallDelete
; d2) BeforeInstallAction (Stop services)
; d3) Install files
; d4) AfterInstallAction (Start services)
; e) All done


  

[Setup]
AppId=HackWindowsInstaller
SetupMutex=HackWindowsInstaller_SetupMutex 

AppName={#AppName}
AppVersion={#Version}
VersionInfoVersion={#Version}

AppPublisher=Michael Hex / Source Foundry
AppContact=Michael Hex / Source Foundry
AppSupportURL={#Installer_Homepage}
AppComments=Hack font installer
AppCopyright={#Copyright}

;This icon is used for the icon of HackWindowsInstaller.exe itself
SetupIconFile=img\Hack-installer-icon.ico
;This icon will be displayed in Add/Remove programs and needs to be installed locally
UninstallDisplayIcon={app}\Hack-installer-icon.ico

;Folder configuration
SourceDir={#base_path}
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


[Messages]
;Default Windows/App text
;SetupAppTitle is displayed in the taskbar
SetupAppTitle={#AppName}
;SetupWindowsTitle is displayed in the setup window itself so better include the version
SetupWindowTitle={#AppName} {#Version}

;Message for the "Read to install" wizard page
  ;NOT USED - "Ready To Install" - below title bar
  ;WizardReady=
;ReadLabel1: "Setup is now ready to begin installing ...."
ReadyLabel1=
;ReadyLabel2b: "Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the Hack fonts v{#HackMonospaced_Version} on your system.




[Icons]
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;Link to the Hack homepage 
Name: "{app}\Hack Homepage"; Filename: "{#HackMonospaced_Homepage}"; 


[Files]
;Copy license files - always copied
Source: "license*.*"; DestDir: "{app}"; Flags: ignoreversion;

;Copy the icon to the installation folder in order to show it in Add/Remove programs
Source: "img\Hack-installer-icon.ico"; DestDir: "{app}"; Flags: ignoreversion;

;Install fonts
#define public i 0
#sub Sub_FontInstall
  Source: "fonts\{#font_source[i]}\{#font_file[i]}"; FontInstall: "{#font_name[i]}"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
#endsub
#for {i = 0; i < DimOf(font_file); i++} Sub_FontInstall
#undef i


[InstallDelete]
;If a user copies *.TTF files to the "Fonts" applet and a font file with the same name already exists, Windows will simply append "_0" (or _1) to the font file and copy it.
;These "ghost" files need to be exterminated!

;Helper macro to add a string at the end of filename, but before the extension
#define public AddStringToEndOfFilename(str fileName, str whatToAdd) \
  StringChange(fileName, '.'+ExtractFileExt(filename), whatToAdd + '.' + ExtractFileExt(fileName))


#define public i 0
#sub Sub_InstallDeleteRemove
  Type: files; Name: "{fonts}\{#AddStringToEndOfFilename(font_file[i], '_*')}"; 
#endsub
#for {i = 0; i < DimOf(font_file); i++} Sub_InstallDeleteRemove
#undef i

;Hack version 2.10 has used "Oblique" instead of "Italic" so these files should be deleted when hack is selected
Type: files; Name: "{fonts}\Hack-BoldOblique.ttf"; 
Type: files; Name: "{fonts}\Hack-RegularOblique.ttf"; 

[Registry]
;Hack version 2.10 has used "Oblique" instead of "Italic" so if there are any registry value found that use this name, delete them. 
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Oblique (TrueType)"; ValueType: none; Flags: deletevalue;
Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "Hack Bold Oblique (TrueType)"; ValueType: none; Flags: deletevalue;

;Delete any entry found in FontSubsitutes
#define public i 0
#sub Sub_DeleteRegistryFontSubstitutes
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "{#font_name[i]} (TrueType)"; ValueType: none; Flags: deletevalue;
#endsub
#for {i = 0; i < DimOf(font_file); i++} Sub_DeleteRegistryFontSubstitutes
#undef i



 
[INI]
;Create an ini to make detection for enterprise deployment tools easy
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "{#Version}"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "{#AppName}"

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
	SERVICE_QUERY_CONFIG		= $1;
	SERVICE_CHANGE_CONFIG		= $2;
	SERVICE_QUERY_STATUS		= $4;
	SERVICE_START				= $10;
	SERVICE_STOP				= $20;
	SERVICE_ALL_ACCESS			= $f01ff;
	SC_MANAGER_ALL_ACCESS		= $f003f;
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

  
var
  //Custom "prepare to install" page
  customProgressPage: TOutputProgressWizardPage;

  //All font files included in this setup
  FontFiles: array of string;
  //SHA1 hashes for these files
  FontFilesHashes: array of string;
  //Font names for these files
  FontFilesNames: array of string;
  
  //SHA1 hashes for fonts already installed
  InstalledFontsHashes: array of string;

  //True if we have stopped FontCache service
  FontCacheService_Stopped:boolean;
  FontCache30Service_Stopped:boolean;

  //True if the action has been run
  BeforeInstallActionWasRun:boolean;

  //If this true we will make changes to this system
  ChangesRequired:boolean;

  //In memory buffer for the "Font" messages written to the special log file ({#LogFontDataFilename})
  FontStateBuffer: array of string;


// #######################################################################################
// Service control code  from http://www.vincenzo.net/isxkb/index.php?title=Service_-_Functions_to_Start%2C_Stop%2C_Install%2C_Remove_a_Service
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

// #######################################################################################




//Adds font data (created at setup creation) to the runtime Font* arrays
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


//Prepare FontFiles* arrays
procedure FillFontDataArray();
begin

//Helper macro to generate a pascal script function call with the font filename, name and SHA1 hash 
#define public AddFontDataMacro(str fileName, str FontName, str SHA1Hash) \
  '  AddFontData(''' + fileName + ''', ''' + FontName + ''', ''' + SHA1Hash + ''');'

//Generate AddFontData(....) calls
#define public i 0  
#sub Sub_FontDataGenerateHash
 #emit  AddFontDataMacro(font_file[i], font_name[i], GetSHA1OfFontFile(font_source[i], font_file[i])) 
#endsub
#for {i = 0; i < DimOf(font_file); i++} Sub_FontDataGenerateHash
#undef public i

end;

//Logs to the internal buffer which will then be written to the installation folder at the end of the setup
procedure LogAsImportant(message:string);
var
  curSize: integer;
begin
  //Always write the message to the "normal" log as well

  log(message);

  curSize:=GetArrayLength(FontStateBuffer);  
  SetArrayLength(FontStateBuffer, curSize+1); 
  FontStateBuffer[curSize]:=message;
end;


procedure InitializeWizard;
var
  title, subTitle:string;
begin
  ChangesRequired:=false;
  FontCacheService_Stopped:=false;
  FontCache30Service_Stopped:=false;

  BeforeInstallActionWasRun:=false;

  //Fill font data arrays
  FillFontDataArray;

  //Prepare the custom PrepareToInstall wizard page where we show the progress of the service start/stop
  title:=SetupMessage(msgWizardPreparing);
  subTitle:=SetupMessage(msgPreparingDesc);
  
  //subTitle contains [name] which we need to replace 
  StringChangeEx(subTitle, '[name]', '{#AppName}', True);
  customProgressPage:=CreateOutputProgressPage(title, subTitle);
end;


{ //Not used right now - See [Messages]
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


//This function returns TRUE if:
// - the SHA1 hash of a file inside Windows\fonts is the same as the hash we have calculated
// - the name in the registry is the same we would use and it points to the same file
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

      //Check SHA1 hash from setup and Windows
      if FontFiles[i]=fileName then begin         
         entryFound:=true;                  

         //For debugging purposes, we first check the registry and than the file hash. 
         //This allows us to get data in the logfile what the data was before installation.

         expectedFontValue:=FontFilesNames[i]+' (TrueType)';
         LogAsImportant('   Checking for font name in registry: ' + expectedFontValue);
         if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', expectedFontValue, registryFontValue) then begin                                         
            LogAsImportant('   Font name found');

            LogAsImportant('   Checking for file name in registry. Expected: ' + fileName);
            //Does the value point to the same file name we expect?
            if registryFontValue=fileName then begin                  
               LogAsImportant('   File name matches');
               
               //Now check the hash value from setup with the file in \Fonts
               if FontFilesHashes[i]=InstalledFontsHashes[i] then begin 
                  LogAsImportant('   File hash matches, installation not required');
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

   //Sanity check
   if entryFound=false then begin
      RaiseException('No entry in the internal hash arrays found for: ' + fileName);
   end; 

end;



//Returns TRUE if a difference between the fonts in setup and the already installed fonts
function AtLeastOneFontRequiresInstallation():boolean;
var
  i:integer;
begin
  result:=false;

  LogAsImportant('Checking for differences between fonts in setup and this system');

  for i := 0 to GetArrayLength(FontFiles)-1 do begin        
     if IsSetupFontSameAsInstalledFont(FontFiles[i]) then begin
        //File is the same, ignore
     end else begin
        //We have a change, installation is required!
        LogAsImportant('   Found difference for file ' + FontFiles[i]);
        LogAsImportant('   Installation required.');

        //One detected difference is enough to result TRUE
        result:=true;           
        break;
     end;    
  end;
end;


//Called for each font that should be installed
//InnoSetup might call this function BEFORE our BeforeInstallAction is run. If this happens, it will always return TRUE
function FontFileInstallationRequired(): Boolean;
var
 file:string;
begin 

  if BeforeInstallActionWasRun=false then begin
     result:=true;
  end else begin 
     //This is the "real" thing once BeforeInstallAction was run
     file:=ExtractFileName(CurrentFileName);

     if IsSetupFontSameAsInstalledFont(file) then begin
        result:=false; //No installation required
     end else begin
        result:=true; //Installation required
     end;
  end;
 
end;



//Returns TRUE if a service was started 
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

//Stops a service and returns TRUE if it was stopped
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


//Show a custom prepare to install page in order to give the user output what we are doing
procedure BeforeInstallAction();
var
  i:integer;
  currentFont:string;
  currentFontFileNameWindows:string;
 
begin
  LogAsImportant('---BeforeInstallAction START---');

  //Write system information to log file
  LogAsImportant('Setup version: {#Version}');
  LogAsImportant('Font version.: {#HackMonospaced_Version}');
  LogAsImportant('Local time...: ' + GetDateTimeString('yyyy-dd-mm hh:nn', '-', ':'));
  LogAsImportant('Fonts folder.: ' + ExpandConstant('{fonts}'));
  LogAsImportant('Dest folder..: ' + ExpandConstant('{app}'));



  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin
         
     //Calculate the SHA1 hash for *ALL* fonts we support
     customProgressPage.SetText('Calculating hashes for fonts already installed...', '');
     
     SetArrayLength(InstalledFontsHashes, GetArrayLength(FontFiles));
     
     LogAsImportant('---HASH CALCULATION---');
     for i := 0 to GetArrayLength(FontFiles)-1 do begin
         currentFont:=FontFiles[i];
         LogAsImportant('Calculating hash for '+currentFont);
         LogAsImportant('   File from setup: ' +  FontFilesHashes[i]);    
         
         currentFontFileNameWindows:=ExpandConstant('{fonts}\'+currentFont);
    
         //Check the windows font folder for this entry and get the hash
         if FileExists(currentFontFileNameWindows) then begin
            InstalledFontsHashes[i]:=GetSHA1OfFile(currentFontFileNameWindows);
         end else begin
            InstalledFontsHashes[i]:='-NOT FOUND-';
         end;
     
         LogAsImportant('   File in \fonts : ' +  InstalledFontsHashes[i]);
     end;
     LogAsImportant('----------------------');
     
     
     //Set it to false by default
     ChangesRequired:=false;


     //Now we need to know if we need to install at least one font     
     if AtLeastOneFontRequiresInstallation then begin
        ChangesRequired:=true;
     end;


     //If at least one file will be installed, we will stop the "Windows Font Cache Service" and the "Windows Presentation Foundation Font Cache".
     //This will ensure that that these services update their internal database
     //If users still report about broken fonts, we will need to delete FontCache-S*.dat and ~FontCache-S*.dat from  C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache 
     FontCacheService_Stopped:=false;
     FontCache30Service_Stopped:=false;

     if ChangesRequired=true then begin
        customProgressPage.SetText('Stopping service {#FontCacheService}...','');
        FontCacheService_Stopped:=StopNTService2('{#FontCacheService}');

        customProgressPage.SetText('Stopping service {#FontCache30Service}...','');
        FontCache30Service_Stopped:=StopNTService2('{#FontCache30Service}')
     end;



    
  end;
  finally
    customProgressPage.Hide;
  end;

  BeforeInstallActionWasRun:=true;
  LogAsImportant('---BeforeInstallAction END---');
end;



//Show a custom prepare to install page in order to give the user output what we are doing
procedure AfterInstallAction();
var 
 appDestinationFolder:string;

begin
  log('---AfterInstallAction START---');

  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin

      //Start the service the before action has stopped
      customProgressPage.SetText('Starting service {#FontCacheService}...','');
      if FontCacheService_Stopped=true then begin
         StartNTService2('{#FontCacheService}');
         FontCacheService_Stopped:=false;
      end;

      customProgressPage.SetText('Starting service {#FontCache30Service}...','');
      if FontCache30Service_Stopped=true then begin
         StartNTService2('{#FontCache30Service}');         
         FontCache30Service_Stopped:=false;
      end;

      //Inform windows that fonts have changed (just to be sure we do this always)
      //See https://msdn.microsoft.com/en-us/library/windows/desktop/dd183326%28v=vs.85%29.aspx
      SendBroadcastMessage(29, 0, 0);
      //HWND_BROADCAST = -1
      //WM_FONTCHANGE = 0x1D = 29

      customProgressPage.SetText('Storing font data...','');

      //Write the buffer to disk. We better make sure that {app} exists.
      appDestinationFolder:=ExpandConstant('{app}');
      appDestinationFolder:=AddBackslash(appDestinationFolder);
      if DirExists(appDestinationFolder) then begin
         
         //Check if there is already a current log. If so, rename it. 
         If FileExists(appDestinationFolder + '{#LogFontDataFilename}') then begin
            
            //Check if and "old" file already exists. If so, delete it. 
            If FileExists(appDestinationFolder + '{#LogFontDataFilenameOld}') then begin
               DeleteFile(appDestinationFolder + '{#LogFontDataFilenameOld}');
            end;

            //Rename current file to old
            RenameFile(appDestinationFolder + '{#LogFontDataFilename}', appDestinationFolder + '{#LogFontDataFilenameOld}'); 
         end;            

         //Save the buffer 
         log('Saving font state to ' + appDestinationFolder + '{#LogFontDataFilename}');
         SaveStringsToFile(appDestinationFolder + '{#LogFontDataFilename}', FontStateBuffer, false); //do not append 
      end;


  end;
  finally
    customProgressPage.Hide;
  end;

  log('---AfterInstallAction END---');
end;



function NeedRestart(): Boolean;
begin
  //Given the MSDN docs, it seems that changing the fonts always requires a restart: https://msdn.microsoft.com/en-us/library/windows/desktop/dd183326%28v=vs.85%29.aspx
  //I also noticed this during the development of this setup, so we better be sure than sorry. 
 
  log('---NeedRestart---');
  if ChangesRequired then
     LogAsImportant('  Changes detected, require reboot');

  result:=ChangesRequired;
    
  log('---NeedRestart END---');
end;

function UninstallNeedRestart(): Boolean;
begin
 //See comments above, we better always request a restart
 result:=true;
end;


//Set up our own actions before and after the install starts
procedure CurStepChanged(CurStep: TSetupStep);
begin
 
 if CurStep=ssInstall then begin
    //I'm aware of the fact that I would also simply display this page by using the PrepareToInstall() function.
    //But I wanted to have both Before* and After* procedures listed here
    BeforeInstallAction();
 end;

 if CurStep=ssPostInstall then begin
    AfterInstallAction(); 
 end;

end;





#expr SaveToFile(AddBackslash(SourcePath) + "HackWindowsInstaller_TEMP_Preprocessed.iss")
