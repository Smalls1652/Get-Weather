function Get-Weather {

param(

[string]$zipcode,
[string]$datatype = "forecast"

)

$darkskyAPI = ""
$googlegeocodeAPI = ""

if (!$darkskyAPI -or !$googlegeocodeAPI)
{

Write-Error "An API key is missing."
Break
}

if ($zipcode)
{


$googleData = Invoke-RestMethod "https://maps.googleapis.com/maps/api/geocode/json?address=$zipcode&key=$googlegeocodeAPI"

$geoLat = $googleData.results.geometry.location.lat;
$geoLong = $googleData.results.geometry.location.lng

$cityLocation = $googleData.results.formatted_address

}
else
{
$publicInfo = Invoke-RestMethod http://ipinfo.io/json

$publicIP = $publicInfo | Select-Object -ExpandProperty ip
$geoLoc = Invoke-RestMethod -Method Get -Uri http://freegeoip.net/json/$publicIP
$publicCity = Invoke-RestMethod http://ipinfo.io/json | Select -ExpandProperty city
$publicRegion = Invoke-RestMethod http://ipinfo.io/json | Select -ExpandProperty region

$cityLocation = "$publicCity, $publicRegion"

$geoLat = $geoLoc | Select-Object -ExpandProperty Latitude
$geoLong = $geoLoc | Select-Object -ExpandProperty Longitude

}


$fullGeo = "$geoLat,$geoLong"


$dsData = Invoke-RestMethod "https://api.darksky.net/forecast/$darkskyAPI/35.6733387,-77.9053182"

$dsCurrTime = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($dsData.currently.time))

$dsCurrTemp = $dsData.currently.temperature

$dsCurrSummary = $dsData.currently.summary

$dsMinSummary = $dsData.minutely.summary

$dsHourSummary = $dsData.hourly.summary

$dsWeeklySummary = $dsdata.daily.data | Select-Object -Property Summary,@{N="High";E={$_.temperatureMax.ToString() + " (F)"}},@{N="Low";E={$_.temperatureMin.ToString() + " (F)"}},@{N="Day";E={[timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($_.Time)) | Get-Date -Uformat %A}} | Format-Table -AutoSize -GroupBy Time -Property Day,Summary,High,Low

Write-Output "`nCurrent Conditions for $cityLocation `n --------------------- `n Last Updated: $dsCurrTime `n Current Temperature (F): $dsCurrTemp `n Current Conditions: $dsCurrSummary `n `n In the next hour: $dsMinSummary `n `n For the next 48 hours: $dsHourSummary "

$dsWeeklySummary

}
