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

class FeedNetwork with ChangeNotifier {
  Future<dynamic> getFeed(double latitude, double longitude, int distance) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'feed/', queryParameters: {
        'distance_range': distance,
        'latitude': latitude,
        'longitude': longitude,
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> getProfileFeed(int user_id) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'feed/profile_feed/' + user_id.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  Future<dynamic> newPost(double latitude, double longitude, String category, String text) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.post(urlKey + 'feed/new_post', data: {
        'latitude': latitude,
        'longitude': longitude,
        'category': category,
        'text': text,
      });
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

  /*Future<dynamic> getPostPic(int id) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.get(urlKey + 'feed/post_pic/' + id.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }*/

  Future<dynamic> postPostPic(int postId, List<XFile> images) async {
    final formData = FormData();
    for (var i = 0; i < images.length; i++) {
      final String? mimeType = mime(images[i].path);
      final File file = File(images[i].path);
      //print(mimeType.toString().split("/")[1]);
      String filetype = mimeType.toString().split("/")[1];
      formData.files.add(MapEntry(
        'files',
        await MultipartFile.fromFile(
          file.path,
          filename: 'image$i.' + filetype,
          contentType: MediaType('image', filetype),
        ),
      ));
    }

    //formData.fields.add(MapEntry('post_id', postId.toString()));

    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    //dio.options.headers['content-Type'] = 'image.jpeg';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;
    dio.options.headers['responseType'] = ResponseType.plain;

    try {
      response = await dio.post(urlKey + 'feed/new_post_photos/' + postId.toString(), data: formData);
      /*response = await dio.post(
        urlKey + 'new_post_photos',
        data: formData,
        queryParameters: {'post_id': postId},
      );*/
      return response;
    } on DioError catch (e) {
      print(e);
      return e.response;
    }

    return null;
  }

  Future<dynamic> deletePost(int id) async {
    Response response;

    var dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.connectTimeout = const Duration(seconds: 5);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    dio.options.headers['authorization'] = "Bearer " + token;

    try {
      response = await dio.delete(urlKey + 'feed/' + id.toString());
      return response;
    }
    on DioError catch (e) {

      return e.response;
    }

    return null;
  }

}