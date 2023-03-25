import 'dart:io';

import 'package:aurora_borealis/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:readmore/readmore.dart';

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
                url:
                    "https://newprofilepic2.photo-cdn.net//assets/images/article/profile.jpg",
                radius: 25,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "FirstName LastName",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    "2023.03.22",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ReadMoreText(
            "This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.This is the post text what the user may insert, "
            "it could be a pretty long text with more than one line, maybe even 5-6 lines.",
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
          const PostImageItem(),
        ],
      ),
    ));
  }
}

class PostNewItem extends StatefulWidget {
  const PostNewItem({Key? key}) : super(key: key);

  @override
  _PostNewItemState createState() => _PostNewItemState();
}

class _PostNewItemState extends State<PostNewItem> {
  List<String> farmsList = ["Farm 1", "Farm 2", "Farm Filakovo"];
  late String dropdownValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropdownValue = farmsList.first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: 'Farm location',
            labelText: 'Farm location',
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1, color: Colors.green.shade900),
            ),
          ),
          items: farmsList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
        ),
        const SizedBox(
          height: 10,
        ),
        const TextField(
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: null,
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Write something about your new post",
              hintMaxLines: 2),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1.0,
                color: Theme.of(context).dividerColor),
            borderRadius: const BorderRadius.all(Radius.circular(5))
          ),
          child: const Padding(
            padding: EdgeInsets.all(5),
          child: PostNewImageItem(),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        FilledButton(
            onPressed: (){

            },
            child: const Text("Create Post")
        )
      ],
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
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
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
                margin: const EdgeInsets.only(left: 2, right: 2),
                child: CustomNetworkPostImage(
                  url: images[pagePosition],
                ));
          }),
    );
  }
}

class PostNewImageItem extends StatefulWidget {
  const PostNewImageItem({Key? key}) : super(key: key);

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
      mainAxisSize: MainAxisSize.min,
      children: [
        images.isNotEmpty ? SizedBox(
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
                    margin: const EdgeInsets.only(left: 2, right: 2),
                    child: Image(
                      image: FileImage(File(images[pagePosition].path)),
                    ),
                    );
              }),
        ) :
        const SizedBox(),
        images.isNotEmpty ? const SizedBox(
          height: 10,
        ) : const SizedBox(),
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
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.red.shade600),
                ),
                child: const Icon(Icons.delete))
          ],
        )
      ],
    );
  }
}
