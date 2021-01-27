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

  static const double smallSizeHeight = 65;
  static const double normalSizeHeight = 85;

  final Memory crew;
  final ValueChanged<Memory> onMemoryTilePressed;
  final ValueChanged<Memory> onMemoryTileDeleted;
  final OBMemoryTileSize size;
  final Widget trailing;

  const OBMemoryTile(this.crew,
      {this.onMemoryTilePressed,
      this.onMemoryTileDeleted,
      Key key,
      this.size = OBMemoryTileSize.normal,
      this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String crewHexColor = crew.color;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;
    ThemeService themeService = OpenbookProvider.of(context).themeService;
    ThemeValueParserService themeValueParserService =
        OpenbookProvider.of(context).themeValueParserService;
    Color crewColor = themeValueParserService.parseColor(crewHexColor);
    OBTheme theme = themeService.getActiveTheme();
    Color textColor;

    BoxDecoration containerDecoration;
    BorderRadius containerBorderRadius = BorderRadius.circular(10);
    bool isMemoryColorDark = themeValueParserService.isDarkColor(crewColor);
    bool crewHasCover = crew.hasCover();

    if (crewHasCover) {
      textColor = Colors.white;
      containerDecoration = BoxDecoration(
          borderRadius: containerBorderRadius,
          image: DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.60), BlendMode.darken),
              image: AdvancedNetworkImage(crew.cover,
                  useDiskCache: true,
                  fallbackAssetImage: COVER_PLACEHOLDER,
                  retryLimit: 0)));
    } else {
      textColor = isMemoryColorDark ? Colors.white : Colors.black;
      bool crewColorIsNearWhite = crewColor.computeLuminance() > 0.9;

      containerDecoration = BoxDecoration(
        color: crewColorIsNearWhite
            ? TinyColor(crewColor).darken(5).color
            : TinyColor(crewColor).lighten(10).color,
        borderRadius: containerBorderRadius,
      );
    }

    bool isNormalSize = size == OBMemoryTileSize.normal;

    Widget crewAvatar;
    if (crew.hasAvatar()) {
      crewAvatar = OBAvatar(
        avatarUrl: crew.avatar,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    } else {
      Color avatarColor = crewHasCover
          ? crewColor
          : (isMemoryColorDark
              ? TinyColor(crewColor).lighten(5).color
              : crewColor);
      crewAvatar = OBLetterAvatar(
        letter: crew.name[0],
        color: avatarColor,
        labelColor: textColor,
        size: isNormalSize ? OBAvatarSize.medium : OBAvatarSize.small,
      );
    }

    String userAdjective =
        crew.userAdjective ?? localizationService.community__member_capitalized;
    String usersAdjective = crew.usersAdjective ??
        localizationService.community__members_capitalized;
    String membersPrettyCount = crew.membersCount != null
        ? getPrettyCount(crew.membersCount, localizationService)
        : null;
    String finalAdjective =
        crew.membersCount == 1 ? userAdjective : usersAdjective;

    Widget crewTile = Container(
      height: isNormalSize ? normalSizeHeight : smallSizeHeight,
      decoration: containerDecoration,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: crewAvatar,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('c/' + crew.name,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis),
                Text(
                  crew.title,
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
      crewTile = Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: GestureDetector(
          onTap: () {
            onMemoryTilePressed(crew);
          },
          child: crewTile,
        ),
        secondaryActions: <Widget>[
          new IconSlideAction(
              caption: localizationService.community__tile_delete,
              foregroundColor:
                  themeValueParserService.parseColor(theme.primaryTextColor),
              color: Colors.transparent,
              icon: Icons.delete,
              onTap: () {
                onMemoryTileDeleted(crew);
              }),
        ],
      );
    } else if (onMemoryTilePressed != null) {
      crewTile = GestureDetector(
        onTap: () {
          onMemoryTilePressed(crew);
        },
        child: crewTile,
      );
    }

    return crewTile;
  }
}

enum OBMemoryTileSize { normal, small }
