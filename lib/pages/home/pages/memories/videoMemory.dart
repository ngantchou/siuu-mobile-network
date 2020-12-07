import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class VideoMemory extends StatefulWidget {
  final Widget video;

  VideoMemory({this.video});
  @override
  _VideoMemoryState createState() => _VideoMemoryState();
}

class _VideoMemoryState extends State<VideoMemory> {
  bool viewStickers;

  String selectedSticker;

  List<Widget> movableItems = [];

  bool search;
  bool recent;
  bool emoji;
  bool persona;

  @override
  void initState() {
    super.initState();
    viewStickers = false;
    selectedSticker = '';
    search = false;
    recent = false;
    emoji = true;
    persona = false;
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white70,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Stack(
              children: [
                Align(
                  alignment:
                      viewStickers ? Alignment.topCenter : Alignment.center,
                  child: Container(
                    height: height * 0.43,
                    width: width,
                    child: widget.video == null
                        ? Center(
                            child: Text('No video selected.'),
                          )
                        : Stack(
                            children: [
                              Positioned.fill(child: widget.video),
                              Positioned.fill(
                                child: Stack(
                                  children: movableItems,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: viewStickers
                      ? Column(
                          children: [
                            Container(
                              width: width,
                              color: Colors.grey.shade100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        viewStickers = false;
                                      });
                                    },
                                    child: Icon(Icons.close),
                                  )
                                ],
                              ),
                            ),
                            buildStickerContainer(width),
                          ],
                        )
                      : SizedBox(
                          width: width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    viewStickers = true;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/svg/emoji.svg',
                                    height: height * 0.073,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildStickerContainer(double width) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white,
      width: width,
      height: height * 0.43,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: SingleChildScrollView(
              child: persona ? buildStickerColumn() : buildEmojiColumn(),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              color: Colors.white,
              width: width,
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            search = true;
                            recent = false;
                            emoji = false;
                            persona = false;
                          });
                        },
                        child: buildRowIcons(
                            pressed: search ? true : false, icon: Icons.search),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            search = false;
                            recent = true;
                            emoji = false;
                            persona = false;
                          });
                        },
                        child: buildRowIcons(
                            pressed: recent ? true : false,
                            icon: Icons.access_time_rounded),
                      ),
                      InkWell(
                          onTap: () {
                            setState(() {
                              search = false;
                              recent = false;
                              emoji = true;
                              persona = false;
                            });
                          },
                          child: buildRowIcons(
                              pressed: emoji ? true : false,
                              icon: Icons.emoji_emotions_outlined)),
                      InkWell(
                          onTap: () {
                            setState(() {
                              search = false;
                              recent = false;
                              emoji = false;
                              persona = true;
                            });
                          },
                          child: buildRowIcons(
                              pressed: persona ? true : false,
                              icon: Icons.face_outlined)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Column buildEmojiColumn() {
    return Column(
      children: [
        buildRow(
            stick1: 'enamorado',
            stick2: 'cryingEmoji',
            stick3: 'emojiWink',
            stick4: 'shockedEmoji'),
        buildRow(
          stick1: 'SillyEmoji',
          stick2: 'kissEmoji',
          stick3: 'heartEyesEmoji',
          stick4: 'noseSteamEmoji',
        ),
        buildRow(
            stick1: 'angryEmoji',
            stick2: 'sadTearEmoji',
            stick3: 'cussingEmoji',
            stick4: 'emojiWow'),
        buildRow(
          stick1: 'emojiFlash',
          stick2: 'sleepingEmoji',
          stick3: 'vomitingEmoji',
          stick4: 'locationFavourite',
        ),
        buildRow(
          stick1: 'cantExpressLove',
          stick2: 'flyHigh',
          stick3: 'retroHeart',
          stick4: 'weekendVibe',
        ),
        buildRow(
            stick1: 'retroHeart', stick2: 'weekendVibe', stick3: 'catInBox'),
      ],
    );
  }

  Column buildStickerColumn() {
    return Column(
      children: [
        buildRow(
            stick1: 'arrete ca',
            stick2: 'blackGirl',
            stick3: 'Colère',
            stick4: 'etonné'),
        buildRow(
            stick1: 'feedback',
            stick2: 'flapperGirl',
            stick3: 'indianGirl',
            stick4: 'kiss'),
        buildRow(
            stick1: 'newsletter',
            stick2: 'pancarte',
            stick3: 'Rire',
            stick4: 'wave'),
        buildRow(
            stick1: 'Youpii',
            stick2: 'ZENN',
            stick3: 'helloLove',
            stick4: 'rainAndWindy'),
      ],
    );
  }

  Container buildRowIcons({IconData icon, bool pressed}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.073,
      width: width * 0.121,
      color: pressed ? Colors.blueGrey.shade100 : Colors.white,
      child: Center(
        child: Icon(icon),
      ),
    );
  }

  Row buildRow({String stick1, String stick2, String stick3, String stick4}) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
              onTap: () {
                setState(() {
                  movableItems.add(MoveableStackItem(
                    sticker: 'assets/lottie/$stick1.json',
                  ));
                });
              },
              child: Lottie.asset('assets/lottie/$stick1.json')),
        ),
        Expanded(
          child: InkWell(
              onTap: () {
                setState(() {
                  movableItems.add(MoveableStackItem(
                    sticker: 'assets/lottie/$stick2.json',
                  ));
                });
              },
              child: Lottie.asset('assets/lottie/$stick2.json')),
        ),
        Expanded(
          child: InkWell(
              onTap: () {
                setState(() {
                  movableItems.add(MoveableStackItem(
                    sticker: 'assets/lottie/$stick3.json',
                  ));
                });
              },
              child: Lottie.asset('assets/lottie/$stick3.json')),
        ),
        stick4 != null
            ? Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      movableItems.add(
                        MoveableStackItem(
                          sticker: 'assets/lottie/$stick4.json',
                        ),
                      );
                    });
                  },
                  child: Lottie.asset('assets/lottie/$stick4.json'),
                ),
              )
            : Container(),
      ],
    );
  }
}

class MoveableStackItem extends StatefulWidget {
  final String sticker;

  MoveableStackItem({this.sticker});
  @override
  _MoveableStackItemState createState() => _MoveableStackItemState();
}

class _MoveableStackItemState extends State<MoveableStackItem> {
  double xPosition = 0;
  double yPosition = 0;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        child: widget.sticker == ''
            ? Container()
            : Lottie.asset(widget.sticker, height: height * 0.146),
      ),
    );
  }
}
