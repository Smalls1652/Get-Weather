# Get-Weather script for PowerShell

This script is a silly, but useful script to gather current weather conditions and a 7-Day forecast. I've seen a lot of similar scripts, but I always saw OpenWeatherMap as the data source.This script is tailored to DarkSky (Formely Forecast.io), which is my preferred weather data provider.An API key will be required for DarkSky and Google's GeoCoding for pinpointing latitude and longitude. DarkSky allows up to 1000 free API calls per day.

I am a weather geek and an IT employee. I work in PowerShell almost daily because it thoroughly helps my workflow, so this script will make seeing the current weather conditions much easier. Even though I can see them on my watch... And phone.

I am not fully done making this script and it's not the prettiest, but it is working perfectly right now.

##Requirements
* PowerShell 3.0 and higher.
* A DarkSky API Key (https://darksky.net/dev/)
* Google GeoCoding API Key (https://console.developers.google.com)


##Installation
1. Install the Get-Weather folder into one of these three folders:
  * C:\Users\<YOUR USERNAME>\Documents\WindowsPowerShell\Modules
  * C:\Program Files\WindowsPowerShell\Modules
  * C:\Windows\system32\WindowsPowerShell\v1.0\Modules

2. Open up the Get-Weather.psm1 file with a text editor and edit these two lines with the API keys from DarkSky and Google GeoCoding:
  ```powershell
$darkskyAPI = "" #Your Dark Sky API Key goes here
$googlegeocodeAPI = "" #Your Google GeoCoding API key goes here
```

3. Save the file.

4. In an admin Powershell console, run this command to allow unsigned scripts to run and make sure it's set to all:
  ```powershell
Set-ExecutionPolicy Bypass
```

5. The script is now able to run.

##Usage

Once the script has been loaded into memory there are two ways to get weather data:

``` powershell
Get-Weather
and
Get-Weather -ZipCode <ZIPCODE>
```

Running the command with no zipcode will load your location data from your public IP, so if you're behind a VPN... This will not pull your right location.

Examples:
``` powershell
Get-Weather

Current Conditions for Birmingham, AL
 --------------------- 
 Last Updated: 02/16/2017 19:55:48 
 Current Temperature (F): 40.96 
 Current Conditions: Clear 
 
 In the next hour: Clear for the hour. 
 
 For the next 48 hours: Partly cloudy starting tonight, continuing until tomorrow morning. 

Day       summary                                High      Low      
---       -------                                ----      ---      
Thursday  Partly cloudy overnight.               51.07 (F) 31.65 (F)
Friday    Mostly cloudy in the morning.          66.29 (F) 32.97 (F)
Saturday  Mostly cloudy throughout the day.      74.5 (F)  44.05 (F)
Sunday    Mostly cloudy in the morning.          76.42 (F) 51.35 (F)
Monday    Mostly cloudy starting in the evening. 70.42 (F) 48.6 (F) 
Tuesday   Mostly cloudy throughout the day.      67.12 (F) 43.64 (F)
Wednesday Mostly cloudy throughout the day.      72.1 (F)  45.92 (F)
Thursday  Light rain throughout the day.         70.39 (F) 55.07 (F)
```
```powershell
Get-Weather -zipcode 36602

Current Conditions for Mobile, AL 36602, USA 
 --------------------- 
 Last Updated: 02/16/2017 19:57:49 
 Current Temperature (F): 40.76 
 Current Conditions: Clear 
 
 In the next hour: Clear for the hour. 
 
 For the next 48 hours: Partly cloudy starting tonight, continuing until tomorrow morning. 

Day       summary                                High      Low      
---       -------                                ----      ---      
Thursday  Partly cloudy overnight.               51.07 (F) 31.65 (F)
Friday    Mostly cloudy in the morning.          66.29 (F) 32.97 (F)
Saturday  Mostly cloudy throughout the day.      74.5 (F)  44.05 (F)
Sunday    Mostly cloudy in the morning.          76.42 (F) 51.35 (F)
Monday    Mostly cloudy starting in the evening. 70.42 (F) 48.6 (F) 
Tuesday   Mostly cloudy throughout the day.      67.13 (F) 43.64 (F)
Wednesday Mostly cloudy throughout the day.      72.1 (F)  45.92 (F)
Thursday  Light rain throughout the day.         70.4 (F)  55.07 (F)
```
##Planned Updates

Hopefully I can find some time to prevent weather data from being constantly downloaded every time the command is ran. I'm hoping to continuously update this script until it fits all of my personal needs, so expect plenty of new additions and changes (Especially to the structure of the code).
