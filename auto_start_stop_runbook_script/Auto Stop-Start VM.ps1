Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

Import-module 'az.accounts'
Import-module 'az.compute'

Connect-AzAccount -Identity

$tag = "Project"
$tagvalue = "Test"

function Stop-Vms {
    param (
        $vms
    )
    foreach ($vm in $vms) {
        try {
            $vm | stop-AzVM -ErrorAction Stop -Force -NoWait
        }
        catch {
            $ErrorMessage = $_.Exception.message
            Write-Error ("Error stopping the VM: " + $ErrorMessage)
        }
    }
}

function Start-Vms {
    param (
        $vms
    )
    foreach ($vm in $vms) {
        try {
            $vm | start-AzVM -ErrorAction Stop -NoWait
        }
        catch {
            $ErrorMessage = $_.Exception.message
            Write-Error ("Error starting the VM: " + $ErrorMessage)
        }
    }
}

try {
    $vms = (get-azvm -ErrorAction Stop  | Where-Object { $_.tags[$tag] -eq $TagValue })
}
catch {
    $ErrorMessage = $_.Exception.message
    Write-Error ("Error returning the VMs: " + $ErrorMessage)
    Break
}

Write-output "Stopping the following servers:"
Write-output $vms.Name
stop-vms $vms

Start-Sleep -Seconds 180

Write-output "Starting the following servers:"
Write-output $vms.Name
start-vms $vms
