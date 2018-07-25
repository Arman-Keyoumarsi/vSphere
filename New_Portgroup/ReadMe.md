# Description

This script is used to Create new portgroup in a VMWare cluster. It will do so by creating the portgroups
in an standard virtual switch inside each ESXi within the cluster.

### Prerequisites

You need the latest PowerCLI module installed on your system to be able to run these scripts.
```Powershell
Install-Module -Name VMware.PowerCLI
```
For more details refer to [VMware PowerCLI Blog](https://blogs.vmware.com/PowerCLI/2017/04/powercli-install-process-powershell-gallery.html)

### EXAMPLE

```cmd
    .\NewPortGroup.ps1
    cmdlet  at command pipeline position 1
    Supply values for the following parameters:
    (Type !? for Help.)
    Cluster: Name Of the Cluster
    vSwitch: vSwitch02
```
```
    .\NewPortGroup.ps1 -Cluster "ClusterNAme" -vSwitch "vSwitch2" -PortGroup "NewPortGroup,13(VLANID)" -Confirm
```
### Disclaimer 

[The author] assumes no responsibility or liability for any errors or omissions or miss use of the scripts. Use at your own risk.