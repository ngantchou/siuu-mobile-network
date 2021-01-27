import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryNavBar extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  final Memory crew;

  const OBMemoryNavBar(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: crew.updateSubject,
        initialData: crew,
        builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
          var crew = snapshot.data;

          String crewColor = crew.color;
          ThemeValueParserService themeValueParserService =
              OpenbookProvider.of(context).themeValueParserService;
          Color color = themeValueParserService.parseColor(crewColor);
          bool isDarkColor = themeValueParserService.isDarkColor(color);
          Color actionsColor = isDarkColor ? Colors.white : Colors.black;

          return CupertinoNavigationBar(
            border: null,
            actionsForegroundColor: actionsColor,
            middle: OBText(
              'c/' + crew.name,
              style:
                  TextStyle(color: actionsColor, fontWeight: FontWeight.bold),
            ),
            transitionBetweenRoutes: false,
            backgroundColor: color,
          );
        });
  }

  bool get fullObstruction {
    return true;
  }

  @override
  Size get preferredSize {
    return const Size.fromHeight(44);
  }

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
