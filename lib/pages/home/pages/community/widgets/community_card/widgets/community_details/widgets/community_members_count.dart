import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:flutter/material.dart';

class OBMemoryMembersCount extends StatelessWidget {
  final Memory crew;

  OBMemoryMembersCount(this.crew);

  @override
  Widget build(BuildContext context) {
    int membersCount = crew.membersCount;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    if (membersCount == null || membersCount == 0) return const SizedBox();

    String count = getPrettyCount(membersCount, localizationService);

    String userAdjective =
        crew.userAdjective ?? localizationService.community__member_capitalized;
    String usersAdjective = crew.usersAdjective ??
        localizationService.community__members_capitalized;

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
              bool isPublicMemory = crew.isPublic();
              bool isLoggedInUserMember =
                  crew.isMember(userService.getLoggedInUser());

              if (isPublicMemory || isLoggedInUserMember) {
                navigationService.navigateToMemoryMembers(
                    crew: crew, context: context);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: count,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: themeValueParserService
                                .parseColor(theme.primaryTextColor))),
                    TextSpan(text: ' '),
                    TextSpan(
                        text:
                            membersCount == 1 ? userAdjective : usersAdjective,
                        style: TextStyle(
                            fontSize: 16,
                            color: themeValueParserService
                                .parseColor(theme.secondaryTextColor)))
                  ])),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          );
        });
  }
}
