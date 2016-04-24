; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS



; BEGIN ISPPBUILTINS.ISS


; END ISPPBUILTINS.ISS











; ISPP: Base Path C:\dev\git\Hack-windows-installer\
























;---DEBUG---
;This output ensures that we do not have font_xxx array elements that are empty.

;Because the sub expects a string for each item, an error from ISPP about "Actual datatype not declared type" 
;when compiling the setup indicates that total_fonts is set to a wrong value
  
; Hack_v2_019\Hack-Bold.ttf - "Hack Bold" (88b4fa8e7d1aa8fe2d2d3f52a75cb2cf44b83c7a)
; Hack_v2_019\Hack-BoldItalic.ttf - "Hack Bold Italic" (a977e19b2b69c39eda63cd57fb41f55ef1fef38a)
; Hack_v2_019\Hack-Regular.ttf - "Hack" (3d5f3ccfa40406ad252b76a2219cb629df8e5ab3)
; Hack_v2_019\Hack-Italic.ttf - "Hack Italic" (5d00974b49990e543f55b4aec2ea83660c8a49bf)

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

AppName=Hack Windows Installer
AppVersion=1.0.1
VersionInfoVersion=1.0.1

AppPublisher=Michael Hex / Source Foundry
AppContact=Michael Hex / Source Foundry
AppSupportURL=https://github.com/source-foundry/Hack-windows-installer
AppComments=Hack font installer
AppCopyright=Copyright © 2016 Michael Hex / Source Foundry

;No icon?
;UninstallDisplayIcon
;SetupIconFile 

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

;Folder configuration
SourceDir=C:\dev\git\Hack-windows-installer\
OutputDir=out\
OutputBaseFilename=HackWindowsInstaller

;the file should be uninstallable
Uninstallable=Yes 

Compression=lzma2/ultra
SolidCompression=yes

PrivilegesRequired=admin

;Only include LicenseFile and InfoBeforeFile when using a release build
;#ifndef DEBUG
;Might be disabled later on
DisableWelcomePage=yes

;License information
;LicenseFile=LICENSE.txt

;readme
;InfoBeforeFile=readme.md

;#endif

;Ignore some screens
DisableDirPage=yes
DisableProgramGroupPage=yes
AllowCancelDuringInstall=False


[Icons]
Name: "{app}\Fonts Applet"; Filename: "control.exe"; Parameters: "/name Microsoft.Fonts"; WorkingDir: "{win}";

;The links to the homepage are only created if the user has selected the matching component
Name: "{app}\Hack Homepage"; Filename: "http://sourcefoundry.org/hack/"; 


[Files]
;Copy license files - always copied
Source: "license*.*"; DestDir: "{app}"; Flags: ignoreversion;

;Install fonts
  Source: "fonts\Hack_v2_019\Hack-Bold.ttf"; FontInstall: "Hack Bold"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "fonts\Hack_v2_019\Hack-BoldItalic.ttf"; FontInstall: "Hack Bold Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "fonts\Hack_v2_019\Hack-Regular.ttf"; FontInstall: "Hack"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 
  Source: "fonts\Hack_v2_019\Hack-Italic.ttf"; FontInstall: "Hack Italic"; DestDir: "{fonts}"; Check: FontFileInstallationRequired; Flags: ignoreversion restartreplace; 


[InstallDelete]
;If a user copies *.TTF files to the "Fonts" applet and a font file with the same name already exists, Windows will simply append "_0" (or _1) to the font file and copy it.
;These "ghost" files need to be exterminated!

;Helper macro to add something to a filename before the extension

  Type: files; Name: "{fonts}\Hack-Bold_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-BoldItalic_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-Regular_*.ttf"; 
  Type: files; Name: "{fonts}\Hack-Italic_*.ttf"; 

;Hack version 2.10 has used "Oblique" instead of "Italic" so these files should be deleted when hack is selected
Type: files; Name: "{fonts}\Hack-BoldOblique.ttf"; 
Type: files; Name: "{fonts}\Hack-RegularOblique.ttf"; 



 
[INI]
;Create an ini to make detection for enterprise deployment tools easy
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Version"; String: "1.0.1"
Filename: "{app}\InstallInfo.ini"; Section: "Main"; Key: "Name"; String: "Hack Windows Installer"

[UninstallDelete]
;Delete Install Info
Type: files; Name: "{app}\InstallInfo.ini"


[Messages]
;Message for the "Read to install" wizard page
;"Ready To Install"
;WizardReady=

;"Setup is now ready to begin installing ...."
ReadyLabel1=
;"Click Install to continue with the installation" 
ReadyLabel2b=Setup is now ready to install the Hack fonts v2.019 on your system.
;%n%nClick Install to continue.


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
  customPrepareToInstall: TOutputProgressWizardPage;

  FontFiles: array of string;
  FontFilesHashes: array of string;
  FontFilesNames: array of string;
  
  InstalledFontsHashes: array of string;

  FontCacheService_Stopped:boolean;
  FontCache30Service_Stopped:boolean;

  BeforeInstallActionWasRun:boolean;

  ChangesRequired:boolean;


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


  AddFontData('Hack-Bold.ttf', 'Hack Bold', '88b4fa8e7d1aa8fe2d2d3f52a75cb2cf44b83c7a');
  AddFontData('Hack-BoldItalic.ttf', 'Hack Bold Italic', 'a977e19b2b69c39eda63cd57fb41f55ef1fef38a');
  AddFontData('Hack-Regular.ttf', 'Hack', '3d5f3ccfa40406ad252b76a2219cb629df8e5ab3');
  AddFontData('Hack-Italic.ttf', 'Hack Italic', '5d00974b49990e543f55b4aec2ea83660c8a49bf');

end;


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
  customPrepareToInstall:=CreateOutputProgressPage(title, subTitle);
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


function IsSetupFontSameAsInstalledFont(fileName:string):boolean;
var
  i:integer;
  entryFound:boolean;
  registryFontValue:string;
begin
  log('IsSetupFontSameAsInstalledFont(): ' + fileName);

  result:=false;
  entryFound:=false;
  
  for i := 0 to GetArrayLength(FontFiles)-1 do begin

      if FontFiles[i]=fileName then begin         
         entryFound:=true;                  

         if FontFilesHashes[i]=InstalledFontsHashes[i] then begin                 
            if RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts', FontFilesNames[i]+' (TrueType)', registryFontValue) then begin               
               if registryFontValue=fileName then begin                  
                  result:=true; //all is exactly as expected
               end else begin
                  log('   File name in registry is different, installation required');                  
               end;            
            end else begin
               log('   Font not found in registry, installation required');
            end;
         end else begin
            log('   Hash values (Setup/Windows): ' + FontFilesHashes[i] + ' / ' + InstalledFontsHashes[i]);
            log('   File is different, installation required');
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

  log('Checking for differences between fonts in setup and this system');

  for i := 0 to GetArrayLength(FontFiles)-1 do begin        
     if IsSetupFontSameAsInstalledFont(FontFiles[i]) then begin
     end else begin
        log('   Found difference for file ' + FontFiles[i]);

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


procedure BeforeInstallAction();
var
  i:integer;
  currentFont:string;
  currentFontFileNameWindows:string;
 
begin
  log('---BeforeInstallAction---');

  customPrepareToInstall.SetProgress(0, 0);
  customPrepareToInstall.Show;

  try
    begin

     customPrepareToInstall.SetText('Calculating hashes for fonts already installed...', '');
     
     SetArrayLength(InstalledFontsHashes, GetArrayLength(FontFiles));
     
     log('---HASH CALCULATION---');
     for i := 0 to GetArrayLength(FontFiles)-1 do begin
         currentFont:=FontFiles[i];
         log('Calculating hash for '+currentFont);
         log('   File from setup: ' +  FontFilesHashes[i]);    
         
         currentFontFileNameWindows:=ExpandConstant('{fonts}\'+currentFont);
    
         if FileExists(currentFontFileNameWindows) then begin
            InstalledFontsHashes[i]:=GetSHA1OfFile(currentFontFileNameWindows);
         end else begin
            InstalledFontsHashes[i]:='-NOT FOUND-';
         end;
     
         log('   File in \fonts : ' +  InstalledFontsHashes[i]);
     end;
     log('----------------------');
     
     
     ChangesRequired:=false;


     if AtLeastOneFontRequiresInstallation then begin
        ChangesRequired:=true;
     end;


     FontCacheService_Stopped:=false;
     FontCache30Service_Stopped:=false;

     if ChangesRequired=true then begin
        customPrepareToInstall.SetText('Stopping service FontCache...','');
        FontCacheService_Stopped:=StopNTService2('FontCache');

        customPrepareToInstall.SetText('Stopping service FontCache3.0.0.0...','');
        FontCache30Service_Stopped:=StopNTService2('FontCache3.0.0.0')
     end;



    
  end;
  finally
    customPrepareToInstall.Hide;
  end;

  BeforeInstallActionWasRun:=true;
  log('---BeforeInstallAction END---');
end;



procedure AfterInstallAction();
begin
  log('---AfterInstallAction---');

  customPrepareToInstall.SetProgress(0, 0);
  customPrepareToInstall.Show;

  try
    begin

      customPrepareToInstall.SetText('Starting service FontCache...','');
      if FontCacheService_Stopped=true then begin
         StartNTService2('FontCache');
         FontCacheService_Stopped:=false;
      end;

      customPrepareToInstall.SetText('Starting service FontCache3.0.0.0...','');
      if FontCache30Service_Stopped=true then begin
         StartNTService2('FontCache3.0.0.0');         
         FontCache30Service_Stopped:=false;
      end;


      SendBroadcastMessage(29, 0, 0);

   
  end;
  finally
    customPrepareToInstall.Hide;
  end;

  log('---AfterInstallAction END---');
end;



function NeedRestart(): Boolean;
begin
 
  log('---NeedRestart---');
  if ChangesRequired then
     log('  Changes detected, require reboot');

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





