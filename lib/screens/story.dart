import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class Story extends StatefulWidget {
  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/images/bgImage.png',
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.029),
                    FlutterSlider(
                      disabled: true,
                      handler: FlutterSliderHandler(
                        // foregroundDecoration: BoxDecoration(),
                        child: Container(),
                      ),
                      trackBar: FlutterSliderTrackBar(),
                      // inactiveTrackBar:
                      //     BoxDecoration(color: Color(0xff929294)),
                      // activeTrackBar: BoxDecoration(color: Colors.white)),
                      values: [40],
                      hatchMark: FlutterSliderHatchMark(disabled: true),
                      handlerHeight: 0,
                      handlerWidth: 0,
                      max: 100,
                      min: 0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/photo1.png')),
                                  shape: BoxShape.circle),
                              height: height * 0.051,
                              width: width * 0.085,
                            ),
                            SizedBox(width: width * 0.024),
                            buildText(text: '_wecreate_', color: Colors.white),
                            SizedBox(width: width * 0.024),
                            buildText(
                              text: '1h',
                              color: Color(0xffffffff).withOpacity(0.70),
                            ),
                          ],
                        ),
                        IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: null)
                      ],
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: height * 0.131,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SvgPicture.asset('assets/svg/storyCamera.svg'),
                      Container(
                        height: height * 0.064,
                        width: width * 0.709,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: width * 0.002,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                            hintText: 'Send Message',
                            hintStyle: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 15,
                              color: Color(0xffffffff),
                            ),
                          ),
                        ),
                      ),
                      SvgPicture.asset('assets/svg/storyMsgSendIcon.svg'),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Text buildText({String text, Color color}) {
    return Text(
      "_wecreate_",
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 13,
        color: color,
      ),
    );
  }
}
