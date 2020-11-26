import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:flutter/material.dart';

class OBProfileFollowingCount extends StatelessWidget {
  final User user;

  OBProfileFollowingCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followingCount = user.followingCount;
    LocalizationService localizationService = OpenbookProvider.of(context).localizationService;

    if (followingCount == null || followingCount == 0) return const SizedBox();

    String count = getPrettyCount(followingCount, localizationService);

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return GestureDetector(
            onTap: () {
              if (userService.isLoggedInUser(user)) {
                navigationService.navigateToFollowingPage(context: context);
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                    Text(count,
                        style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 22,
                            color: Color(0xff000000))),
                    Text( localizationService.post__profile_counts_following,
                        style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 11,
                            color: Color(0xffaeb5bc))),
                SizedBox(
                  width: 10,
                )
              ],
            ),
          );
        });
  }
}
