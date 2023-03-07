import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Weather/weather.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/oval_component.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../Components/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Weather/weather_data.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';


class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({Key? key}) : super(key: key);

  @override
  WeatherMainScreenState createState() => WeatherMainScreenState();
}

enum WeatherType {
  daily,
  hourly
}

//https://stackoverflow.com/questions/54371874/how-get-the-name-of-the-days-of-the-week-in-dart

class WeatherMainScreenState extends State<WeatherMainScreen> {

  MapController mapController = MapController();
  late latLng.LatLng currentPosition;


  void handleLongPressInMap(latLng.LatLng point){
    setState(() {
      currentPosition = point;
      print(point);
    });
  }

  Future<void> _getCurrentLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = latLng.LatLng(position.latitude,
          position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
      _getCurrentLocation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomMap(
                mapController: mapController,
                //coors: latLng.LatLng(currentPosition.latitude, currentPosition.longitude),
              onLongPress: handleLongPressInMap,
            ),
          ),

        FutureBuilder(
          future: Future.microtask(() => WeatherData.create(currentPosition.latitude, currentPosition.longitude)),
          builder: (
              BuildContext context,
              AsyncSnapshot<dynamic> snapshot
              ) {
            if (snapshot.hasData){

              WeatherData weatherData = snapshot.data as WeatherData;

              //return Text(data.currentWeather.weather_main);
              return weatherBody(weatherData);
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        ],
      ),
    );
  }


  //main body of the weather screen
  Widget weatherBody(WeatherData weatherData){
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40),
                  topLeft: Radius.circular(40))),
          child: SingleChildScrollView(
            child: Padding(
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //first row with basic statistics
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
                                weatherText(weatherData.currentWeather.main_temp.toString() +' °C', 28),
                                weatherText(weatherData.currentWeather.weather_main, 22),
                              ],
                            ),
                          )),
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
                                      weatherText(
                                          weatherData.currentWeather.snow_1h == 0 ? weatherData.currentWeather.rain_1h.toString()  + ' mm' :
                                          weatherData.currentWeather.snow_1h.toString()
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
                                      weatherText(weatherData.currentWeather.wind_speed.toString() + ' m/s', 15)
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
                                    weatherText(weatherData.currentWeather.main_temp_min.toString() + ' °C', 15)
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
                                    weatherText(weatherData.currentWeather.main_temp_max.toString() + ' °C', 15)
                                  ],
                                ))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //hourly forecast
                  CustomContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 200,
                            width: 1000,
                            child: createChart(weatherData, WeatherType.hourly),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //daily forecast
                  CustomContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 200,
                            width: 700,
                            child: createChart(weatherData, WeatherType.daily),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //Advanced statistics
                  advancedStats(weatherData.currentWeather),
                  const SizedBox(
                    height: 5,
                  ),

                ],
              ),
            ),
          )),
    );
  }

  Widget advancedStats(WeatherVariables weatherVariables){

    Map<String, String> weatherStats = {
      'Temperature': weatherVariables.main_temp.toString() + ' °C',
      'Min. Temperature': weatherVariables.main_temp_min.toString() + ' °C',
      'Max. Temperature': weatherVariables.main_temp_max.toString() + ' °C',
      'Feels like': weatherVariables.main_feels_like.toString() + ' °C',
      'Pressure': weatherVariables.main_pressure.toString() + ' hPa',
      'Sea level': weatherVariables.main_sea_level.toString() + ' hPa',
      'Ground level': weatherVariables.main_grnd_level.toString() + ' hPa',
      'Humidity': weatherVariables.main_humidity.toString() + ' %',
      'Visibility': weatherVariables.visibility.toString() + ' m',
      'Wind Speed': weatherVariables.wind_speed.toString() + ' m/s',
      'Wind Gust': weatherVariables.wind_gust.toString() + ' m/s',
      'Wind Degrees': weatherVariables.wind_deg.toString() + ' °',
      'Clouds': weatherVariables.clouds_all.toString() + ' %',
      'Rain': weatherVariables.rain_1h.toString() + ' mm',
      'Snow': weatherVariables.snow_1h.toString() + ' mm',
    };

    List<MapEntry<String, String>> weatherStatsEntries = weatherStats.entries.toList();

    List<Widget> boxes = [];

    for (int i = 0; i < weatherStatsEntries.length ; i++) {
      boxes.add(
        Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
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


  //create chart
  Widget createChart(WeatherData weatherData, WeatherType weatherType){
          return LineChart(
              LineChartData(
                lineBarsData: [
                  weatherType == WeatherType.hourly ?
                  LineChartBarData(
                    //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                    spots: weatherData.hourlyWeather.asMap().map((index, element) => MapEntry(
                      index,
                      FlSpot(index.toDouble(), element.main_temp.toDouble()),
                    )).values.toList(),
                    isCurved: false,
                    // dotData: FlDotData(
                    //   show: false,
                    // ),
                  )
                  :
                  LineChartBarData(
                    //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                    spots: weatherData.dailyWeather.asMap().map((index, element) => MapEntry(
                      index,
                      FlSpot(index.toDouble(), element.temp_day.toDouble()),
                    )).values.toList(),
                    isCurved: false,
                    // dotData: FlDotData(
                    //   show: false,
                    // ),
                  ),
                ],
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 45,
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

  Widget weatherText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
