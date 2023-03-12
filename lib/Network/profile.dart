import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:aurora_borealis/key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileNetwork with ChangeNotifier {
  Future<dynamic> getProfile(int profileId) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'profile/' + profileId.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> getSearch(String search) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    //final prefs = await SharedPreferences.getInstance();
    //final token = prefs.getString('token') ?? '';
    //dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'weather/search/' + search);
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> getProfilePic(int id) async {
    Response response;

    var dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'profile/profile_pic/' + id.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }
}