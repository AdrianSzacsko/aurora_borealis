import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:aurora_borealis/key.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_interceptor.dart';

class SettingsNetwork with ChangeNotifier {
  Future<dynamic> getNotifications() async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'settings/notifications/');
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> setNotifications(bool news) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.put(urlKey + 'settings/notifications/', data: {
        'news_notifications': news
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> setFCM(String fcmToken) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;
    try {
      response = await dio.put(urlKey + 'settings/fcm_token', data: {
        'fcm_token': fcmToken,
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> logout() async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;
    try {
      response = await dio.put(urlKey + 'settings/logout');
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

}