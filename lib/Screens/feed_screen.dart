import 'package:aurora_borealis/Components/custom_chart.dart';
import 'package:aurora_borealis/Components/custom_map.dart';
import 'package:aurora_borealis/Components/custom_network_image.dart';
import 'package:aurora_borealis/Components/post_item.dart';
import 'package:aurora_borealis/Components/snackbar.dart';
import 'package:aurora_borealis/Network/farm.dart';
import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:aurora_borealis/Network_Responses/weather.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_map/flutter_map.dart';
import '../Components/custom_form_field.dart';
import '../Components/ext_string.dart';
import '../Components/marker_shape.dart';
import '../Components/not_logged_in.dart';
import '../Components/oval_component.dart';
import '../Network_Responses/feed.dart';
import '../Network_Responses/post.dart';
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
  List<ScrollController> scrollControllers = [];
  bool _shouldScrollToNextPage = false;
  bool _shouldScrollToPrevPage = true;
  latLng.LatLng currentPosition = latLng.LatLng(48.148598, 17.107748);
  latLng.LatLng farmPosition = latLng.LatLng(48.148598, 17.107748);


  int user_id = 0;

  int activePage = 1;
  List<Marker> markers = [];
  List<Marker> farmMarkers = [];

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

  Future<void> _getCurrentLocation() async {
    final status = await Geolocator.checkPermission();
    if (status == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = latLng.LatLng(position.latitude, position.longitude);
      farmPosition = currentPosition;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    //currentPosition is always set
    _pageController = PageController(viewportFraction: 0.925);
  }

  void addMarker(latLng.LatLng point) {
    markers.add(Marker(
        point: point,
        width: 150,
        height: 70,
        builder: (context) => CustomShape(child: const Icon(Icons.location_on_outlined))));
  }

  void generateMarkers(List<Post> points) {
    markers.clear();
    points.forEach((element) {
      addMarker(latLng.LatLng(element.latitude, element.longitude));
    });
  }

  void addFarmMarker(latLng.LatLng point) {
    farmMarkers.add(Marker(
        point: point,
        width: 150,
        height: 70,
        builder: (context) => CustomShape(child: const Icon(Icons.agriculture_outlined), color: Colors.brown,)));
  }

  void generateFarmMarkers(List<Farms> points) {
    farmMarkers.clear();
    points.forEach((element) {
      addFarmMarker(latLng.LatLng(element.latitude, element.longitude));
    });
  }

  void getChosenFarm(Farms farm){
    print(farm.name);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        farmPosition = latLng.LatLng(farm.latitude, farm.longitude);
        mapController.move(latLng.LatLng(farm.latitude, farm.longitude), mapController.zoom);
      });
    });
  }

  void setMapLocation(latLng.LatLng point){
    mapController.move(point, mapController.zoom);
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)!.settings.arguments == null) {
      return const NotLoggedInScreen();
    } else {
      user_id = ModalRoute.of(context)!.settings.arguments as int;

      return FutureBuilder(
        future: Future.microtask(() => FarmsList.create(context, true)),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData){

            FarmsList farmsList = snapshot.data as FarmsList;

            if (farmsList.farms.isEmpty){
              /*Future.delayed(Duration.zero, (){
                errorResponseBar("Please create a Farm", context);
              });*/
            }

            generateFarmMarkers(farmsList.farms);

            Farms currentPositionFarm = Farms(0, "Current position", currentPosition.latitude, currentPosition.longitude);

            return Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: MyAppBarWithDropdown(farmsList: [currentPositionFarm, ...farmsList.farms], function: getChosenFarm,),
              floatingActionButton: FloatingActionButton(
                backgroundColor: farmsList.farms.isEmpty ? Colors.grey : primaryColor,
                onPressed: () async {
                  if (farmsList.farms.isEmpty){
                    errorResponseBar("Please create a Farm", context);
                  }
                  else{
                    await showDialog(context: context, builder: (context){
                      return PostDialog(farmsList: farmsList.farms,);
                    });
                  }

                },
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
                      markerLayer: MarkerLayer(
                        markers: [...farmMarkers, ...markers],
                      ),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.59,
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
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: FutureBuilder(
                                  future: Future.microtask(() => Feed.create(farmPosition.latitude, farmPosition.longitude, 150, context)),
                                  builder: (
                                      BuildContext context,
                                      AsyncSnapshot<dynamic> snapshot
                                      ) {
                                    if (snapshot.hasData){

                                      Feed feedData = snapshot.data as Feed;
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

                                      generateMarkers(feedData.posts);

                                      //return Text(data.currentWeather.weather_main);
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

                                            /*Future.delayed(Duration.zero, (){
                                              //mapController.move(markers[pagePosition].point, mapController.zoom);
                                              setMapLocation(markers[pagePosition].point);
                                            });*/

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
                                                  child: PostItem(post: feedData.posts[pagePosition], setMapLocation: setMapLocation,)
                                              ),
                                            );
                                          });
                                    }
                                    else{
                                      return const Center(child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                              )
                          )
                      )
                  ),
                ],
              ),
            );
          }
          else{
            return Scaffold(
              resizeToAvoidBottomInset: true,
                appBar: myAppBar(context),
              body: const Center(child: CircularProgressIndicator(),),
            );
          }
        },
      );
    }
  }
}

class PostDialog extends StatefulWidget {

  const PostDialog({Key? key, required this.farmsList}) : super(key: key);

  final List<Farms> farmsList;

  @override
  _PostDialogState createState() => _PostDialogState();
}

class _PostDialogState extends State<PostDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      alignment: Alignment.center,
      title: const Text("Add post"),
      content: Container(
          width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: PostNewItem(farmsList: widget.farmsList,),
        )
      ),
    );
  }
}
