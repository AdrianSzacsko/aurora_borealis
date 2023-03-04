import 'package:dio/dio.dart';

import 'weather.dart';
import 'package:aurora_borealis/Network/weather.dart';

class WeatherData {
  final double lat;
  final double long;
  late Weather weatherInfo;
  late WeatherVariables currentWeather;
  late List<WeatherVariables> hourlyWeather;
  
  
  /// Private constructor
  WeatherData._create(this.lat, this.long) {
    // Do most of your initialization here, that's what a constructor is for
    //...
  }

  /// Public factory
  static Future<WeatherData> create(double lat, double long) async {

    // Call the private constructor
    var component = WeatherData._create(lat, long);

    var responseCurr = await WeatherNetwork().getCurrentWeather(lat, long);
    var responseHourly = await WeatherNetwork().getHourlyWeather(lat, long);


    if (responseCurr.statusCode == 200 && responseHourly.statusCode == 200) {
      component.fromJson(responseCurr.data, responseHourly.data);

    }



    // Do initialization that requires async
    //await component._complexAsyncInit();

    // Return the fully initialized object
    return component;
  }


  fromJson(Map<String, dynamic> jsonCurr, Map<String, dynamic> jsonHourly){
    weatherInfo = Weather.fromJson(jsonCurr['weather']);
    currentWeather = WeatherVariables.fromJson(jsonCurr['variables']);
    List<WeatherVariables> temp = [];
    for (int i = 0; i < jsonHourly['variables'].length; i++){
      temp.add(WeatherVariables.fromJson(jsonHourly['variables'][i]));
    }

    hourlyWeather = temp;
  }
}