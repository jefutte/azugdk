$cred = Get-Credential
Login-AzureRmAccount -Credential $cred
Select-AzureRmSubscription -SubscriptionName "Demo"

#Variables
$rgName = "GAB2017"
$automationAccountName = "GAB2017"
$configPath = "C:\Users\jj\Documents\GitHub\azugdk\dsc\ReplicaDC.ps1"
$configName = "ReplicaDC"
$computerName = "dc6"
$domainName = "solvoittest.com"
$primaryDNS = "192.168.11.19"

#Upload and compile DSC configuration
Import-AzureRmAutomationDscConfiguration -SourcePath $configPath -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Published -Force

#Compile configuration
$Parameters = @{
    "computerName" = $computerName
    "domainName" = $domainName
    "primaryDNS" = $primaryDNS
}

$ConfigData = @{             
    AllNodes = @(             
        @{             
            NodeName = "localhost"
            PsDscAllowPlainTextPassword = $true            
        }
    )             
} 

$job = Start-AzureRmAutomationDscCompilationJob -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -ConfigurationName $configName -Parameters $Parameters -ConfigurationData $ConfigData
Get-AzureRmAutomationDscCompilationJob -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Id $job.Id