import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'memories/videoMemory.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  VideoPlayerController _videoPlayerController;

  File _video;
  final picker = ImagePicker();

  bool value;
  @override
  void initState() {
    super.initState();
    value = false;
  }

  _pickVideo() async {
    PickedFile pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    _video = File(pickedFile.path);
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }
  // @override
  // void initState() {
  //   super.initState();
  //   _image = null;
  // }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: height * 0.292,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/TextMemory');
                      },
                      child: buildSizedBox(
                        text: 'Text',
                        icon: Icons.format_color_text,
                        color: [
                          Color(0xff1a2a6c),
                          Color(0xffb21f1f),
                          Color(0xfffdbb2d),
                          // Color(0xff03001e),
                          // Color(0xff7303c0),
                          // Color(0xffec38bc),
                          // Color(0xfffdeff9),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.024,
                    ),
                    buildSizedBox(
                      text: 'Pictures',
                      icon: Icons.image,
                      color: [
                        Color(0xffc0392b),
                        Color(0xff8e44ad),
                      ],
                    ),
                    SizedBox(
                      width: width * 0.024,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/VoiceMemory');
                      },
                      child: buildSizedBox(
                          text: 'VoiceClips',
                          icon: Icons.record_voice_over,
                          color: [
                            Color(0xff7F00FF),
                            Color(0xffE100FF),
                          ]),
                    ),
                    SizedBox(
                      width: width * 0.024,
                    ),
                    InkWell(
                      onTap: () async {
                        await _pickVideo();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => VideoMemory(
                              video: _video != null
                                  ? _videoPlayerController.value.initialized
                                      ? AspectRatio(
                                          aspectRatio: _videoPlayerController
                                              .value.aspectRatio,
                                          child: VideoPlayer(
                                              _videoPlayerController),
                                        )
                                      : Container()
                                  : Container(),
                            ),
                          ),
                        );
                      },
                      child: buildSizedBox(
                        text: 'Videos',
                        icon: Icons.videocam_sharp,
                        color: [
                          Color(0xffFDC830),
                          Color(0xffF37335),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.43),
              Column(
                children: [
                  Text(
                    'Record live story with\ncamera here',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 18,
                        color: Colors.blueGrey),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 40,
                      ),
                      onPressed: null)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildSizedBox({String text, List<Color> color, IconData icon}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.292,
      width: width * 0.364,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(
              height: height * 0.014,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
