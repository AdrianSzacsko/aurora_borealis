import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:aurora_borealis/key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class WeatherNetwork with ChangeNotifier {
  Future<dynamic> getCurrentWeather(double lat, double long) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token') ?? '';
    //dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'weather/curr/' +lat.toString() + '/' + long.toString());
      return response;
    }
    on DioError catch (e) {
      return e.response;
    }

    return null;
  }

  Future<dynamic> getHourlyWeather(double lat, double long) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token') ?? '';
    //dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'weather/hourly/' + lat.toString() + '/'+ long.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }
}