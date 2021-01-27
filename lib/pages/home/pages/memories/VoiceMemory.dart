import 'dart:io';

import 'package:Siuu/pages/home/pages/MediaPlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

typedef _Fn = void Function();
typedef IntCallback = Function(String _mPath);

class VoiceMemory extends StatefulWidget {
  IntCallback onRecorded;
  VoiceMemory({this.onRecorded});
  @override
  _VoiceMemoryState createState() => _VoiceMemoryState();
}

class _VoiceMemoryState extends State<VoiceMemory>
    with TickerProviderStateMixin {
  /*FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder _mRecorder = FlutterSoundRecorder();*/
  bool _mPlayerIsInited = false;
  bool _mRecorderIsInited = false;
  bool _mplaybackReady = false;
  String _mPath;
  bool isPng;
  bool isSvg;
  bool isColor;
  int color;

  bool isRecording;
  bool isRecorded;

  bool isfontColorWhite;

  LinearGradient gradient;

  bool isExpanded;
  String imagePath;

  Widget expressYourselfPost;

  @override
  void initState() {
    super.initState();
    /*_mPlayer.openAudioSession().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    openTheRecorder().then((value) {
      setState(() {
        _mRecorderIsInited = true;
      });
    });*/
    imagePath = '';
    isRecording = false;
    isRecorded = false;
    expressYourselfPost = Container();
    isfontColorWhite = false;
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    );
    isPng = false;
    isSvg = false;
    isColor = true;
    color = 0xffffffff;
    isExpanded = false;
  }
/*
  @override
  void dispose() {
    stopPlayer();
    _mPlayer.closeAudioSession();
    _mPlayer = null;

    stopRecorder();
    _mRecorder.closeAudioSession();
    _mRecorder = null;
    if (_mPath != null) {
      var outputFile = File(_mPath);
      if (outputFile.existsSync()) {
        outputFile.delete();
      }
    }
    super.dispose();
  }

  Future<void> openTheRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    var tempDir = await getTemporaryDirectory();
    _mPath = '${tempDir.path}/flutter_sound_example.aac';
    var outputFile = File(_mPath);
    if (outputFile.existsSync()) {
      await outputFile.delete();
    }
    await _mRecorder.openAudioSession();
    _mRecorderIsInited = true;
  }

  // ----------------------  Here is the code for recording and playback -------

  Future<void> record() async {
    assert(_mRecorderIsInited && _mPlayer.isStopped);
    await _mRecorder.startRecorder(
      toFile: _mPath,
      codec: Codec.aacADTS,
    );
    setState(() {});
  }

  Future<void> stopRecorder() async {
    await _mRecorder.stopRecorder();
    _mplaybackReady = true;
  }

  void play() async {
    assert(_mPlayerIsInited &&
        _mplaybackReady &&
        _mRecorder.isStopped &&
        _mPlayer.isStopped);
    await _mPlayer.startPlayer(
        fromURI: _mPath,
        codec: Codec.aacADTS,
        whenFinished: () {
          setState(() {});
        });
    setState(() {});
  }

  Future<void> stopPlayer() async {
    await _mPlayer.stopPlayer();
  }

// ----------------------------- UI --------------------------------------------

  _Fn getRecorderFn() {
    if (!_mRecorderIsInited || !_mPlayer.isStopped) {
      return null;
    }
    return _mRecorder.isStopped
        ? record
        : () {
            stopRecorder().then((value) => setState(() {}));
          };
  }

  _Fn getPlaybackFn() {
    if (!_mPlayerIsInited || !_mplaybackReady || !_mRecorder.isStopped) {
      return null;
    }
    return _mPlayer.isStopped
        ? play
        : () {
            stopPlayer().then((value) => setState(() {}));
          };
  }*/

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: new Container(
                decoration: new BoxDecoration(
                  gradient: isColor ? gradient : null,
                ),
                child: isSvg
                    ? SvgPicture.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      )
                    : isPng
                        ? Image.asset(
                            imagePath,
                            fit: BoxFit.cover,
                          )
                        : null),
          ),
          /*Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isRecording
                    ? Column(
                        children: [
                          buildText(text: 'Your Voice is Recording'),
                          SizedBox(
                            height: height * 0.043,
                          ),
                          SpinKitWave(
                            color:
                                isfontColorWhite ? Colors.white : Colors.black,
                            size: 50.0,
                            controller: AnimationController(
                                vsync: this,
                                duration: const Duration(milliseconds: 1200)),
                          ),
                          SizedBox(
                            height: height * 0.043,
                          ),
                        ],
                      )
                    : isRecorded
                        ? buildText(text: 'Play your recorded crew')
                        : buildText(text: 'Record Your Voice\nMemory here'),
                GestureDetector(
                  child: Icon(
                      isRecorded
                          ? Icons.play_circle_filled_rounded
                          : Icons.keyboard_voice,
                      size: 40,
                      color: isfontColorWhite ? Colors.white : Colors.black),
                  onLongPressStart: (details) {
                    // getRecorderFn();
                    setState(() {
                      isRecording = true;
                    });
                  },
                  onLongPressUp: () {
                    // getPlaybackFn();
                    setState(() {
                      isRecording = false;
                      isRecorded = true;
                    });
                  },
                )
              ],
            ),
          ),*/
          Positioned(
            // bottom: MediaQuery.of(context).viewInsets.bottom,
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                height: height * 0.043,
                child: Row(
                  children: [
                    Container(
                      height: height * 0.043,
                      width: width * 0.0729,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black54,
                              ),
                            ),
                            child: coloredBox(
                                boxColor: 0xffffffff, fontColor: 'black'),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xff293DA8, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isfontColorWhite = true;
                                isColor = false;
                                isSvg = false;
                                isPng = true;
                                imagePath =
                                    'assets/images/abstractBackground.png';
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: height * 0.0365,
                                width: width * 0.083,
                                child: Image.asset(
                                  "assets/images/abstractBackground.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xffA32775, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/abstraction.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xffDD15B5, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/giraffe.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(fontColor: 'white', boxColor: 0xff1549DD),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/heart3.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/hearts2.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/lines.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/lines2.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/love.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'black',
                              boxImagePath:
                                  'assets/svg/oldSchoolMusicBackground.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/planets.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isfontColorWhite = true;
                                isColor = false;
                                isSvg = false;
                                isPng = true;
                                imagePath = 'assets/images/triangles.png';
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: height * 0.0365,
                                width: width * 0.083,
                                child: Image.asset(
                                  "assets/images/triangles.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 30,
            child: InkWell(
              onTap: () {
                widget.onRecorded(_mPath);
              },
              child: Text(
                "Save",
                style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: isfontColorWhite ? Colors.white : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Text buildText({String text}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontFamily: "Segoe UI",
          fontWeight: FontWeight.w300,
          fontSize: 25,
          color: isfontColorWhite ? Colors.white : Colors.black),
    );
  }

  InkWell imageBox({String boxImagePath, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          isSvg = true;
          isPng = false;
          isColor = false;
          fontColor == 'white'
              ? isfontColorWhite = true
              : isfontColorWhite = false;
          imagePath = boxImagePath;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: height * 0.0365,
          width: width * 0.083,
          child: SvgPicture.asset(
            boxImagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  InkWell coloredBox({int boxColor, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(
          () {
            gradient = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(boxColor), Colors.white],
            );
            fontColor == 'white'
                ? isfontColorWhite = true
                : isfontColorWhite = false;
            isColor = true;
            isSvg = false;
            isPng = false;
            color = boxColor;
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(boxColor), Colors.white],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        height: height * 0.0365,
        width: width * 0.083,
      ),
    );
  }
}
