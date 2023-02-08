import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleplaceapidemo/framework/provider/google_maps/polyline_controller.dart';
import 'package:googleplaceapidemo/framework/network/apis/api_result.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/contract/google_maps_repository.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/model/place_auto_complete_response_model.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/model/query_auto_complete_response_model.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/repository/google_maps_repository_builder.dart';
import 'package:googleplaceapidemo/ui/utils/const.dart';

double cameraZoom = 15.4746;

class GoogleMapsController extends ChangeNotifier {
  bool isShowMarker = false;
  bool isShowTrail = false;
  MapType mapType = MapType.normal;
  bool isNormalMap = true;
  bool isHybridMap = false;
  bool isSatelliteMap = false;
  bool isPlaceAutoComplete = true;

  bool isBottomSheetVisible = false;

  String selectedMapType = "Normal";

  String originPlaceId = "";
  String destinationPlaceId = "";

  FocusNode placeFocus = FocusNode();
  FocusNode originFocus = FocusNode();
  FocusNode destinationFocus = FocusNode();

  LatLng? directionStartLatLng;
  LatLng? directionEndLatLng;

  List<PointLatLng>? decodedPolyLine;

  bool isDirection = false;

  Position? position;

  var mapTypeList = [
    {"icon": "normal.png", "title": "Normal"},
    {"icon": "satellite.png", "title": "Satellite"},
    {"icon": "terrain.png", "title": "Terrain"},
  ];

  Completer<GoogleMapController> controller = Completer<GoogleMapController>();

  late GoogleMapController googleMapController;

  ///Text Controllers
  TextEditingController searchPlaceCtr = TextEditingController();
  TextEditingController markerIdCtr = TextEditingController();
  TextEditingController titleCtr = TextEditingController();
  TextEditingController latitudeCtr = TextEditingController();
  TextEditingController longitudeCtr = TextEditingController();
  TextEditingController originPlaceCtr = TextEditingController();
  TextEditingController destinationCtr = TextEditingController();

  Set<Marker> markerList = {};
  Set<Polygon> polygonList = {};

  clearProvider() {
    mapType = MapType.normal;
    isShowMarker = false;
    isShowTrail = false;
    markerIdCtr = TextEditingController();
    titleCtr = TextEditingController();
    latitudeCtr = TextEditingController();
    longitudeCtr = TextEditingController();
    originPlaceCtr = TextEditingController();
    destinationCtr = TextEditingController();
    isPlaceAutoComplete = true;
    isDirection = false;
    originPlaceId = "";
    destinationPlaceId = "";
    isBottomSheetVisible = false;
    decodedPolyLine = [];
    controller = Completer<GoogleMapController>();
  }

  clearDirectionPlaces() {
    originPlaceId = "";
    destinationPlaceId = "";
  }

  Future googleMapsControllerDefine() async {
    googleMapController = await controller.future;
    notifyListeners();
  }

  decodePolylinePoints(PolylineController polylineWatch) {
    decodedPolyLine = PolylinePoints().decodePolyline(
      directionResponseModel!['routes'][0]['overview_polyline']['points'],
    );
    polylineWatch.polylineList = {};
    double lat = directionResponseModel!['routes'][0]['legs'][0]
        ['start_location']['lat'];
    double lng = directionResponseModel!['routes'][0]['legs'][0]
        ['start_location']['lng'];
    updateCameraPosition(LatLng(lat, lng), 12);
    polylineWatch.setPolyline(decodedPolyLine!);
    notifyListeners();
  }

  setMapType(String val) {
    selectedMapType = val;
    switch (val) {
      case "Normal":
        mapType = MapType.normal;
        break;
      case "Satellite":
        mapType = MapType.satellite;
        break;
      case "Terrain":
        mapType = MapType.terrain;
    }
    notifyListeners();
  }

  /*Future getCurrentPositionLocator() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }*/

  Future<void> getCurrentPosition(BuildContext context) async {
    final hasPermission = await handleLocationPermission(context);
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then(
      (Position position) {
        this.position = position;
      },
    ).catchError(
      (e) {
        debugPrint(e);
      },
    );
    notifyListeners();
  }

  updateMapType(MapType updatedType) {
    mapType = updatedType;
    if (mapType == MapType.normal) {
      isNormalMap = true;
      isHybridMap = false;
      isSatelliteMap = false;
    }
    if (mapType == MapType.hybrid) {
      isNormalMap = false;
      isHybridMap = true;
      isSatelliteMap = false;
    }
    if (mapType == MapType.satellite) {
      isNormalMap = false;
      isHybridMap = false;
      isSatelliteMap = true;
    }
    notifyListeners();
  }

  updateMarkerShow(bool val) {
    isShowMarker = val;
    notifyListeners();
  }

  updateIsDirection(bool val) {
    isDirection = val;
    notifyListeners();
  }

  updateTrailShow(bool val) {
    isShowTrail = val;
    notifyListeners();
  }

  addMarker(String markerId, String title, LatLng latLng) async {
    markerList.add(
      Marker(
        markerId: MarkerId(markerId),
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng,
      ),
    );
    isShowMarker = true;
    updateCameraPosition(latLng);
    notifyListeners();
  }

  updateCameraPosition(LatLng latLng, [double? cameraZoomDirection]) async {
    await googleMapsControllerDefine();
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: latLng,
          zoom: cameraZoomDirection ?? cameraZoom,
        ),
      ),
    );
    notifyListeners();
  }

  setDirectionsId(int index) {
    if (originFocus.hasFocus) {
      originPlaceId =
          placeAutoCompleteResponseModel?.predictions[index].placeId ?? "";
      originPlaceCtr.text =
          placeAutoCompleteResponseModel?.predictions[index].description ?? "";
      placeAutoCompleteResponseModel = null;
    } else {
      destinationPlaceId =
          placeAutoCompleteResponseModel?.predictions[index].placeId ?? "";
      destinationCtr.text =
          placeAutoCompleteResponseModel?.predictions[index].description ?? "";
      placeAutoCompleteResponseModel = null;
    }

    notifyListeners();
  }

  checkIfDirectionValid() {
    if (originPlaceId == "" || destinationPlaceId == "") {
      /*if (originPlaceCtr.text == "" || destinationCtr.text == "") {
        return false;
      } else {
        if (originPlaceCtr.text.length < 3 || destinationCtr.text.length < 3) {
          return false;
        }
      }*/
      return true;
    } else {
      return true;
    }
  }

  ///-------------------------API Integration----------------------------///
  bool isLoading = false;
  bool isError = false;

  void isLoadingUpdate(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void isErrorUpdate(bool value) {
    isError = value;
    notifyListeners();
  }

  final GoogleMapsRepository _googleMapsRepository =
      GoogleMapsRepositoryBuilder.repository();

  /*Future getPlaceIdApi(BuildContext context) async {
    String placeId;
    isLoadingUpdate(true);
    isErrorUpdate(false);
    ApiResult apiResult = await _googleMapsRepository.getPlaceId(
        searchPlaceCtr.text, "textquery");
    apiResult.when(success: (data) async {
      isLoadingUpdate(false);
      placeId = data['candidates'][0]['place_id'] as String;
      getPlaceDetails(context, placeId);
    }, failure: (error) {
      isLoadingUpdate(false);
      isErrorUpdate(true);
    });
    notifyListeners();
  }*/

  Future getPlaceDetails(BuildContext context, String placeId) async {
    isLoadingUpdate(true);
    isErrorUpdate(false);
    ApiResult apiResult = await _googleMapsRepository.getPlaceDetails(placeId);
    apiResult.when(success: (data) async {
      isLoadingUpdate(false);
      Map<String, dynamic> placeDetails = data as Map<String, dynamic>;
      double latitude = 0.0;
      double longitude = 0.0;
      latitude = placeDetails['result']['geometry']['location']['lat'];
      longitude = placeDetails['result']['geometry']['location']['lng'];
      String name = placeDetails['result']['name'];
      addMarker(
        name,
        name,
        LatLng(latitude, longitude),
      );
      placeAutoCompleteResponseModel = null;
      searchPlaceCtr.text = "";
      hideKeyboard(context);
    }, failure: (error) {
      isLoadingUpdate(false);
      isErrorUpdate(true);
    });
    notifyListeners();
  }

  PlaceAutoCompleteResponseModel? placeAutoCompleteResponseModel;

  Future getAutoCompleteList(
      BuildContext context, TextEditingController textEditingController) async {
    // isLoadingUpdate(true);
    isPlaceAutoComplete = true;
    isErrorUpdate(false);
    ApiResult apiResult = await _googleMapsRepository
        .getPlaceAutoComplete(textEditingController.text);
    apiResult.when(
      success: (data) async {
        isLoadingUpdate(false);
        placeAutoCompleteResponseModel = data as PlaceAutoCompleteResponseModel;
      },
      failure: (error) {
        isLoadingUpdate(false);
        isErrorUpdate(true);
      },
    );
    notifyListeners();
  }

  Map<String, dynamic>? directionResponseModel;

  Future getDirection(
      BuildContext context, PolylineController polylineController) async {
    isLoadingUpdate(true);
    isErrorUpdate(false);
    ApiResult apiResult = await _googleMapsRepository.getDirection(
      originPlaceId,
      destinationPlaceId,
    );
    apiResult.when(
      success: (data) async {
        isLoadingUpdate(false);
        isBottomSheetVisible = true;
        directionResponseModel = data as Map<String, dynamic>;
        decodePolylinePoints(polylineController);
        addMarker(
          directionResponseModel!['geocoded_waypoints'][0]['place_id'],
          directionResponseModel!['routes'][0]['legs'][0]['start_address'],
          LatLng(
            directionResponseModel!['routes'][0]['legs'][0]['start_location']
                ['lat'],
            directionResponseModel!['routes'][0]['legs'][0]['start_location']
                ['lng'],
          ),
        );
        addMarker(
          directionResponseModel!['geocoded_waypoints'][1]['place_id'],
          directionResponseModel!['routes'][0]['legs'][0]['end_address'],
          LatLng(
            directionResponseModel!['routes'][0]['legs'][0]['end_location']
                ['lat'],
            directionResponseModel!['routes'][0]['legs'][0]['end_location']
                ['lng'],
          ),
        );
      },
      failure: (error) {
        isLoadingUpdate(false);
        isErrorUpdate(true);
      },
    );
    notifyListeners();
  }

  QueryAutoCompleteResponseModel? queryAutoCompleteResponseModel;

  Future getQueryAutoCompleteList(
      BuildContext context, TextEditingController textEditingController) async {
    isPlaceAutoComplete = false;
    isErrorUpdate(false);
    ApiResult apiResult = await _googleMapsRepository
        .getQueryAutoComplete(textEditingController.text);
    apiResult.when(
      success: (data) async {
        isLoadingUpdate(false);
        placeAutoCompleteResponseModel = data as PlaceAutoCompleteResponseModel;
      },
      failure: (error) {
        isLoadingUpdate(false);
        isErrorUpdate(true);
      },
    );
    notifyListeners();
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services'),
        ),
      );
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
