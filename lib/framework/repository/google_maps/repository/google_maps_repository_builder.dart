import 'package:googleplaceapidemo/framework/repository/google_maps/contract/google_maps_repository.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/repository/google_maps_api_repository.dart';

class GoogleMapsRepositoryBuilder {
  static GoogleMapsRepository repository() {
    return GoogleMapsApiRepository();
  }
}