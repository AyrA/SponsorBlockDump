<#
	.SYNOPSIS
	Create SponsorBlock SQLite database
	.LINK
	https://github.com/AyrA/SponsorBlockDump
	.DESCRIPTION
	Downloads the latest CSV dump from SponsorBlock,
	and then converts it into an SQLite database.
	.PARAMETER NoIndexes
	Do not add indexes to the database. Saves a few seconds at the end
	.PARAMETER NoDownload
	Do not download the latest CSV files. Uses whatever CSV is in the temp folder.
	Note: Database will consist of empty tables if no files are present
	.PARAMETER DumpScript
	Rather than creating the SQLite database, the creation script is dumped to the output.
	The script can be manually fed into the sqlite3 command later.
	Note: Paths in the script are relative to the createdb powershell script
	.PARAMETER JournalInRam
	Keep journal in RAM instead of disk. This is faster, but requires up to 16GB of memory.
	Using this will likely corrupt the database if you run out of memory
	or cancel the operation.
	If corruption happens, rerun the script without -JournalInRam argument.
#>
param(
	[switch]$NoIndexes,
	[switch]$NoDownload,
	[switch]$DumpScript,
	[switch]$JournalInRam
)

$ErrorActionPreference = "Stop"

# Gets the current version number from sponsorblock, which is a unix timestamp
function Get-Version{
	return Invoke-WebRequest 'https://sponsor.ajay.app/database.json?generate=false' | ConvertFrom-Json | Select-Object -ExpandProperty lastUpdated
}

# Download CSV files with the given version number
function Sync-CSV{
	param($Version)
	.\tools\rsync\rsync.exe -ztvhP --inplace rsync://rsync.sponsor.ajay.app:31111/sponsorblock/*_$Version.csv ./Temp/CSV
}

# Create the SQLite command script
function Create-Script{
	$Script = Get-Content Files\_init.txt
	if($JournalInRam){
		$Script = $Script.Replace("=WAL;","=MEMORY;")
	}
	Foreach($item in Get-Item .\Temp\CSV\*){
		$name = $item.Name
		$table = $name -Split '_' | Select-Object -Index 0
		$Script += Write-Output ".print Importing $name..."
		$Script += Write-Output ".import --csv --skip 1 -v Temp\CSV\$name $table";
	}
	if(!$NoIndexes){
		$Script += Get-Content Files\_index.txt
	}
	$Script += Get-Content Files\_end.txt

	return $Script
}

# Create the database using the given script
function Create-Database{
	param($Script)
	if(Test-Path .\Temp\sponsorblock.temp.db3 -PathType Leaf) {
		Write-Error "Temporary database already exists. Will delete and try to recreate it.."
		Remove-Item -Force .\Temp\sponsorblock.temp.db3
	}
	# Redirect temporary directory to a local folder
	$tmp1 = $env:TEMP
	$tmp2 = $env:TMP
	$env:TEMP = "$PSScriptRoot\Temp"
	$env:TMP = "$PSScriptRoot\Temp"
	Write-Output $Script | Tools\sqlite3.exe
	$env:TEMP = $tmp1
	$env:TMP = $tmp2
	If(Test-Path .\DB\sponsorblock.db3 -PathType Leaf) {
		Remove-Item -Force .\Temp\sponsorblock.temp.db3
	} Else {
		Throw "Failed to create database. Previous output may contain information as to why"
	}
}

# Ensures that required folders exist
function Init{
	If(!(Test-Path .\Temp -PathType Container))     { New-Item -ItemType Directory .\Temp;     }
	If(!(Test-Path .\Temp\CSV -PathType Container)) { New-Item -ItemType Directory .\Temp\CSV; }
}

# Deletes temporary directory
function Cleanup{
	If(Test-Path .\Temp -PathType Container) { Remove-Item -Recurse -Force .\Temp; }
}

### End of functions

Push-Location $PSScriptRoot

Init
If(!$NoDownload){
	$Version = Get-Version
	Sync-CSV $Version
}
$Script = Create-Script
if($DumpScript){
	Write-Output $Script
} Else {
Create-Database $Script
}
# Do not clean up if we did not create CSV files
If(!$NoDownload){
	Cleanup
}

Pop-Location
