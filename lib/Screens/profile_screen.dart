import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import 'register_screen.dart';
import '../Components/app_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomMap(
              mapController: _mapController,
              //coors: latLng.LatLng(48.269798, 19.820565),
              onLongPress: null,
            ),
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
                      padding: const EdgeInsets.only(top: 50, right: 16, left: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                        ],
                      )
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}