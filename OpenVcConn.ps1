<#
.NOTES
    Author: Ted Spinks
    Created: 12/23/2014
    Updated: 12/28/2014
    Provided for demonstration / non-production use only!
.SYNOPSIS
    Opens a connection to the specified vCenter.
.DESCRIPTION 
    Loads the VMware PowerCLI core snapin (and others if needed in the future) and opens a 
    VMware PowerCLI connection to the specified vCenter, using the specified credentials.

    Subsequent scripts in the same PS session can then make use of PowerCLI and this vCenter 
    connection.  To run this and subsequent scripts in the same session, either dot 
    source them or reference the same PS session.

    It's also nice to close the vCenter connection when you're done, with Disconnect-VIServer.
.EXAMPLE
    .\OpenVcConn.ps1 172.16.111.204 administrator@vsphere.local vmware1!
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$vcServer,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$vcUser,
    [Parameter(Mandatory=$True,Position=3)]
    [string]$vcPass
)


#For any unexpected errors, stop the script and return an error.  Be sure that 
# any expected errors in your script are handled with -ea SilentlyContinue.
# Any output to Standard Error will cause vCO/vRO to think the script has 
# failed, and also seems to cause getHostOutput() and getResults() to be NULL. 
$ErrorActionPreference = "Stop"

#Start logging
echo ("Beginning vCenter connection script for server: " + $vcServer)

#Add the core VMware PowerCLI snapin
add-pssnapin VMware.VimAutomation.Core

#Add other snapins


#Connect to the vCenter Server
Connect-VIServer -Server $vcServer -Force -User $vcUser -Password $vcPass
