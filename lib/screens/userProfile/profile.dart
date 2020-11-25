import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/res/colors.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool isInformationPressed = true;
  bool isPublicationsPressed = false;

  TabController _tabController;
  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          setState(() {
            isInformationPressed = true;
            isPublicationsPressed = false;
          });

          break;
        case 1:
          setState(() {
            isInformationPressed = false;
            isPublicationsPressed = true;
          });

          break;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: height * 0.512,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: linearGradient,
                            ),
                            height: height * 0.336,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed: null),
                                      SvgPicture.asset('assets/svg/menu.svg'),
                                    ],
                                  ),
                                  Spacer(
                                    flex: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: height * 0.365,
                              width: width * 0.607,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: Image.asset(
                                      'assets/images/profile-picture.png',
                                    ),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 20,
                                    child:
                                        SvgPicture.asset('assets/svg/DM.svg'),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child: SvgPicture.asset(
                                        'assets/svg/add-to.svg'),
                                  ),
                                  Positioned(
                                    left: 40,
                                    bottom: 40,
                                    child: SvgPicture.asset(
                                        'assets/svg/active.svg'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.014),
                    Text(
                      "Julie Palmer",
                      style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 40,
                        color: Color(0xff4d0cbb),
                      ),
                    ),
                    SizedBox(height: height * 0.029),
                    Row(
                      children: [
                        Spacer(
                          flex: 2,
                        ),
                        Column(
                          children: [
                            buildText(
                                color: 0xff000000, fontSize: 22, label: '5'),
                            buildText(
                                color: 0xffaeb5bc,
                                fontSize: 11,
                                label: 'Friends'),
                          ],
                        ),
                        Spacer(),
                        buildLineContainer(),
                        Spacer(),
                        Column(
                          children: [
                            buildText(
                                color: 0xff000000, fontSize: 22, label: '242'),
                            buildText(
                                color: 0xffaeb5bc,
                                fontSize: 11,
                                label: 'Follower'),
                          ],
                        ),
                        Spacer(),
                        buildLineContainer(),
                        Spacer(),
                        Column(
                          children: [
                            buildText(
                                color: 0xff000000, fontSize: 22, label: '100'),
                            buildText(
                                color: 0xffaeb5bc,
                                fontSize: 11,
                                label: 'Follows'),
                          ],
                        ),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.029),
                    SizedBox(
                      height: height * 0.321,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Image.asset(
                                  'assets/images/girl1.png',
                                ),
                                Image.asset('assets/images/girl2.png'),
                                Image.asset('assets/images/girl3.png'),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 50,
                            bottom: 50,
                            left: 50,
                            child: Container(
                              height: height * 0.157,
                              width: width * 0.261,
                              decoration: BoxDecoration(
                                color: Color(0xff52575d),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 10.00),
                                    color: Color(0xff000000).withOpacity(0.38),
                                    blurRadius: 20,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(12.00),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildText(
                                      color: 0xffDFD8C8,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      label: '5'),
                                  buildText(
                                      color: 0xffAEB5BC,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      label: 'PICS')
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: TabBar(
                  indicatorColor: Colors.white,
                  indicatorWeight: 0.1,
                  controller: _tabController,
                  tabs: [
                    Tab(
                      child: Container(
                        height: height * 0.061,
                        width: width * 0.369,
                        decoration: BoxDecoration(
                          gradient:
                              isInformationPressed ? linearGradient : null,
                          border: isInformationPressed
                              ? null
                              : Border.all(
                                  width: width * 0.002,
                                  color: Color(0xff4D0CBB),
                                ),
                          borderRadius: BorderRadius.circular(21.00),
                        ),
                        child: Center(
                          child: Text(
                            "Informations",
                            style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 19,
                              color: Color(isInformationPressed
                                  ? 0xffffffff
                                  : 0xff4d0cbb),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: height * 0.061,
                        width: width * 0.369,
                        decoration: BoxDecoration(
                          gradient:
                              isPublicationsPressed ? linearGradient : null,
                          border: isPublicationsPressed
                              ? null
                              : Border.all(
                                  width: width * 0.002,
                                  color: Color(0xff4D0CBB),
                                ),
                          borderRadius: BorderRadius.circular(21.00),
                        ),
                        child: Center(
                          child: Text(
                            "Publications",
                            style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 19,
                              color: Color(isPublicationsPressed
                                  ? 0xffffffff
                                  : 0xff4d0cbb),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        buildCustomPostContainer(),
                        buildCustomPostContainer(),
                        buildCustomPostContainer(),
                      ],
                    ),
                  ),
                ],
              ),
              ListView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 10, 0),
                    child: Column(
                      children: [
                        buildColumn(
                          title: 'Membier since',
                          trailing: 'a day a go',
                        ),
                        buildColumn(
                          title: 'Last seen',
                          trailing: '3 hours ago',
                        ),
                        buildColumn(
                          title: 'Email',
                          trailing: 'loremipsum@gmail.com',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                        buildColumn(
                          title: 'lorep Ipsum',
                          trailing: 'lorep Ipsum',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column buildColumn({String title, String trailing}) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.014),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.w300,
                fontSize: 13,
                color: Color(0xffbbbbbb),
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Color(0xff4d0cbb),
              ),
            )
          ],
        ),
        Divider(
          color: Color(0xff707070),
          thickness: 1,
        )
      ],
    );
  }

  CustomPostContainer buildCustomPostContainer() {
    final double height = MediaQuery.of(context).size.height;
    return CustomPostContainer(
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
    );
  }

  Text buildText(
      {String label, double fontSize, int color, FontWeight fontWeight}) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: fontWeight != null ? fontWeight : null,
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }

  Container buildLineContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.036,
      width: width * 0.004,
      color: Color(0xff3b3b3b),
    );
  }
}
