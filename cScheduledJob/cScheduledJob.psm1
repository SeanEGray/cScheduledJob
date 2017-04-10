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

enum MultipleInstancePolicy {
	IgnoreNew
	Parallel
	Queue
	StopExisting
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
	[String] $ScriptBlock

	# Specifies whether this job is enabled or not.
	[Bool] $Enabled

	# Hashtable containing arguments to pass to the script. <-- Is this correct?
	[DscProperty()]
	[Hashtable] $Arguments

	# Method used to authenticate credentials.
	[DscProperty()]
	[Authentication] $Authentication
	
	# Credential to run the job under.
	[DscProperty()]
	[PSCredential] $Credential
	
	# Script to initialize the session before running the primary script. If the initialization script generates any kind of error, the primary script will not be run.
	[DscProperty()]
	[String] $InitializationScript

	# The number of job results that are retained for this job.
	[DscProperty()]
	[Int32] $MaxResultCount

	# Specifies whether to run this job in a 32-bit process.
	[DscProperty()]
	[Bool] $RunAs32

	# Specifies whether to continue the job if the computer switches to battery power.
	[DscProperty()]
	[bool] $ContinueIfGoingOnBattery

	# Start the job only when it is triggered. Users cannot start the job manually.
	[DscProperty()]
	[bool] $DoNotAllowDemandStart

	# Do not display the job in Task Scheduler.
	[DscProperty()]
	[bool] $HideInTaskScheduler

	# Specifies how long the computer must be idle before the job starts.
	[DscProperty()]
	[String] $IdleDuration

	# Specifies how long the scheduled job waits.
	[DscProperty()]
	[String] $IdleTimeout

	# Determines how the system responds to a request to start an instance of the job while another instances is running.
	[DscProperty()]
	[MultipleInstancePolicy] $MultipleInstancePolicy

	# Runs the job only when network connections are available.
	[DscProperty()]
	[bool] $RequireNetwork

	# Restarts a job when the computer becomes idle.
	[DscProperty()]
	[bool] $RestartOnIdleResume

	# Run the job as an administrator.
	[DscProperty()]
	[bool] $RunElevated

	# Only start the job if the computer has been idle for the period specified in IdleDuration.
	[DscProperty()]
	[bool] $StartIfIdle
	
	# Allow the job to start if the computer is running on battery.
	[DscProperty()]
	[bool] $StartIfOnBattery

	# Suspend the running job if the computer becomes active.
	[DscProperty()]
	[bool] $StopIfGoingOffIdle

	# Wake the computer to run the job.
	[DscProperty()]
	[bool] $WakeToRun

	<# 
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
				$this.Arguments = $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value
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
			Write-Verbose 'Checking whether job will run on battery.'
			$this.StartIfOnBattery = $job.Options.StartIfOnBatteries
			Write-Verbose 'Checking whether job will continue when switching to battery.'
			$this.ContinueIfGoingOnBattery = -not $job.Options.StopIfGoingOnBatteries
			Write-Verbose 'Checking whether job will wake the computer to run.'
			$this.WakeToRun = $job.Options.WakeToRun
			Write-Verbose 'Checking whether job will wait for computer to be idle before starting.'
			$this.StartIfIdle = -not $job.Options.StartIfNotIdle
			Write-Verbose 'Checking whether job will stop if computer stops being idle.'
			$this.StopIfGoingOffIdle = $job.Options.StopIfGoingOffIdle
			Write-Verbose 'Checking whether job will restart when the computer is idle again.'
			$this.RestartOnIdleResume = $job.Options.RestartOnIdleResume
			Write-Verbose 'Checking how long computer must idle before starting job.'
			$this.IdleDuration = $job.Options.IdleDuration.ToString()
			Write-Verbose 'Checking how long computer will wait to become idle.'
			$this.IdleTimeout = $job.Options.IdleTimeout.ToString()
			Write-Verbose 'Checking whether this job should be hidden in task scheduler.'
			$this.HideInTaskScheduler = -not $job.Options.ShowInTaskScheduler
			Write-Verbose 'Checking whether this job should run elevated.'
			$this.RunElevated = $job.Options.RunElevated
			Write-Verbose 'Checking whether this job can run without network access.'
			$this.RequireNetwork = -not $job.Options.RunWithoutNetwork
			Write-Verbose 'Checking whether this job can run on demand.'
			$this.DoNotAllowDemandStart = $job.Options.DoNotAllowDemandStart
			Write-Verbose "Checking this job's multiple instance policy."
			$this.MultipleInstancePolicy = $job.Options.MultipleInstancePolicy
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
				if ($this.Arguments -and $this.Arguments -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value) {
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
				if ($null -ne $this.ContinueIfGoingOnBattery -and $this.ContinueIfGoingOnBattery -ne -not $job.Options.StopIfGoingOnBatteries) {
					Write-Verbose 'ContinueIfGoingOnBattery does not match.'
					return $false
				}
				if ($null -ne $this.DoNotAllowDemandStart -and $this.DoNotAllowDemandStart -ne $job.Options.DoNotAllowDemandStart) {
					Write-Verbose 'DoNotAllowDemandStart does not match.'
					return $false
				}
				if ($null -ne $this.HideInTaskScheduler -and $this.HideInTaskScheduler -ne -not $job.Options.ShowInTaskScheduler) {
					Write-Verbose 'HideInTaskScheduler does not match.'
					return $false
				}
				if ($this.IdleDuration -and $this.IdleDuration -ne $job.Options.IdleDuration.ToString()) {
					Write-Verbose 'IdleDuration does not match.'
					return $false
				}
				if ($this.IdleTimeout -and $this.IdleTimeout -ne $job.Options.IdleTimeout.ToString()) {
					Write-Verbose 'IdleTimeout does not match.'
					return $false
				}
				if ($this.MultipleInstancePolicy -and $this.MultipleInstancePolicy -ne $job.Options.MultipleInstancePolicy) {
					Write-Verbose 'MultipleInstancePolicy does not match.'
					return $false
				}
				if ($null -ne $this.RequireNetwork -and $this.RequireNetwork -ne -not $job.Options.RunWithoutNetwork) {
					Write-Verbose 'RequireNetwork does not match.'
					return $false
				}
				if ($null -ne $this.RestartOnIdleResume -and $this.RestartOnIdleResume -ne $job.Options.RestartOnIdleResume) {
					Write-Verbose 'RestartOnIdleResume does not match.'
					return $false
				}
				if ($null -ne $this.RunElevated -and $this.RunElevated -ne $job.Options.RunElevated) {
					Write-Verbose 'RunElevated does not match.'
					return $false
				}
				if ($null -ne $this.StartIfIdle -and $this.StartIfIdle -ne -not $job.Options.StartIfNotIdle) {
					Write-Verbose 'StartIfIdle does not match.'
					return $false
				}
				if ($null -ne $this.StartIfOnBattery -and $this.StartIfOnBattery -ne $job.Options.StartIfOnBatteries) {
					Write-Verbose 'StartIfOnBattery does not match.'
					return $false
				}
				if ($null -ne $this.StopIfGoingOffIdle -and $this.StopIfGoingOffIdle -ne $job.Options.StopIfGoingOffIdle) {
					Write-Verbose 'StopIfGoingOffIdle does not match.'
					return $false
				}
				if ($null -ne $this.WakeToRun -and $this.WakeToRun -ne $job.Options.WakeToRun) {
					Write-Verbose 'WakeToRun does not match.'
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
				$OptionSplat = @{}
				$ParamSplat = @{}
				## DEAL WITH CHANGING FROM FILEPATH TO SCRIPTBLOCK (and vice versa (does it handle this automatically?)
				if ($this.FilePath -and -not $this.ScriptBlock) {
					Write-Verbose 'Job is a FilePath job.'
					if ($this.FilePath -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'FilePath'}.value) {
						Write-Verbose 'FilePath does not match.'
						$ParamSplat.Add('FilePath', $this.FilePath)
					}
				}
				elseif ($this.ScriptBlock -and -not $this.FilePath) {
					Write-Verbose 'Job is a ScriptBlock job.'
					if ($this.ScriptBlock -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ScriptBlock'}.value) {
						Write-Verbose 'ScriptBlock does not match.'
						$ParamSplat.Add('ScriptBlock', $this.ScriptBlock)
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
				if ($this.Arguments -and $this.Arguments -ne $job.InvocationInfo.Parameters[0].where{$_.name -eq 'ArgumentList'}.value) {
					# THIS BLATANTLY ISN'T GOING TO WORK. FIXME.
					Write-Verbose 'Setting ArgumentList.'
					$ParamSplat.Add('ArgumentList', $this.Arguments)
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
				# NB: If we set any options, we must set ALL SPECIFIED options, to avoid overwriting correct settings
				# This is why we just overwrite options automatically in this case.
				# Could probably tidy this up with a helper function.
				if ($null -ne $this.ContinueIfGoingOnBattery) {
					$OptionSplat.Add('ContinueIfGoingOnBattery', $this.ContinueIfGoingOnBattery)
				}
				if ($null -ne $this.DoNotAllowDemandStart) {
					$OptionSplat.Add('DoNotAllowDemandStart', $this.DoNotAllowDemandStart)
				}
				if ($null -ne $this.HideInTaskScheduler) {
					$OptionSplat.Add('HideInTaskScheduler', $this.HideInTaskScheduler)
				}
				if ($this.IdleDuration) {
					$OptionSplat.Add('IdleDuration', $this.IdleDuration)
				}
				if ($this.IdleTimeout) {
					$OptionSplat.Add('IdleTimeout', $this.IdleTimeout)
				}
				if ($this.MultipleInstancePolicy) {
					$OptionSplat.Add('MultipleInstancePolicy', $this.MultipleInstancePolicy)
				}
				if ($null -ne $this.WakeToRun) {
					$OptionSplat.Add('WakeToRun', $this.WakeToRun)
				}
				if ($null -ne $this.RequireNetwork) {
					$OptionSplat.Add('RequireNetwork', $this.RequireNetwork)
				}
				if ($null -ne $this.RestartOnIdleResume) {
					$OptionSplat.Add('RestartOnIdleResume', $this.RestartOnIdleResume)
				}
				if ($null -ne $this.RunElevated) {
					$OptionSplat.Add('RunElevated', $this.RunElevated)
				}
				if ($null -ne $this.StartIfIdle) {
					$OptionSplat.Add('StartIfIdle', $this.StartIfIdle)
				}
				if ($null -ne $this.StartIfOnBattery) {
					$OptionSplat.Add('StartIfOnBattery', $this.StartIfOnBattery)
				}
				if ($null -ne $this.StopIfGoingOffIdle) {
					$OptionSplat.Add('StopIfGoingOffIdle', $this.StopIfGoingOffIdle)
				}
				if ($OptionSplat.Count -gt 0) {
					$ParamSplat.Add('ScheduledJobOption', (New-ScheduledJobOption @OptionSplat))
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
				$OptionSplat = @{}
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
				if ($this.Arguments) {
					$ParamSplat.Add('ArgumentList', $this.Arguments)
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
				if ($null -ne $this.ContinueIfGoingOnBattery) {
					$OptionSplat.Add('ContinueIfGoingOnBattery', $this.ContinueIfGoingOnBattery)
				}
				if ($null -ne $this.DoNotAllowDemandStart) {
					$OptionSplat.Add('DoNotAllowDemandStart', $this.DoNotAllowDemandStart)
				}
				if ($null -ne $this.HideInTaskScheduler) {
					$OptionSplat.Add('HideInTaskScheduler', $this.HideInTaskScheduler)
				}
				if ($this.IdleDuration) {
					$OptionSplat.Add('IdleDuration', $this.IdleDuration)
				}
				if ($this.IdleTimeout) {
					$OptionSplat.Add('IdleTimeout', $this.IdleTimeout)
				}
				if ($this.MultipleInstancePolicy) {
					$OptionSplat.Add('MultipleInstancePolicy', $this.MultipleInstancePolicy)
				}
				if ($null -ne $this.WakeToRun) {
					$OptionSplat.Add('WakeToRun', $this.WakeToRun)
				}
				if ($null -ne $this.RequireNetwork) {
					$OptionSplat.Add('RequireNetwork', $this.RequireNetwork)
				}
				if ($null -ne $this.RestartOnIdleResume) {
					$OptionSplat.Add('RestartOnIdleResume', $this.RestartOnIdleResume)
				}
				if ($null -ne $this.RunElevated) {
					$OptionSplat.Add('RunElevated', $this.RunElevated)
				}
				if ($null -ne $this.StartIfIdle) {
					$OptionSplat.Add('StartIfIdle', $this.StartIfIdle)
				}
				if ($null -ne $this.StartIfOnBattery) {
					$OptionSplat.Add('StartIfOnBattery', $this.StartIfOnBattery)
				}
				if ($null -ne $this.StopIfGoingOffIdle) {
					$OptionSplat.Add('StopIfGoingOffIdle', $this.StopIfGoingOffIdle)
				}
				if ($OptionSplat.Count -gt 0) {
					$ParamSplat.Add('ScheduledJobOption', (New-ScheduledJobOption @OptionSplat))
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

