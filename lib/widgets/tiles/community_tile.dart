import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/libs/pretty_count.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tinycolor/tinycolor.dart';

class OBMemoryTile extends StatelessWidget {
  static const COVER_PLACEHOLDER = 'assets/images/fallbacks/cover-fallback.jpg';

  static const double smallSizeHeight = 60;
  static const double normalSizeHeight = 80;

  final Memory memory;
  final ValueChanged<Memory> onMemoryTilePressed;
  final ValueChanged<Memory> onMemoryTileDeleted;
  final OBMemoryTileSize size;
  final Widget trailing;

  const OBMemoryTile(this.memory,
      {this.onMemoryTilePressed,
      this.onMemoryTileDeleted,
      Key key,
      this.size = OBMemoryTileSize.normal,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String memoryHexColor = memory.color;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;
    ThemeService themeService = OpenbookProvider.of(context).themeService;
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    Color memoryColor = themeValueParserService.parseColor(memoryHexColor);
    OBTheme theme = themeService.getActiveTheme();
    Color textColor;

    BoxDecoration containerDecoration;
    BorderRadius containerBorderRadius = BorderRadius.circular(10);
    bool isMemoryColorDark = themeValueParserService.isDarkColor(memoryColor);
    bool memoryHasCover = memory.hasCover();

    if (memoryHasCover) {
      textColor = Colors.white;
      containerDecoration = BoxDecoration(
          borderRadius: containerBorderRadius,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.60), BlendMode.darken),
              image: AdvancedNetworkImage(memory.cover,
                  useDiskCache: true,
                  fallbackAssetImage: COVER_PLACEHOLDER,
                  retryLimit: 0)));
    } else {
      textColor = isMemoryColorDark ? Colors.white : Colors.black;
      bool memoryColorIsNearWhite = memoryColor.computeLuminance() > 0.9;

      containerDecoration = BoxDecoration(
        color: memoryColorIsNearWhite
            ? TinyColor(memoryColor).darken(5).color
            : TinyColor(memoryColor).lighten(10).color,
        borderRadius: containerBorderRadius,
      );
    }

    bool isNormalSize = size == OBMemoryTileSize.normal;

    Widget memoryAvatar;
    if (memory.hasAvatar()) {
      memoryAvatar = OBAvatar(
        avatarUrl: memory.avatar,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    } else {
      Color avatarColor = memoryHasCover
          ? memoryColor
          : (isMemoryColorDark
              ? TinyColor(memoryColor).lighten(5).color
              : memoryColor);
      memoryAvatar = OBLetterAvatar(
        letter: memory.name[0],
        color: avatarColor,
        labelColor: textColor,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    }

    String userAdjective = memory.userAdjective ??
        localizationService.community__member_capitalized;
    String usersAdjective = memory.usersAdjective ??
        localizationService.community__members_capitalized;
    String membersPrettyCount = memory.membersCount != null
        ? getPrettyCount(memory.membersCount, localizationService)
        : null;
    String finalAdjective =
        memory.membersCount == 1 ? userAdjective : usersAdjective;

    Widget memoryTile = Container(
      height: isNormalSize ? normalSizeHeight : smallSizeHeight,
      decoration: containerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: memoryAvatar,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('c/' + memory.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis),
                Text(
                  memory.title,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                isNormalSize && membersPrettyCount != null
                    ? Text(
                        '$membersPrettyCount $finalAdjective',
                        style: TextStyle(color: textColor, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      )
                    : SizedBox()
              ],
            ),
          ),
          trailing == null
              ? SizedBox(
                  width: 20,
                )
              : Padding(
                  child: trailing,
                  padding: const EdgeInsets.all(20),
                )
        ],
      ),
    );

    if (onMemoryTileDeleted != null && onMemoryTilePressed != null) {
      memoryTile = Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: GestureDetector(
          onTap: () {
            onMemoryTilePressed(memory);
          },
          child: memoryTile,
        ),
        secondaryActions: <Widget>[
          new IconSlideAction(
              caption: localizationService.community__tile_delete,
              foregroundColor:
                  themeValueParserService.parseColor(theme.primaryTextColor),
              color: Colors.transparent,
              icon: Icons.delete,
              onTap: () {
                onMemoryTileDeleted(memory);
              }),
        ],
      );
    } else if (onMemoryTilePressed != null) {
      memoryTile = GestureDetector(
        onTap: () {
          onMemoryTilePressed(memory);
        },
        child: memoryTile,
      );
    }

    return memoryTile;
  }
}

enum OBMemoryTileSize { normal, small }
