import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:flutter/material.dart';

class OBMemoryMembersCount extends StatelessWidget {
  final Memory memory;

  OBMemoryMembersCount(this.memory);

  @override
  Widget build(BuildContext context) {
    int membersCount = memory.membersCount;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    if (membersCount == null || membersCount == 0) return const SizedBox();

    String count = getPrettyCount(membersCount, localizationService);

    String userAdjective = memory.userAdjective ??
        localizationService.community__member_capitalized;
    String usersAdjective = memory.usersAdjective ??
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
              bool isPublicMemory = memory.isPublic();
              bool isLoggedInUserMember =
                  memory.isMember(userService.getLoggedInUser());

              if (isPublicMemory || isLoggedInUserMember) {
                navigationService.navigateToMemoryMembers(
                    memory: memory, context: context);
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
