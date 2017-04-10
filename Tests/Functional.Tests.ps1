Describe 'Get' {
	BeforeAll {
		$TestScript = 'Testdrive:\TestScript.ps1'
		$TestSB = {Write-Ouput 'Test'}
		New-Item -Path $TestScript
		Register-ScheduledJob -FilePath $TestScript -Name 'FilePathJob'
		Register-ScheduledJob -ScriptBlock $TestSB -Name 'ScriptBlockJob'
	}
	It 'Correctly retrieve FilePath job' {
		$job = Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Get -Property @{Name='FilePathJob'; Ensure='Present'}
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
		$job = Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Get -Property @{Name='ScriptBlockJob'; Ensure='Present'}
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
		$job = Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Get -Property @{Name='DoesNotExist'; Ensure='Present'}
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
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Absent'} | Should Be $false
	}
	It 'Return false for job that should exist but does not' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Get -Property @{Name='DoesNotExist'; Ensure='Present'} | Should Be $false
	}
	It 'Return false for FilePath not matching' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; FilePath='DoesNotMatch'} | Should Be $false
	}
	It 'Return false for Enabled not matching' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; Enabled=$false} | Should Be $false
	}
	It 'Return false for Arguments not matching' {

	}
	It 'Return false for Credential not matching' {

	}
	It 'Return false for InitializationScript not matching' {

	}
	It 'Return false for MaxResultCount not matching' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; MaxResultCount=42} | Should Be $false
	}
	It 'Return false for RunAs32 not matching' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; RunAs32=$true} | Should Be $false
	}
	It 'Throw if FilePath and ScriptBlock are both specified' {
		{Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; FilePath=$TestScript; ScriptBlock=$TestSB}} | Should Throw
	}
	It 'Throw if neither FilePath nor ScriptBlock are specified' {
		{Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; }} | Should Throw
	}
	It 'Return false for ScriptBlock not matching' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='ScriptBlockJob'; Ensure='Present'; ScriptBlock='DoesNotMatch'} | Should Be $false
	}
	It 'Return true for FilePath job that is correct' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; FilePath=$TestScript} | Should Be $true
	}
	It 'Return true for ScriptPath job that is correct' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='FilePathJob'; Ensure='Present'; ScriptBlock=$TestSB} | Should Be $true
	}
	It 'Return true for job that matches all optional parameters' {

	}
	It 'Return true for job that should not exist and does not' {
		Invoke-DscResource -Name cScheduledJob -ModuleName cScheduledJob -Method Test -Property @{Name='DoesNotExist'; Ensure='Absent'} | Should Be $true
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