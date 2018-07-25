<# 
 
.SYNOPSIS
    This script is used to Create new portgroup in a VMWare cluster. 

.DESCRIPTION
    This script is used to Create new portgroup in a VMWare cluster. It will do so by creating the portgroups
    in an standard virtual switch inside each ESXi within the cluster.

.PARAMETER  Cluster
    Name of the VMWare Cluster you want to create the portgroups in.

.PARAMETER  vSwitch
    Name of the Standard virtual switch you want to create the portgroups in.
    Note, vSwitch should exist in the cluster

.PARAMETER  PortGroup
    Name of the Portgroup and its associated VLAN. it should be inserted in an array format

.EXAMPLE
    .\NewPortGroup.ps1
    cmdlet  at command pipeline position 1
    Supply values for the following parameters:
    (Type !? for Help.)
    Cluster: Name Of the Cluster
    vSwitch: vSwitch02

.EXAMPLE
    .\NewPortGroup.ps1 -Cluster "ClusterNAme" -vSwitch "vSwitch2" -PortGroup "NewPortGroup,13(VLANID)" -Confirm

.INPUTS
    Optionally portgroups can be added in a text file and be added to the root of the directory.

.OUTPUTS
    Log.txt will be either in the script directory or will be created on user desktop.

.LINK
    None

.NOTES
    File Name  	: New-PortGroup.ps1
    Author     	: Arman Keyoumarsi

#>
if($PSScriptRoot)
{
    $logFile = $PSScriptRoot + "\Log.txt"
    Start-Transcript $logFile
}else{Start-Transcript ($env:USERPROFILE + "\Desktop\log.txt")}
#############################################################
#Importing all the necessary modules
Import-Module VMware.PowerCLI
Function NewPortGroups{
#Input Variables
Param(

  [Parameter(Mandatory=$True, HelpMessage="Enter the name of the cluster you want to create the Portgoups")][string]$Cluster,
  [Parameter(Mandatory=$True, HelpMessage="Enter the name of the vSwitch Example vSwitch2")][string]$vSwitch,
  [Parameter(Mandatory=$False, HelpMessage="NewPortGroup, Example PortGroup,13")][array]$PortGroup,
  [switch]$Confirm #this is a switch for confirm with default value of $Flase 
)

if(!$PortGroup){
    #You can create multiple Portgroup using the text file in the root directory
    $PortGroup = Get-Content .\NewPortGroups.txt
}

Get-Cluster $Cluster | Get-VMHost |  % {

    $vSwitch01 = Get-VirtualSwitch -VMHost $_  -Name $vSwitch
    $VswitchVmHost = $vSwitch01.VMHost
    
    #Looping through the array
    $PortGroup |  % {
        
        $Name = ($_.split(","))[0]
        $VLAN = ($_.split(","))[1]
    
        Write-Host "Creating PortGroup $name with VLAN $VLAN in vSwitch $vSwitch01  at $VswitchVmHost "
        #~Creating the vSwitch
        New-VirtualPortGroup -Name $Name -VLanId $VLAN -VirtualSwitch $vSwitch01 -Confirm:$Confirm
    
        }
    
    }
}

NewPortGroups
############################################################
Stop-Transcript
