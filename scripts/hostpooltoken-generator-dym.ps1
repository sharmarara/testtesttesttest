﻿# ARM RdsRegistrationInfotoken Used by arm parameter hostpoolToken
# Get RdsRegistrationInfotoken
# Import Modules for WVD

#import-module az.desktopvirtualization
#import-module az.network
#import-module az.compute

param(
$subscriptionIdDym,
$resourceGroupNameDym,
$existingWVDHostPoolNameDym
)


#Obtain RdsRegistrationInfotoken

$Registered = Get-AzWvdRegistrationInfo -SubscriptionId "$subscriptionIdDym" -ResourceGroupName "$resourceGroupNameDym" -HostPoolName $existingWVDHostPoolNameDym
if (-not(-Not $Registered.Token)){$registrationTokenValidFor = (NEW-TIMESPAN -Start (get-date) -End $Registered.ExpirationTime | select Days,Hours,Minutes,Seconds)}

$registrationTokenValidFor
if ((-Not $Registered.Token) -or ($Registered.ExpirationTime -le (get-date)))
{
    $Registered = New-AzWvdRegistrationInfo -SubscriptionId $subscriptionIdDym -ResourceGroupName $resourceGroupNameDym -HostPoolName $existingWVDHostPoolNameDym -ExpirationTime (Get-Date).AddHours(4) -ErrorAction SilentlyContinue
}
$RdsRegistrationInfotoken = $Registered.Token

# Write Host task.setvariable 
Write-Host "$("##vso[task.setvariable variable=RdsRegistrationInfotoken;]")$($RdsRegistrationInfotoken)"
