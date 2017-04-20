Using module ..\cScheduledJob.psm1

Describe 'Get' {
	BeforeAll {
		$TestScript = 'Testdrive:\TestScript.ps1'
		$TestSB = {Write-Ouput 'Test'}
		New-Item -Path $TestScript
		Register-ScheduledJob -FilePath $TestScript -Name 'FilePathJob'
		Register-ScheduledJob -ScriptBlock $TestSB -Name 'ScriptBlockJob'
	}
	It 'Correctly retrieve FilePath job' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Get()
		$job.Name | Should Be 'FilePathJob'
		$job.Ensure | Should Be 'Present'
		$job.Enabled | Should Be $true
		$job.Authentication | Should Be 'Default'
		$job.MaxResultCount | Should Be 32
		$job.RunAs32 | Should Be $false
		$job.StartIfOnBattery | Should Be $false
		$job.ContinueIfGoingOnBattery | Should Be $false
		$job.WakeToRun | Should Be $false
		$job.StartIfIdle | Should Be $false
		$job.StopIfGoingOffIdle | Should Be $false
		$job.RestartOnIdleResume | Should Be $false
		$job.IdleDuration | Should Be '00:10:00'
		$job.IdleTimeout | Should Be '01:00:00'
		$job.HideInTaskScheduler | Should Be $false
		$job.RunElevated | Should Be $false
		$job.RequireNetwork | Should Be $false
		$job.DoNotAllowDemandStart | Should Be $false
		$job.MultipleInstancePolicy | Should Be 'IgnoreNew'
	}
	It 'Correctly retrieve ScriptBlock job' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'ScriptBlockJob'
		$job.Get()
		$job.Name | Should Be 'ScriptBlockJob'
		$job.Ensure | Should Be 'Present'
		$job.Enabled | Should Be $true
		$job.Authentication | Should Be 'Default'
		$job.MaxResultCount | Should Be 32
		$job.RunAs32 | Should Be $false
		$job.StartIfOnBattery | Should Be $false
		$job.ContinueIfGoingOnBattery | Should Be $false
		$job.WakeToRun | Should Be $false
		$job.StartIfIdle | Should Be $false
		$job.StopIfGoingOffIdle | Should Be $false
		$job.RestartOnIdleResume | Should Be $false
		$job.IdleDuration | Should Be '00:10:00'
		$job.IdleTimeout | Should Be '01:00:00'
		$job.HideInTaskScheduler | Should Be $false
		$job.RunElevated | Should Be $false
		$job.RequireNetwork | Should Be $false
		$job.DoNotAllowDemandStart | Should Be $false
		$job.MultipleInstancePolicy | Should Be 'IgnoreNew'
	}
	It 'Correctly retrieve job with Arguments' {

	}
	It 'Correctly retrieve job with InitializationScript' {

	}
	It 'Correctly report non-existent job' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'DoesNotExist'
		$job.Get()
		$job.Ensure | Should Be 'Absent'
	}
	AfterAll {
		Get-ScheduledJob -Name 'FilePathJob','ScriptBlockJob' | Unregister-ScheduledJob -Force
	}
}

Describe 'Test' {
	BeforeAll {
		$TestScript = 'Testdrive:\TestScript.ps1'
		$TestSB = {Write-Ouput 'Test'}
		New-Item -Path $TestScript
		Register-ScheduledJob -FilePath $TestScript -Name 'FilePathJob'
		Register-ScheduledJob -ScriptBlock $TestSB -Name 'ScriptBlockJob'
	}
	It 'Return false for job that should not exist but does' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Absent'
		$job.Test() | Should Be $false
	}
	It 'Return false for job that should exist but does not' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'DoesNotExist'
		$job.Ensure = 'Present'
		$job.Test() | Should Be $false
	}
	It 'Return false for FilePath not matching' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.FilePath = 'DoesNotMatch'
		$job.Test() | Should Be $false
	}
	It 'Return false for Enabled not matching' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.Enabled = $false
		$job.Test() | Should Be $false
	}
	It 'Return false for Arguments not matching' {

	}
	It 'Return false for Credential not matching' {

	}
	It 'Return false for InitializationScript not matching' {

	}
	It 'Return false for MaxResultCount not matching' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.MaxResultCount = 42
		$job.Test() | Should Be $false
	}
	It 'Return false for RunAs32 not matching' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.RunAs32 = $true
		$job.Test() | Should Be $false
	}
	It 'Throw if FilePath and ScriptBlock are both specified' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.FilePath = $TestScript
		$job.ScriptBlock = $TestSB
		{$job.Test()} | Should Throw
	}
	It 'Throw if neither FilePath nor ScriptBlock are specified' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		{$job.Test()} | Should Throw
	}
	It 'Return false for ScriptBlock not matching' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'ScriptBlockJob'
		$job.Ensure = 'Present'
		$job.ScriptBlock = 'DoesNotMatch'
		$job.Test() | Should Be $false
	}
	It 'Return true for FilePath job that is correct' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'FilePathJob'
		$job.Ensure = 'Present'
		$job.FilePath = $TestScript
		$job.Test() | Should Be $true
	}
	It 'Return true for ScriptPath job that is correct' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'ScriptBlockJob'
		$job.Ensure = 'Present'
		$job.ScriptBlock = $TestSB
		$job.Test() | Should Be $true
	}
	It 'Return true for job that matches all optional parameters' {

	}
	It 'Return true for job that should not exist and does not' {
		$job = New-Object -TypeName cScheduledJob
		$job.Name = 'DoesNotExist'
		$job.Ensure = 'Absent'
		$job.Test() | Should Be $true
	}
	AfterAll {
		Get-ScheduledJob -Name 'FilePathJob','ScriptBlockJob' | Unregister-ScheduledJob -Force
	}
}

Describe 'Set' {
	BeforeAll {
		#Create jobs
	}
	It 'Create new FilePath job' {

	}
	It 'Create new ScriptBlock job' {

	}
	It 'Throw if FilePath and ScriptBlock are both specified' {

	}
	It 'Throw if neither FilePath nor ScriptBlock are specified' {

	}
	It 'Create job with Arguments' {

	}
	It 'Create job with Authentication' {

	}
	It 'Create job with Credential' {

	}
	It 'Create job with InitializationScript' {

	}
	It 'Create job with MaxResultCount' {

	}
	It 'Create job with RunAs32' {

	}
	It 'Create job Enabled' {

	}
	It 'Create job Disabled' {

	}
	It 'Set FilePath' {

	}
	It 'Set ScriptBlock' {

	}
	It 'Change FilePath to ScriptBlock' {

	}
	It 'Change ScriptBlock to FilePath' {

	}
	It 'Enable job' {

	}
	It 'Disable job' {

	}
	It 'Set Arguments' {

	}
	It 'Set Authentication' {

	}
	It 'Set Credential' {

	}
	It 'Set InitializationScript' {

	}
	It 'Set MaxResultCount' {

	}
	It 'Set RunAs32' {

	}
	It 'Remove job' {

	}
	AfterAll {
		#Remove jobs
	}
}