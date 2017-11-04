function Get-Weather {
	
    <#
	.SYNOPSIS
	Gets weather data from DarkSky and outputs it into the shell.
	
	.DESCRIPTION
	Gets weather data from DarkSky and outputs it into the shell. This data includes current conditions and a 7-day forecast for the current area or a specified zipcode.
	
	.PARAMETER ZipCode
	Manual zipcode to gather data for.

	.PARAMETER Address
	Manual address to gather data for.
	
	.PARAMETER Forecast
	Show the next 8 day forecast.
	
	.PARAMETER Hourly
  	Show the hourly forecast for the rest of the day.
  
  	.PARAMETER Config
  	Rerun the API Key config setup.

	.PARAMETER ClearDB
	Clear all DB files.
	
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
	
    [cmdletbinding()]
    param(
	
        [string]$ZipCode,
        [string]$Address,
        [switch]$Forecast,
        [switch]$Hourly,
        [switch]$Config,
        [switch]$ClearDB,
        [switch]$Force
	
    )
	
    function APIConfig {
        param(
				
            [string]$DarkSky,
            [string]$Google
        )
	
        If (!($DarkSky)) {
            $DarkSky = Read-Host -Prompt "Please enter the Dark Sky API Key"
        }
        If (!($Google)) {
            $Google = Read-Host -Prompt "Please enter the Google Maps Geocode API Key"
        }
        $APIFile = '"API","Key"
	"DarkSky","' + $DarkSky + '"
	"GoogleGeocoding","' + $Google + '"'
	
        $APIFile | Out-File -FilePath "$PSScriptRoot/APIKeys.csv" -Force
    }
	
    if (!(Get-ChildItem -Path "$PSScriptRoot/APIKeys.csv" -ErrorAction SilentlyContinue) -or ($Config)) {
        APIConfig
    }
	
    $apiKeys = Import-Csv -Path "$PSScriptRoot/APIKeys.csv"
	
    $darkskyAPI = ($apiKeys | Where-Object -Property "API" -eq "DarkSky").Key
    $googlegeocodeAPI = ($apiKeys | Where-Object -Property "API" -eq "GoogleGeocoding").Key
	
    <#
	
	DarkSky uses latitude and longitude to get weather data, since it's a "hyperlocal" weather service. To make this easier to the user, the script must determine the latitude and longitude of their location.
	
	#>
    if ($ZipCode) {
	
	
        $googleData = (Invoke-RestMethod "https://maps.googleapis.com/maps/api/geocode/json?address=$ZipCode&key=$googlegeocodeAPI").results
	
        $geoLat = $googleData.geometry.location.lat
        $geoLong = $googleData.geometry.location.lng
	
        $cityLocation = $googleData.formatted_address
	
    }
    elseif ($Address) {


        $googleData = (Invoke-RestMethod "https://maps.googleapis.com/maps/api/geocode/json?address=$Address&key=$googlegeocodeAPI").results
        if ($googleData.Length -gt 1) {
            Write-Warning "More than one result returned.`n"
            $i = 0
            foreach ($option in $googleData) {
                $i++
                $optionName = $option.formatted_address
                Write-Host  "$i. $optionName"
            }
			
            while ((($chosenOption = Read-Host -Prompt "Select an option") -gt $i) -or !($chosenOption)) {
                Write-Warning "Out of range. Please select and option within the range."
            }

            $googleData = $googleData[$chosenOption - 1]
        }
        $geoLat = $googleData.geometry.location.lat
        $geoLong = $googleData.geometry.location.lng

        $cityLocation = $googleData.formatted_address

    }
    else {

        $googleGeoLocation = Invoke-RestMethod -Method Post -Uri "https://www.googleapis.com/geolocation/v1/geolocate?key=$googlegeocodeAPI"

        $geoLat = $googleGeoLocation.location.lat
        $geoLong = $googleGeoLocation.location.lng
	
        $googleData = Invoke-RestMethod ("https://maps.googleapis.com/maps/api/geocode/json?latlng=" + $geoLat + "," + $geoLong + "&result_type=street_address&key=$googlegeocodeAPI")

        $cityLocation = $googleData.results.formatted_address
    }
	
    $fullGeo = "$geoLat,$geoLong" #Combine the latitude and longitude into one string.
    $fullFile = $PSScriptRoot + "/$fullgeo.xml"
	
    if (!(Get-ChildItem $fullFile -ErrorAction SilentlyContinue) -or ((Get-Date) -ge ((Get-ChildItem $fullFile -ErrorAction SilentlyContinue).LastWriteTime.AddHours(1))) -or ($Force)) {
	
        $dsData = Invoke-RestMethod "https://api.darksky.net/forecast/$darkskyAPI/$fullgeo"
	
        Export-Clixml -Path $fullFile -InputObject $dsData
    }
    else {
        $dsData = Import-Clixml -Path $fullFile
    }
	
    If ($Forecast) {
        $ForecastOutput = foreach ($day in $dsData.daily.data) {
            If (([timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($day.Time)) | Get-Date) -eq (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0)) { 
                $weektoday = "Today" 
            } 
            else { 
                $weektoday = ([timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($day.Time)) | Get-Date -Format "dddd").ToString()
            }
	
            $DayForecast = @{
	
                "Day"          = $weektoday;
	
                "Summary"      = $day.Summary;
	
                "High (F)"     = ([math]::Round($day.temperatureMax)).ToString() + [char]0x00b0;
	
                "Low (F)"      = ([math]::Round($day.temperatureMin)).ToString() + [char]0x00b0;
	
                "Precip Prob." = $day.precipProbability.ToString() + "%";
	
                "Sunrise"      = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($day.sunriseTime)) | Get-Date -Format "hh:mm tt";
	
                "Sunset"       = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($day.sunsetTime)) | Get-Date -Format "hh:mm tt";
            }
	
            [pscustomobject]$DayForecast
        }
        [pscustomobject]$ForecastOutput | Select-Object -Property "Day", "Summary", "High (F)", "Low (F)", "Sunrise", "Sunset", "Precip Prob." | Format-Table -AutoSize
    }
    elseif (($Hourly)) {
        $HourlyOutput = foreach ($hour in $dsData.hourly.data) {
            $HourlyForecast = @{
				
                "Day"          = If (([timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($hour.Time)) | Get-Date) -eq (Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0)) { "Today" } else { ([timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($hour.Time)) | Get-Date -Format "dddd").ToString() };

                "Hour"         = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($hour.Time)) | Get-Date -Format "hh:mm tt";
					
                "Summary"      = $hour.Summary;
					
                "Temp (F)"     = ([math]::Round($hour.temperature)).ToString() + [char]0x00b0;
	
                "Precip Prob." = $hour.precipProbability.ToString() + "%";
	
                "Pressure"     = $hour.pressure.ToString() + "mb";
	
                "Wind Speed"   = ([math]::Round($hour.windSpeed)).ToString() + " MPH"
	
            }
					
            [pscustomobject]$HourlyForecast
        }
        [pscustomobject]$HourlyOutput | Select-Object -Property "Day", "Hour", "Summary", "Temp (F)", "Pressure", "Wind Speed", "Precip Prob." | Format-Table -AutoSize
    }
    elseif ($ClearDB) {
        foreach ($file in (Get-ChildItem -Path $PSScriptRoot -Filter "*.xml")) {
            $file.Delete()
        }
    }
    else {
        $todaySunrise = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($dsData.daily.data[0].sunriseTime)) | Get-Date -Format "hh:mm tt";
        $todaySunset = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($dsData.daily.data[0].sunsetTime)) | Get-Date -Format "hh:mm tt";
	
        $sunriseOccured = If ((Get-Date) -gt ($todaySunrise)) { " (Already Occured)" }
        $sunsetOccured = If ((Get-Date) -gt ($todaySunset)) { " (Already Occured)" }
	
        $currentSummary = @{
	
            "Location"           = $cityLocation;
	
            "Last Updated"       = [timezone]::CurrentTimeZone.ToLocalTime(([datetime]'1/1/1970').AddSeconds($dsData.currently.time));
	
            "Current Temp (F)"   = ([math]::Round($dsData.currently.temperature)).ToString() + [char]0x00b0;
	
            "Current Conditions" = $dsData.currently.summary;
	
            "Pressure"           = $dsData.currently.pressure.ToString() + " mb"; 
	
            "Wind Speed"         = ([math]::Round($dsData.currently.windSpeed)).ToString() + " MPH";
	
            "Sunrise"            = $todaySunrise + $sunriseOccured;
	
            "Sunset"             = $todaySunset + $sunsetOccured;
	
            "Next Hour"          = $dsData.minutely.summary;
	
            "Next 48 Hours"      = $dsData.hourly.summary
        }
        return [pscustomobject]$currentSummary | Select-Object -Property "Location", "Last Updated", "Current Temp (F)", "Current Conditions", "Pressure", "Wind Speed", "Sunrise", "Sunset", "Next Hour", "Next 48 Hours"
    }
	
	
}