import 'package:aurora_borealis/Components/custom_chart.dart';
import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Network_Responses/weather.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/not_logged_in.dart';
import '../Components/oval_component.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../Components/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import '../Network_Responses/weather_data.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  FeedScreenState createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen>{

  MapController mapController = MapController();
  late latLng.LatLng currentPosition;
  int user_id = 0;


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
    if (ModalRoute
        .of(context)!
        .settings
        .arguments == null) {
      return const NotLoggedInScreen();
    } else {
      user_id = ModalRoute
          .of(context)!
          .settings
          .arguments as int;

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
              ),
            ),

            /*FutureBuilder(
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
          ),*/


          ],
        ),
      );
    }
  }

}