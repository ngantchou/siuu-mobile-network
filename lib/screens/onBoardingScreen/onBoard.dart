import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/res/colors.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int _index;
  String _image;
  String _text;
  PageController controller;
  @override
  void initState() {
    super.initState();
    _index = 0;
    _image = 'onBoard1Picture';
    _text = 'Decouvrez un nouveau monde';
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              _index = index;
            });
          },
          children: <Widget>[
            SlideTile(
              imagePath:'assets/images/onBoard1Picture.png',
              title:'Decouvrez un nouveau monde',
              desc: "",
              index: _index,
              width: width,
              height: height,
            ),
            SlideTile(
              imagePath:'assets/images/onBoard2Picture.png',
              title: "Echangez avec vos amis",
              desc: "",
              index: _index,
              width: width,
              height: height,
            ),
            SlideTile(
              imagePath:'assets/images/onBoard3Picture.png',
              title: "Discutez en toute sécurité",
              desc: "",
              index: _index,
              width: width,
              height: height,
            )
          ],
        ),
        /*bottomSheet: _index != 2 ? Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                onPressed: (){
                  controller.animateToPage(2, duration: Duration(milliseconds: 400), curve: Curves.linear);
                },
                splashColor: Colors.blue[50],
                child: Text(
                  "SKIP",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: Row(
                  children: [
                    for (int i = 0; i < 3 ; i++) i == _index ? _buildPageIndicator(true): _buildPageIndicator(false),
                  ],),
              ),
              FlatButton(
                onPressed: (){
                  print("this is slideIndex: $_index");
                  controller.animateToPage(_index + 1, duration: Duration(milliseconds: 500), curve: Curves.linear);
                },
                splashColor: Colors.blue[50],
                child: Text(
                  "NEXT",
                  style: TextStyle(color: Color(0xFF0074E4), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ): InkWell(
          onTap: (){
            print("Get Started Now");
          },
          child: Container(
            height: Platform.isIOS ? 70 : 60,
            color: Colors.blue,
            alignment: Alignment.center,
            child: Text(
              "GET STARTED NOW",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),*/
      ),
    );
  }

  Container buildHugeContainer(String number) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.080,
      width: width * 0.134,
      decoration:
          BoxDecoration(gradient: linearGradient, shape: BoxShape.circle),
      child: Center(
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 19,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }

  Container buildTinyContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.006,
      width: width * 0.010,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        shape: BoxShape.circle,
      ),
    );
  }

  Text buildText(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 12,
        color: Color(0xffffffff),
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String imagePath, title, desc;
  int index;
  double height;
  double width;
  SlideTile({this.imagePath, this.title, this.desc,this.index,this.width,this.height});

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child:SizedBox(
        height: height,
        width: width,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(height: height * 0.029),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset('assets/svg/leftCircle.svg'),
                    index == 0
                        ? buildHugeContainer('1',width,height)
                        : buildTinyContainer(width,height),
                    index == 1
                        ? buildHugeContainer('2',width,height)
                        : buildTinyContainer(width,height),
                    index == 2
                        ? buildHugeContainer('3',width,height)
                        : buildTinyContainer(width,height),
                    SvgPicture.asset(
                      'assets/svg/rightCircle.svg',
                    ),
                  ],
                ),
                SizedBox(
                  height: height * 0.117,
                ),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xffffffff),
                  ),
                ),
                SizedBox(
                  height: height * 0.512,
                ),
                InkWell(
                  onTap: () {
                        if (index == 3) {
                          Navigator.of(context).pushNamed('/auth');
                        }
                  },
                  child: Container(
                    height: height * 0.067,
                    width: width * 0.639,
                    decoration: BoxDecoration(
                      // color: Color(0xffffffff),
                      border: Border.all(
                        width: width * 0.004,
                        color: Color(0xffffffff),
                      ),
                      borderRadius: BorderRadius.circular(22.00),
                    ),
                    child: Center(
                      child: Text(
                        "LET’S START",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xffffffff),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.029),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildText('Already have an account?'),
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/auth');
                        },
                        child: buildText('Sign In')),
                  ],
                ),
                SizedBox(height: height * 0.029),
              ],
            )
          ],
        ),
      ),
    );
  }
  Container buildHugeContainer(String number,double width,double height) {
    return Container(
      height: height * 0.080,
      width: width * 0.134,
      decoration:
      BoxDecoration(gradient: linearGradient, shape: BoxShape.circle),
      child: Center(
        child: Text(
          number,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Segoe UI",
            fontSize: 19,
            color: Color(0xffffffff),
          ),
        ),
      ),
    );
  }
  Container buildTinyContainer(double width,double height) {
    return Container(
      height: height * 0.006,
      width: width * 0.010,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        shape: BoxShape.circle,
      ),
    );
  }

  Text buildText(String label) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: 12,
        color: Color(0xffffffff),
      ),
    );
  }
}