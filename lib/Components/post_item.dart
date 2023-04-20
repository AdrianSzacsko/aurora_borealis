import 'dart:io';

import 'package:aurora_borealis/Components/snackbar.dart';
import 'package:aurora_borealis/Network_Responses/post.dart';
import 'package:aurora_borealis/Network_Responses/feed.dart';
import 'package:aurora_borealis/constants.dart';
import 'package:aurora_borealis/key.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:shared_preferences/shared_preferences.dart';
import '../Network/feed.dart';
import '../Network_Responses/farms.dart';
import '../Screens/profile_screen.dart';
import 'app_bar.dart';
import 'custom_network_image.dart';
import 'oval_component.dart';

class PostItem extends StatefulWidget {
  final Post post;
  final Function(latLng.LatLng point) setMapLocation;
  Function(Post post)? deletePost;
  PostItem({Key? key, required this.post, required this.setMapLocation, this.deletePost})
      : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Padding(
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () async {
                  var cache = await SharedPreferences.getInstance();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProfileScreen(showProfileId: widget.post.user_id,),
                          settings: RouteSettings(
                              arguments: cache.getInt('user_id'))));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      reload: false,
                      url: urlKey +
                          'profile/profile_pic/' +
                          widget.post.user_id.toString(),
                      radius: 25,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.post.first_name + " " + widget.post.last_name,
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          widget.post.date.year.toString() +
                              "." +
                              widget.post.date.month.toString() +
                              "." +
                              widget.post.date.day.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                          onPressed: () {
                            widget.setMapLocation(latLng.LatLng(
                                widget.post.latitude, widget.post.longitude));
                          },
                          icon: Icon(
                            Icons.my_location,
                            color: primaryColor.shade900,
                          )),
                    ),
                  ),
                  widget.deletePost != null ? ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: IconButton(
                          onPressed: () async {

                              bool? result =  await dialogConfirmation(context, "Delete", "Are you sure you want to delete this post?");
                              if (result == true){
                                await widget.deletePost!(widget.post);
                              }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red.shade800,
                          )),
                    ),
                  ) : const SizedBox(),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Text(
                "Category: ",
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                "#" + widget.post.category,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ReadMoreText(
            widget.post.text,
            style: const TextStyle(fontSize: 16),
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimCollapsedText: " Show more",
            trimExpandedText: " Show less",
            colorClickableText: primaryColor.shade900,
          ),
          const SizedBox(
            height: 10,
          ),
          PostImageItem(
            images: widget.post.photos_id,
          ),
        ],
      ),
    ));
  }
}

class PostNewItem extends StatefulWidget {
  const PostNewItem({Key? key, required this.farmsList}) : super(key: key);

  final List<Farms> farmsList;

  @override
  _PostNewItemState createState() => _PostNewItemState();
}

class _PostNewItemState extends State<PostNewItem> {
  late Farms dropdownValue;
  late String categoryDropdownValue;
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = widget.farmsList.first;
    categoryDropdownValue = feedCategories.first;
  }

  void createPost(List<XFile> images) async {
    //call the post method
    await Feed.newPost(
        dropdownValue.latitude,
        dropdownValue.longitude,
        categoryDropdownValue,
        textEditingController.text,
        images, context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Farm location',
            labelText: 'Farm location',
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.green.shade900),
            ),
          ),
          items: widget.farmsList.map<DropdownMenuItem<Farms>>((Farms value) {
            return DropdownMenuItem<Farms>(
              value: value,
              child: Text(value.name),
            );
          }).toList(),
          onChanged: (Farms? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          value: dropdownValue,
        ),
        const SizedBox(
          height: 10,
        ),
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Post Category',
            labelText: 'Post Category',
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.green.shade900),
            ),
          ),
          items: feedCategories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                "#" + value,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              categoryDropdownValue = value!;
            });
          },
          value: feedCategories.first,
        ),
        const SizedBox(
          height: 10,
        ),
        TextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          controller: textEditingController,
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Write something about your new post",
              hintMaxLines: 2),
        ),
        const SizedBox(
          height: 10,
        ),
        PostNewImageItem(createPost: createPost,),
      ],
    );
  }
}

class PostImageItem extends StatefulWidget {
  final List<int> images;
  const PostImageItem({Key? key, required this.images}) : super(key: key);

  @override
  _PostImageState createState() => _PostImageState();
}

class _PostImageState extends State<PostImageItem> {
  int activePage = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.images.isEmpty ? MediaQuery.of(context).size.height * 0.3 : MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: widget.images.isEmpty ?
          const Center(child: Icon(Icons.image_not_supported, size: 100,),):
      PageView.builder(
          padEnds: false,
          itemCount: widget.images.length,
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
                child: CustomNetworkPostImage(
                  url: urlKey +
                      "feed/post_pic/" +
                      widget.images[pagePosition].toString(),
                ));
          }),
    );
  }
}

class PostNewImageItem extends StatefulWidget {
  const PostNewImageItem({Key? key, required this.createPost}) : super(key: key);

  final Function(List<XFile> images) createPost;

  @override
  _PostNewImageState createState() => _PostNewImageState();
}

class _PostNewImageState extends State<PostNewImageItem> {
  final ImagePicker _picker = ImagePicker();
  int activePage = 1;
  late PageController _pageController;
  List<XFile> images = [];


  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border:
                  Border.all(width: 1.0, color: Theme.of(context).dividerColor),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                images.isNotEmpty
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: PageView.builder(
                            padEnds: false,
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
                                margin:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: Image(
                                  image: FileImage(
                                      File(images[pagePosition].path)),
                                ),
                              );
                            }),
                      )
                    : const SizedBox(),
                images.isNotEmpty
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilledButton(
                      onPressed: () async {
                        List<XFile> tempImages = await _picker.pickMultiImage(
                          //source: ImageSource.gallery,
                          maxHeight: 4000,
                          maxWidth: 4000,
                        );
                        if (tempImages.isNotEmpty) {
                          for (var image in tempImages) {
                            images.add(image);
                          }
                          setState(() {});
                        }
                      },
                      child: const Icon(Icons.add_photo_alternate),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilledButton(
                        onPressed: () {
                          images.clear();
                          setState(() {});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll<Color>(
                              Colors.red.shade600),
                        ),
                        child: const Icon(Icons.delete))
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FilledButton(
            onPressed: () async {
          await widget.createPost(images);
          Navigator.of(context).pop();
        },
            child: const Text("Create Post")),
      ],
    );
  }
}
