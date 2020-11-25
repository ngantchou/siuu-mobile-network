import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/custom/customAppBars/appBar1.dart';
import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/res/colors.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isViewed1;
  bool isViewed2;
  bool isViewed3;
  bool isViewed4;
  @override
  void initState() {
    super.initState();
    isViewed1 = false;
    isViewed2 = false;
    isViewed3 = false;
    isViewed4 = false;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment(0.9, 0.75),
        child: FloatingActionButton(
          elevation: 0.0,
          child: Container(
            width: width * 0.145,
            height: height * 0.087,
            decoration:
                BoxDecoration(shape: BoxShape.circle, gradient: linearGradient),
            child: Center(
              child: SizedBox(
                height: height * 0.033,
                width: width * 0.058,
                child: SvgPicture.asset(
                  'assets/svg/pencilIcon.svg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/expressYourself');
          },
        ),
      ),
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: CustomAppbar(
          title: 'Home',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              SizedBox(height: height * 0.014),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildText(color: 0xff78849e, label: 'Memories', fontSize: 14),
                  Row(
                    children: [
                      Image.asset('assets/images/playIcon.png'),
                      buildText(
                          color: 0xff000000, label: 'Watch all', fontSize: 14),
                    ],
                  )
                ],
              ),
              SizedBox(height: height * 0.014),
              SizedBox(
                height: height * 0.131,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: height * 0.0892,
                          width: width * 0.1482,
                          // height: height * 0.096,
                          // width: width * 0.160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: width * 0.004,
                            ),
                          ),
                          child: SizedBox(
                            height: height * 0.083,
                            width: width * 0.1385,
                            child: Stack(
                              children: [
                                Positioned.fill(
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              '/connectionLostScreen');
                                        },
                                        child: Image.asset(
                                            "assets/images/user.png"))),
                                Align(
                                    alignment: Alignment.bottomRight,
                                    child: SvgPicture.asset(
                                        'assets/svg/plus.svg')),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.007),
                        buildText(
                            color: 0xff7E7E7E,
                            label: 'Your Story',
                            fontSize: 12)
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isViewed1 = true;
                        });
                        Navigator.of(context).pushNamed('/story');
                      },
                      child: buildStatusColumn(
                          gradient: isViewed1
                              ? LinearGradient(
                                  colors: [Colors.grey, Colors.grey],
                                )
                              : linearGradient,
                          imagePath: 'assets/images/friend1.png',
                          name: 'grandpa'),
                    ),
                    buildStatusColumn(
                        gradient: isViewed2
                            ? LinearGradient(
                                colors: [Colors.grey, Colors.grey],
                              )
                            : linearGradient,
                        imagePath: 'assets/images/friend2.png',
                        name: 'beardguy'),
                    buildStatusColumn(
                        gradient: isViewed3
                            ? LinearGradient(
                                colors: [Colors.grey, Colors.grey],
                              )
                            : linearGradient,
                        imagePath: 'assets/images/friend3.png',
                        name: 'Ally'),
                    buildStatusColumn(
                        gradient: isViewed4
                            ? LinearGradient(
                                colors: [Colors.grey, Colors.grey],
                              )
                            : linearGradient,
                        imagePath: 'assets/images/friend4.png',
                        name: 'elleranas'),
                  ],
                ),
              ),
              SizedBox(height: height * 0.014),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Column(
                  children: [
                    CustomPostContainer(
                      image: 'avatar',
                      commentsNumber: '256',
                      heartNumber: '428',
                      height: height * 0.357,
                      personName: 'Jerome Gaveau',
                      widget: Text(
                        "When one door of happiness closes, another opens, but often we look so long at the closed door that we do not see the one that has been opened for us. ",
                        style: TextStyle(
                          height: height * 0.002,
                          fontFamily: "Segoe UI",
                          fontSize: 14,
                          color: Color(0xff78849e),
                        ),
                      ),
                    ),
                    CustomPostContainer(
                      image: 'avatar2',
                      commentsNumber: '143',
                      heartNumber: '942',
                      height: height * 0.421,
                      personName: 'Jonathan Lecluze',
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Believe you can and you’re halfway there.",
                            style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 14,
                              color: Color(0xff78849e),
                            ),
                          ),
                          SizedBox(height: height * 0.014),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/mediaPlayer');
                            },
                            child: Image.asset('assets/images/girlPicture.png'),
                          )
                        ],
                      ),
                    ),
                    buildCustomSuggestionColumn(),
                    CustomPostContainer(
                      image: 'avatar',
                      commentsNumber: '256',
                      heartNumber: '428',
                      height: height * 0.357,
                      personName: 'Jerome Gaveau',
                      widget: Text(
                        "When one door of happiness closes, another opens, but often we look so long at the closed door that we do not see the one that has been opened for us. ",
                        style: TextStyle(
                          height: height * 0.002,
                          fontFamily: "Segoe UI",
                          fontSize: 14,
                          color: Color(0xff78849e),
                        ),
                      ),
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

  Padding buildCustomSuggestionColumn() {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildText(
                  color: 0xff000000,
                  fontSize: 16,
                  label: 'Suggestions for you'),
              buildText(color: 0xff4d0cbb, fontSize: 16, label: 'View All')
            ],
          ),
          SizedBox(
            height: height * 0.0292,
          ),
          SizedBox(
            height: height * 0.2999,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                buildSuggestionContainer(),
                buildSuggestionContainer(),
                buildSuggestionContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row buildSuggestionContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
          height: height * 0.2999,
          width: width * 0.396,
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.close,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/profile-picture.png',
                          ),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                      height: height * 0.105,
                      width: width * 0.175,
                    ),
                    Spacer(),
                    buildText(
                      color: 0xff000000,
                      fontSize: 16,
                      label: "John Doe",
                    ),
                    // Spacer(),
                    buildText(
                      color: 0xff7e7e7e,
                      fontSize: 10,
                      label: "@anysiuuser",
                    ),
                    Spacer(
                      flex: 3,
                    ),
                    new Container(
                      height: height * 0.033,
                      width: width * 0.226,
                      decoration: BoxDecoration(
                        color: Color(0xffffffff),
                        border: Border.all(
                          width: 1.00,
                          color: Color(0xff4d0cbb),
                        ),
                        borderRadius: BorderRadius.circular(8.00),
                      ),
                      child: Center(
                        child: buildText(
                          color: 0xff4d0cbb,
                          fontSize: 8,
                          label: "FOLLOW",
                        ),
                      ),
                    ),
                    Spacer(
                      flex: 2,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(width: width * 0.0194)
      ],
    );
  }

  Row buildStatusColumn({String imagePath, String name, Gradient gradient}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        SizedBox(
          width: width * 0.048,
        ),
        Column(
          children: [
            Container(
              width: width * 0.1482,
              height: height * 0.0892,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: Colors.red,
                  gradient: gradient
                  // border: Border.all(color: Colors.red, width: 2),
                  ),
              child: Center(
                child: Container(
                  height: height * 0.083,
                  width: width * 0.1385,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(child: Image.asset(imagePath)),
                ),
              ),
            ),
            SizedBox(height: height * 0.007),
            buildText(color: 0xff000000, fontSize: 12, label: name)
          ],
        ),
      ],
    );
  }

  Text buildText({String label, double fontSize, int color}) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }
}
