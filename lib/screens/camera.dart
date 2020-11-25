import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
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
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Positioned.fill(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/svg/flash.svg'),
                          SvgPicture.asset('assets/svg/HDR.svg'),
                          Row(
                            children: [
                              SvgPicture.asset('assets/svg/timer.svg'),
                              SizedBox(width: width * 0.012),
                              Text(
                                "3s",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Segoe UI",
                                  fontSize: 14,
                                  color: Color(0xff4d0cbb),
                                ),
                              )
                            ],
                          ),
                          SvgPicture.asset('assets/svg/filters.svg'),
                        ],
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: height * 0.024,
                          width: width * 0.8,
                          child: Stack(
                            children: [
                              Container(
                                height: height * 0.024,
                                width: width * 0.160,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      colors: [Colors.black, Colors.white],
                                      end: Alignment.centerRight),
                                ),
                              ),
                              CarouselSlider(
                                options: CarouselOptions(
                                  viewportFraction: 0.3,
                                  scrollDirection: Axis.horizontal,
                                  height: height * 0.024,
                                ),
                                items: [
                                  'PHOTO',
                                  'SQUARE',
                                  'VIDEO',
                                  'PANO',
                                ].map((i) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        child: buildText(
                                          '$i',
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              // ListView(
                              //   scrollDirection: Axis.horizontal,
                              //   children: [
                              //     buildText('PHOTO'),
                              //     buildText('SQUARE'),
                              //     buildText('VIDEO'),
                              //     buildText('PANO'),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset('assets/images/photoCaptured.png'),
                              Container(
                                height: height * 0.096,
                                width: width * 0.160,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: width * 0.014,
                                    color: Color(0xffffffff),
                                  ),
                                ),
                                child: Center(
                                  child: Container(
                                    height: height * 0.073,
                                    width: width * 0.121,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xffffffff),
                                    ),
                                  ),
                                ),
                              ),
                              SvgPicture.asset('assets/svg/swap.svg'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildText(String name) {
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: width * 0.072,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 15,
            color: Color(0xffffffff),
          ),
        ),
      ],
    );
  }
}
