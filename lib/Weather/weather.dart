
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
  double main_temp;
  double main_feels_like;
  int main_pressure;
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
      this.main_temp,
      this.main_feels_like,
      this.main_pressure,
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