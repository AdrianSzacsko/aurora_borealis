import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Network_Responses/weather_data.dart';
import '../Screens/weather_main_screen.dart';
import 'oval_component.dart';

enum Daily{
  DayTemp,
  MinimumTemp,
  MaximumTemp,
  NightTemp,
  EveningTemp,
  MorningTemp,
  Pressure,
  Humiditiy,
  Wind,
  Clouds,
  Rain,
  Snow
}

enum Hourly{
  Temperature,
  MinimumTemp,
  MaximumTemp,
  Pressure,
  Humiditiy,
  Wind,
  Clouds,
  Rain,
  Snow
}



class CustomChart extends StatefulWidget {
  final WeatherData weatherData;
  final WeatherType weatherType;

  const CustomChart({
    required this.weatherData,
    required this.weatherType,
    Key? key
  }) : super(key: key);

  @override
  _CustomChartState createState() => _CustomChartState();
}

class _CustomChartState extends State<CustomChart> {
  // Define any state variables or methods needed for your chart here
  late WeatherData weatherData;
  late WeatherType weatherType;
  late String dropdownValue;
  late List<String> weatherDataList;
  late List<double> weatherDataListValues;


  @override
  void initState() {
    super.initState();
    weatherData = widget.weatherData;
    weatherType = widget.weatherType;
    createList();
    dropdownValue = weatherDataList.first;
    createListValues(dropdownValue);
  }

  void createList(){
    if (weatherType == WeatherType.daily){
      weatherDataList = Daily.values.map((e) => e.name).toList();
    }
    else{
      weatherDataList = Hourly.values.map((e) => e.name).toList();
    }
  }

  void createListValues(String choice){
    weatherDataListValues = [];

    if (weatherType == WeatherType.daily){
      switch (Daily.values.byName(choice)){
        case Daily.MinimumTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_min)).values.toList();
          break;
        case Daily.MaximumTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_max)).values.toList();
          break;
        case Daily.NightTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_night)).values.toList();
          break;
        case Daily.EveningTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_eve)).values.toList();
          break;
        case Daily.MorningTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_morn)).values.toList();
          break;
        case Daily.Pressure:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.pressure.toDouble())).values.toList();
          break;
        case Daily.Humiditiy:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.humidity.toDouble())).values.toList();
          break;
        case Daily.Wind:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.wind_speed)).values.toList();
          break;
        case Daily.Clouds:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.clouds)).values.toList();
          break;
        case Daily.Rain:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.rain)).values.toList();
          break;
        case Daily.Snow:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.snow)).values.toList();
          break;
        case Daily.DayTemp:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_day)).values.toList();
          break;
      }
    }
    else{
      switch (Hourly.values.byName(choice)){

        case Hourly.Temperature:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_temp)).values.toList();
          break;
        case Hourly.MinimumTemp:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_temp_min)).values.toList();
          break;
        case Hourly.MaximumTemp:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_temp_max)).values.toList();
          break;
        case Hourly.Pressure:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_pressure.toDouble())).values.toList();
          break;
        case Hourly.Humiditiy:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_humidity.toDouble())).values.toList();
          break;
        case Hourly.Wind:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.wind_speed)).values.toList();
          break;
        case Hourly.Clouds:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.clouds_all)).values.toList();
          break;
        case Hourly.Rain:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.rain_1h)).values.toList();
          break;
        case Hourly.Snow:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.snow_1h)).values.toList();
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Implement your chart UI here, using the state variables and methods defined above
    // You can access the WeatherData object through the _weatherData variable

    return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
            Align(
              alignment: AlignmentDirectional.topCenter,
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                underline: Container(
                  height: 2,
                  color: Colors.green.shade900,
                ),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                    createListValues(dropdownValue);
                  });
                },
                items: weatherDataList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 200,
                  width: 800,
                  child: createChart(),
                ),
              ),
            ],
          )
        )
    );
  }


  Widget createChart(){
    return LineChart(
        LineChartData(

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return null;
                }).toList();
                },
            )
          ),
          gridData: FlGridData(
            show: false,
          ),

            lineBarsData: [
              LineChartBarData(
                color: Colors.green,
                //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                spots: weatherDataListValues.asMap().map((key, value) =>
                    MapEntry(key, FlSpot(key.toDouble(), value)),).values.toList(),
                isCurved: true,
                // dotData: FlDotData(
                //   show: false,
                // ),
              )
            ],
            minY: weatherDataListValues.reduce(min) - 1,
            maxY: weatherDataListValues.reduce(max) + 5,
            borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.green.shade900)

            ),
            titlesData: FlTitlesData(
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: false
                  ),
                ),
                bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 45,
                      showTitles: true,
                      getTitlesWidget: weatherType == WeatherType.hourly ?
                      bottomTitleWidgetsHourly
                          :
                      bottomTitleWidgetsDaily,
                    )
                ),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 30,
                      showTitles: true,
                    )
                )
            )
        )
    );
  }

  Widget bottomTitleWidgetsHourly(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    int hour = currentHour + value.toInt() + 1;
    if (hour > 23) {
      hour = hour - 24;
    }

    String text = hour.toString() + ":00";
    return RotationTransition(turns: const AlwaysStoppedAnimation(300/360), child: Text(text, textAlign: TextAlign.right));
    //return FittedBox(child: Text(text, style: style, textAlign: TextAlign.center), fit: BoxFit.fitWidth, );
  }

  Widget bottomTitleWidgetsDaily(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    int currentDay = now.weekday - 1;

    int day = currentDay + value.toInt();
    if (day >= 7){
      day = day % 7;
    }

    const Map<int, String> weekdayName = {
      0: "Monday",
      1: "Tuesday",
      2: "Wednesday",
      3: "Thursday",
      4: "Friday",
      5: "Saturday",
      6: "Sunday"
    };


    String? text = weekdayName[day];
    return RotationTransition(turns: const AlwaysStoppedAnimation(300/360), child: Text(text!, textAlign: TextAlign.right));
  }

}
