import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Components/snackbar.dart';
import '../Screens/menu_screen.dart';
import 'weather.dart';
import 'package:aurora_borealis/Network/weather.dart';

class WeatherData {
  final double lat;
  final double long;
  late Weather weatherInfo;
  late WeatherVariables currentWeather;
  late List<WeatherVariables> hourlyWeather;
  late List<WeatherVariablesDaily> dailyWeather;
  
  
  /// Private constructor
  WeatherData._create(this.lat, this.long) {
    // Do most of your initialization here, that's what a constructor is for
    //...
  }

  /// Public factory
  static Future<WeatherData> create(double lat, double long, context) async {

    // Call the private constructor
    var component = WeatherData._create(lat, long);

    var responseCurr = await WeatherNetwork().getCurrentWeather(lat, long);
    var responseHourly = await WeatherNetwork().getHourlyWeather(lat, long);
    var responseDaily = await WeatherNetwork().getDailyWeather(lat, long);


    if (responseCurr == null || responseHourly == null || responseDaily == null){
      errorResponseBar("Connection Error", context);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }));
    }

    if (responseCurr.statusCode == 200 && responseHourly.statusCode == 200 &&
    responseDaily.statusCode == 200) {
      component.fromJson(responseCurr.data, responseHourly.data, responseDaily.data);

    }
    else if (responseCurr.statusCode == 401 || responseHourly.statusCode == 401 ||
        responseDaily.statusCode == 401){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
        return const MenuScreen();
      }), (r){
        return false;
      });
    }
    else{
      errorResponseBar("Something went wrong", context);
    }



    // Do initialization that requires async
    //await component._complexAsyncInit();

    // Return the fully initialized object
    return component;
  }


  fromJson(Map<String, dynamic> jsonCurr, Map<String, dynamic> jsonHourly, Map<String, dynamic> jsonDaily){
    weatherInfo = Weather.fromJson(jsonCurr['weather']);
    currentWeather = WeatherVariables.fromJson(jsonCurr['variables']);
    List<WeatherVariables> temp_h = [];
    for (int i = 0; i < jsonHourly['variables'].length; i++){
      temp_h.add(WeatherVariables.fromJson(jsonHourly['variables'][i]));
    }

    hourlyWeather = temp_h;

    List<WeatherVariablesDaily> temp_d = [];
    for (int i = 0; i < jsonDaily['variables'].length; i++){
      temp_d.add(WeatherVariablesDaily.fromJson(jsonDaily['variables'][i]));
    }

    dailyWeather = temp_d;
  }
}