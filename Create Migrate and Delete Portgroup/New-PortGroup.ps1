<# 
 
.SYNOPSIS
    This script is used xxxxxx 

.DESCRIPTION
    This script is used as a template for all the PowerShell scripts
    and contains all the predefined functions in "Lib" directory.

.PARAMETER  <Parameter-Name>
    The description of a parameter. Add a .PARAMETER keyword for
    each parameter in the function or script syntax.

.EXAMPLE
    A sample command that uses the function or script, optionally followed
    by sample output and a description. Repeat this keyword for each example.

.INPUTS
    The Microsoft .NET Framework types of objects that can be piped to the
    function or script. You can also include a description of the input 
    objects.

.OUTPUTS
    The .NET Framework type of the objects that the cmdlet returns. You can
    also include a description of the returned objects.

.LINK
    None

.NOTES
    File Name  	: xxxx.ps1
    Author     	: Arman Keyoumarsi
    Date		: 30:05:2016


#>
if($PSScriptRoot)
{
    # Load all the Libraries in "Lib" folder 
    $Library = Get-ChildItem -File ($PSScriptRoot + "\Lib") | select Name -ExpandProperty fullname
    foreach ($i in $library){. $i}
    $logFile = $PSScriptRoot + "\Log.txt"
    Start-Transcript $logFile
}else{Start-Transcript ($env:USERPROFILE + "\Desktop\log.txt")}
#############################################################
#Importing all the necessary modules
#Import-Module VMware.PowerCLI
Function NewPOrtGroups{
#Input Variables
Param(

  [Parameter(Mandatory=$True, HelpMessage="Enter the name of the cluster you want to create the Portgoups")][string]$Cluster,
  [Parameter(Mandatory=$True, HelpMessage="Enter the name of the vSwitch you want to create the Portgroup in")][string]$vSwitch,
  [Parameter(Mandatory=$False, HelpMessage="Enter the name of the vSwitch you want to create the Portgroup in")][array]$PortGroup

)

if(!$PortGroup){
    #You can create multiple portgroup using the text file in the root directory
    $PortGroup = Get-Content .\PortGroups.txt
}


Get-Cluster $Cluster | Get-VMHost |  % {

    $Vswitch = Get-VirtualSwitch -VMHost $_  -Name vSwitch2
    $VswitchVmHost = $Vswitch.VMHost
    
    $PortGroup |  % {
    
    
        $Name = ($_.split(","))[0]
        $VLAN = ($_.split(","))[1]
    
        Write-Host "Creating PortGroup $name with VLAN $VLAN in vSwitch $Vswitch at $VswitchVmHost "
    
        #New-VirtualPortGroup -Name $Name -VLanId $VLAN -VirtualSwitch $Vswitch -Confirm:$false -WhatIf
    
        }
    
    }
}
    NewPOrtGroups
############################################################
Stop-Transcript
