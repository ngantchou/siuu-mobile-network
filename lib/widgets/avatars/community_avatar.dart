import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
export 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class OBMemoryAvatar extends StatelessWidget {
  final Memory crew;
  final OBAvatarSize size;
  final VoidCallback onPressed;
  final bool isZoomable;
  final double borderRadius;
  final double customSize;

  const OBMemoryAvatar(
      {Key key,
      @required this.crew,
      this.size = OBAvatarSize.small,
      this.isZoomable = false,
      this.borderRadius,
      this.onPressed,
      this.customSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: crew.updateSubject,
        initialData: crew,
        builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
          Memory crew = snapshot.data;
          bool crewHasAvatar = crew.hasAvatar();

          Widget avatar;

          if (crewHasAvatar) {
            avatar = OBAvatar(
                avatarUrl: crew?.avatar,
                size: size,
                onPressed: onPressed,
                isZoomable: isZoomable,
                borderRadius: borderRadius,
                customSize: customSize);
          } else {
            String crewHexColor = crew.color ?? '#ffffff';

            OpenbookProviderState openbookProviderState =
                OpenbookProvider.of(context);
            ThemeValueParserService themeValueParserService =
                openbookProviderState.themeValueParserService;
            ThemeService themeService = openbookProviderState.themeService;

            OBTheme currentTheme = themeService.getActiveTheme();
            Color currentThemePrimaryColor =
                themeValueParserService.parseColor(currentTheme.primaryColor);
            double currentThemePrimaryColorLuminance =
                currentThemePrimaryColor.computeLuminance();

            Color crewColor = themeValueParserService.parseColor(crewHexColor);
            double crewColorLuminance = crewColor.computeLuminance();
            Color textColor = themeValueParserService.isDarkColor(crewColor)
                ? Colors.white
                : Colors.black;

            if (crewColorLuminance > 0.9 &&
                currentThemePrimaryColorLuminance > 0.9) {
              // Is extremely white and our current theem is also extremely white, darken it
              crewColor = TinyColor(crewColor).darken(5).color;
            } else if (crewColorLuminance < 0.1) {
              // Is extremely dark and our current theme is also extremely dark, lighten it
              crewColor = TinyColor(crewColor).lighten(10).color;
            }

            avatar = OBLetterAvatar(
                letter: crew.name[0],
                color: crewColor,
                size: size,
                onPressed: onPressed,
                borderRadius: borderRadius,
                labelColor: textColor,
                customSize: customSize);
          }

          return avatar;
        });
  }
}
