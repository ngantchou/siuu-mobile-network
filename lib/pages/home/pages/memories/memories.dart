import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Memories extends StatefulWidget {
  @override
  State<Memories> createState() {
    return MemoriesState();
  }
}

class MemoriesState extends State<Memories> {
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(height: height * 0.014),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildText(color: 0xff78849e, label: 'Memories', fontSize: 14),
            Row(
              children: [
                Image.asset('assets/images/playIcon.png'),
                buildText(color: 0xff000000, label: 'Watch all', fontSize: 14),
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
                                    _navigationService.navigateToCreateStory(
                                        context: context);
                                  },
                                  child:
                                      Image.asset("assets/images/user.png"))),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: SvgPicture.asset('assets/svg/plus.svg')),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.007),
                  buildText(
                      color: 0xff7E7E7E, label: 'Your Story', fontSize: 12)
                ],
              ),
              InkWell(
                onTap: () {
                  setState(() {});
                  Navigator.of(context).pushNamed('/story');
                },
                child: buildStatusColumn(
                    gradient: linearGradient,
                    imagePath: 'assets/images/friend1.png',
                    name: 'grandpa'),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.014),
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
