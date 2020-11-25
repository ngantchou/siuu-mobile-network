import 'dart:async';

import 'package:Siuu/models/moderation/moderation_penalty_list.dart';
import 'package:Siuu/models/moderation/moderation_penalty.dart';
import 'package:Siuu/pages/home/pages/menu/pages/my_moderation_penalties/widgets/moderation_penalty/moderation_penalty.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyModerationPenaltiesPage extends StatefulWidget {
  @override
  State<OBMyModerationPenaltiesPage> createState() {
    return OBMyModerationPenaltiesPageState();
  }
}

class OBMyModerationPenaltiesPageState
    extends State<OBMyModerationPenaltiesPage> {
  UserService _userService;
  LocalizationService _localizationService;

  OBHttpListController _httpListController;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _httpListController = OBHttpListController();
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.moderation__my_moderation_penalties_title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<ModerationPenalty>(
          padding: EdgeInsets.all(15),
          controller: _httpListController,
          listItemBuilder: _buildModerationPenaltyListItem,
          listRefresher: _refreshModerationPenalties,
          listOnScrollLoader: _loadMoreModerationPenalties,
          resourceSingularName: _localizationService.moderation__my_moderation_penalties_resouce_singular,
          resourcePluralName: _localizationService.moderation__my_moderation_penalties_resource_plural,
        ),
      ),
    );
  }

  Widget _buildModerationPenaltyListItem(
      BuildContext context, ModerationPenalty moderationPenalty) {
    return OBModerationPenaltyTile(
      moderationPenalty: moderationPenalty,
    );
  }

  Future<List<ModerationPenalty>> _refreshModerationPenalties() async {
    ModerationPenaltiesList moderationPenalties =
        await _userService.getModerationPenalties();
    return moderationPenalties.moderationPenalties;
  }

  Future<List<ModerationPenalty>> _loadMoreModerationPenalties(
      List<ModerationPenalty> moderationPenaltiesList) async {
    var lastModerationPenalty = moderationPenaltiesList.last;
    var lastModerationPenaltyId = lastModerationPenalty.id;
    var moreModerationPenalties = (await _userService.getModerationPenalties(
      maxId: lastModerationPenaltyId,
      count: 10,
    ))
        .moderationPenalties;
    return moreModerationPenalties;
  }
}
