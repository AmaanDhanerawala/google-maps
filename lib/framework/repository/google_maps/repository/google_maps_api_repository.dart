import 'dart:convert' as convert;
import 'package:dio/dio.dart';
import 'package:googleplaceapidemo/framework/network/apis/api_end_points.dart';
import 'package:googleplaceapidemo/framework/network/apis/api_result.dart';
import 'package:googleplaceapidemo/framework/network/apis/network_exceptions.dart';
import 'package:googleplaceapidemo/framework/network/apis/restClient.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/contract/google_maps_repository.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/model/place_auto_complete_response_model.dart';
import 'package:googleplaceapidemo/framework/repository/google_maps/model/query_auto_complete_response_model.dart';

class GoogleMapsApiRepository implements GoogleMapsRepository {
  @override
  Future getPlaceId(String input, String inputType) async {
    try {
      Response? response = await RestClient.getData(
        ApiEndPoints.findPlaceFromText(input, inputType),
      );
      var json = convert.jsonDecode(response.toString());
      return ApiResult.success(data: json);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getPlaceDetails(String placeId) async {
    try {
      Response? response = await RestClient.getData(
        ApiEndPoints.getPlaceDetails(placeId),
      );
      var json = convert.jsonDecode(response.toString());
      return ApiResult.success(data: json);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getPlaceAutoComplete(String place) async {
    try {
      Response? response = await RestClient.getData(
        ApiEndPoints.getPlaceAutoComplete(place),
      );
      PlaceAutoCompleteResponseModel placeAutoCompleteResponseModel =
          placeAutoCompleteResponseModelFromJson(response.toString());
      return ApiResult.success(data: placeAutoCompleteResponseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getQueryAutoComplete(String query) async {
    try {
      Response? response = await RestClient.getData(
        ApiEndPoints.getQueryAutoComplete(query),
      );
      QueryAutoCompleteResponseModel queryAutoCompleteResponseModel =
          queryAutoCompleteResponseModelFromJson(response.toString());
      return ApiResult.success(data: queryAutoCompleteResponseModel);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }

  @override
  Future getDirection(String origin, String destination) async {
    try {
      Response? response = await RestClient.getData(
        ApiEndPoints.getDirection(origin, destination),
      );
      var json = convert.jsonDecode(response.toString());
      return ApiResult.success(data: json);
    } catch (err) {
      return ApiResult.failure(error: NetworkExceptions.getDioException(err));
    }
  }
}
