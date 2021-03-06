<#
.NOTES
    Author: Ted Spinks
    Created: 3/12/2015
    Updated: 3/15/2015
    Provided for demonstration / non-production use only!
.SYNOPSIS
    Assigns the specified vSphere tag/category to the specified target VM.
.DESCRIPTION 
    Assigns the specified vSphere tag/category to the specified target VM.  
	
    Creates the tag if it doesn't already exist.

	Options include wiping previous tag assignments, or only wiping previous assignments for single cardinality tag assignments.

    Requirements:
    1) Expects the PowerCLI core snapin to have already been loaded in the same PS session
    2) Expects a vCenter connection to have already been opened in the same PS session
    3) Expects the tag Category to already be created in vCenter
.PARAMETER tagValue
	The value of the tag to be assigned to the target VM.  Creates the tag if it doesn't already exist.
.PARAMETER tagCatValue
	The category of the tag.  This must already be defined in vCenter.
.PARAMETER targetVm
	The VM to which the tag will be assigned.
.PARAMETER clearAll
	Clears all previous tag assignments on the target VM for the specified Tag Category.  Overrides the -smart parameter.
.PARAMETER clearSmart
	Assumes that you want to clear previous tags for single-cardinality tag categories, but not for multiple-cardinality tag categories.  This parameter is ignored if -clearAll is specified.
.EXAMPLE
    .\AssignTag.ps1 tspinks Owner "testvm01" -clearSmart
#>

[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True,Position=1)]
    [string]$tagValue,
    [Parameter(Mandatory=$True,Position=2)]
    [string]$tagCatValue,
    [Parameter(Mandatory=$True,Position=3)]
    [string]$targetVm,
	[switch]$clearAll,
	[switch]$clearSmart
)

#For any unexpected errors, stop the script and return an error.  Be sure that 
# any expected errors in your script are handled with -ea SilentlyContinue.
# Any output to Standard Error will cause vCO/vRO to think the script has 
# failed, and also seems to cause getHostOutput() and getResults() to be NULL. 
$ErrorActionPreference = "Stop"

#Start logging
echo ("Beginning Tag Assignment Script for VM: " + $targetVm + ".")

#Make sure the tag Category exists (an error will stop this script)
$tagCat = Get-TagCategory -Name $tagCatValue

#See if the specified tag already exists in vCenter
$newTag = get-tag $tagValue -ErrorAction SilentlyContinue

#If the specified tag wasn't found in vCenter, then create it
if (!$?) {
    echo ("Tag, " + $tagValue + ", wasn't found, creating it now.")
    $newTag = new-tag -Name $tagValue -category $tagCatValue
    echo ("Tag, " + $tagValue + ", successfully created.")
}

#Process the "clearAll" and "clearSmart" options
if ( ($clearAll) -or ($clearSmart -and ($tagCat.Cardinality -eq "Single")) ) {
	echo ("Clearing tag(s) in category " + $tagCatValue + " for VM " + $targetVm + ".")
	#Read tag(s) from the target VM
	$tagAssignment = Get-TagAssignment $targetVm -Category $tagCatValue -ErrorAction SilentlyContinue

	#If tags were returned, then go head and remove them
	if ($tagAssignment -ne $null) {
		Remove-TagAssignment $tagAssignment -Confirm:$false
	} else {
		echo "No existing tags were found to clear."
	}
}

#Assign the specified tag
echo ("Adding new tag, " + $tagValue + ", to the VM, " + $targetVm + ".")
New-TagAssignment -tag $newTag -entity $targetVm
