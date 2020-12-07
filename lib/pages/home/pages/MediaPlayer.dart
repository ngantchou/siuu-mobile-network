import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MediaPlayer extends StatefulWidget {
  final LinearGradient gradient;
  final bool isColor;
  final Widget child;
  final bool isfontColorWhite;

  MediaPlayer({this.gradient, this.isColor, this.child, this.isfontColorWhite});

  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  bool isOnLoop = false;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Container(
          decoration: widget.isColor
              ? BoxDecoration(
                  gradient: widget.isColor ? widget.gradient : null,
                )
              : null,
          child: Stack(
            children: [
              Positioned.fill(
                  child: widget.isColor ? Container() : widget.child),
              SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(height: height * 0.0585),
                        Container(
                          height: height * 0.117,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color: widget.isfontColorWhite
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                Text(
                                  'Siuu user',
                                  style: TextStyle(
                                      fontFamily: "Segoe UI",
                                      fontSize: 19,
                                      color: widget.isfontColorWhite
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                SvgPicture.asset('assets/svg/menu.svg',
                                    color: widget.isfontColorWhite
                                        ? Colors.white
                                        : Colors.black),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.073),
                    Column(
                      children: [
                        SleekCircularSlider(
                          appearance: CircularSliderAppearance(
                            counterClockwise: false,
                            size: 215,
                            startAngle: 90,
                            angleRange: 360,
                            customColors: CustomSliderColors(
                                trackColor: Colors.blueGrey.shade200,
                                progressBarColor: Colors.white),
                            customWidths: CustomSliderWidths(
                                handlerSize: 0,
                                progressBarWidth: 4,
                                trackWidth: 4),
                          ),
                          innerWidget: (double) {
                            return Center(
                              child: Container(
                                height: height * 0.256,
                                width: width * 0.425,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/photo1.png'),
                                      fit: BoxFit.contain),
                                ),
                              ),
                            );
                          },
                          onChange: (double value) {
                            print(value);
                          },
                        ),
                        SizedBox(height: height * 0.014),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buildText(fontSize: 13, text: "0:00 "),
                            buildText(fontSize: 13, text: ": 0:30")
                          ],
                        ),
                        SizedBox(height: height * 0.014 + height * 0.073),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isOnLoop) {
                                      isOnLoop = false;
                                    } else
                                      isOnLoop = true;
                                  });
                                },
                                child: isOnLoop
                                    ? Container(
                                        height: height * 0.087,
                                        width: width * 0.145,
                                        decoration: BoxDecoration(
                                          color: widget.isfontColorWhite
                                              ? Colors.white
                                              : Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                            child: SvgPicture.asset(
                                                'assets/svg/loop.svg')),
                                      )
                                    : SvgPicture.asset('assets/svg/loop.svg',
                                        color: widget.isfontColorWhite
                                            ? Colors.white
                                            : Colors.black)),
                            SvgPicture.asset('assets/svg/previousSong.svg',
                                color: widget.isfontColorWhite
                                    ? Colors.white
                                    : Colors.black),
                            SvgPicture.asset('assets/svg/PlayButton.svg',
                                color: widget.isfontColorWhite
                                    ? Colors.white
                                    : Colors.black),
                            SvgPicture.asset('assets/svg/nextSong.svg',
                                color: widget.isfontColorWhite
                                    ? Colors.white
                                    : Colors.black),
                            SvgPicture.asset('assets/svg/shuffle.svg',
                                color: widget.isfontColorWhite
                                    ? Colors.white
                                    : Colors.black),
                          ],
                        ),
                        SizedBox(height: height * 0.073),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Text buildText({String text, FontWeight fontWeight, double fontSize}) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: "Segoe UI",
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: widget.isfontColorWhite ? Colors.white : Colors.black),
    );
  }
}
