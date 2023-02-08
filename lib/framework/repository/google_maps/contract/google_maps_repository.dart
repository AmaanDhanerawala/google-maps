abstract class GoogleMapsRepository {
  ///Get Place Id
  Future getPlaceId(String input, String inputType);

  ///Get Place Details from ID
  Future getPlaceDetails(String placeId);

  ///Get Place AutoComplete
  Future getPlaceAutoComplete(String place);


  ///Get Query AutoComplete
  Future getQueryAutoComplete(String query);

  ///Get Query AutoComplete
  Future getDirection(String origin, String destination);
}
