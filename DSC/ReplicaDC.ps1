# Pre-reqs
# -VM with 1 disk attached - but not initialized or configured
# -Automation Account with the following modules imported:
# xActiveDirectory, xComputerManagement, xRemoteDesktopAdmin, xNetworking, xStorage
#
##################################################################################


Configuration ReplicaDC
{
    param
    (
    [Parameter(Mandatory)]
    $computerName,

    [Parameter(Mandatory)]
    $domainName,

    [Parameter(Mandatory)]
    $primaryDNS

    #[Parameter(Mandatory)]
    #$domainCred,

    #[Parameter(Mandatory)]
    #$safemodeAdministratorCred
    )

    Import-DscResource -Module xActiveDirectory   
    Import-DscResource -Module xComputerManagement 
    Import-DscResource -Module xRemoteDesktopAdmin   
    Import-DscResource -Module xNetworking    
    Import-DscResource -Module xStorage

    $domainCred = Get-AutomationPSCredential -Name 'domainadmin'
    $safemodeAdministratorCred = Get-AutomationPSCredential -Name 'safemodeAdministratorCred'


    Node localhost
    {
        #Rename Computer
        xComputer Rename
        {
            Name = $computerName
        }

        #Enable RDP
        xRemoteDesktopAdmin RemoteDesktopSettings
        {
           Ensure = 'Present'
           UserAuthentication = 'Secure'
        }

        #RDP firewall rule
        xFirewall AllowRDP
        {
            Name = 'DSC - Remote Desktop Admin Connections'
            Group = "Remote Desktop"
            Ensure = 'Present'
            Enabled = $true
            Action = 'Allow'
            Profile = ('Domain','Private','Public')
        }

        #Configure AD DB disk
        xWaitforDisk Disk2
        {
            DiskNumber = 2
        }

        xDisk VolumeF
        {
            DiskNumber = 2
            DriveLetter = 'F'
            FSLabel = 'NTDS'
            DependsOn = '[xWaitforDisk]Disk2'
        }

        File NTDSDir
        {
            DestinationPath = 'F:\NTDS'
            Type = 'Directory'
            DependsOn = '[xDisk]VolumeF'
        }

        #Configure Network
        <#xDNSServerAddress DNSServerAddress
        {
            InterfaceAlias = 'Ethernet'
            Address = @($primaryDNS
                        '127.0.0.1')
            AddressFamily = 'IPv4'
        }#>

        #Install Windows Features
        WindowsFeature ADDomainServices
        {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
        }

        WindowsFeature DNS
        {
            Ensure = 'Present'
            Name = "DNS"
        }

        xADDomainController ReplicaDC
        {
            DomainName = $domainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $safemodeAdministratorCred
            DatabasePath = 'F:\NTDS'
            LogPath = 'F:\NTDS'
            SysvolPath = 'F:\SYSVOL'
            #SiteName = 'Bagsvaerd'
            DependsOn = '[WindowsFeature]ADDomainServices','[WindowsFeature]DNS'#,'[xDNSServerAddress]DNSServerAddress'
        }
    }
}