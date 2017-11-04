function Get-Weather {

<#
.SYNOPSIS
Gets weather data from DarkSky and outputs it into the shell.

.DESCRIPTION
Gets weather data from DarkSky and outputs it into the shell. This data includes current conditions and a 7-day forecast for the current area or a specified zipcode.

.PARAMETER ZipCode
Manual zipcode to gather data for.

.EXAMPLE
# Show weather for the current location.
Get-Weather

.EXAMPLE
# Get weather for a specific location through a zipcode.
Get-Weather -ZipCode 36602

#>

[cmdletbinding()]
param(

[string]$ZipCode

)

$apiKeys = Import-Csv -Path "$PSScriptRoot/APIKeys.csv"

$darkskyAPI = ($apiKeys | Where-Object -Property "API" -eq "DarkSky").Key
$googlegeocodeAPI = ($apiKeys | Where-Object -Property "API" -eq "GoogleGeocoding").Key


if (!$darkskyAPI -or !$googlegeocodeAPI)
{

	Write-Error "An API key is missing."
	Break
}

<#

DarkSky uses latitude and longitude to get weather data, since it's a "hyperlocal" weather service. To make this easier to the user, the script must determine the latitude and longitude of their location.

#>
if ($ZipCode) #If the zipcode parameter has been supplied
{

<#

Google GeoCoding is used here to pinpoint the zipcode down to it's latitude and longitude.

#>

	$googleData = Invoke-RestMethod "https://maps.googleapis.com/maps/api/geocode/json?address=$ZipCode&key=$googlegeocodeAPI"

	$geoLat = $googleData.results.geometry.location.lat;
	$geoLong = $googleData.results.geometry.location.lng

	$cityLocation = $googleData.results.formatted_address

}
else #If the zipcode parameter was not supplied.
{
<#

Public IP reverse lookup is used here to pinpoint the zipcode down to it's latitude and longitude.

#>
	$publicInfo = Invoke-RestMethod http://ipinfo.io/json

	$publicIP = $publicInfo | Select-Object -ExpandProperty ip
	$geoLoc = Invoke-RestMethod -Method Get -Uri http://freegeoip.net/json/$publicIP
	$publicCity = $publicInfo | Select-Object -ExpandProperty city
	$publicRegion = $publicInfo | Select-Object -ExpandProperty region

	$cityLocation = "$publicCity, $publicRegion"

	$geoLat = $geoLoc | Select-Object -ExpandProperty Latitude
	$geoLong = $geoLoc | Select-Object -ExpandProperty Longitude

}

$fullGeo = "$geoLat,$geoLong" #Combine the latitude and longitude into one string.


$dsData = Invoke-RestMethod "https://api.darksky.net/forecast/$darkskyAPI/$fullgeo"

$dsCurrTime = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($dsData.currently.time))

$dsCurrTemp = $dsData.currently.temperature

$dsCurrSummary = $dsData.currently.summary

$dsMinSummary = $dsData.minutely.summary

$dsHourSummary = $dsData.hourly.summary

$dsWeeklySummary = $dsdata.daily.data | Select-Object -Property Summary,@{N="High";E={$_.temperatureMax.ToString() + " (F)"}},@{N="Low";E={$_.temperatureMin.ToString() + " (F)"}},@{N="Day";E={[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($_.Time)) | Get-Date -Uformat %A}} | Format-Table -AutoSize -GroupBy Time -Property Day,Summary,High,Low

Write-Output "`nCurrent Conditions for $cityLocation `n --------------------- `n Last Updated: $dsCurrTime `n Current Temperature (F): $dsCurrTemp `n Current Conditions: $dsCurrSummary `n `n In the next hour: $dsMinSummary `n `n For the next 48 hours: $dsHourSummary "

$dsWeeklySummary

}