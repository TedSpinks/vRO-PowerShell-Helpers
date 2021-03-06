<#
.NOTES
    Author: Ted Spinks
    Created: 12/23/2014
    Updated: 12/28/2014
    Provided for demonstration / non-production use only!
.SYNOPSIS
    Closes a vCenter connection.
.DESCRIPTION 
    Closes a vCenter connection that was previously opened with the PowerCLI Connect-VIServer
    cmdlet from within the same PS session as this script.
.EXAMPLE
    .\CloseVcConn.ps1 172.16.111.204
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$vcServer
)


#For any unexpected errors, stop the script and return an error.  Be sure that 
# any expected errors in your script are handled with -ea SilentlyContinue.
# Any output to Standard Error will cause vCO/vRO to think the script has 
# failed, and also seems to cause getHostOutput() and getResults() to be NULL. 
$ErrorActionPreference = "Stop"

#Start logging
echo ("Closing vCenter connection to server: " + $vcServer)

#Disconnect from the vCenter Server already!
Disconnect-VIServer -server $vcServer -Force -Confirm:$False
