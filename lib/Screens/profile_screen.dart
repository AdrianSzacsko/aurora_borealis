import 'dart:io';
import 'dart:typed_data';
import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Components/custom_network_image.dart';
import 'package:aurora_borealis/Components/oval_component.dart';
import 'package:aurora_borealis/Network/farm.dart';
import 'package:aurora_borealis/Network/feed.dart';
import 'package:aurora_borealis/Network/profile.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:aurora_borealis/Screens/login_screen.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/marker_shape.dart';
import '../Components/not_logged_in.dart';
import '../Components/post_item.dart';
import '../Network_Responses/feed.dart';
import '../Network_Responses/post.dart';
import '../Network_Responses/profile.dart';
import '../key.dart';
import 'register_screen.dart';
import '../Components/app_bar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';



/*
navigator variable is the own profile ID
showProfileID is the ID of the profile to show
 */
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.showProfileId}) : super(key: key);
  final int? showProfileId;


  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final _mapController = MapController();
  List<Marker> markers = [];
  int user_id = 0;
  late PageController _pageController;
  List<ScrollController> scrollControllers = [];
  bool _shouldScrollToNextPage = false;
  bool _shouldScrollToPrevPage = true;
  int activePage = 1;
  bool upFloatingButton = false;

  ScrollController mainScrollController = ScrollController();

  _scrollDown() async {
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }

  _scrollUp() async {
    await _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.linear,
    );
  }

  void setMapLocation(latLng.LatLng point){
    _mapController.move(point, _mapController.zoom);
  }

  void deletePost(Post post) async {
    await FeedNetwork().deletePost(post.id);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
  }

  void onTilePress(int userId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    //TODO Fix this
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(showProfileId: userId,),
            settings: RouteSettings(
                arguments: user_id)));

  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null || widget.showProfileId == null) {
      return const NotLoggedInScreen();
    } else {

      user_id = ModalRoute.of(context)!.settings.arguments as int;

      mainScrollController = ScrollController()..addListener(() {
        setState(() {
          if (mainScrollController.positions.isNotEmpty){
            if (mainScrollController.offset >= 300) {
              upFloatingButton = true; // show up arrow
            } else {
              upFloatingButton = false; // show down arrow
            }
          }
        });
      });
      return Scaffold(
        appBar: myAppBarWithProfileSearch(context, onTilePress),
        floatingActionButtonLocation: upFloatingButton == false ? FloatingActionButtonLocation.centerFloat : FloatingActionButtonLocation.startFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (upFloatingButton){
              mainScrollController.animateTo(0, duration: const Duration(milliseconds: 200), curve: Curves.linear);
            }
            else{
              mainScrollController.animateTo(500, duration: const Duration(milliseconds: 200), curve: Curves.linear);
            }
          },
          child: upFloatingButton == false ? const Icon(Icons.arrow_downward_outlined) : const Icon(Icons.arrow_upward_outlined),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: CustomMap(
                mapController: _mapController,
                //coors: latLng.LatLng(48.269798, 19.820565),
                onLongPress: null,
                  markerLayer: MarkerLayer(
                    markers: markers,
                  )
              ),
            ),
            FutureBuilder(
                future: Profile.create(widget.showProfileId!, context),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    print(snapshot.data);
                    Profile profile = snapshot.data as Profile;
                    bool myProfile = user_id == profile.id;
                    generateMarkers(profile.farms);

                    Future.delayed(Duration.zero, (){
                      _mapController.move(latLng.LatLng(_mapController.center.latitude + 0.000001, _mapController.center.longitude), _mapController.zoom);
                    });

                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.6,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: Image.asset('assets/images/backgroundGreen.jpg',
                                ).image,
                                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
                              ),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(40),
                                  topLeft: Radius.circular(40))),
                          child: SingleChildScrollView(
                            controller: mainScrollController,
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
                                        Stack(
                                          children: [
                                            CustomNetworkImage(
                                              reload: true,
                                              url: urlKey +
                                                  'profile/profile_pic/' +
                                                  profile.id.toString(),
                                              radius: 50,
                                            ),
                                            myProfile
                                                ? Container(
                                                    width: 100,
                                                    height: 100,
                                                    alignment:
                                                        const Alignment(1, 1),
                                                    child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: IconButton(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          onPressed: () async {
                                                            await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return ImageDialog(
                                                                      profile);
                                                                });
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                            Icons
                                                                .add_circle_outline,
                                                            size: 40,
                                                            color: primaryColor[
                                                                900],
                                                          )),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
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
                                                  ? FilledButton(
                                                  onPressed: () async {
                                                    await Profile.likeOrDislike(profile.id, !profile.interaction, context);
                                                    setState(() {

                                                    });
                                                  },
                                                  child: profile.interaction == true ? const Text(
                                                      "Unfollow") : const Text("Follow"))
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
                                        counter(profile.like_count, "Follows"),
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
                                                myProfile ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "FARMS",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                    color:
                                                        primaryColor.shade900),
                                              ),
                                              myProfile
                                                  ? TextButton(
                                                      onPressed: () async {
                                                        MapDialog mapDialog =
                                                            MapDialog();
                                                        await mapDialog
                                                            .dialogAddFarm(
                                                                context);
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
                                                      ))
                                                  : const SizedBox(),
                                            ],
                                          )),
                                    ),
                                    Divider(
                                      color: Colors.lightGreen.shade900,
                                      thickness: 2,
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        itemCount: profile.farms.length,
                                        itemBuilder: (context, index) {
                                          return FarmListTile(
                                            onPressed: (Farms farm) async {
                                              await FarmNetwork().deleteFarm(farm.id);
                                              setState(() {});
                                            },
                                            farm: profile.farms[index],
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      child: FutureBuilder(
                                        future: Future.microtask(() => ProfileFeed.create(profile.id, context)),
                                        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                          if (snapshot.hasData){

                                            ProfileFeed feedData = snapshot.data as ProfileFeed;
                                            scrollControllers.clear();
                                            for (int i = 0; i < feedData.posts.length; i++) {
                                              scrollControllers.add(ScrollController());
                                            }
                                            if (feedData.posts.isEmpty){
                                              return Center(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: const [
                                                      Icon(Icons.image_not_supported, size: 50,),
                                                      SizedBox(height: 10,),
                                                      Text("There are no available posts", style: TextStyle(fontSize: 22),)
                                                    ],
                                                  ),
                                              );
                                            }

                                            return PageView.builder(
                                                padEnds: false,
                                                itemCount: feedData.posts.length,
                                                pageSnapping: true,
                                                controller: _pageController,
                                                scrollDirection: Axis.vertical,
                                                onPageChanged: (page) {
                                                  //setState(() {
                                                  activePage = page;
                                                  //});
                                                },
                                                itemBuilder: (context, pagePosition) {

                                                  return NotificationListener(
                                                    onNotification: (notification) {
                                                      //bool isStart = false;
                                                      if (notification is ScrollStartNotification){
                                                        if (scrollControllers[pagePosition].position.pixels == scrollControllers[pagePosition].position.maxScrollExtent){
                                                          _shouldScrollToNextPage = true;
                                                          //print( _shouldScrollToNextPage);
                                                        }
                                                        else if (scrollControllers[pagePosition].position.pixels == 0){
                                                          _shouldScrollToPrevPage = true;
                                                        }
                                                        else{
                                                          _shouldScrollToNextPage = false;
                                                          _shouldScrollToPrevPage = false;
                                                        }
                                                      }
                                                      if (notification is OverscrollNotification) {
                                                        if (notification.metrics.axis == Axis.vertical) {
                                                          if (notification.dragDetails != null) {
                                                            if (notification.dragDetails!.delta.dy < 0 && _shouldScrollToNextPage) {
                                                              _scrollDown();
                                                              _shouldScrollToNextPage = false;
                                                            }
                                                            else if (notification.dragDetails!.delta.dy > 0 && _shouldScrollToPrevPage) {
                                                              _scrollUp();
                                                            }
                                                          }
                                                        }
                                                      }
                                                      return false;
                                                    },
                                                    child: SingleChildScrollView(
                                                        controller: scrollControllers[pagePosition],
                                                        child: PostItem(post: feedData.posts[pagePosition], setMapLocation: setMapLocation, deletePost: deletePost,)
                                                    ),
                                                  );
                                                });
                                          }
                                          else{
                                            return const Center(child: CircularProgressIndicator(),);
                                          }
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

  void addMarker(Farms point) {
    markers.add(Marker(
        point: latLng.LatLng(point.latitude, point.longitude),
        width: 150,
        height: 70,
        builder: (context) => CustomShape(child: Text(point.name))));
  }

  void generateMarkers(List<Farms> points) {
    markers.clear();
    points.forEach((element) {
      addMarker(element);
    });
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
            IconButton(
                onPressed: () {
                  onPressed(farm);
                },
                icon: const Icon(Icons.delete))
          ],
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}

class ImageDialog extends StatefulWidget {
  final Profile profile;

  const ImageDialog(this.profile, {Key? key}) : super(key: key);

  @override
  _ImageDialogState createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog> {
  final ImagePicker _picker = ImagePicker();
  bool isPicked = false;
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      title: const Text("Pick Image"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            !isPicked
                ? CustomNetworkImage(
              reload: true,
                    url: urlKey +
                        'profile/profile_pic/' +
                        widget.profile.id.toString(),
                        radius: 50,
                  )
                : CircleAvatar(
                    backgroundImage: FileImage(File(image!.path)),
                    radius: 50,
                  ),
            !isPicked
                ? FilledButton(
                    onPressed: () async {
                      image = await _picker.pickImage(
                        source: ImageSource.gallery,
                        maxHeight: 4000,
                        maxWidth: 4000,
                      );
                      if (image != null) {
                        setState(() {
                          isPicked = true;
                        });
                      }
                    },
                    child: const Text("Choose new"),
                  )
                : FilledButton(
                    onPressed: () async {
                      await ProfileNetwork().putProfilePic(image);
                      Navigator.pop(context, true);
                    },
                    child: const Text("Upload"),
                  ),
          ],
        ),
      ),
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
                              )
                          ),
                        ),
                        FilledButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate() &&
                                  markers.isNotEmpty) {
                                print("pressed submit on map");
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
