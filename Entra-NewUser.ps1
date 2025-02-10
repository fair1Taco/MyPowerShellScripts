param (
    [Parameter(Mandatory = $true)][String]$DisplayName,
    [Parameter(Mandatory = $true)][String]$UserPrincipalName,
    [Parameter(Mandatory = $true)][String]$PWD,
    [Parameter(Mandatory = $false)][String]$Group
)  

Connect-MgGraph -scopes "user.readwrite.all, group.readwrite.all"

$PWProfile = @{
    Password = $PWD;
    ForceChangePasswordNextSignIn = $false
}

$MailNickname = $UserPrincipalName.Split('@')[0]

    New-MgUser `
        -DisplayName $DisplayName `
        -MailNickname $MailNickname `
        -UserPrincipalName $UserPrincipalName `
        -PasswordProfile $PWProfile -AccountEnabled `

    $Addtogroup = Get-MgGroup | Where-Object {$_.DisplayName -eq "$Group"}
    $Addthisuser = Get-MgUser | Where-Object {$_.DisplayName -eq "$DisplayName"}

    if (-not $Group) {
        $Group = Read-Host "User not assigned to a group" -AsSecureString
    }
    else {
    New-MgGroupMember -GroupId $Addtogroup.Id -DirectoryObjectId $Addthisuser.Id
    }

