import 'package:aurora_borealis/Weather/weather.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/oval_component.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../Components/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Weather/hourly_weather_data.dart';

class WeatherMainScreen extends StatefulWidget {
  const WeatherMainScreen({Key? key}) : super(key: key);

  @override
  WeatherMainScreenState createState() => WeatherMainScreenState();
}

class WeatherMainScreenState extends State<WeatherMainScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Placeholder(),
          ),

        FutureBuilder(
          future: WeatherData.create(48.269798, 19.820565),
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
          height: MediaQuery.of(context).size.height * 0.7,
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
                            width: 4000,
                            child: createChart(weatherData),
                          ),
                        ),
                      )
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  //daily forecast

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
      'Temperature': weatherVariables.main_temp.toString(),
      'Min. Temperature': weatherVariables.main_temp_min.toString(),
      'Max. Temperature': weatherVariables.main_temp_max.toString(),
      'Feels like': weatherVariables.main_feels_like.toString(),
      'Pressure': weatherVariables.main_pressure.toString(),
      'Sea level': weatherVariables.main_sea_level.toString(),
      'Ground level': weatherVariables.main_grnd_level.toString(),
      'Humidity': weatherVariables.main_humidity.toString(),
      'Visibility': weatherVariables.visibility.toString(),
      'Wind Speed': weatherVariables.wind_speed.toString(),
      'Wind Gust': weatherVariables.wind_gust.toString(),
      'Wind Degrees': weatherVariables.wind_deg.toString(),
      'Clouds': weatherVariables.clouds_all.toString(),
      'Rain': weatherVariables.rain_1h.toString(),
      'Snow': weatherVariables.snow_1h.toString(),
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

        /*child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < boxes.length; i += 2)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  boxes[i],
                  if (i + 1 < boxes.length) boxes[i + 1],
                ],
              ),
            const SizedBox(height: 16.0),
          ],
        ),*/
      )
    );
  }


  //create chart
  Widget createChart(WeatherData weatherData){
          return LineChart(
              LineChartData(
                lineBarsData: [
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
                      getTitlesWidget: bottomTitleWidgets,
                    )
                  ),
                )
              )
          );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
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

  Widget weatherText(String text, double fontSize) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
    );
  }
}
