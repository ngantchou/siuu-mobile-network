import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottiePersonaStickers extends StatefulWidget {
  const LottiePersonaStickers({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  _LottiePersonaStickersState createState() => _LottiePersonaStickersState();
}

class _LottiePersonaStickersState extends State<LottiePersonaStickers> {
  bool search;
  bool recent;
  bool emoji;
  bool persona;

  @override
  void initState() {
    super.initState();
    search = false;
    recent = false;
    emoji = true;
    persona = false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      width: widget.width,
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
              // height: height*0.073,,
              width: widget.width,
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
            stick1: 'enamorado', stick2: 'cryingEmoji', stick3: 'emojiWink'),
        buildRow(
            stick1: 'shockedEmoji', stick2: 'SillyEmoji', stick3: 'kissEmoji'),
        buildRow(
            stick1: 'heartEyesEmoji',
            stick2: 'noseSteamEmoji',
            stick3: 'angryEmoji'),
        buildRow(
            stick1: 'sadTearEmoji', stick2: 'cussingEmoji', stick3: 'emojiWow'),
        buildRow(
            stick1: 'emojiFlash',
            stick2: 'sleepingEmoji',
            stick3: 'vomitingEmoji'),
        buildRow(
            stick1: 'locationFavourite',
            stick2: 'cantExpressLove',
            stick3: 'flyHigh'),
        buildRow(
            stick1: 'retroHeart', stick2: 'weekendVibe', stick3: 'catInBox'),
      ],
    );
  }

  Column buildStickerColumn() {
    return Column(
      children: [
        buildRow(stick1: 'arrete ca', stick2: 'blackGirl', stick3: 'Colère'),
        buildRow(stick1: 'etonné', stick2: 'feedback', stick3: 'flapperGirl'),
        buildRow(stick1: 'indianGirl', stick2: 'kiss', stick3: 'newsletter'),
        buildRow(stick1: 'pancarte', stick2: 'Rire', stick3: 'wave'),
        buildRow(stick1: 'Youpii', stick2: 'ZENN', stick3: 'helloLove'),
        Row(
          children: [
            Expanded(
              child: Lottie.asset('assets/lottie/rainAndWindy.json'),
            ),
            Expanded(
              child: Container(),
            ),
            Expanded(
              child: Container(),
            ),
          ],
        ),
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

  Row buildRow({String stick1, String stick2, String stick3}) {
    return Row(
      children: [
        Expanded(child: Lottie.asset('assets/lottie/$stick1.json')),
        Expanded(child: Lottie.asset('assets/lottie/$stick2.json')),
        Expanded(child: Lottie.asset('assets/lottie/$stick3.json')),
      ],
    );
  }
}
