import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/story/stories_service.dart';
import 'package:Siuu/story/story_model.dart';
import 'package:Siuu/story/utilities/constants.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../storyView.dart';

class Memories extends StatefulWidget {
  String avatar;
  List<CameraDescription> cameras;
  CameraConsumer cameraConsumer = CameraConsumer.Photo;
  Memories(this.avatar,this.cameras,this.cameraConsumer);

  @override
  State<Memories> createState() {
    return MemoriesState();
  }
}

class MemoriesState extends State<Memories> {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  List<Story> stories = [];

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final String userPic = widget.avatar;
    return Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            SizedBox(height: height * 0.004),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildText(color: 0xff78849e, label: 'Stories', fontSize: 14),
                Row(
                  children: [
                    Image.asset('assets/images/playIcon.png'),
                    buildText(
                        color: 0xff000000, label: 'Watch all', fontSize: 14),
                  ],
                )
              ],
            ),
            SizedBox(height: height * 0.004),
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
                                        _navigationService
                                            .navigateToCreateStory(
                                                context: context,backToHomeScreen:null ,cameras:widget.cameras ,cameraConsumer: widget.cameraConsumer);
                                      },
                                      child: Container(
                                        width: width * 0.1482,
                                        height: height * 0.0892,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // color: Colors.red,
                                            gradient: linearGradient
                                            // border: Border.all(color: Colors.red, width: 2),
                                            ),
                                        child: Center(
                                          child: Container(
                                            height: height * 0.053,
                                            width: width * 0.1085,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: userPic != null
                                                      ? NetworkImage(userPic)
                                                      : AssetImage(
                                                          "assets/images/fallbacks/avatar-fallback.jpg")),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            child: Container(),
                                          ),
                                        ),
                                      ))),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child:
                                      SvgPicture.asset('assets/svg/plus.svg')),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.007),
                      buildText(
                          color: 0xff7E7E7E, label: 'Your Story', fontSize: 12)
                    ],
                  ),
                  FutureBuilder<List<Story>>(
                    future: StoriesService.getStoriesByUserId(_userService.getLoggedInUser().uuid, true), // a previously-obtained Future<String> or null
                    builder: (BuildContext context, AsyncSnapshot<List<Story>> snapshot) {
                      List<Widget> children;
                      List<Story> stories = snapshot.data;
                      if (snapshot.hasData) {
                        for (Story story in stories) {
                          children = <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {});
                                _navigationService.navigateToStory(context: context,stories: stories,user: _userService.getLoggedInUser());
                              },
                              child: buildStatusColumn(
                                  gradient: linearGradient,
                                  imagePath: _userService.getLoggedInUser().profile.avatar,
                                  name: story.caption),
                            ),
                          ];
                        }
                      } else if (snapshot.hasError) {
                        children = <Widget>[
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text('Error: ${snapshot.error}'),
                          )
                        ];
                      } else {
                        children = const <Widget>[
                          SizedBox(
                            child: CircularProgressIndicator(),
                            width: 60,
                            height: 60,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Text('Awaiting result...'),
                          )
                        ];
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: children,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: height * 0.014),
          ],
        ));
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
                  child: Container(
                    height: height * 0.053,
                    width: width * 0.1085,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _userService.getLoggedInUser().profile.avatar != null
                              ? NetworkImage(_userService.getLoggedInUser().profile.avatar)
                              : AssetImage(
                              "assets/images/fallbacks/avatar-fallback.jpg")),
                      border: Border.all(
                          color: Colors.white,
                          width: 2),
                    ),
                    child: Container(),
                  ),
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
