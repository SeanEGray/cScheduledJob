# cScheduledJob
DSC Resource for creating and configuring Scheduled Jobs on Windows Server.
This module aims to implement most of the options made available by the PSScheduledJob module; the RunEvery and RunNow parameters for Register-ScheduledJob cannot be implemented, as they simply create triggers that can't be distinguished from triggers created with the Trigger parameter.

This module has not yet achieved minimal viable functionality. Do not use it, yet.

# Resources in this module
## cScheduledJob

cScheduledJob represents a single scheduled job.

### Properties
#### Name (Key)
Name of the scheduled job. Names must be unique on a single computer.
#### Ensure (Mandatory)
Indicates whether the scheduled job should be present or absent.
#### FilePath 
Path to a PowerShell file for this job to run.
Each cScheduledJob must have one FilePath OR one ScriptBlock.
#### ScriptBlock 
PowerShell scriptblock for this job to run.
Each cScheduledJob must have one FilePath OR one ScriptBlock.
#### Enabled
Specifies whether this job is enabled or not.
#### Arguments
Hashtable containing arguments to pass to the script. 
This is equivalent to the Register-ScheduledJob's ArgumentList parameter, but ArgumentList is not a valid name for a DSC property.
#### Authentication
Method used to authenticate credentials.
#### Credential
Credential to run the job under.
#### InitializationScript
Script to initialize the session before running the primary script. 
If the initialization script generates any kind of error, the primary script will not be run.
#### MaxResultCount
The number of job results that are retained for this job.
#### RunAs32
Specifies whether to run this job in a 32-bit process.
### ContinueIfGoingOnBattery
Specifies whether to continue the job if the computer switches to battery power.
### DoNotAllowDemandStart
Start the job only when it is triggered. Users cannot start the job manually.
### HideInTaskScheduler
Do not display the job in Task Scheduler.
### IdleDuration
Specifies how long the computer must be idle before the job starts.
### IdleTimeout
Specifies how long the scheduled job waits.
### MultipleInstancePolicy
Determines how the system responds to a request to start an instance of the job while another instances is running.
### RequireNetwork
Runs the job only when network connections are available.
### RestartOnIdleResume
Restarts a job when the computer becomes idle.
### RunElevated
Run the job as an administrator.
### StartIfIdle
Only start the job if the computer has been idle for the period specified in IdleDuration.
### StartIfOnBattery
Allow the job to start if the computer is running on battery.
### StopIfGoingOffIdle
Suspend the running job if the computer becomes active.
### WakeToRun
Wake the computer to run the job.
#### Trigger
Specifies one or more triggers for this job.
