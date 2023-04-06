import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../key.dart';

class CustomNetworkImage extends StatelessWidget{
  final String url;
  final double radius;
  final bool reload;

  const CustomNetworkImage({Key? key, required this.url, required this.radius, required this.reload}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            SharedPreferences data = snapshot.data;
            if (data.containsKey('token') == false){
              return CircleAvatar(
                child: const Icon(Icons.account_circle),
                radius: radius / 2,
              );
            }

            return CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  reload ? '$url?${DateTime.now().millisecondsSinceEpoch.toString()}' : url,
                  headers: {'authorization': 'Bearer ' + snapshot.data.getString('token')},
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.image_not_supported, size: radius,);
                  },
                  loadingBuilder: (context, child, loadingProgress){
                    if(loadingProgress == null) {
                      return child;
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              radius: radius,
            );
          }
          else if (snapshot.hasError){
            return CircleAvatar(
              child: const Icon(Icons.account_circle),
              radius: radius / 2,
            );
          }
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

}

class CustomNetworkPostImage extends StatelessWidget{
  final String url;

  const CustomNetworkPostImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return Image.network(
              url,
              headers: {'authorization': 'Bearer ' + snapshot.data.getString('token')},
              fit: BoxFit.fitHeight,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.image_not_supported, size: 50,);
              },
              loadingBuilder: (context, child, loadingProgress){
                if(loadingProgress == null) {
                  return child;
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },

            );
          }
          /*else if (snapshot.hasError){
            return CircleAvatar(
              child: const Icon(Icons.account_circle),
            );
          }*/
          else {
            return const Center(child: CircularProgressIndicator(),);
          }
        }
    );
  }

}


//https://stackoverflow.com/questions/48716067/how-to-show-fullscreen-image-in-flutter
class FullScreenPage extends StatefulWidget {
  const FullScreenPage({Key? key,
    required this.child,
    required this.dark,
  }) : super(key: key);

  final Image child;
  final bool dark;

  @override
  _FullScreenPageState createState() => _FullScreenPageState();
}

class _FullScreenPageState extends State<FullScreenPage> {
  @override
  void initState() {
    var brightness = widget.dark ? Brightness.light : Brightness.dark;
    var color = widget.dark ? Colors.black12 : Colors.white70;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: color,
      statusBarColor: color,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      systemNavigationBarDividerColor: color,
      systemNavigationBarIconBrightness: brightness,
    ));
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      // Restore your settings here...
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.dark ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: widget.child,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                child: Icon(
                  Icons.arrow_back,
                  color: widget.dark ? Colors.white : Colors.black,
                  size: 25,
                ),
                color: widget.dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}