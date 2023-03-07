import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart' as LatLng;
import 'package:geolocator/geolocator.dart';

class CustomMap extends StatefulWidget {
  CustomMap({
    Key? key,
    required this.mapController,
    this.coors,
    this.onLongPress,
  }) : super(key: key);

  final MapController mapController;
  LatLng.LatLng? coors;

  void Function(LatLng.LatLng point)? onLongPress;

  @override
  CustomMapState createState() => CustomMapState();
}

class CustomMapState extends State<CustomMap>{

  late Position currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((value) => {
    if (widget.coors == null){
      widget.coors = LatLng.LatLng(currentPosition.latitude, currentPosition.longitude,),
      _goToCurrentLocation()
    }
    });

  }

  Future<void> _getCurrentLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
    });
  }

  void _goToCurrentLocation() {
    widget.mapController.move(
      LatLng.LatLng(currentPosition.latitude, currentPosition.longitude),
      16.0,
    );
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FlutterMap(
        mapController: widget.mapController,
        options: MapOptions(
          center: widget.coors,
          onLongPress: (tapPosition, point) => {
            widget.onLongPress!(point),
          }
        ),
        children: [
          TileLayer(
            minZoom: 1,
            maxZoom: 18,
            backgroundColor: Colors.black,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.aurora_borealis',
          ),
          CurrentLocationLayer(),
          Positioned(
            top: 5,
            right: 5,
            child: FloatingActionButton(
              onPressed: _goToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],

        nonRotatedChildren: [],
      ),
    );
  }

}