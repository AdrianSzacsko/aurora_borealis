import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Network_Responses/profile.dart';
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
              builder: (
                  BuildContext context,
                  AsyncSnapshot<dynamic> snapshot
              ) {
              if (snapshot.hasData){

                Profile profile = snapshot.data as Profile;

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
                            padding:
                            const EdgeInsets.only(top: 20, right: 16, left: 16),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
                                      radius: 50,
                                    ),
                                    SizedBox(
                                      child: Column(
                                        children: [
                                          Text(
                                            profile.first_name + " " + profile.last_name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              FilledButton(
                                                  onPressed: () {},
                                                  child: const Text("Like")),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              FilledButton(
                                                  onPressed: () {},
                                                  child: const Text("Dislike"))
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    counter(profile.post_count, "Posts"),
                                    counter(profile.like_count, "Likes"),
                                    counter(profile.dislike_count, "Dislikes"),
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
                                          TextButton(
                                              onPressed: () {},
                                              child: Text(
                                                'ADD FARM',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color: primaryColor.shade900),
                                              )),
                                        ],
                                      )),
                                ),
                                Divider(
                                  color: Colors.lightGreen.shade900,
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount: profile.farms.length,
                                    itemBuilder: (context, index) {
                                      return FarmListTile(onPressed: (){

                                      },
                                        farm: profile.farms[index],);
                                    },
                                  ),
                                )
                              ],
                            )),
                      )),
                );
              }
              else {
                return const Center(child: CircularProgressIndicator());
              }
            }
          ),
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

  final void Function() onPressed;
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
            Text(farm.name,

              style: TextStyle(fontSize: 16),
            ),
            IconButton(onPressed: onPressed, icon: const Icon(Icons.delete))
          ],
        ),
        const Divider(color: Colors.grey,)
      ],
    );
  }
}
