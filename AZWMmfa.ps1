#Install-Module MSOnline      to get the necessary commandlets
Connect-MsolService
function Get-AZWMMFA{
    $admlist=get-msoluser -SearchString "adm" |where {$_.UserPrincipalName -like "adm*"} #get all administrative accounts
    $output=@()
    foreach($user in $admlist)
    {
        $item=[PSCustomObject]@{
            DisplayName=$user.DisplayName
            UPN = $user.UserPrincipalName
            MFAState = $user.StrongAuthenticationRequirements.state
        }
        $output+=$item
    }
    write-output $output
}
function set-azwmmfa{
    param(
    [Parameter(Mandatory=$true)]
    [ValidateSet("Enabled","Disabled")]
    [string]$State,
    [Parameter(Mandatory=$true)]
    [string]$upn
    )
    try {
        if($state -eq "Enabled")
        {
            #to enable MFA
            $st = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
            $st.RelyingParty = "*"
            $st.State = "Enabled"
            $sta = @($st)
            Set-MsolUser -UserPrincipalName $upn -StrongAuthenticationRequirements $sta -ErrorAction Stop
        }
        if($State -eq "Disabled")
        {
            #to disable MFA
            Set-MsolUser -UserPrincipalName $upn -StrongAuthenticationRequirements @()
        }
        write-host "$($UPN) MFA: Enabled"
    }catch {
        write-host "$($UPN) MFA: NOT Enabled" -ForegroundColor red
    }

}

$list = Get-AZWMMFA
$list|where{$_.MFAstate -ne "Enabled" -and $_.MFAstate -ne "Enforced"}|%{set-azwmmfa -State "Enabled" -upn $_.UPN }