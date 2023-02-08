import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:googleplaceapidemo/framework/network/apis/dio_logger.dart';

class RestClient {
  static var dio = Dio();

  static Future<Response> getData(String endpoint) async {
    try {
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      /*if (token != "") {
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }*/

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.get(endpoint);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> postData(String endpoint, String req) async {
    try {
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      /*if (token != "") {
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }*/

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.post(endpoint, data: req);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> postForm(String endpoint, FormData formData) async {
    try {
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      /*if (token != "") {
        headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }*/

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.post(endpoint, data: formData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> putData(String endpoint, Map<String, dynamic> req,
      {String? s, String? userId}) async {
    try {
      String data = jsonEncode(req);
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      // if(token != ""){
      //   headers.addAll({"X-Auth-Token": token});
      // }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.put(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> putForm(String endpoint, FormData formData) async {
    try {
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      // if(token != ""){
      //   headers.addAll({"X-Auth-Token": token});
      // }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.put(endpoint, data: formData);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> deleteData(
      String endpoint, Map<String, dynamic> req) async {
    try {
      String data = jsonEncode(req);
      /*String token = getUserAccessToken();*/

      Map<String, dynamic>? headers = {
        "Accept": "application/json",
        "Accept-Language": "en",
      };

      // if(token != ""){
      //   headers.addAll({"X-Auth-Token": token});
      // }

      var dioAuth = Dio(BaseOptions(headers: headers));
      dioAuth.interceptors.add(DioLogger());
      Response response = await dioAuth.delete(endpoint, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
