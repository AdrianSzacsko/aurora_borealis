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

class ProfileNetwork with ChangeNotifier {
  Future<dynamic> getProfile(int profileId) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

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

  Future<dynamic> likeOrDislike(int profileId, bool status) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.put(urlKey + 'profile/like_dislike', data: {
        'profile_id': profileId,
        'interaction': status
      });
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
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'profile/search/' + search);
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> putProfilePic(XFile? image) async {
    final String? mimeType = mime(image!.path);
    final File file = File(image.path);
    print(mimeType.toString().split("/")[1]);
    String filetype = mimeType.toString().split("/")[1];

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: 'image.' + filetype,
        contentType: MediaType('image', filetype),
      ),
    });


    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'image.' + filetype;
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;
    dio.options.headers['responseType'] = ResponseType.plain;

    try {
      response = await dio.put(urlKey + 'profile/pic', data: formData);
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }
}