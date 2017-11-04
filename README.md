# Get-Weather script for PowerShell

This script is a silly, but useful script to gather current weather conditions and a 7-Day forecast. I've seen a lot of similar scripts, but I always saw OpenWeatherMap as the data source.This script is tailored to DarkSky (Formely Forecast.io), which is my preferred weather data provider.An API key will be required for DarkSky and Google's GeoCoding for pinpointing latitude and longitude. DarkSky allows up to 1000 free API calls per day.

I am a weather geek and an IT employee. I work in PowerShell almost daily because it thoroughly helps my workflow, so this script will make seeing the current weather conditions much easier. Even though I can see them on my watch... And phone... And tablet... And if I just open up a web browser. Still, this is a simple and easy way to see current weather data from something I am constantly in every day.

I am not fully done making this script and it's not the prettiest, but it is working perfectly right now.

## Requirements
* PowerShell 3.0 and higher.
* A DarkSky API Key (https://darksky.net/dev/)
* Google GeoCoding API Key (https://console.developers.google.com)


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

## Post-Install Setup

Once you run Get-Weather once, it will ask you to supply the API keys from Dark Sky and Google Maps Geocoding.

## Module Help File

```powershell
<#
	.SYNOPSIS
	Gets weather data from DarkSky and outputs it into the shell.
	
	.DESCRIPTION
	Gets weather data from DarkSky and outputs it into the shell. This data includes current conditions and a 7-day forecast for the current area or a specified zipcode.
	
	.PARAMETER ZipCode
	Manual zipcode to gather data for.
	
	.PARAMETER Forecast
	Show the next 8 day forecast.
	
	.PARAMETER Hourly
  Show the hourly forecast for the rest of the day.
  
  .PARAMETER Config
  Rerun the API Key config setup.
	
	.PARAMETER Force
	Force an update to the local DB of the location. Warning: This counts as an API call to Dark Sky.
	
	.EXAMPLE
	# Show weather for the current location.
	Get-Weather
	
	.EXAMPLE
	# Get weather for a specific location through a zipcode and get the 8 day forecast.
  Get-Weather -ZipCode 36602 -Forecast
  
  .EXAMPLE
  # Force a refresh of the local DB for a zipcode and get the hourly forecast.
	Get-Weather -ZipCode 36602 -Hourly -Force
	#>
	
```

## Notes

DarkSky has a 1,000 free API calls per day. After that, it costs $1 per 10,000 API calls. My advice is to not go wild with multiple refreshes of weather data. At this moment in time, the module will only refresh the local DB if it is one hour old or if you force a refresh.

## Planned Updates

As of November 4th, 2017, the module has been heavily updated to function in a more cohesive and modular way. Further improvements to the module will consist of more depth/options in the data that's presented, cleaning the structure of the code, improving the local DB refresh, and building error handling.