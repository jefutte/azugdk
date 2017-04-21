$cred = Get-Credential
Login-AzureRmAccount -Credential $cred
Select-AzureRmSubscription -SubscriptionName "Demo"

#Variables
$location = "West Europe"
$rgName = "GAB2017"
$automationAccountName = "GAB2017"
$xActiveDirectoryUrl = "https://www.powershellgallery.com/api/v2/package/xActiveDirectory/2.16.0.0"
$xComputerManagementUrl = "https://www.powershellgallery.com/api/v2/package/xComputerManagement/1.9.0.0"
$xRemoteDesktopAdminUrl = "https://www.powershellgallery.com/api/v2/package/xRemoteDesktopAdmin/1.1.0.0"
$xNetworkingUrl = "https://www.powershellgallery.com/api/v2/package/xNetworking/3.2.0.0"
$xStorageUrl = "https://www.powershellgallery.com/api/v2/package/xStorage/2.9.0.0"

#Resource -ResourceGroupName
New-AzureRmResourceGroup -Name $rgName -Location $location

#Automation Account
$automationAccount = New-AzureRmAutomationAccount -ResourceGroupName $rgName -Name $automationAccountName -Location $location

#Automation Credentials
$domainCred = Get-Credential -UserName "solvoittest\jj" -Message "pw"
New-AzureRmAutomationCredential -Name "domainAdmin" -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Value $domainCred
$safeModePassword = Get-Credential -UserName "safemodepw" -Message "pw"
New-AzureRmAutomationCredential -Name "safemodeAdministratorCred" -ResourceGroupName $rgName -AutomationAccountName $automationAccountName -Value $safeModePassword

#Automation Modules
New-AzureRmAutomationModule -Name xActiveDirectory -ContentLink $xActiveDirectoryUrl -ResourceGroupName $rgName -AutomationAccountName $automationAccountName 
New-AzureRmAutomationModule -Name xComputerManagement -ContentLink $xComputerManagementUrl -ResourceGroupName $rgName -AutomationAccountName $automationAccountName
New-AzureRmAutomationModule -Name xRemoteDesktopAdmin -ContentLink $xRemoteDesktopAdminUrl -ResourceGroupName $rgName -AutomationAccountName $automationAccountName
New-AzureRmAutomationModule -Name xNetworking -ContentLink $xNetworkingUrl -ResourceGroupName $rgName -AutomationAccountName $automationAccountName
New-AzureRmAutomationModule -Name xStorage -ContentLink $xStorageUrl -ResourceGroupName $rgName -AutomationAccountName $automationAccountName

#Cleanup
#Remove-AzureRmResourceGroup -Name $rgName