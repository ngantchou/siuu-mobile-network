import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/res/colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MediaPlayer extends StatefulWidget {
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
          decoration: BoxDecoration(gradient: linearGradient),
          child: SingleChildScrollView(
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
                                    color: Colors.white)),
                            Text(
                              'Lorep Ipsum',
                              style: TextStyle(
                                fontFamily: "Segoe UI",
                                fontSize: 19,
                                color: Color(0xffffffff),
                              ),
                            ),
                            SvgPicture.asset('assets/svg/menu.svg'),
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
                            handlerSize: 0, progressBarWidth: 4, trackWidth: 4),
                      ),
                      innerWidget: (double) {
                        return Center(
                          child: Container(
                            height: height * 0.256,
                            width: width * 0.425,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: AssetImage('assets/images/photo1.png'),
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
                        buildText(
                            color: 0xffBCBCBC, fontSize: 13, text: "2:30 "),
                        buildText(
                            color: 0xffffffff, fontSize: 13, text: ": 4:45")
                      ],
                    ),
                    SizedBox(height: height * 0.014),
                    buildText(
                        color: 0xffffffff,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        text: "Higher Ground"),
                    SizedBox(height: height * 0.014),
                    buildText(
                        color: 0xffffffff, fontSize: 13, text: "Stevie Wonder"),
                    SizedBox(height: height * 0.073),
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
                                      color: Color(0xff956397),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                        child: SvgPicture.asset(
                                            'assets/svg/loop.svg')),
                                  )
                                : SvgPicture.asset('assets/svg/loop.svg')),
                        SvgPicture.asset('assets/svg/previousSong.svg'),
                        SvgPicture.asset('assets/svg/PlayButton.svg'),
                        SvgPicture.asset('assets/svg/nextSong.svg'),
                        SvgPicture.asset('assets/svg/shuffle.svg'),
                      ],
                    ),
                    SizedBox(height: height * 0.073),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Text buildText(
      {String text, int color, FontWeight fontWeight, double fontSize}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
