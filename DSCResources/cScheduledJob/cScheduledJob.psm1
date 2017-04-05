enum Ensure {
	Present
	Absent
}

enum Authentication {
	Default
	Basic
	Negotiate
	NegotiateWithImplicitCredential
	Credssp
	Digest
	Kerberos
}

[DscResource()]
class cScheduledJob {
	# Name of the scheduled job. Names must be unique on a single computer.
	[DscProperty(Key)]
	[String] $Name

	# Indicates whether the scheduled job should be present or absent.
	[DscProperty(Mandatory)]
	[Ensure] $Ensure

	# Path to a PowerShell file for this job to run.
	[DscProperty()]
	[String] $FilePath
	
	# PowerShell scriptblock for this job to run.
	[DscProperty()]
	[ScriptBlock] $ScriptBlock

	# Hashtable containing arguments to pass to the script. <-- Is this correct?
	[DscProperty()]
	[Object[]] $ArgumentList

	# Method used to authenticate credentials.
	[DscProperty()]
	[Authentication] $Authentication
	
	# Credential to run the job under.
	[DscProperty()]
	[PSCredential] $Credential
	
	# Script to initialize the session before running the primary script. If the initialization script generates any kind of error, the primary script will not be run.
	[DscProperty()]
	[ScriptBlock] $InitializationScript

	# The number of job results that are retained for this job.
	[DscProperty()]
	[Int32] $MaxResultCount

	# Specifies whether to run this job in a 32-bit process.
	[DscProperty()]
	[Bool] $RunAs32

	# Sets the job to repeat after a given timespan.
	[DscProperty()]
	[TimeSpan] $RunEvery

	# Runs the job immediately upon its creation.
	[DscProperty()]
	[Bool] $RunNow

	# Specifies additional options for this job.
	[DscProperty()]
	[cScheduledJobOption] $ScheduledJobOption

	# Specifies one or more triggers for this job.
	[DscProperty()]
	[cJobTrigger[]] $Trigger

	[cScheduledJob] Get () {

	}

	[bool] Test () {

	}

}