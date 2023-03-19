import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../Network_Responses/weather_data.dart';
import '../Screens/weather_main_screen.dart';
import 'oval_component.dart';

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

  @override
  void initState() {
    super.initState();
    weatherData = widget.weatherData;
    weatherType = widget.weatherType;
  }

  @override
  Widget build(BuildContext context) {
    // Implement your chart UI here, using the state variables and methods defined above
    // You can access the WeatherData object through the _weatherData variable

    return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              height: 200,
              width: 1000,
              child: createChart(),
            ),
          ),
        )
    );
  }


  Widget createChart(){
    return LineChart(
        LineChartData(
          gridData: FlGridData(
            show: false,
          ),

            lineBarsData: [
              weatherType == WeatherType.hourly ?
              LineChartBarData(
                color: Colors.green,
                //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                spots: weatherData.hourlyWeather.asMap().map((index, element) => MapEntry(
                  index,
                  FlSpot(index.toDouble(), element.main_temp.toDouble()),
                )).values.toList(),
                isCurved: true,
                // dotData: FlDotData(
                //   show: false,
                // ),
              )
                  :
              LineChartBarData(
                color: Colors.green,
                //spots: weatherData.map((point) => FlSpot(point.x, point.y)).toList(),
                spots: weatherData.dailyWeather.asMap().map((index, element) => MapEntry(
                  index,
                  FlSpot(index.toDouble(), element.temp_day.toDouble()),
                )).values.toList(),
                isCurved: true,
                // dotData: FlDotData(
                //   show: false,
                // ),
              ),
            ],

            /*minY: weatherType == WeatherType.hourly ?
                  createMinMax(weatherData, min, WeatherVariable.main_temp) :
                  createMinMax(weatherData, min, WeatherVariable.temp_day),
                  maxY: weatherType == WeatherType.hourly ?
                  createMinMax(weatherData, max, WeatherVariable.main_temp) :
                  createMinMax(weatherData, max, WeatherVariable.temp_day),*/
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
