public with sharing class TestAPI {

    public String city {get;set;}
    public String temp {get;set;}
    public String pressure {get;set;}
    public String humidity {get;set;}
    public String temp_min {get;set;}
    public String temp_max {get;set;}

    public TestAPI(ApexPages.StandardController stdController){
        Account account = (Account) stdController.getRecord();
        account = [Select Id, Site from Account where Id = :account.id];

        String accountCity = account.Site;
        String apiKey = 'b51692a0c0e99073499e49d19795c919';
        
        String requestEndPoint = 'http://api.openweathermap.org/data/2.5/weather';
        requestEndPoint += '?q=' + accountCity;
        requestEndPoint += '&units=metric';
        requestEndPoint += '&APPID=' + apiKey;

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(requestEndPoint);
        request.setMethod('GET');

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200){
            Map<String,Object> results = (Map<String,Object>)JSON.deserializeUntyped(response.getBody());
            city = String.valueOf(results.get('name'));
            Map<String,Object> mainresults = (Map<String,Object>) (results.get('main'));
            temp = String.valueOf(mainresults.get('temp'));
            pressure = String.valueOf(mainresults.get('pressure'));
            humidity = String.valueOf(mainresults.get('humidity'));
            temp_min = String.valueOf(mainresults.get('temp_min'));
            temp_max = String.valueOf(mainresults.get('temp_max'));
        }
        else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
            ApexPages.addMessage(myMsg);
        }
    }
}
