# Get-Weather script for PowerShell

This script is a silly, but useful script to gather current weather conditions and a 7-Day forecast. 
I've seen a lot of similar scripts, but I always saw OpenWeatherMap as the data source.
This script is tailored to DarkSky (Formely Forecast.io), which is my preferred weather data provider.
An API key will be required for DarkSky and Google's GeoCoding for pinpointing latitude and longitude. DarkSky allows up to 1000 free API calls per day.

I am not fully done making this script and it's not the prettiest, but it is working perfectly right now.

##Requirements
* PowerShell 3.0 and higher.
* A DarkSky API Key (https://darksky.net/dev/)
* Google GeoCoding API Key (https://console.developers.google.com)

##Usage

At this moment, you need to load the script into memory by running it or by importing it into a modules folder. Don't forget to set your ExecutionPolicy to Bypass.

Once the script has been loaded into memory there are ways to get weather data:

``` powershell
Get- Weather
Get-Weather -ZipCode <ZIPCODE>
```
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
