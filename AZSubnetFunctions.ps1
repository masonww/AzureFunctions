function get-AZWMSubnetSecurity
{
    param(
        
        [Parameter(Mandatory=$true,HelpMessage="Enter Subscrption Name.")]
        [string]$SubscriptionName
    )
    Set-AzContext -Subscription $SubscriptionName
    $VNs=Get-AzVirtualNetwork
    $subnets=$vns|Get-AzVirtualNetworkSubnetConfig
    $output=@()
    foreach($subnet in $Subnets)
    {
        $item=[PSCustomObject]@{
            Name = $subnet.name
            AddressPrefix=$subnet.AddressPrefix
            ServiceEndpoints=$subnet.serviceendpoints.service -join ","
            NetworkSecurityGroup=$subnet.NetworkSecurityGroup.id -join ","
        }
        $output+= $item
    }
    $output
}


function Set-AZWMSubnetsEnableServiceEndpoints
{
    param(
        
        [Parameter(Mandatory=$true,HelpMessage="Enter Subscrption Name.")]
        [string]$SubscriptionName
    )
    Set-AzContext -Subscription $SubscriptionName
    $VNs=Get-AzVirtualNetwork
    foreach($VN in $VNs)
    {
        $subnets=$vn|Get-AzVirtualNetworkSubnetConfig
        $list=New-Object System.Collections.Generic.List[string]
        $list.add("Microsoft.AzureActiveDirectory")
        $list.add("Microsoft.AzureCosmosDB")
        $list.add("Microsoft.ContainerRegistry")
        $list.add("Microsoft.EventHub")
        $list.add("Microsoft.KeyVault")
        $list.add("Microsoft.ServiceBus")
        $list.add("Microsoft.Sql")
        $list.add("Microsoft.Storage")
        $list.add("Microsoft.Web")
        $c=0
        foreach($subnet in $Subnets)
        {
            $c++
            Write-Progress -Activity "Adding Service Endpoints to Subnets." -Status $subnet.Name -PercentComplete ($c/$subnets.count * 100)
            set-AzVirtualNetworkSubnetConfig -name $subnet.Name -VirtualNetwork $VN -AddressPrefix $subnet.AddressPrefix -ServiceEndpoint $list | Set-AzVirtualNetwork
            $c
        }
    }
    
}
