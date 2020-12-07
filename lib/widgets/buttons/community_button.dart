import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

class OBMemoryButton extends StatelessWidget {
  final Memory memory;
  final bool isLoading;
  final String text;
  final VoidCallback onPressed;

  static const borderRadius = 30.0;

  const OBMemoryButton(
      {Key key,
      this.isLoading = false,
      @required this.memory,
      @required this.text,
      @required this.onPressed})
      : super(key: key);

  Widget build(BuildContext context) {
    String memoryHexColor = memory.color;
    OpenbookProviderState openbookProviderState = OpenbookProvider.of(context);
    ThemeValueParserService themeValueParserService =
        openbookProviderState.themeValueParserService;
    ThemeService themeService = openbookProviderState.themeService;

    OBTheme currentTheme = themeService.getActiveTheme();
    Color currentThemePrimaryColor =
        themeValueParserService.parseColor(currentTheme.primaryColor);
    double currentThemePrimaryColorLuminance =
        currentThemePrimaryColor.computeLuminance();

    Color memoryColor = themeValueParserService.parseColor(memoryHexColor);
    Color textColor = themeValueParserService.isDarkColor(memoryColor)
        ? Colors.white
        : Colors.black;
    double memoryColorLuminance = memoryColor.computeLuminance();

    if (memoryColorLuminance > 0.9 && currentThemePrimaryColorLuminance > 0.9) {
      // Is extremely white and our current theem is also extremely white, darken it
      memoryColor = TinyColor(memoryColor).darken(5).color;
    } else if (memoryColorLuminance < 0.1) {
      // Is extremely dark and our current theme is also extremely dark, lighten it
      memoryColor = TinyColor(memoryColor).lighten(10).color;
    }

    return ButtonTheme(
      minWidth: 110,
      child: RaisedButton(
          elevation: 0,
          child: isLoading
              ? _buildLoadingIndicatorWithColor(textColor)
              : Text(
                  text,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
          color: memoryColor,
          onPressed: onPressed,
          shape: new RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius))),
    );
  }

  Widget _buildLoadingIndicatorWithColor(Color color) {
    return OBProgressIndicator(
      color: color,
    );
  }
}
