#emit '//--- START incl_ServiceControlManager-functions.iss ---'

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



#emit '//--- END incl_ServiceControlManager-functions.iss ---'
	