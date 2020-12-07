import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/theming/divider.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/actions/exclude_joined_communities_from_top_posts_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTopPostsSettingsPage extends StatefulWidget {
  @override
  State<OBTopPostsSettingsPage> createState() {
    return OBTopPostsSettingsState();
  }
}

class OBTopPostsSettingsState extends State<OBTopPostsSettingsPage> {
  NavigationService _navigationService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
        navigationBar: OBThemedNavigationBar(
          title: _localizationService.community__top_posts_settings,
        ),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            ListView(
              physics: const ClampingScrollPhysics(),
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                  leading: const OBIcon(OBIcons.excludePostMemory),
                  subtitle: OBSecondaryText(_localizationService
                      .community__top_posts_excluded_memories_desc),
                  title: OBText(_localizationService
                      .community__top_posts_excluded_memories),
                  onTap: () {
                    _navigationService.navigateToTopPostsExcludedCommunities(
                        context: context);
                  },
                ),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 40),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [OBDivider(), OBExcludeJoinedCommunitiesTile()])),
          ],
        )));
  }
}
