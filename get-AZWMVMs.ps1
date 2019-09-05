$subscriptions = Get-AzSubscription
$output=@()
$c=0
foreach($subscription in $subscriptions)
{
    Set-AzContext $subscription.name | out-null
    $c++
    write-progress -activity "Getting VMs " -Status $subscription.name -PercentComplete ($c/$subscriptions.Count*100)
    $VMs=get-azvm -status
    foreach($VM in $VMs)
    {
        $item=[PSCustomObject]@{
            Subscription = $subscription.name
            Name = $vm.name
            OSType = $vm.StorageProfile.OsDisk.OsType
            PowerState = $vm.PowerState
            NIC = $vm.networkprofile.networkinterfaces.id.split("/")[-1]
            DataDiskCount = $vm.StorageProfile.DataDisks.Count

        }
        $output += $item
    }
}
$output|Out-GridView
