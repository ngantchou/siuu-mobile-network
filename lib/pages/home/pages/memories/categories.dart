import 'dart:io';

import 'package:Siuu/pages/home/pages/camera.dart';
import 'package:Siuu/pages/home/pages/memories/TextMemory.dart';
import 'package:Siuu/pages/home/pages/memories/VoiceMemory.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'videoMemory.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  VideoPlayerController _videoPlayerController;

  File _video;
  File _image;
  final picker = ImagePicker();
  StoryType type = StoryType.Text;
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

  _pickImage() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {});
    _image = File(pickedFile.path);
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

    Widget widgetType;

    switch (type) {
      case StoryType.Text:
        widgetType = TextMemory();
        break;
      case StoryType.Picture:
        widgetType = imageMemory();
        break;
      case StoryType.Voice:
        widgetType = VoiceMemory();
        break;
      case StoryType.Video:
        widgetType = videoMemory();
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: height * 0.192,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      type = StoryType.Text;
                    });
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
                InkWell(
                  onTap: () {
                    setState(() {
                      type = StoryType.Picture;
                    });
                  },
                  child: buildSizedBox(
                    text: 'Pictures',
                    icon: Icons.image,
                    color: [
                      Color(0xffc0392b),
                      Color(0xff8e44ad),
                    ],
                  ),
                ),
                SizedBox(
                  width: width * 0.024,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      type = StoryType.Voice;
                    });
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
                  width: width * 0.004,
                ),
                InkWell(
                  onTap: () async {
                    setState(() {
                      type = StoryType.Video;
                    });
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
          SizedBox(
            height: height * 0.024,
          ),
          widgetType != null
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: height * 0.642,
                    child: widgetType,
                  ),
                )
              : Column(
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
    );
  }

  Widget videoMemory() {
    return InkWell(
      onTap: () async {
        await _pickVideo();
      },
      child: _video == null
          ? Column(
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
          : VideoMemory(
              video: _video != null
                  ? _videoPlayerController.value.initialized
                      ? AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )
                      : Container()
                  : Container(),
            ),
    );
  }

  Widget imageMemory() {
    return InkWell(
      onTap: () async {
        await _pickImage();
      },
      child: _image == null
          ? Column(
              children: [
                Text(
                  'Take a picture',
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
          : Container(
              child: Image.asset(_image.path),
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

enum StoryType { Text, Picture, Voice, Video }
