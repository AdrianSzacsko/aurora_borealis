import 'package:flutter/material.dart';

import 'custom_network_image.dart';
import 'oval_component.dart';

class PostItem extends StatefulWidget {

  const PostItem({Key? key}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                    url: "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg",
                    radius: 25,
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("FirstName LastName", style: TextStyle(
                        fontSize: 18,
                      ),
                      ),
                      Text("2023.03.22", style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text("This is the post text what the user may insert, "
                  "it could be a pretty long text with more than one line, maybe even 5-6 lines.", style: TextStyle(
                  fontSize: 16
              ),
              ),
              const SizedBox(height: 10,),
              const PostImageItem(),
            ],
          ),
        )
    );
  }
}

class PostImageItem extends StatefulWidget {

  const PostImageItem({Key? key}) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImageItem> {
  int activePage = 1;
  late PageController _pageController;
  List<String> images = [
    "https://images.wallpapersden.com/image/download/purple-sunrise-4k-vaporwave_bGplZmiUmZqaraWkpJRmbmdlrWZlbWU.jpg",
    "https://wallpaperaccess.com/full/2637581.jpg",
    "https://uhdwallpapers.org/uploads/converted/20/01/14/the-mandalorian-5k-1920x1080_477555-mm-90.jpg"
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child:   PageView.builder(
          itemCount: images.length,
          pageSnapping: true,
          controller: _pageController,
          onPageChanged: (page) {
            setState(() {
              activePage = page;
            });
          },
          itemBuilder: (context, pagePosition) {
            return Container(
              margin: const EdgeInsets.only(left: 2, right: 2),
              child: CustomNetworkPostImage(url: images[pagePosition],)
            );
          }),
    );
  }

}
