#Create Resource Group
New-AzureRmResourceGroup -Name "rg-tfbackend" -Location "uksouth"
  
#Create Storage Account
New-AzureRmStorageAccount -ResourceGroupName "rg-tfbackend" -AccountName "tfbackendsa" -Location uksouth -SkuName Standard_LRS
  
#Create Storage Container
New-AzureRmStorageContainer -ResourceGroupName "rg-tfbackend" -AccountName "tfbackendsa" -ContainerName "tfstatedevops"