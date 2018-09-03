# Get-Weather script for PowerShell

This script is mean to grab data from the National Weather Service from a specified zipcode. Current weather conditions are not always up-to-date, which I cannot control this as the data is only pulled from the NWS.

I am a weather geek and an IT employee. I work in PowerShell almost daily because it thoroughly helps my workflow, so this script will make seeing the current weather conditions much easier. Even though I can see them on my watch... And phone... And tablet... And if I just open up a web browser. Still, this is a simple and easy way to see current weather data from something I am constantly in every day.

## Installation
1. Install the Get-Weather folder into one of these folders:
  If on Windows:
  * C:\Users\YOUR USERNAME\Documents\WindowsPowerShell\Modules
  * C:\Program Files\WindowsPowerShell\Modules
  * C:\Windows\system32\WindowsPowerShell\v1.0\Modules

  If on macOS:
  * ~/.local/share/powershell/Modules


2. [Windows only] In an admin Powershell console, run this command to allow unsigned scripts to run and make sure it's set to all:
  ```powershell
Set-ExecutionPolicy Bypass
```

3. The script is now able to run.

## Module Help File

```powershell
<#
.SYNOPSIS
Get weather data from the specified zipcode.

.DESCRIPTION
Get weatehr data releated to the current conditions, forecast, and hourly conditions from the specified zipcode. Weather data is retrieved from the National Weather Service.

.PARAMETER ZipCode
The zipcode for the location to grab weather data from.

.PARAMETER Current
Get the current conditions.

.PARAMETER Forecast
Get the weekly forecast.

.PARAMETER Hourly
Get the next twelve hours of hourly conditions.

.EXAMPLE
Get-Weather -ZipCode 36602 -Current

.EXAMPLE
Get-Weather -ZipCode 36602 -Hourly

.NOTES
If too many switches are provided, the first switch provided will be the only one to return data.
#>
	
```