import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:aurora_borealis/key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FarmNetwork with ChangeNotifier {
  Future<dynamic> postFarm(String farmName, double lat, double long) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.post(urlKey + 'farms/' , data: {
        'name': farmName,
        'latitude': lat,
        'longitude': long
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> deleteFarm(int id) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.delete(urlKey + 'farms/' , data: {
        'id': id
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> getFarms() async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.post(urlKey + 'farms/');
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }
}