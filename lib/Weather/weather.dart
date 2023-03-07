
import 'package:json_annotation/json_annotation.dart';

part 'weather.g.dart';

@JsonSerializable(includeIfNull: false)
class Weather{
  final double coord_lat;
  final double coord_lon;
  final int timezone;
  final String name;
  final String sys_country;
  final int sys_sunset;
  final int sys_sunrise;

  Weather(this.coord_lat, this.coord_lon, this.timezone, this.name,
      this.sys_country, this.sys_sunset, this.sys_sunrise);

  factory Weather.fromJson(Map<String, dynamic> json) => _$WeatherFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherToJson(this);
}

@JsonSerializable(includeIfNull: false)
class WeatherVariables{
  String weather_main;
  String weather_icon;
  String weather_description;
  int weather_id;
  double main_temp;
  double main_temp_max;
  double main_temp_min;
  double main_feels_like;
  int main_pressure;
  int main_humidity;
  int main_sea_level;
  int main_grnd_level;
  int visibility;
  double wind_speed;
  int wind_deg;
  double wind_gust;
  double clouds_all;
  double rain_1h;
  double snow_1h;
  double pop;

  WeatherVariables(
      this.weather_main,
      this.weather_icon,
      this.weather_description,
      this.weather_id,
      this.main_temp,
      this.main_temp_max,
      this.main_temp_min,
      this.main_feels_like,
      this.main_pressure,
      this.main_humidity,
      this.main_sea_level,
      this.main_grnd_level,
      this.visibility,
      this.wind_speed,
      this.wind_deg,
      this.wind_gust,
      this.clouds_all,
      this.rain_1h,
      this.snow_1h,
      this.pop);

  factory WeatherVariables.fromJson(Map<String, dynamic> json) => _$WeatherVariablesFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherVariablesToJson(this);
}

@JsonSerializable(includeIfNull: false)
class WeatherVariablesDaily{
  double temp_day;
  double temp_min;
  double temp_max;
  double temp_night;
  double temp_eve;
  double temp_morn;
  double feels_like_day;
  double feels_like_night;
  double feels_like_eve;
  double feels_like_morn;
  int pressure;
  int humidity;
  String weather_main;
  String weather_icon;
  String weather_description;
  int weather_id;
  double wind_speed;
  int wind_deg;
  double wind_gust;
  double clouds;
  double rain;
  double snow;
  double pop;


  WeatherVariablesDaily(this.temp_day, this.temp_min, this.temp_max,
      this.temp_night, this.temp_eve, this.temp_morn, this.feels_like_day,
      this.feels_like_night, this.feels_like_eve, this.feels_like_morn,
      this.pressure, this.humidity, this.weather_main, this.weather_icon,
      this.weather_description, this.weather_id, this.wind_speed, this.wind_deg,
      this.wind_gust, this.clouds, this.rain, this.snow, this.pop);

  factory WeatherVariablesDaily.fromJson(Map<String, dynamic> json) => _$WeatherVariablesDailyFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherVariablesDailyToJson(this);
}