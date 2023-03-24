import 'package:aurora_borealis/Components/custom_chart.dart';
import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Components/custom_network_image.dart';
import 'package:aurora_borealis/Components/post_item.dart';
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

class FeedScreenState extends State<FeedScreen> {
  MapController mapController = MapController();
  late PageController _pageController;
  late latLng.LatLng currentPosition;
  int user_id = 0;

  int activePage = 1;

  Future<void> _getCurrentLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = latLng.LatLng(position.latitude, position.longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const NotLoggedInScreen();
    } else {
      user_id = ModalRoute.of(context)!.settings.arguments as int;

      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: myAppBar(context),
        floatingActionButton: FloatingActionButton(
          onPressed: () {  },
          child: const Icon(Icons.add_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: Image.asset(
                            'assets/images/backgroundGreen.jpg',
                          ).image,
                          colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.2), BlendMode.dstATop),
                        ),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40))),
                    child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: PageView.builder(
                                itemCount: 1,
                                pageSnapping: true,
                                controller: _pageController,
                                onPageChanged: (page) {
                                  setState(() {
                                    activePage = page;
                                  });
                                },
                                itemBuilder: (context, pagePosition) {
                                  return const PostItem();
                                }),
                          )
                        )
                    )
                )
            ),
          ],
        ),
      );
    }
  }
}
