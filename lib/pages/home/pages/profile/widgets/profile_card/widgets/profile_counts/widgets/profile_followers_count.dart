import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:flutter/material.dart';

class OBProfileFollowersCount extends StatelessWidget {
  final User user;

  OBProfileFollowersCount(this.user);

  @override
  Widget build(BuildContext context) {
    int followersCount = user.followersCount;

    if (followersCount == null ||
        followersCount == 0 ||
        user.getProfileFollowersCountVisible() == false)
      return const SizedBox();

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var userService = openbookProvider.userService;
    var navigationService = openbookProvider.navigationService;
    LocalizationService _localizationService = openbookProvider.localizationService;
    String count = getPrettyCount(followersCount, _localizationService);

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return GestureDetector(
            onTap: () {
              if (userService.isLoggedInUser(user)) {
                navigationService.navigateToFollowersPage(context: context);
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
                    Text( followersCount == 1 ? _localizationService.post__profile_counts_follower : _localizationService.post__profile_counts_followers,
                        style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 11,
                            color: Color(0xffaeb5bc))),
                const SizedBox(
                  width: 10,
                )
              ],
            ),
          );
        });
  }
  
}
