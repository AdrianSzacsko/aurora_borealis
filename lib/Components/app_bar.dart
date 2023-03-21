import 'package:aurora_borealis/Network_Responses/farms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import '../Screens/menu_screen.dart';
import 'package:aurora_borealis/Network_Responses/search_results.dart';
import 'package:latlong2/latlong.dart' as LatLng;

AppBar myAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: primaryColor,
    //leading: const Icon(Icons.menu),
    leading: GestureDetector(
      onTap: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          bool? result = await dialogConfirmation(
              context, "Exit", "Are you sure you want to exit?");
          if (result == true) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();
            SystemNavigator.pop();
          }
        }
      },
      child: const Icon(
        Icons.arrow_back_outlined, // add custom icons also
      ),
    ),
    actions: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () async {
              SharedPreferences shared = await SharedPreferences.getInstance();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
                  settings: RouteSettings(arguments: shared.getInt('user_id'))));
            },
            child: const Icon(Icons.menu),
          )),
    ],
  );
}

AppBar myAppBarWithSearch(BuildContext context, void Function(LatLng.LatLng point) onTilePress) {

  return AppBar(
    backgroundColor: primaryColor,
    //leading: const Icon(Icons.menu),
    title: Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: TextField(
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            //prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                /* Search field */
              },
            ),
            hintText: "Search...",
            border: InputBorder.none,
          ),
          onTap: () {
            showSearch(
              context: context,
              delegate: MySearchDelegate(onTilePress),
            );
          },
        ),
      ),
    ),
    leading: GestureDetector(
      onTap: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          bool? result = await dialogConfirmation(
              context, "Exit", "Are you sure you want to exit?");
          if (result == true) {
            SystemNavigator.pop();
          }
        }
      },
      child: const Icon(
        Icons.arrow_back_outlined, // add custom icons also
      ),
    ),
    actions: [
      Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () async {
              SharedPreferences shared = await SharedPreferences.getInstance();
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen(),
                  settings: RouteSettings(arguments: shared.getInt('user_id'))));
            },
            child: const Icon(Icons.menu),
          )),
    ],
  );
}

Future<bool> dialogConfirmation(
  BuildContext context,
  String title,
  String content, {
  String textNo = 'No',
  String textYes = 'Yes',
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        alignment: Alignment.center,
        title: Text(title, textAlign: TextAlign.center),
        content: Text(content, textAlign: TextAlign.center),
        actions: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, defaultPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    backgroundColor: primaryColor[300],
                    onPressed: () => Navigator.pop(context, true),
                    child: const Icon(
                      Icons.check_outlined,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    backgroundColor: secondaryColor[300],
                    onPressed: () => Navigator.pop(context, false),
                    child: const Icon(
                      Icons.cancel_outlined,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class MySearchDelegate extends SearchDelegate<String> {

  final void Function(LatLng.LatLng point) onTilePress;


  MySearchDelegate(
      this.onTilePress
      );

  @override
  List<Widget> buildActions(BuildContext context) {
    // This is where you can add buttons to the search toolbar.
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // This is where you can add a "back" button to the search toolbar.
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "Close");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // This is where you can display the search results.
    // For example, you can use a ListView to display a list of search results.

    return FutureBuilder(
      future: SearchResults.search(query),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasData){
          List<SearchResult> searchResults = snapshot.data as List<SearchResult>;

          return ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              return SearchResultListTile(
                  searchResult: searchResults[index],
                  onTap: () {
                    // This is where you can handle a tap on a search result.
                    // For example, you can navigate to a new screen to display more details.
                    onTilePress(LatLng.LatLng(searchResults[index].lat, searchResults[index].lon));
                    close(context, "Close");
                  });
            },
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    // This is where you can display suggestions as the user types in the search query.
    // For example, you can use a ListView to display a list of suggestions.
    return FutureBuilder(
      future: FarmsList.create(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {

        if (snapshot.hasData){
          FarmsList farmsList = snapshot.data as FarmsList;

          return ListView.builder(
            itemCount: farmsList.farms.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(farmsList.farms[index].name),
                onTap: () {
                  onTilePress(LatLng.LatLng(farmsList.farms[index].latitude, farmsList.farms[index].longitude));
                  close(context, "Close");
                },
              );
            },
          );
        }
        else{
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SearchResultListTile extends ListTile {
  final SearchResult searchResult;

  const SearchResultListTile({Key? key, required this.searchResult, required void Function() onTap})
      : super(key: key, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Icon(Icons.place_outlined),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          searchResult.display_name,
                          softWrap: false,
                        ),
                        const SizedBox(height: 2,),
                        Text(
                            searchResult.type[0].toUpperCase() +
                                searchResult.type.substring(1).toLowerCase()
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
