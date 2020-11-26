import 'package:Siuu/libs/pretty_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:flutter/material.dart';

class OBPostsCount extends StatelessWidget {
  final int postsCount;
  final bool showZero;
  final Color color;
  final double fontSize;

  OBPostsCount(this.postsCount, {this.showZero = false, this.color, this.fontSize});

  @override
  Widget build(BuildContext context) {
    if (postsCount == null || (postsCount == 0 && !showZero))
      return const SizedBox();

    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    LocalizationService _localizationService =
        openbookProvider.localizationService;
    String count = getPrettyCount(postsCount, _localizationService);

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                  Text(count,
                      style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 22,
                            color: Color(0xff000000))),
                  Text( postsCount == 1
                          ? _localizationService.post__profile_counts_post
                          : _localizationService.post__profile_counts_posts,
                      style: TextStyle(
                                    fontFamily: "Segoe UI",
                                    fontSize: 11,
                            color: Color(0xffaeb5bc))),
              const SizedBox(
                width: 10,
              )
            ],
          );
        });
  }
}
