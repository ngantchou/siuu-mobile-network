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
  final Memory memory;
  final OBAvatarSize size;
  final VoidCallback onPressed;
  final bool isZoomable;
  final double borderRadius;
  final double customSize;

  const OBMemoryAvatar(
      {Key key,
      @required this.memory,
      this.size = OBAvatarSize.small,
      this.isZoomable = false,
      this.borderRadius,
      this.onPressed,
      this.customSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: memory.updateSubject,
        initialData: memory,
        builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
          Memory memory = snapshot.data;
          bool memoryHasAvatar = memory.hasAvatar();

          Widget avatar;

          if (memoryHasAvatar) {
            avatar = OBAvatar(
                avatarUrl: memory?.avatar,
                size: size,
                onPressed: onPressed,
                isZoomable: isZoomable,
                borderRadius: borderRadius,
                customSize: customSize);
          } else {
            String memoryHexColor = memory.color ?? '#ffffff';

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

            Color memoryColor =
                themeValueParserService.parseColor(memoryHexColor);
            double memoryColorLuminance = memoryColor.computeLuminance();
            Color textColor = themeValueParserService.isDarkColor(memoryColor)
                ? Colors.white
                : Colors.black;

            if (memoryColorLuminance > 0.9 &&
                currentThemePrimaryColorLuminance > 0.9) {
              // Is extremely white and our current theem is also extremely white, darken it
              memoryColor = TinyColor(memoryColor).darken(5).color;
            } else if (memoryColorLuminance < 0.1) {
              // Is extremely dark and our current theme is also extremely dark, lighten it
              memoryColor = TinyColor(memoryColor).lighten(10).color;
            }

            avatar = OBLetterAvatar(
                letter: memory.name[0],
                color: memoryColor,
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
