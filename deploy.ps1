Login-AzureRmAccount 
Select-AzureRmSubscription -SubscriptionName "Demo"

$rgName = "GAB17"
$regKey = ConvertTo-SecureString -AsPlainText -Force -String "dqRmXOxmJ9JPpkxQsdMhO3RowSGWnxw/T1kmE0oebRWEZrBzJ4/0XeePNoa4HeBYrrqyG1gkEciO0OdKN9M8wQ=="
New-AzureRmResourceGroup -Name $rgName -Location "West Europe"
New-AzureRmResourceGroupDeployment -Name "dc5-1" -ResourceGroupName $rgName -TemplateParameterFile C:\temp\azvm\parameters-dc5.json -TemplateFile C:\temp\azvm\template.json -timeStamp (Get-Date) -registrationKey $regKey

#Cleanup
#Remove-AzureRmResourceGroup -Name $rgName