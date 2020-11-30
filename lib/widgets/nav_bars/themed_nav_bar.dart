import 'package:Siuu/models/theme.dart';
import 'package:Siuu/pages/home/pages/menu/menu.dart';
import 'package:Siuu/pages/home/pages/search/search.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A navigation bar that uses the current theme colours
class OBThemedNavigationBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Widget leading;
  final String title;
  final Widget trailing;
  final String previousPageTitle;
  final Widget middle;
  OBMainMenuPageController _mainMenuPageController;
  OBMainSearchPageController _searchPageController;

  OBThemedNavigationBar({
    this.leading,
    this.previousPageTitle,
    this.title,
    this.trailing,
    this.middle,
  });

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    _mainMenuPageController = OBMainMenuPageController();
    _searchPageController = OBMainSearchPageController();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: linearGradient,
      ),
      child: Column(
        children: [
          /* Container(
            height: height * 0.058,
          ),*/
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
                        Navigator.of(context).pushNamed('/camera');
                      },
                      child: SvgPicture.asset('assets/svg/Camera.svg')),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 19,
                      color: Color(0xffffffff),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OBMainSearchPage(
                                          controller: _searchPageController,
                                        )));
                          },
                          child: SizedBox(
                            height: height * 0.029,
                            width: width * 0.048,
                            child: SvgPicture.asset('assets/svg/search.svg',
                                fit: BoxFit.contain, color: Colors.white),
                          )),
                      SizedBox(width: width * 0.024),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OBMainMenuPage(
                                        controller: _mainMenuPageController,
                                      )));
                        },
                        child: SvgPicture.asset('assets/svg/menu.svg'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            height: height * 0.058,
          ),
        ],
      ),
    );
    /* return StreamBuilder(
      stream: themeService.themeChange,
      initialData: themeService.getActiveTheme(),
      builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
        var theme = snapshot.data;

        Color actionsForegroundColor = themeValueParserService
            .parseGradient(theme.primaryAccentColor)
            .colors[1];
        return CupertinoNavigationBar(
          border: null,
          actionsForegroundColor: actionsForegroundColor != null
              ? actionsForegroundColor
              : Colors.black,
          middle: middle ??
              (title != null
                  ? OBText(
                      title,
                    )
                  : const SizedBox()),
          transitionBetweenRoutes: false,
          backgroundColor:
              themeValueParserService.parseColor(theme.primaryColor),
          trailing: trailing,
          leading: leading,
        );
      },
    );*/
  }

  /// True if the navigation bar's background color has no transparency.
  @override
  bool get fullObstruction => true;

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
