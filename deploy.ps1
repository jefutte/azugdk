#$cred = Get-Credential
#Login-AzureRmAccount -Credential $cred
#Select-AzureRmSubscription -SubscriptionName "Demo"

#******************
# Get Automation key and URL!
#******************


$rgName = "GAB2017"
$regKey = ConvertTo-SecureString -AsPlainText -Force -String "ybz5weMDXOdM2hTugyvMG8mV9HFk0KVQhXWHsHro0ogYbFLSN5pl4uwdOkGNznszmfgPjwNRMQgL2WlxpBj6+w=="
$regUrl = "https://we-agentservice-prod-1.azure-automation.net/accounts/ad9e2849-2e88-406c-87be-90b7719320de"
New-AzureRmResourceGroupDeployment `
                             -Name "GAB2017" `
                             -ResourceGroupName $rgName `
                             -TemplateParameterFile "C:\Users\jj\Documents\GitHub\azugdk\Template\azuredeploy.params.json" `
                             -TemplateFile "C:\Users\jj\Documents\GitHub\azugdk\Template\azuredeploy.json" `
                             -timeStamp (Get-Date) `
                             -registrationKey $regKey `
                             -registrationUrl $regUrl `
                             -vmName $computerName

#Cleanup
#Remove-AzureRmResourceGroup -Name $rgName