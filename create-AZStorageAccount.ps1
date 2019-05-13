param(
    [Parameter(Mandatory=$true)]
    $Name,
    [Parameter(Mandatory=$true)]
    [validatescript({(get-azlocation).location -contains $_})]
    $location,
    [Parameter(Mandatory=$true)]
    $ResourceGroupName,
    [validateset("Storage","StorageV2","BlobStorage","BlockBlobStorage")]
    $kind="StorageV2",
    [ValidateSet("Standard_LRS","Standard_GRS","Standard_RAGRS","Standard_ZRS","Premium_LRS")]
    $skuname="Standard_LRS",
    [switch]$createResourceGroup,
    [switch]$EnableHttpsTrafficOnly
)
<#
Storage types:
Standard_LRS. Locally-redundant storage.
Standard_ZRS. Zone-redundant storage.
Standard_GRS. Geo-redundant storage.
Standard_RAGRS. Read access geo-redundant storage.
Premium_LRS. Premium locally-redundant storage.
#>
begin {
    if($createResourceGroup){New-AzResourceGroup -Name $resourceGroup -Location $location -ErrorAction Stop}    
}
process {
    try
    {
        if($EnableHttpsTrafficOnly){New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $name -kind $kind -skuname $skuname -EnableHttpsTrafficOnly}
        else{New-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $name -kind $kind -skuname $skuname}
    }Catch{Write-error $_}
}


