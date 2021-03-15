import 'package:Siuu/story/camera_screen/nested_screens/create_story_screen.dart';
import 'package:Siuu/story/stories_screen/widgets/circular_icon_button.dart';
import 'package:Siuu/story/utilities/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

import 'nested_screens/edit_photo_screen.dart';

class CameraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;
  final CameraConsumer cameraConsumer;
  final Function backToHomeScreen;
  CameraScreen(this.cameras, this.backToHomeScreen, this.cameraConsumer);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String imagePath;
  bool _toggleCamera = false;
  CameraController controller;
  final _picker = ImagePicker();
  CameraConsumer _cameraConsumer = CameraConsumer.Photo;

  TextStyle _textStyle = TextStyle(fontSize: 11);
  int _pageSelectedIndex=1;
  String path;
  File filePath;

  int intervalTime = 10; // 30 seconds

  DateTime dateTimeStart;
  Duration totalVideoDuration = Duration(seconds: 0);

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras[0]);
    } catch (e) {
      print(e.toString());
    }
    if (widget.cameraConsumer != CameraConsumer.Photo) {
      changeConsumer(widget.cameraConsumer);
    }
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras.isEmpty) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16.0),
        child: Text(
          'No Camera Found',
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      );
    }

    if (!controller.value.isInitialized) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: new CameraPreview(controller),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: CircularIconButton(
                splashColor: kBlueColorWithOpacity,
                icon: Icon(
                  Icons.close_sharp,
                  color: Colors.white,
                  size: 22,
                ),
                onTap: widget.backToHomeScreen,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                /*Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              topLeft: Radius.circular(15))),
                      onPressed: () => changeConsumer(CameraConsumer.Photo),
                      color: _cameraConsumer == CameraConsumer.Photo
                          ? Colors.white.withOpacity(0.85)
                          : Colors.black38,
                      child: Text(
                        'Photo',
                        style: TextStyle(
                          fontSize: 18,
                          color: _cameraConsumer == CameraConsumer.Photo
                              ? Colors.black
                              : Colors.white,
                          fontWeight: _cameraConsumer == CameraConsumer.Photo
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15))),
                      onPressed: () => changeConsumer(CameraConsumer.Video),
                      color: _cameraConsumer == CameraConsumer.Video
                          ? Colors.white.withOpacity(0.85)
                          : Colors.black38,
                      child: Text(
                        'Video',
                        style: TextStyle(
                          fontSize: 18,
                          color: _cameraConsumer == CameraConsumer.Video
                              ? Colors.black
                              : Colors.white,
                          fontWeight: _cameraConsumer == CameraConsumer.Video
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),*/
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 120.0,
                  padding: EdgeInsets.all(20.0),
                  color: Colors.black45,
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            onTap: () {
                              if(_cameraConsumer == CameraConsumer.Video){
                                _startVideoRecording();
                              }else{
                              _captureImage();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                'assets/svg/storyCamera.svg',
                                height: 57,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            onTap: () {
                              if (!_toggleCamera) {
                                onCameraSelected(widget.cameras[1]);
                                setState(() {
                                  _toggleCamera = true;
                                });
                              } else {
                                onCameraSelected(widget.cameras[0]);
                                setState(() {
                                  _toggleCamera = true;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                'assets/svg/Camera2.svg',
                                height: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            onTap: getGalleryImage,
                            child: Container(
                              padding: EdgeInsets.all(4.0),
                              child: SvgPicture.asset(
                                'assets/svg/Camera.svg',
                                height: 42,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _topRowWidget(),
          _rightColumnWidgets(),

        ],
      ),
    );
  }
  Future<String> _startVideoRecording() async {

    if (!controller.value.isInitialized) {

      return null;

    }

    // Do nothing if a recording is on progress

    if (controller.value.isRecordingVideo) {

      return null;

    }
    //get storage path

    final Directory appDirectory = await getApplicationDocumentsDirectory();

    final String videoDirectory = '${appDirectory.path}/Videos';

    await Directory(videoDirectory).create(recursive: true);

    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();

    final String filePath = '$videoDirectory/${currentTime}.mp4';



    try {

      await controller.startVideoRecording(filePath);

      //videoPath = filePath;

    } on CameraException catch (e) {

      print(e);

      return null;

    }


    //gives you path of where the video was stored
    return filePath;

  }
  Widget _topRowWidget() {
    return Positioned(
      top: 30,
      left: 10,
      right: 20,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.close)),
            Container(
              child: Row(
                children: <Widget>[
                  Icon(Icons.music_note),
                  Text("Sounds"),
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Icon(Icons.flip),
                Text(
                  "flip",
                  style: _textStyle,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _rightColumnWidgets() {
    return Positioned(
      right: 20,
      top: 80,
      child: Column(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.shutter_speed),
                Text(
                  "Speed",
                  style: _textStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.filter_tilt_shift),
                Text(
                  "filters",
                  style: _textStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.color_lens),
                Text(
                  "beautify",
                  style: _textStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.av_timer),
                Text(
                  "Timer",
                  style: _textStyle,
                )
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            child: Column(
              children: <Widget>[
                Icon(Icons.flash_off),
                Text(
                  "Flash",
                  style: _textStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _bottomRowWidget() {
    return Positioned(
      bottom: 60,
      left: 10,
      right: 10,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Colors.purple.withOpacity(.4),
                        Colors.blue.withOpacity(.4)
                      ]),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("assets/effects.png"),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Effects",
                    style: _textStyle,
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(.4),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset("assets/gallery.png"),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Upload",
                    style: _textStyle,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void changeConsumer(CameraConsumer cameraConsumer) {
    if (_cameraConsumer != cameraConsumer) {
      setState(() => _cameraConsumer = cameraConsumer);
    }
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller =
        CameraController(cameraDescription, ResolutionPreset.ultraHigh);

    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showMessage('Camera Error: ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      showException(e);
    }

    if (mounted) setState(() {});
  }

  String timestamp() => new DateTime.now().millisecondsSinceEpoch.toString();

  void _captureImage() {
    takePicture().then((String filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath;
        });
        if (filePath != null) {
          showMessage('Picture saved to $filePath');
          setCameraResult();
        }
      }
    });
  }

  void getGalleryImage() async {
    PickedFile pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePath = pickedFile.path;
      });
      setCameraResult();
    } else {
      print('No image selected.');
    }
  }

  void setCameraResult() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateStoryScreen(File(imagePath)),
      ),
    );
    /*if (_cameraConsumer == CameraConsumer.Photo) {
      File croppedImage = await _cropImage(File(imagePath));
      if (croppedImage == null) {
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => EditPhotoScreen(
                  imageFile: croppedImage,
                )
            //  CreatePostScreen(
            //   imageFile: croppedImage,
            // ),
            ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CreateStoryScreen(File(imagePath)),
        ),
      );
    }*/
  }

  Future<String> takePicture() async {
    if (!controller.value.isInitialized) {
      showMessage('Error: select a camera first.');
      return null;
    }
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/InstaDart/Images';
    await new Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      showException(e);
      return null;
    }
    return filePath;
  }

  _cropImage(File imageFile) async {
    File croppedImage = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        backgroundColor: Theme.of(context).backgroundColor,
        toolbarColor: Theme.of(context).appBarTheme.color,
        toolbarWidgetColor: Theme.of(context).accentColor,
        toolbarTitle: 'Crop Photo',
        activeControlsWidgetColor: Colors.blue,
      ),
      sourcePath: imageFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
    );
    return croppedImage;
  }

  void showException(CameraException e) {
    logError(e.code, e.description);
    print('Error: ${e.code}\n${e.description}');
  }

  void showMessage(String message) {
    print(message);
  }

  void logError(String code, String message) =>
      print('Error: $code\nMessage: $message');
}
