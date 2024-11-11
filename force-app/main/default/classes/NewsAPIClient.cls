/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 07-10-2024
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class NewsAPIClient {
    //by default this data should be avaliable
        @AuraEnabled(cacheable = true) 
        public static Map<String, Object> retriveNews(){
            HttpRequest httpRequest = new HttpRequest();
            //7bc06d93ace84fe293b19098383a5329
            String endpoint  = 'https://newsapi.org/v2/top-headlines?apiKey=7bc06d93ace84fe293b19098383a5329&country=us&category=business';
            httpRequest.setEndpoint(endpoint);
            httpRequest.setMethod('GET');
    
            Map<String, Object> newsJsonData = new Map<String, Object>();
            String strResponse = null;
    
            try{
                Http http = new Http();
                HttpResponse httpResponse = http.send(httpRequest);
                if(httpResponse.getStatusCode() == 200){
                    strResponse = httpResponse.getBody();
                } else {
                    throw new CalloutException(httpResponse.getBody());
                }
    
            } catch(Exception ex){
                throw ex;
            }
    
            if(!String.isBlank(strResponse)){
                newsJsonData = (Map<String, Object>)JSON.deserializeUntyped(strResponse);
            }
            if(!newsJsonData.isEmpty()){
                return newsJsonData;
            } else {
                return null;
            }
        }
        //on searching this data should be available
        @AuraEnabled
        public static Map<String, Object> retrieveNewsOnSearch(String category, String country) {
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setEndpoint('https://newsapi.org/v2/top-headlines?apiKey=7bc06d93ace84fe293b19098383a5329' 
                                   + '&category=' + category + '&country=' + country);
            httpRequest.setMethod('GET');
            
            Map<String, Object> newsJsonData = new Map<String, Object>();
            String strResponse = null;
            
            try {
                Http http = new Http();
                HttpResponse httpResponse = http.send(httpRequest);
                if (httpResponse.getStatusCode() == 200) {
                    strResponse = httpResponse.getBody();
                } else {
                    throw new CalloutException('Failed to retrieve news. HTTP Status: ' + httpResponse.getStatusCode());
                }
            } catch(Exception ex) {
                throw ex;
            }
            
            if (!String.isBlank(strResponse)) {
                newsJsonData = (Map<String, Object>) JSON.deserializeUntyped(strResponse);
            }
            
            if (newsJsonData.isEmpty()) {
                return null; // Return null if no news data is available for the specified country and category
            }
            
            return newsJsonData;
        }
        
    }