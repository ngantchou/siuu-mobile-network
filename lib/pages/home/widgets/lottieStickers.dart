import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieStickers extends StatelessWidget {
  const LottieStickers({
    Key key,
    @required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.white38,
      width: width,
      height: height * 0.117,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Lottie.asset('assets/lottie/enamorado.json'),
          Lottie.asset('assets/lottie/cryingEmoji.json'),
          Lottie.asset('assets/lottie/emojiWink.json'),
          Lottie.asset('assets/lottie/shockedEmoji.json'),
          Lottie.asset('assets/lottie/SillyEmoji.json'),
          Lottie.asset('assets/lottie/kissEmoji.json'),
          Lottie.asset('assets/lottie/heartEyesEmoji.json'),
          Lottie.asset('assets/lottie/noseSteamEmoji.json'),
          Lottie.asset('assets/lottie/angryEmoji.json'),
          Lottie.asset('assets/lottie/sadTearEmoji.json'),
          Lottie.asset('assets/lottie/cussingEmoji.json'),
          Lottie.asset('assets/lottie/emojiWow.json'),
          Lottie.asset('assets/lottie/emojiFlash.json'),
          Lottie.asset('assets/lottie/sleepingEmoji.json'),
          Lottie.asset('assets/lottie/vomitingEmoji.json'),
          Lottie.asset('assets/lottie/locationFavourite.json'),
          Lottie.asset('assets/lottie/cantExpressLove.json'),
          Lottie.asset('assets/lottie/flyHigh.json'),
          Lottie.asset('assets/lottie/helloLove.json'),
          Lottie.asset('assets/lottie/retroHeart.json'),
          Lottie.asset('assets/lottie/weekendVibe.json'),
        ],
      ),
    );
  }
}
