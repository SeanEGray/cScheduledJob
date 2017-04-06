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
			$this.Ensure = [Ensure]::Present
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.count -gt 0) {
				Write-Verbose 'This is a FilePath job.'
				$this.FilePath = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.value
			}
			else {
				Write-Verbose 'This is a ScriptBlock job.'
				$this.ScriptBlock = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ScriptBlock'}.value
			}
			Write-Verbose 'Checking whether job is enabled.'
			$this.Enabled = $job.Enabled
			Write-Verbose 'Checking whether job has an argument list.'
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.count -gt 0) {
				Write-Verbose 'Job does have an argument list.'
				$this.ArgumentList = InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value
			}
			Write-Verbose 'Checking authentication method.'
			$this.Authentication = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'Authentication'}.value
			Write-Verbose 'Checking credential that job runs under.'
			$this.Credential = $job.Credential
			Write-Verbose 'Checking whether job has an initialization script.'
			if ($job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.count -gt 0) {
				Write-Verbose 'Job does have an initialization script.'
				$this.InitializationScript = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.value
			}
			Write-Verbose 'Checking max result count.'
			$this.MaxResultCount = $job.ExecutionHistoryLength
			Write-Verbose 'Checking whether job runs as a 32-bit process.'
			$this.RunAs32 = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'RunAs32'}.value
		}
		else {
			Write-Verbose 'Job not found.'
			$this.Ensure = [Ensure]::Absent
		}
		return $this
	}

	[bool] Test () {
		Write-Verbose "Testing for Scheduled Job: $($this.Name)."
		$job = Get-ScheduledJob -Name $this.Name -ErrorAction Ignore
		if ($job.Count -eq 1) {
			if ($this.Ensure -eq [Ensure]::Absent) {
				Write-Verbose 'Job should not exist.'
				return $false
			}
			else {
				Write-Verbose 'Job should exist. Checking settings.'
				if ($this.FilePath -and -not $this.ScriptBlock) {
					Write-Verbose 'Job is a FilePath job.'
					if ($this.FilePath -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.value) {
						Write-Verbose 'FilePath does not match.'
						return $false
					}
				}
				elseif ($this.ScriptBlock -and -not $this.FilePath) {
					Write-Verbose 'Job is a ScriptBlock job.'
					if ($this.ScriptBlock -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ScriptBlock'}.value) {
						Write-Verbose 'ScriptBlock does not match.'
						return $false
					}
				}
				else {
					Write-Verbose 'Job either does not specify a FilePath, does not specify a ScriptBlock, or specifies both.'
					throw 'A Scheduled Job must have a FilePath OR a ScriptBlock. It must not have both.'
				}
				if ($null -ne $this.Enabled -and $this.Enabled -ne $job.Enabled) {
					Write-Verbose 'Enabled does not match.'
					return $false
				}
				if ($this.ArgumentList -and $this.ArgumentList -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value) {
					# THIS BLATANTLY ISN'T GOING TO WORK. FIXME.
					Write-Verbose 'ArgumentList does not match.'
					return $false
				}
				if ($this.Authentication -and $this.Authentication -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'Authentication'}.value) {
					Write-Verbose 'Authentication does not match.'
					return $false
				}
				if ($this.Credential -and $this.Credential -ne $job.Credential) {
					# NOT CONVINCED THAT THIS WILL WORK. FIXME.
					Write-Verbose 'Credential does not match.'
					return $false
				}
				if ($this.InitializationScript -and $this.InitializationScript -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.value) {
					# Check what happens when you compare scriptblocks.
					Write-Verbose 'InitializationScript does not match.'
					return $false
				}
				if ($this.MaxResultCount -and $this.MaxResultCount -ne $job.ExecutionHistoryLength) {
					Write-Verbose 'MaxResultCount does not match.'
					return $false
				}
				if ($null -ne $this.RunAs32 -and $this.RunAs32 -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'RunAs32'}.value) {
					Write-Verbose 'RunAs32 does not match.'
					return $false
				}
			}
		}
		else {
			Write-Verbose 'Job not found.'
			if ($this.Ensure -eq [Ensure]::Present) {
				Write-Verbose 'Job should exist.'
				return $false
			}
		}
		Write-Verbose 'No checks failed.'
		return $true
	}

	[void] Set () {
		Write-Verbose "Testing for Scheduled Job: $($this.Name)."
		$job = Get-ScheduledJob -Name $this.Name -ErrorAction Ignore
		if ($job.Count -eq 1) {
			if ($this.Ensure -eq [Ensure]::Absent) {
				Write-Verbose 'Removing job.'
				# We use force here to remove the job even if it's running. This may not be the correct behaviour in all situations; unsure what the best way to deal with this is.
				Unregister-ScheduledJob -Name $this.Name -Force
			}
			else {
				Write-Verbose 'Job exists. Checking settings.'
				$ParamSplat = @{}
				## DEAL WITH CHANGING FROM FILEPATH TO SCRIPTBLOCK
				if ($this.FilePath -and -not $this.ScriptBlock) {
					Write-Verbose 'Job is a FilePath job.'
					if ($this.FilePath -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.value) {
						Write-Verbose 'FilePath does not match.'
						## FIX FILEPATH
					}
				}
				elseif ($this.ScriptBlock -and -not $this.FilePath) {
					Write-Verbose 'Job is a ScriptBlock job.'
					if ($this.ScriptBlock -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ScriptBlock'}.value) {
						Write-Verbose 'ScriptBlock does not match.'
						## FIX SCRIPTBLOCK
					}
				}
				else {
					Write-Verbose 'Job either does not specify a FilePath, does not specify a ScriptBlock, or specifies both.'
					throw 'A Scheduled Job must have a FilePath OR a ScriptBlock. It must not have both.'
				}
				if ($null -ne $this.Enabled -and $this.Enabled -ne $job.Enabled) {
					if ($this.Enabled) {
						Write-Verbose 'Enabling job.'
						Enable-ScheduledJob -Name $this.Name
					}
					else {
						Write-Verbose 'Disabling job.'
						Disable-ScheduledJob -Name $this.Name 
					}
				}
				if ($this.ArgumentList -and $this.ArgumentList -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value) {
					# THIS BLATANTLY ISN'T GOING TO WORK. FIXME.
					Write-Verbose 'Setting ArgumentList.'
					$ParamSplat.Add('ArgumentList', $this.ArgumentList)
				}
				if ($this.Authentication -and $this.Authentication -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'Authentication'}.value) {
					Write-Verbose 'Setting Authentication method.'
					$ParamSplat.Add('Authentication', $this.Authentication)
				}
				if ($this.Credential -and $this.Credential -ne $job.Credential) {
					# NOT CONVINCED THAT THIS WILL WORK. FIXME.
					Write-Verbose 'Setting Credential.'
					$ParamSplat.Add('Credential',$this.Credential)
				}
				if ($this.InitializationScript -and $this.InitializationScript -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'InitializationScript'}.value) {
					# Check what happens when you compare scriptblocks.
					Write-Verbose 'Setting InitializationScript.'
					$ParamSplat.Add('InitializationScript',$this.InitializationScript)
				}
				if ($this.MaxResultCount -and $this.MaxResultCount -ne $job.ExecutionHistoryLength) {
					Write-Verbose 'Setting MaxResultCount.'
					$ParamSplat.Add('MaxResultCount', $this.MaxResultCount)
				}
				if ($null -ne $this.RunAs32 -and $this.RunAs32 -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'RunAs32'}.value) {
					Write-Verbose 'Setting RunAs32.'
					$ParamSplat.Add('RunAs32',$this.RunAs32)
				}
				if ($ParamSplat.Count -gt 0) {
					Get-ScheduledJob -Name $this.Name | Set-ScheduledJob @ParamSplat
				}
			}
		}
		else {
			Write-Verbose 'Job not found.'
			if ($this.Ensure -eq [Ensure]::Present) {
				Write-Verbose 'Creating job.'
				$ParamSplat = @{Name = $this.Name}
				if ($this.FilePath -and -not $this.ScriptBlock) {
					$ParamSplat.Add('FilePath', $this.FilePath)
				}
				elseif ($this.ScriptBlock -and -not $this.FilePath) {
					$ParamSplat.Add('ScriptBlock', $this.ScriptBlock)
				}
				else {
					Write-Verbose 'Job either does not specify a FilePath, does not specify a ScriptBlock, or specifies both.'
					throw 'A Scheduled Job must have a FilePath OR a ScriptBlock. It must not have both.'
				}
				if ($this.ArgumentList) {
					$ParamSplat.Add('ArgumentList', $this.ArgumentList)
				}
				if ($this.Authentication) {
					$ParamSplat.Add('Authentication', $this.Authentication)
				}
				if ($this.Credential) {
					$ParamSplat.Add('Credential', $this.Credential)
				}
				if ($this.InitializationScript) {
					$ParamSplat.Add('InitializationScript', $this.InitializationScript)
				}
				if ($this.MaxResultCount) {
					$ParamSplat.Add('MaxResultCount', $this.MaxResultCount)
				}
				if ($null -ne $this.RunAs32) {
					$ParamSplat.Add('RunAs32', $this.RunAs32)
				}
				Register-ScheduledJob @ParamSplat 

				if ($null -ne $this.Enabled -and $this.Enabled -eq $false) {
					Write-Verbose 'Disabling job.'
					Disable-ScheduledJob -Name $this.Name
				}
			}
		}
	}

}