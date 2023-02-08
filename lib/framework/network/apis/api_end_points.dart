class ApiEndPoints {
  static String placeBaseUrl = "https://maps.googleapis.com/maps/api/place/";
  static String directionBaseUrl =
      "https://maps.googleapis.com/maps/api/directions/";
  static String apiKey = "AIzaSyAMEhtHG6zP-mK3p6G5nqMEXfL8FSUmoAE";

  /*
  * ----- Api status
  * */
  static int apiStatus_200 = 200; //success

/*
  * ---- Static data to pass in api's
  * */

/*
  * ----- End Points
  * */

//Common API
// static String countryList                   = strBaseUrl + "/course/country/pageNumber/1/pageSize/10000";

  /// ----- API End Points ----------
  static String findPlaceFromText(String input, String inputType) =>
      "${placeBaseUrl}findplacefromtext/json?input=$input&inputtype=$inputType&key=$apiKey";

  static String getPlaceDetails(String placeId) =>
      "${placeBaseUrl}details/json?place_id=$placeId&key=$apiKey";

  static String getPlaceAutoComplete(String place) =>
      "${placeBaseUrl}autocomplete/json?input=$place&key=$apiKey";

  static String getQueryAutoComplete(String query) =>
      "${placeBaseUrl}queryautocomplete/json?input=$query&key=$apiKey";

  static String getDirection(String origin, String destination) =>
      "${directionBaseUrl}json?origin=place_id:$origin&destination=place_id:$destination&key=$apiKey";
}
