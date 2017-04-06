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
#### Argumentlist
Hashtable containing arguments to pass to the script. 
#### Authentication
Method used to authenticate credentials.
#### Credential
Credential to run the job under.
#### InitializationScript
Script to initialize the session before running the primary script. If the initialization script generates any kind of error, the primary script will not be run.
#### MaxResultCount
The number of job results that are retained for this job.
#### RunAs32
Specifies whether to run this job in a 32-bit process.
#### ScheduledJobOption
Specifies additional options for this job.
#### Trigger
Specifies one or more triggers for this job.
