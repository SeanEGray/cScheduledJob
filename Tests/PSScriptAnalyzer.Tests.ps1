<# 
	Run everything through PSScriptAnalyzer
#>

$Rules   = Get-ScriptAnalyzerRule
$PSFiles = Get-ChildItem "$PSScriptRoot\DSCResources\" -Filter '*.psm1' -Recurse

foreach ($PSFile in $PSFiles) {
	Describe $PSFile {
		foreach ($Rule in $Rules) {
			It "passes the PSScriptAnalyzer Rule $Rule" {
				(Invoke-ScriptAnalyzer -Path $PSFile.FullName -IncludeRule $rule.RuleName).Count | Should Be 0
            }
        }
    }
}
