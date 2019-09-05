Function Get-AZWMNSGsSummary{
    param(
    [string]$subscriptionName)
    $output=@()

    Set-AzContext $sub.Name|out-null
    $NSGs=Get-AzNetworkSecurityGroup
    foreach($NSG in $NSGs)
    {
        $rules=$nsg.securityrules
        foreach($rule in $rules)
        {
            $item=[PSCustomObject]@{
                NSGName = $nsg.name
                Subscription = $sub.Name
                RuleName = $rule.name
                SourceAddress =$rule.SourceAddressPrefix|out-string
                DestAddress = $rule.DestinationAddressPrefix|out-string
                DestinationPort = $rule.DestinationPortRange|out-string
                Direction = $rule.Direction
                Access = $rule.access
                NSGInterfaces = $nsg.NetworkInterfaces.count
                NSGSubnets = $nsg.subnets.Count
            

            }
            $output+=$item
        }
    }
    write-output $output
}


$subs=Get-AzSubscription
$list=@()
foreach($sub in $subs)
{
    $templist=@()
    $templist=Get-AZWMNSGsSummary $sub.name
    $list+=$templist
}
$list