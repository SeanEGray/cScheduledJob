Describe 'Get' {
	BeforeAll {
		#Create jobs
	}
	It 'Correctly retrieve FilePath job' {

	}
	It 'Correctly retrieve ScriptBlock job' {

	}
	It 'Correctly retrieve job with Arguments' {

	}
	It 'Correctly retrieve job with InitializationScript' {

	}
	It 'Correctly report non-existent job' {

	}
	AfterAll {
		#Remove jobs
	}
}

Describe 'Test' {
	BeforeAll {
		#Create jobs
	}
	It 'Return false for job that should not exist but does' {

	}
	It 'Return false for job that should exist but does not' {

	}
	It 'Return false for FilePath not matching' {

	}
	It 'Return false for Enabled not matching' {

	}
	It 'Return false for Arguments not matching' {

	}
	It 'Return false for Credential not matching' {

	}
	It 'Return false for InitializationScript not matching' {

	}
	It 'Return false for MaxResultCount not matching' {

	}
	It 'Return false for RunAs32 not matching' {

	}
	It 'Throw if FilePath and ScriptBlock are both specified' {

	}
	It 'Throw if neither FilePath nor ScriptBlock are specified' {

	}
	It 'Return false for ScriptBlock not matching' {

	}
	It 'Return true for FilePath job that is correct' {

	}
	It 'Return true for ScriptPath job that is correct' {

	}
	It 'Return true for job that matches all optional parameters' {

	}
	It 'Return true for job that should not exist and does not' {

	}
	AfterAll {
		#Remove jobs
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