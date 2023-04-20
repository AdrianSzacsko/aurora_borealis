import 'dart:math';

import 'package:aurora_borealis/Network_Responses/weather.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../Network_Responses/weather_data.dart';
import '../Screens/weather_main_screen.dart';
import 'oval_component.dart';

enum Daily{
  Temperature_at_day,
  Minimum_temperature,
  Maximum_temperature,
  Temperature_at_night,
  Evening_temperature,
  Morning_temperature,
  Pressure,
  Humiditiy,
  Wind,
  Clouds,
  Rain,
  Snow
}

enum Hourly{
  Temperature,
  Minimum_temperature,
  Maximum_temperature,
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
        case Daily.Minimum_temperature:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_min)).values.toList();
          break;
        case Daily.Maximum_temperature:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_max)).values.toList();
          break;
        case Daily.Temperature_at_night:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_night)).values.toList();
          break;
        case Daily.Evening_temperature:
          weatherDataListValues = weatherData.dailyWeather.asMap().map((key, value) =>
              MapEntry(key, value.temp_eve)).values.toList();
          break;
        case Daily.Morning_temperature:
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
        case Daily.Temperature_at_day:
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
        case Hourly.Minimum_temperature:
          weatherDataListValues = weatherData.hourlyWeather.asMap().map((key, value) =>
              MapEntry(key, value.main_temp_min)).values.toList();
          break;
        case Hourly.Maximum_temperature:
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
                    child: Text(value.toString().split("_").join(" ")),
                  );
                }).toList(),
              ),
            ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  height: 200,
                  width: weatherDataListValues.length * 51,
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
              touchCallback: (event, response) {
                if (event is FlTapUpEvent) {
                  if (response != null && response.lineBarSpots != null) {
                    if (response.lineBarSpots?.length == 1){
                      showDialog(context: context, builder: (context){
                        return WeatherDialog(weatherData, weatherType,
                          response.lineBarSpots![0].spotIndex,
                            widget.weatherType == WeatherType.daily ?
                            getWeekDay(response.lineBarSpots![0].spotIndex.toDouble()) :
                            getHour(response.lineBarSpots![0].spotIndex.toDouble())
                        );
                      });
                    }
                    //print(event);
                    //print(response.lineBarSpots?.length);
                  }
                }
              },
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
                      getTitlesWidget: (value, meta) {
                        if (value == meta.max || value == meta.min){
                          return Container();
                        }
                        else {
                          return Text(value.toStringAsFixed(0));
                        }
                      }
                    ),
                )
            )
        )
    );
  }

  String? getHour(double value){
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    int hour = currentHour + value.toInt() + 1;
    if (hour > 23) {
      hour = hour - 24;
    }

    return hour.toString() + ":00";
  }

  Widget bottomTitleWidgetsHourly(double value, TitleMeta meta) {

    String text = getHour(value)! + "";
    return RotationTransition(turns: const AlwaysStoppedAnimation(300/360), child: Text(text, textAlign: TextAlign.right));
    //return FittedBox(child: Text(text, style: style, textAlign: TextAlign.center), fit: BoxFit.fitWidth, );
  }

  String? getWeekDay(double value){
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


    return weekdayName[day];
  }

  Widget bottomTitleWidgetsDaily(double value, TitleMeta meta) {
    String? text = getWeekDay(value);
    return RotationTransition(turns: const AlwaysStoppedAnimation(300/360), child: Text(text!, textAlign: TextAlign.right));
  }

}

class WeatherDialog extends StatefulWidget {
  final WeatherData weatherData;
  final WeatherType weatherType;
  final int index;
  final String? title;

  const WeatherDialog(this.weatherData, this.weatherType, this.index, this.title, {Key? key}) : super(key: key);

  @override
  WeatherDialogState createState() => WeatherDialogState();
}

class WeatherDialogState extends State<WeatherDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      title: Center(child: Text(widget.weatherData.weatherInfo.name + " " + widget.title!)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            mainStats(widget.weatherData),
            advancedStats(widget.weatherData, widget.weatherType, widget.index),
          ],
        )
      ),
    );
  }

  List<MapEntry<String, String>> getHourlyStats(){

    var weatherData = widget.weatherData;
    int index = widget.index;
    Map<String, String> weatherStatsHourly = {
      'Temperature': weatherData.hourlyWeather[index].main_temp.toString() + ' °C',
      'Min. Temp.': weatherData.hourlyWeather[index].main_temp_min.toString() + ' °C',
      'Max. Temp.': weatherData.hourlyWeather[index].main_temp_max.toString() + ' °C',
      'Feels like': weatherData.hourlyWeather[index].main_feels_like.toString() + ' °C',
      'Pressure': weatherData.hourlyWeather[index].main_pressure.toString() + ' hPa',
      'Sea level': weatherData.hourlyWeather[index].main_sea_level.toString() + ' hPa',
      'Ground level': weatherData.hourlyWeather[index].main_grnd_level.toString() + ' hPa',
      'Humidity': weatherData.hourlyWeather[index].main_humidity.toString() + ' %',
      'Visibility': weatherData.hourlyWeather[index].visibility.toString() + ' m',
      'Wind Speed': weatherData.hourlyWeather[index].wind_speed.toString() + ' m/s',
      'Wind Gust': weatherData.hourlyWeather[index].wind_gust.toString() + ' m/s',
      'Wind Degrees': weatherData.hourlyWeather[index].wind_deg.toString() + ' °',
      'Clouds': weatherData.hourlyWeather[index].clouds_all.toString() + ' %',
      'Rain': weatherData.hourlyWeather[index].rain_1h.toString() + ' mm',
      'Snow': weatherData.hourlyWeather[index].snow_1h.toString() + ' mm',
    };
    return weatherStatsHourly.entries.toList();
  }

  List<MapEntry<String, String>> getDailyStats(){

    var weatherData = widget.weatherData;
    int index = widget.index;
  Map<String, String> weatherStatsDaily = {
    'Day temp.': weatherData.dailyWeather[index].temp_day.toString() + ' °C',
    'Night temp.': weatherData.dailyWeather[index].temp_night.toString() + ' °C',
    'Evening temp.': weatherData.dailyWeather[index].temp_eve.toString() + ' °C',
    'Morning temp.': weatherData.dailyWeather[index].temp_morn.toString() + ' °C',
    'Min. Temp.': weatherData.dailyWeather[index].temp_min.toString() + ' °C',
    'Max. Temp.': weatherData.dailyWeather[index].temp_max.toString() + ' °C',
    'Feels like': weatherData.dailyWeather[index].feels_like_day.toString() + ' °C',
    'Pressure': weatherData.dailyWeather[index].pressure.toString() + ' hPa',
    'Humidity': weatherData.dailyWeather[index].humidity.toString() + ' %',
    'Wind Speed': weatherData.dailyWeather[index].wind_speed.toString() + ' m/s',
    'Wind Gust': weatherData.dailyWeather[index].wind_gust.toString() + ' m/s',
    'Wind Degrees': weatherData.dailyWeather[index].wind_deg.toString() + ' °',
    'Clouds': weatherData.dailyWeather[index].clouds.toString() + ' %',
    'Rain': weatherData.dailyWeather[index].rain.toString() + ' mm',
    'Snow': weatherData.dailyWeather[index].snow.toString() + ' mm',
  };
  return weatherStatsDaily.entries.toList();
}

  Widget advancedStats(WeatherData weatherData, WeatherType weatherType, int index){

    late List<MapEntry<String, String>> weatherStatsEntries;

    if (weatherType == WeatherType.daily){
      weatherStatsEntries = getDailyStats();
    }
    else{
      weatherStatsEntries = getHourlyStats();
    }

    List<Widget> boxes = [];

    for (int i = 0; i < weatherStatsEntries.length ; i++) {
      boxes.add(
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Column(
              children: [
                Text(weatherStatsEntries[i].key,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                weatherText(weatherStatsEntries[i].value, 18),
              ],
            ),
          )
      );
    }

    return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  for (int i = 0; i < boxes.length; i += 2)
                    boxes[i]
                ],
              ),
              const SizedBox(width: 20),
              Column(
                children: [
                  for (int i = 1; i < boxes.length; i += 2)
                    boxes[i]
                ],
              ),
            ],
          ),
        )
    );

  }

  Widget mainStats(WeatherData weatherData){
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomContainer(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      weatherText(weatherData.weatherInfo.name, 22),
                      widget.weatherType == WeatherType.daily ?
                      weatherText(weatherData.dailyWeather[widget.index].temp_day.toString() +' °C', 28) :
                      weatherText(weatherData.hourlyWeather[widget.index].main_temp.toString() +' °C', 28),
                      widget.weatherType == WeatherType.daily ?
                      weatherText(weatherData.dailyWeather[widget.index].weather_main.toString(), 22) :
                      weatherText(weatherData.hourlyWeather[widget.index].weather_main.toString(), 22),
                    ],
                  ),
                )
            ),
            Column(
              children: [
                CustomContainer(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            weatherData.currentWeather.snow_1h == 0 ?
                            const Icon(
                                Icons.water_drop_outlined) :
                            const Icon(
                                Icons.snowing),
                            widget.weatherType == WeatherType.daily ?
                            weatherText(
                                weatherData.dailyWeather[widget.index].snow == 0 ? weatherData.dailyWeather[widget.index].rain.toString()  + ' mm' :
                                weatherData.dailyWeather[widget.index].snow.toString()
                                    + ' mm', 15) :
                            weatherText(
                                weatherData.hourlyWeather[widget.index].snow_1h == 0 ? weatherData.hourlyWeather[widget.index].rain_1h.toString()  + ' mm' :
                                weatherData.hourlyWeather[widget.index].snow_1h.toString()
                                    + ' mm', 15)
                          ],
                        ))),
                const SizedBox(
                  height: 5,
                ),
                CustomContainer(
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Row(
                          children: [
                            const Icon(Icons.air),
                            widget.weatherType == WeatherType.daily ?
                            weatherText(weatherData.dailyWeather[widget.index].wind_speed.toString() + ' m/s', 15) :
                            weatherText(weatherData.hourlyWeather[widget.index].wind_speed.toString() + ' m/s', 15),
                          ],
                        ))),
              ],
            )
          ],
        ),
        //min and max temps
        SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomContainer(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.thermostat,
                            color: Colors.blue,
                          ),
                          widget.weatherType == WeatherType.daily ?
                          weatherText(weatherData.dailyWeather[widget.index].temp_min.toString() + ' °C', 15) :
                          weatherText(weatherData.hourlyWeather[widget.index].main_temp_min.toString() + ' °C', 15)
                        ],
                      ))),
              const SizedBox(
                width: 5,
              ),
              CustomContainer(
                  child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          const Icon(Icons.thermostat,
                              color: Colors.red),
                          widget.weatherType == WeatherType.daily ?
                          weatherText(weatherData.dailyWeather[widget.index].temp_max.toString() + ' °C', 15) :
                          weatherText(weatherData.hourlyWeather[widget.index].main_temp_max.toString() + ' °C', 15)
                        ],
                      )
                  )
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget weatherText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
