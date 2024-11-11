public class ParkLocator{
    public static List<String> country(String countryName){
        ParkService.ParksImplPort parks = new  ParkService.ParksImplPort();
        System.debug(parks.byCountry(countryName));
        return parks.byCountry(countryName);
    }

}