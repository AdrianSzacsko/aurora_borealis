import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                width: MediaQuery.of(context).size.width,
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
                            Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      weatherText('Bratislava', 22),
                                      weatherText('5 °C', 28),
                                      weatherText('Cloudy', 22),
                                    ],
                                  ),
                                )),
                            Column(
                              children: [
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.water_drop_outlined),
                                            weatherText('0 mm', 15)
                                          ],
                                        ))),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: Colors.black,
                                        ),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.air),
                                            weatherText('5 m/s', 15)
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
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.thermostat,
                                            color: Colors.blue,
                                          ),
                                          weatherText('-2 °C', 15)
                                        ],
                                      ))),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.thermostat,
                                              color: Colors.red),
                                          weatherText('9 °C', 15)
                                        ],
                                      ))),
                            ],
                          ),
                        ),
                        //hourly forecast
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              /*child: LineChart(
                              LineChartData(
                                lineBarsData: [
                                  LineChartBarData(
                                    //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                                    spots: weatherData.hourlyWeather.map((e) => FlSpot(0, e.main_temp)).toList(),
                                    isCurved: false,
                                    // dotData: FlDotData(
                                    //   show: false,
                                    // ),
                                  ),
                                ],
                              )
                            ),*/
                              child: SizedBox(
                                height: 200,
                                width: 4000,
                                child: createChart(),
                              ),
                            ),
                          )
                        ),
                        //daily forecast
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  FutureBuilder createChart(){
    return FutureBuilder<WeatherData>(
      future: WeatherData.create(48.269798, 19.820565),
      builder: (
          BuildContext context,
          AsyncSnapshot<dynamic> snapshot
          ) {
        if (snapshot.hasData){

          var data = snapshot.data as WeatherData;

          //return Text(data.currentWeather.weather_main);

          return LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                    spots: data.hourlyWeather.asMap().map((index, element) => MapEntry(
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
        else{
          return const Text('Error');
        }
      },
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
