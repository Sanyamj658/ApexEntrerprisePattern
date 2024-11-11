/**
 * @description       : Apex class to fetch weather details using OpenWeatherMap API
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class weatherDetaiClass {

    // Method to fetch weather details for a city
    @AuraEnabled
    public static WeatherDetailsWrapper getWeatherDetails(String city) {
        // Construct the API endpoint
        String apiKey = '0ab3ad2b649e6882da1aa07bf6914026';
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather';
        endpoint += '?q=' + EncodingUtil.urlEncode(city, 'UTF-8');
        endpoint += '&units=metric'; // for standard Celsius
        endpoint += '&APPID=' + apiKey;
        //endpoint += '&APPID={!$Credential.testEC.appid}';
        // Perform HTTP callout to fetch weather data
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        HttpResponse res = http.send(req);

        // Parse the JSON response
        WeatherDetailsWrapper weatherDetails = new WeatherDetailsWrapper();
        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            weatherDetails.city = String.valueOf(result.get('name'));
            Map<String, Object> mainResult = (Map<String, Object>) result.get('main');
            weatherDetails.temperature = String.valueOf(mainResult.get('temp'));
            weatherDetails.pressure = String.valueOf(mainResult.get('pressure'));
            weatherDetails.humidity = String.valueOf(mainResult.get('humidity'));
            weatherDetails.feelsLike = String.valueOf(mainResult.get('feels_like'));
            weatherDetails.tempMin = String.valueOf(mainResult.get('temp_min'));
            weatherDetails.tempMax = String.valueOf(mainResult.get('temp_max'));
        } else {
            // Handle errors if any
            weatherDetails.errorMessage = 'Failed to fetch weather data. Status code: ' + res.getStatusCode();
        }

        return weatherDetails;
    }

    // Wrapper class to store weather details
    public class WeatherDetailsWrapper {
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public String temperature { get; set; }
        @AuraEnabled public String pressure { get; set; }
        @AuraEnabled public String humidity { get; set; }
        @AuraEnabled public String feelsLike { get; set; }
        @AuraEnabled public String tempMin { get; set; }
        @AuraEnabled public String tempMax { get; set; }
        @AuraEnabled public String errorMessage { get; set; }
    }

}