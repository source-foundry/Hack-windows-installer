//Font Setup Creator for Windows (FSCW) + Hack Windows Installer 
//Copyright (C) 2016-2017 Michael Hex 
//
//Licensed under the MIT License
//
//https://github.com/source-foundry/FSCW
//https://github.com/source-foundry/Hack-windows-installer
//
//--------------------------------------------------------
//Version of this installer script. Please do not change.
#define public ScriptVersion '2.11'
//--------------------------------------------------------


//We require InnoSetup 5.5.9
#if VER < EncodeVer(5,5,9)
  #error A more recent version of Inno Setup is required to compile this script (5.5.9 or newer)
#endif

#if DEFINED(UNICODE) != 0
    #define public InnoSetupType 'Unicode'
#else 
    #define public InnoSetupType 'ANSI'
#endif


#emit ';--------------------------------------------------------'
#emit '; FSCW Script Version: ' + ScriptVersion
#emit '; Inno Setup Version.: ' + DecodeVer(VER)
#emit '; Inno Setup Type....: ' + InnoSetupType
#emit ';--------------------------------------------------------'


//Set ISPP options
#pragma option -v+
#pragma verboselevel 9


//Get the base path of this project. It is assumed that this .ISS file is located in a folder named "src" and the base path is the folder above it
#define base_path StringChange(SourcePath,'src\','') 
#emit '; ISPP Base Path: ' + base_path

//The name of the data.ini to be used. Default is data.ini in the same path as this file
#define public DataIni AddBackslash(base_path) + 'src\Data.ini'
#emit '; DATA.INI Path: ' + DataIni



//Start processing data from 'DATA.ini'
#if !FileExists(DataIni)
    #pragma error 'Data.ini not found'
#endif


//Reads a value from the Data.ini 
#define public GetDataIniValue(str sectionName, str valueName) \
        ReadIni(DataIni, sectionName, valueName, '')

//Read a numbered value from Data.ini in the form valueName.Counter e.g. "Font.1"
#define public GetIniNumberedValue(str sectionName, str valueName, int counter) \
        GetDataIniValue(sectionName, valueName + '.' + Str(Counter))

//Define helper macro to add a string at the end of filename, but before the extension
#define public AddStringToEndOfFilename(str fileName, str whatToAdd) \
  StringChange(fileName, '.'+ExtractFileExt(filename), whatToAdd + '.' + ExtractFileExt(fileName))
  

//INI Section Names
#define public SectionAbout 'About'
#define public SectionGeneral 'General'
#define public SectionVersion 'Version'
#define public SectionInstallFonts 'InstallFonts'
#define public SectionRemoveFonts 'RemoveFonts'




//Retrieve Unique / Setup ID
#define public UniqueID GetDataIniValue('ID', 'UniqueID')
#if len(UniqueID)==0
 #pragma error 'UniqueID is empty'
#endif


//--- VERSION section ---

//Version of the SETUP/INSTALLER
#define public Version GetDataIniValue(SectionVersion, 'Version')
#if len(Version)==0
 #error 'Version is empty'
#endif

//Overwrite the version when an external version is found
#ifdef EXTERNAL_VERSION
 #if len(EXTERNAL_VERSION)>0
     #define public Version EXTERNAL_VERSION
 #endif
#endif 

//Version of the font(s)
#define public FontVersion GetDataIniValue(SectionVersion, 'FontVersion')
#if len(FontVersion)==0
 #pragma error 'FontVersion is empty'
#endif

//Overwrite the font version when an external font version is found
#ifdef EXTERNAL_FONT_VERSION
 #if len(EXTERNAL_FONT_VERSION)>0
     #define public FontVersion EXTERNAL_FONT_VERSION
 #endif
#endif 


//--- ABOUT section ---

//Name of this font
#define public FontName GetDataIniValue(SectionAbout, 'FontName')
#if len(FontName)==0
 #error 'FontName is empty'
#endif

//Retrieve Publisher
#define public Publisher GetDataIniValue(SectionAbout, 'Publisher')
#if len(Publisher)==0
 #error 'Publisher is empty'
#endif

//Retrieve Copyright information 
#define public Copyright GetDataIniValue(SectionAbout, 'Copyright')
#if len(Copyright)==0
 #error 'Copyright is empty'
#endif

//Retrieve Website 
#define public Website GetDataIniValue(SectionAbout, 'Website')
#if len(Website)==0
 #error 'Website is empty'
#endif


//--- GENERAL section ---

//Retrieve InstallerName
#define public InstallerName GetDataIniValue(SectionGeneral, 'Name')
#if len(InstallerName)==0
 #error 'Name is empty'
#endif

//Retrieve ExeFile (name of the resulting setup file)  
#define public ExeFile GetDataIniValue(SectionGeneral, 'ExeFile')
#if len(ExeFile)==0
 #error 'ExeFile is empty'
#endif

//Retrieve DestinationFolder 
#define public DestinationFolder GetDataIniValue(SectionGeneral, 'DestinationFolder')
#if len(DestinationFolder)==0
 #error 'DestinationFolder is empty'
#endif

//Retrieve icon file
#define public IconFile GetDataIniValue(SectionGeneral, 'Icon')
//Icon file can be empty, so no check here

//Retrieve license file(s) 
#define public LicenseFiles GetDataIniValue(SectionGeneral, 'LicenseFile')
#if len(LicenseFiles)==0
 #error 'LicenseFile is empty'
#endif


//--- INSTALLFONTS section ---

//Process *InstallFonts* section
#emit '; Processing section ' + SectionInstallFonts

//Retrieve source folder        
#define font_source_folder GetDataIniValue(SectionInstallFonts, 'SourceFolder')
#if len(font_source_folder)==0
 #error 'Source folder is empty'
#endif

#define install_font_count_string GetDataIniValue(SectionInstallFonts, 'Count')
//Check value
#if len(install_font_count_string)==0
 #error 'Value COUNT count of fonts to be installed is empty'
#endif

//Declare the arrays
#define install_font_count int(install_font_count_string)

#dim public font_files[install_font_count]
#dim public font_names[install_font_count]
#dim public font_paths[install_font_count]
#dim public font_hashes[install_font_count]


#define public i 0
#sub Sub_ProcessFontSectionEntry
  #emit ';  INI position #' +  Str(i+1) 
  //Fontname
  #define cur_name GetIniNumberedValue(SectionInstallFonts, 'Name', i+1)
  #if len(cur_name)==0
      #pragma error 'Error: Unable to read font name for entry ' + Str(i+1)
  #endif
  #emit ';    ' + cur_name
  #define public font_names[i] cur_name
  //Filename
  #define cur_file GetIniNumberedValue(SectionInstallFonts, 'File', i+1)
  #if len(cur_file)==0
      #pragma error 'Error: Unable to read font file for entry ' + Str(i+1)
  #endif
  #emit ';    ' +  cur_file
  #define public font_files[i] cur_file
  //Fontpath
  #define cur_fullpath base_path + AddBackslash(font_source_folder) + cur_file
  #if !FileExists(cur_fullpath)
    #pragma error 'Font ' +  cur_fullpath + ' not found'
  #endif
  #emit ';    ' + cur_fullpath
  #define public font_paths[i] cur_fullpath
  //Fonthash 
  #define public font_hashes[i] GetSHA1OfFile(cur_fullpath)
  #emit ';    ' + font_hashes[i]

#endsub

//Loop over all font data entries to generate the base arrays for storing font data
#for {i = 0; i < install_font_count; i++} Sub_ProcessFontSectionEntry
#undef i


//--- REMOVEFONTS section ---

//Process *RemoveFont* sections
#emit '; Processing section ' + SectionRemoveFonts

#define remove_font_count_string GetDataIniValue(SectionRemoveFonts, 'Count')
//Check value
#if len(remove_font_count_string)==0
 #pragma error 'Value COUNT of fonts to remove is empty'
#endif

#define remove_font_count int(remove_font_count_string)

//If remove_font_count is 0, we need to init the arrays with 1 or ISPP will error out
#define remove_font_array_size remove_font_count
#if remove_font_array_size==0
    #define remove_font_array_size 1
#endif

#dim public remove_font_files[remove_font_array_size]
#dim public remove_font_names[remove_font_array_size]


//Start looping
#define public i 0

#sub Sub_ProcessRemoveFontSectionEntry
  //Filename
  #emit ';  INI position #' +  Str(i+1) 
  #define cur_file GetIniNumberedValue(SectionRemoveFonts, 'File', i+1)
  #if len(cur_file)==0
      #pragma error 'Error: Unable to read font file for entry ' + Str(i+1)
  #endif
  #emit ';    ' +  cur_file
  #define public remove_font_files[i] cur_file
  //Fontname
  #define cur_name GetIniNumberedValue(SectionRemoveFonts, 'Name', i+1)
  #if len(cur_name)==0
      #pragma error 'Error: Unable to read font name for entry ' + Str(i+1)
  #endif
  #emit ';    ' + cur_name
  #define public remove_font_names[i] cur_name

#endsub

//Loop over all font data entries to generate the base arrays for storing font data
#for {i = 0; i < remove_font_count; i++} Sub_ProcessRemoveFontSectionEntry
#undef i


//Internal names of the font services 
#define public FontCacheService 'FontCache'
#define public FontCache30Service 'FontCache3.0.0.0'

//File name for the FontState Log
#define public LogFontDataFilename 'Log-FontData.txt'
#define public LogFontDataFilenameOld 'Log-FontData-old.txt'

//We need this more than once
#define public TrueType '(TrueType)'




;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.
#define public GetFontDataDebugOutput(str source, str fileName, str fontName, str hash) \
   source + '\' + fileName + ' - "' + fontName + '" - ' + hash
;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
#define public i 0
#sub Sub_DebugFontDataOutput
  #emit '; ' + GetFontDataDebugOutput(font_paths[i], font_files[i], font_names[i], font_hashes[i])
#endsub
#for {i = 0; i < install_font_count; i++} Sub_DebugFontDataOutput
#undef i

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
AppId={#UniqueID}
SetupMutex={#UniqueID}_Mutex 

AppName={#InstallerName}

AppVersion={#Version}
VersionInfoVersion={#Version}

AppPublisher={#Publisher}
AppCopyright={#Copyright}

;Information displayed in Control Panel -> Add/Remove Programs applet
;---------------------------------------------------
;Displayed as "Help link:"
AppSupportURL={#Website}
;Should also be displayed there, but I was unable to verify this
AppContact={#Publisher}
;Displayed as "Comments" 
AppComments={#FontName} v{#FontVersion}
;NOT USED: Displayed as "Update information:"
;AppUpdatesURL=http://appupdates.com
;---------------------------------------------------

;Store resulting exe in the \out folder
OutputDir=out\

;How to call the resulting EXE file
OutputBaseFilename={#ExeFile}

;Target folder settings
DefaultDirName={pf}\{#AddBackslash(DestinationFolder)}
;Don't warn when the taget folder exists
DirExistsWarning=no

#if len(IconFile)>0
 ;This icon is used for the icon of the resulting exe
 SetupIconFile={#IconFile}

 ;This icon will be displayed in Add/Remove Programs and needs to be installed locally
 UninstallDisplayIcon={app}\{#ExtractFileName(IconFile)}
#endif

;Source folder is the base path
SourceDir={#base_path}

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
SetupAppTitle={#InstallerName}

;SetupWindowsTitle is displayed in the setup window itself so we better include the version
SetupWindowTitle={#InstallerName} {#Version}

;Messages for the "Read to install" wizard page
  ;NOT USED - "Ready To Install" - below title bar
  ;WizardReady=

;ReadLabel1: "Setup is now ready to begin installing ...."
ReadyLabel1=

;ReadyLabel2b: "Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the {#FontName} v{#FontVersion} on your system.


[Icons]
;Create shortcut to the Font applet so the user can easily view the installed fonts.
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;Link to the homepage for this font
Name: "{app}\Website"; Filename: "{#Website}"; 


[Files]
#if len(LicenseFiles)>0
  ;Copy license files
  Source: "{#LicenseFiles}"; DestDir: "{app}"; Flags: ignoreversion;
#endif

#if len(IconFile)>0
  ;Copy the icon to the installation folder in order to show it in Add/Remove Programs
  Source: "{#IconFile}"; DestDir: "{app}"; Flags: ignoreversion;
#endif

;------------------------
;Install font files and register them
#define public i 0
#sub Sub_FontInstall
  Source: "{#font_paths[i]}"; FontInstall: "{#font_names[i]}"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
#endsub
#for {i = 0; i < install_font_count; i++} Sub_FontInstall
#undef i
;------------------------


; InstallDelete section is no longer used as it can not delete any file that is locked.
; See pascal scripting function "DeleteUnwantedFontFiles()" ( FillUnwantedFontFilesArray() ) for new delete code. 
;[InstallDelete]



[Registry]
;------------------------
;Remove old font names during install
#define public i 0
#sub Sub_DeleteRegistryOldFontnames
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "{#remove_font_names[i]} {#TrueType}"; ValueType: none; Flags: deletevalue;
#endsub
#for {i = 0; i < remove_font_count; i++} Sub_DeleteRegistryOldFontnames
#undef i
;------------------------

;------------------------
;Check if we find a font name without "Bold" or "Italic" in it and if so, we will add (Regular) to the name and delete it during installation
;This is necessary as Windows does not expect (Regular) to be used, but sometimes the Font applet add this text anyway
#define public i 0
#sub Sub_DeleteRegistryFontRegular
  #if pos('Bold', font_names[i]) == 0
    #if pos('Italic', font_names[i]) == 0
       Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"; ValueName: "{#font_names[i]} Regular {#TrueType}"; ValueType: none; Flags: deletevalue;
    #endif
  #endif 
#endsub
#for {i = 0; i < install_font_count; i++} Sub_DeleteRegistryFontRegular
#undef i
;------------------------

;------------------------
;Delete any entry found in FontSubsitutes for each of the fonts that will be installed
#define public i 0
#sub Sub_DeleteRegistryFontSubstitutes
  Root: HKLM; Subkey: "SOFTWARE\Microsoft\Windows NT\CurrentVersion\FontSubstitutes"; ValueName: "{#font_names[i]} {#TrueType}"; ValueType: none; Flags: deletevalue;
#endsub
#for {i = 0; i < install_font_count; i++} Sub_DeleteRegistryFontSubstitutes
#undef i
;------------------------



 
[INI]
;Create an ini to make detection for enterprise deployment tools easy
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "{#Version}"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "{#InstallerName}"


[UninstallDelete]
;Delete install Info
Type: files; Name: "{app}\InstallInfo.ini"
;Delete log files
Type: files; Name: "{app}\Log*.txt"



[Code]

//-------------------------------------------------------
//Required definitions for Windows Service handling
//from http://www.vincenzo.net/isxkb/index.php?title=Service_-_Functions_to_Start%2C_Stop%2C_Install%2C_Remove_a_Service
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

//Windows Service Handling END	
//-------------------------------------------------------


//Helper function
function BoolToStr(Value: Boolean): String; 
begin
  if Value then Result := 'True'
           else Result := 'False';
end;


  
var
  //Custom "prepare to install" page
  //customProgressPage: TOutputProgressWizardPage;

  //All font files included in this setup
  FontFiles: array of string;
  //SHA1 hashes for these files
  FontFilesHashes: array of string;
  //Font names for these files
  FontFilesNames: array of string;

  //Unwanted (to be deleted) font files as defined by the setup creator
  UnwantedFontFiles: array of string;
  
  //Font files that need to be deleted, this array include fully qualified names
  FontFilesToBeDeleted: array of string;


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

//Helper macro to generate a pascal script function call with the font filename, name and SHA1 hash 
#define public AddFontDataMacro(str fileName, str fontName, str hash) \
  '  AddFontData(''' + fileName + ''', ''' + fontName + ''', ''' + hash + ''');'

//Prepare FontFiles* arrays
procedure FillFontDataArray();
begin

//Generate AddFontData(....) calls
#define public i 0  
#sub Sub_FontDataEnum
 #emit  AddFontDataMacro(font_files[i], font_names[i], font_hashes[i]) 
#endsub
#for {i = 0; i < install_font_count; i++} Sub_FontDataEnum
#undef public i

end;



//Adds font data (created at setup creation) to the runtime UnwantedFont* array
procedure AddUnwantedFontFile(fontFile:string);
var
  curSize: integer;
begin
  curSize:=GetArrayLength(UnwantedFontFiles);

  SetArrayLength(UnwantedFontFiles, curSize+1)

  UnwantedFontFiles[curSize]:=fontFile;
end;

//Define helper macro to generate a pascal script function call with the font filename
#define public AddUnwantedFontFileMacro(str fileName) \
  '  AddUnwantedFontFile(''' + fileName + ''');'

//Prepare UnwantedFontFiles array for font files that should be deleted
procedure FillUnwantedFontFilesArray();
begin

//------------------------
//If a user copies *.TTF files to the "Fonts" applet and a font file with the same name already exists, 
//Windows will simply append "_0" (or _1) to the font file and copy it.
//These "ghost" files need to be exterminated!
#define public i 0
#sub Sub_DeleteGhostFonts
  #emit  AddUnwantedFontFileMacro( AddStringToEndOfFilename(font_files[i], '_*') ) 
#endsub
#for {i = 0; i < install_font_count; i++} Sub_DeleteGhostFonts
#undef i
//------------------------


//------------------------
//Remove old font files, as noted in [RemoveFonts] section
#define public i 0
#sub Sub_DeleteOldFonts
  #emit  AddUnwantedFontFileMacro( remove_font_files[i] ) 
#endsub
#for {i = 0; i < remove_font_count; i++} Sub_DeleteOldFonts
#undef i
//------------------------

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

var
  //Custom "prepare to install" page
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

  //Fill font data arrays
  FillFontDataArray;
  FillUnwantedFontFilesArray;  

  //Prepare the custom PrepareToInstall wizard page where we show the progress of the service start/stop
  //title:=SetupMessage(msgWizardPreparing);
  title:=SetupMessage(msgWizardInstalling);
  
  //subTitle:=SetupMessage(msgPreparingDesc);  
  subTitle:=SetupMessage(msgInstallingLabel);  

  //subTitle contains [name] which we need to replace 
  StringChangeEx(subTitle, '[name]', '{#InstallerName}', True);
  
  customProgressPage:=CreateOutputProgressPage(title, subTitle);

  LogAsImportant('---DONE---');
end;


function PrepareToInstall(var NeedsRestart: Boolean): String;
begin
  LogAsImportant('---PrepareToInstall---');

  //Write system information to log file
  //LogAsImportant('--------------------------------');
  LogAsImportant('Font name.....: {#FontName}');
  LogAsImportant('Font version..: {#FontVersion}');
  LogAsImportant('Setup version.: {#Version}');
  LogAsImportant('Script version: {#ScriptVersion}');
  LogAsImportant('Local time....: ' + GetDateTimeString('yyyy-dd-mm hh:nn', '-', ':'));
  LogAsImportant('Fonts folder..: ' + ExpandConstant('{fonts}'));
  LogAsImportant('Dest folder...: ' + ExpandConstant('{app}'));
  LogAsImportant('--------------------------------');


  //We need to check if HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations exists
  //and if so, we should break the installation to make 100% sure everything is fine. 
  //But on the other hand a lot of stuff is added there that wouldn't make any difference for our setup. 
  
  //As of now, this check is disabled
  {
  If RegValueExists(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Control\Session Manager', 'PendingFileRenameOperations') then begin
     result:='Pending system changes, that require a reboot, have been detected. Please restart your computer.';
     NeedsRestart:=true;
  end; 
  }

  result:='';
  LogAsImportant('---DONE---');
end;


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

            LogAsImportant('   Checking file name in registry. Expected: ' + fileName);
            //Does the value point to the same file name we expect?
            if registryFontValue=fileName then begin                  
               LogAsImportant('   File name matches');
               
               //Now check the hash value from setup with the file in \Fonts
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
               // Don't count directories
               if FindRec.Attributes and FILE_ATTRIBUTE_DIRECTORY = 0 then begin
                  //Found one!
                  foundFontfile:=ExpandConstant('{fonts}\'+FindRec.Name);
                  LogAsImportant('           Matching file: ' + foundFontfile);
                  
                  //Add to our array
                  arraySize:=GetArrayLength(FontFilesToBeDeleted);
                  SetArrayLength(FontFilesToBeDeleted, arraySize+1)
                  FontFilesToBeDeleted[arraySize]:=foundFontFile;
               end;
            
            until not FindNext(FindRec);
         finally
           FindClose(FindRec);
         end;
      end;
      
      //next entry
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
    
      //Check the windows font folder for this entry and get the hash
      if FileExists(currentFontFileNameWindows) then begin
         InstalledFontsHashes[i]:=GetSHA1OfFile(currentFontFileNameWindows);
      end else begin
         InstalledFontsHashes[i]:='-NOT FOUND-';
      end;
     
      LogAsImportant('   File in \fonts : ' +  InstalledFontsHashes[i]);
  end;

end;


//Windows function to set HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations
//This will allow us to delete even locked files.  
//Protype copied from https://www.codeproject.com/Tips/1193043/Inno-Setup-Cleanup-Extra-Files
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
            
            //This will display an error message and halt setup.
            //If the setup is started with /SUPPRESSMSGBOXES the message box is not shown, only logged
            RaiseException(errorTextLong);
         end;

         LogAsImportant('   Done');
      end;

  end;

end;


//This function is called just before Inno Setup starts the real installation procedure
procedure BeforeInstallAction();
var
 deleteChanges:boolean;
 installChanges:boolean;
 
begin
  LogAsImportant('---BeforeInstallAction START---');

  //Show a custom prepare to install page in order to give the user output what we are doing
  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin         
     
     //Check if font files exist that require deletion
     LogAsImportant('-CHECK UNWANTED FONT FILES-');
     customProgressPage.SetText('Checking if font files need to be deleted...', '');     
     PrepareListOfFontFilesToBeDeleted();
     LogAsImportant('----------------------');

     //If the arraysize of FontFilesToBeDeleted is bigger than 0, we have changes pending delete operations
     if GetArrayLength(FontFilesToBeDeleted) > 0 then begin
        deleteChanges:=true;
     end else begin
        deleteChanges:=false;
     end;
     
     
     //Calculate the SHA1 hash for the fonts we want to install
     LogAsImportant('-CALCULATE HASH FOR EXISTING FONTS-');
     customProgressPage.SetText('Calculating hashes for installed fonts...', '');     
     PrepareInstalledFontHashes();
     LogAsImportant('----------------------');

     //Now we need to know if we need to install at least one font     
     if AtLeastOneFontRequiresInstallation then begin
        installChanges:=true;
     end else begin
        installChanges:=false;
     end;

     
     //Now we need to check if any changes are required or not.
     //If changes are required, we will stop the two services before installation starts and restart them later on.
     //If no changes are required, we will not stop/start those services
     ChangesRequired:=false;
     if (deleteChanges) or (installChanges) then begin
        ChangesRequired:=true;
     end; 
     
     LogAsImportant('----------------------');     
     LogAsImportant('Font deletion required: ' + BoolToStr(deleteChanges));
     LogAsImportant('Font installation required: ' + BoolToStr(installChanges));
     LogAsImportant('Pending changes: ' + BoolToStr(ChangesRequired));
     LogAsImportant('----------------------');     

      
     //If at least one file will be installed, we will stop the "Windows Font Cache Service" and the "Windows Presentation Foundation Font Cache" services. 
     //This will ensure that that these services update their internal database.
     //If users still report about broken fonts, we will need to delete FontCache-S*.dat and ~FontCache-S*.dat from
     //C:\Windows\ServiceProfiles\LocalService\AppData\Local\FontCache 
     FontCacheService_Stopped:=false;
     FontCache30Service_Stopped:=false;

     if ChangesRequired=true then begin
        customProgressPage.SetText('Stopping service {#FontCacheService}...','');
        FontCacheService_Stopped:=StopNTService2('{#FontCacheService}');

        customProgressPage.SetText('Stopping service {#FontCache30Service}...','');
        FontCache30Service_Stopped:=StopNTService2('{#FontCache30Service}')
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


//This function is called once Inno Setup has finished the installation procedure
procedure AfterInstallAction();
var 
 appDestinationFolder:string;

begin
  log('---AfterInstallAction START---');

  //Show a custom prepare to install page in order to give the user output what we are doing
  customProgressPage.SetProgress(0, 0);
  customProgressPage.Show;

  try
    begin

      //Start the service the before action has stopped
      customProgressPage.SetText('Starting {#FontCacheService} service...','');
      if FontCacheService_Stopped=true then begin
         StartNTService2('{#FontCacheService}');
         FontCacheService_Stopped:=false;
         customProgressPage.SetText('{#FontCacheService} service was started','');
      end;
      
      customProgressPage.SetText('Starting service {#FontCache30Service}...','');
      if FontCache30Service_Stopped=true then begin
         StartNTService2('{#FontCache30Service}');         
         FontCache30Service_Stopped:=false;
         customProgressPage.SetText('{#FontCache30Service} service was started','');
      end;

      
      // We got several error reports that step hangs the installer if certain programs are running:
      // "Installer stuck at starting fontcache on windows 10 Version 10.0.15063 Build 15063" 
      // https://github.com/source-foundry/Hack-windows-installer/issues/11
      
      // Hence, this step is disabled although it is recommended to send out WM_FONTCHANGE. Given
      // that we request a restart anyway, this should only have a minimum impact (if at all). 
      {
      ;customProgressPage.SetText('Informing Windows that fonts have changed...','');

      //Inform windows that fonts have changed (just to be sure we do this always)
      //See https://msdn.microsoft.com/en-us/library/windows/desktop/dd183326%28v=vs.85%29.aspx
      ;SendBroadcastMessage(29, 0, 0);
      //WM_FONTCHANGE = 0x1D = 29
      }

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

 if CurStep=ssDone then begin
    LogAsImportant('Setup finished');
 end;

end;


{ 
  //Not used right now - See [Messages]		
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


//Save the result of the preprocessor to a file for review
#expr SaveToFile(AddBackslash(SourcePath) + "zz_Preprocessor_Result.iss")
