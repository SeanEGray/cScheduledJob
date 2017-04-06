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

	# Specifies whether this job is enabled or not.
	[Bool] $Enabled

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

	<# 
	# Specifies additional options for this job.
	[DscProperty()]
	[cScheduledJobOption] $ScheduledJobOption

	# Specifies one or more triggers for this job.
	[DscProperty()]
	[cJobTrigger[]] $Trigger
	#>
	[cScheduledJob] Get () {
		Write-Verbose "Retrieving Scheduled Job: $($this.Name)."
		$job = Get-ScheduledJob -Name $this.Name -ErrorAction Ignore
		if ($job.Count -eq 1) {
			Write-Verbose 'Job found. Checking whether it has a FilePath or a ScriptBlock.'
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.count -gt 0) {
				Write-Verbose 'This is a FilePath job.'
				$this.FilePath = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.value
			}
			else {
				Write-Verbose 'This is a ScriptBlock job.'
				$this.ScriptBlock = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ScriptBlock'}.value
			}
			Write-Verbose 'Retrieving other properties.'
			$this.Enabled = $job.Enabled
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.count -gt 0) {
				$this.ArgumentList = InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value
			}
			$this.Authentication = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'Authentication'}.value
			$this.Credential = $job.Credential
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.count -gt 0) {
				$this.InitializationScript = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.value
			}
			$this.MaxResultCount = $job.ExecutionHistoryLength
			$this.RunAs32 = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'RunAs32'}.value
		}
		else {
			Write-Verbose 'Job not found.'
			$this.Ensure = [Ensure]::Absent
		}
		return $this
	}

	[bool] Test () {

	}

	[void] Set () {

	}

}