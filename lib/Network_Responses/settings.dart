import 'package:aurora_borealis/Network/farm.dart';
import 'package:aurora_borealis/Network/settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';

part 'settings.g.dart';

@JsonSerializable()
class Settings{
  bool weather_notifications = false;
  bool news_notifications = false;


  Settings(this.weather_notifications, this.news_notifications);

  Settings._create();

  static Future<Settings> create(context) async {
    var component = Settings._create();

    var response = await SettingsNetwork().getNotifications();

    if (response == null){
      errorResponseBar("Connection Error", context);
      return component;
    }

    if (response.statusCode == 200){
      component = Settings.fromJson(response.data);
    }
    else if (response.statusCode == 401){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
    }
    else{
      errorResponseBar("Something went wrong", context);
    }

    return component;
  }

  static Future<void> setValues(bool weather, bool news, context) async {
    Response? response = await SettingsNetwork().setNotifications(weather, news);

    if (response == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
      return;
    }

    if (response.statusCode == 200){
      return;
    }
    else {
      errorResponseBar("Something went wrong", context);
    }
  }

  factory Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsToJson(this);
}
