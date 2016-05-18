#emit '//--- START incl_ServiceControlManager-definition.iss ---'

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
	
#emit '//--- END incl_ServiceControlManager-definition.iss ---'
	