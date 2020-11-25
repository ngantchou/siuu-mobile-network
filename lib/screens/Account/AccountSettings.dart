import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/screens/Account/AccountDetails.dart';
import 'package:Siuu/screens/Account/AccountPictureSettings.dart';
import 'package:Siuu/screens/Account/AccountPrivacy&Terms.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey();

  int _index;

  @override
  void initState() {
    _index = 0;
    super.initState();
  }

  switchStatements() {
    switch (_index) {
      case 0:
        return AccountDetails();
        break;
      case 1:
        return AccountPictureSettings();
        break;
      case 2:
        return AccountPrivacyAndTerms();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _drawerKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            gradient: linearGradient,
          ),
          child: Column(
            children: [
              Container(height: height * 0.0585),
              Container(
                height: height * 0.117,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {
                            _drawerKey.currentState.openDrawer();
                          },
                          child: Image.asset('assets/images/drawerMenu.png')),
                      Text(
                        "Account settings",
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 19,
                          color: Color(0xffffffff),
                        ),
                      ),
                      Text(
                        "Save",
                        style: TextStyle(
                          fontFamily: "Segoe UI",
                          fontSize: 11,
                          color: Color(0xffaeaeae),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Container(
        width: width * 0.243,
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: linearGradient,
            ),
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset('assets/images/drawerMenu.png'),
                ),
                SizedBox(height: height * 0.073),
                InkWell(
                    onTap: () {
                      setState(() {
                        _index = 0;
                      });
                      Navigator.pop(context);
                    },
                    child: _index == 0
                        ? buildCircleContainer(
                            icon: 'assets/svg/AccountSettingss.svg',
                          )
                        : SvgPicture.asset(
                            'assets/svg/AccountSettingss.svg',
                            color: Colors.white,
                          )),
                SizedBox(height: height * 0.073),
                InkWell(
                  onTap: () {
                    setState(() {
                      _index = 1;
                    });
                    Navigator.pop(context);
                  },
                  child: _index == 1
                      ? buildCircleContainer(
                          icon: 'assets/svg/AccountPictureSettings.svg',
                        )
                      : SvgPicture.asset(
                          'assets/svg/AccountPictureSettings.svg',
                          color: Colors.white,
                        ),
                ),
                SizedBox(height: height * 0.073),
                InkWell(
                  onTap: () {
                    setState(() {
                      _index = 2;
                    });
                    Navigator.pop(context);
                  },
                  child: _index == 2
                      ? buildCircleContainer(
                          icon: 'assets/svg/AccountPrivacyAndTerms.svg',
                        )
                      : SvgPicture.asset(
                          'assets/svg/AccountPrivacyAndTerms.svg',
                          color: Colors.white,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: switchStatements(),
    );
  }

//custom circle container
  Container buildCircleContainer({String icon}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.090,
      width: width * 0.150,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          icon,
        ),
      ),
    );
  }
}
