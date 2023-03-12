import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Components/custom_network_image.dart';
import 'package:aurora_borealis/Network/farm.dart';
import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Network_Responses/profile.dart';
import '../key.dart';
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
    final int user_id = ModalRoute.of(context)!.settings.arguments as int;

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
          FutureBuilder(
              future: Profile.create(user_id),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  //TODO add variable for my_profile or not

                  Profile profile = snapshot.data as Profile;
                  bool myProfile = user_id == profile.id;

                  return Align(
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
                              padding: const EdgeInsets.only(
                                  top: 20, right: 16, left: 16),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CustomNetworkImage(
                                        url: urlKey +
                                            'profile/profile_pic/' +
                                            profile.id.toString(),
                                      ),
                                      SizedBox(
                                        child: Column(
                                          children: [
                                            Text(
                                              profile.first_name +
                                                  " " +
                                                  profile.last_name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            !myProfile
                                                ? Row(
                                                    children: [
                                                      FilledButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Like")),
                                                      const SizedBox(
                                                        width: 20,
                                                      ),
                                                      FilledButton(
                                                          onPressed: () {},
                                                          child: const Text(
                                                              "Dislike"))
                                                    ],
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      counter(profile.post_count, "Posts"),
                                      counter(profile.like_count, "Likes"),
                                      counter(
                                          profile.dislike_count, "Dislikes"),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.lightGreen.shade900,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "FARMS ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                  color: primaryColor.shade900),
                                            ),
                                            myProfile ? TextButton(
                                                onPressed: () async {
                                                  MapDialog mapDialog =
                                                      MapDialog();
                                                  await mapDialog
                                                      .dialogAddFarm(context);
                                                  setState(() {});
                                                },
                                                child: Text(
                                                  'ADD FARM',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 17,
                                                      color: primaryColor
                                                          .shade900),
                                                )) : const SizedBox(),
                                          ],
                                        )),
                                  ),
                                  Divider(
                                    color: Colors.lightGreen.shade900,
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    width: double.infinity,
                                    child: ListView.builder(
                                      itemCount: profile.farms.length,
                                      itemBuilder: (context, index) {
                                        return FarmListTile(
                                          onPressed: (Farms farm) {
                                            FarmNetwork().deleteFarm(farm.id);
                                            setState(() {

                                            });
                                          },
                                          farm: profile.farms[index],
                                        );
                                      },
                                    ),
                                  )
                                ],
                              )),
                        )),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Widget counter(int count, String type) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        Text(
          type,
          style: const TextStyle(
              fontWeight: FontWeight.w100, fontSize: 17, color: Colors.grey),
        ),
      ],
    );
  }
}

class FarmListTile extends ListTile {
  final void Function(Farms farm) onPressed;
  final Farms farm;

  const FarmListTile({Key? key, required this.onPressed, required this.farm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              farm.name,
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(onPressed: (){
              onPressed(farm);
            }, icon: const Icon(Icons.delete))
          ],
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}

class MapDialog {
  MapController mapController = MapController();
  late latLng.LatLng pickedPoint;

  List<Marker> markers = [];
  TextEditingController nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future dialogAddFarm(
    BuildContext context,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            alignment: Alignment.center,
            title: const Text("Add new Farm"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormField(
                            hintText: "Add your Farm name",
                            labelText: "Farm name",
                            prefixIcon: Icons.agriculture,
                            controller: nameController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a name";
                              } else if (value.length > 50) {
                                return "Name is too long";
                              } else {
                                return null;
                              }
                            },
                            isPassword: false),
                        Container(
                          width: 400,
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            "Pick a location:",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: 400,
                          height: 300,
                          child: CustomMap(
                            mapController: mapController,
                            onLongPress: onLongPress,
                            markerLayer: MarkerLayer(
                              markers: markers,
                            ),
                          ),
                        ),
                        FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  markers.isNotEmpty) {
                                var resp = await FarmNetwork().postFarm(
                                    nameController.text,
                                    pickedPoint.latitude,
                                    pickedPoint.longitude);
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text("Save"))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void onLongPress(latLng.LatLng point) {
    pickedPoint = point;
    markers.clear();
    markers.add(
      Marker(
        point: pickedPoint,
        width: 50,
        height: 50,
        builder: (context) => const Icon(
          Icons.location_searching,
          size: 50,
          color: Colors.red,
        ),
      ),
    );
  }
}
