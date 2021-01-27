import 'dart:async';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/badges/badge.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyModerationTasksPage extends StatefulWidget {
  @override
  State<OBMyModerationTasksPage> createState() {
    return OBMyModerationTasksPageState();
  }
}

class OBMyModerationTasksPageState extends State<OBMyModerationTasksPage> {
  UserService _userService;
  NavigationService _navigationService;
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
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.moderation__my_moderation_tasks_title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Memory>(
          padding: EdgeInsets.all(15),
          controller: _httpListController,
          listItemBuilder: _buildPendingModeratedObjectsMemoryListItem,
          listRefresher: _refreshPendingModeratedObjectsCommunities,
          listOnScrollLoader: _loadMorePendingModeratedObjectsCommunities,
          resourceSingularName: _localizationService
              .moderation__pending_moderation_tasks_singular,
          resourcePluralName:
              _localizationService.moderation__pending_moderation_tasks_plural,
        ),
      ),
    );
  }

  Widget _buildPendingModeratedObjectsMemoryListItem(
      BuildContext context, Memory crew) {
    return GestureDetector(
      onTap: () => _onPendingModeratedObjectsMemoryListItemPressed(crew),
      child: Row(
        children: <Widget>[
          SizedBox(height: 50),
          Expanded(
            child: OBMemoryTile(crew),
          ),
          SizedBox(
            width: 20,
          ),
          OBBadge(
            size: 25,
            count: crew.pendingModeratedObjectsCount,
          )
        ],
      ),
    );
  }

  void _onPendingModeratedObjectsMemoryListItemPressed(Memory crew) {
    _navigationService.navigateToMemoryModeratedObjects(
        crew: crew, context: context);
  }

  Future<List<Memory>> _refreshPendingModeratedObjectsCommunities() async {
    CommunitiesList pendingModeratedObjectsCommunities =
        await _userService.getPendingModeratedObjectsCommunities();
    return pendingModeratedObjectsCommunities.memories;
  }

  Future<List<Memory>> _loadMorePendingModeratedObjectsCommunities(
      List<Memory> pendingModeratedObjectsCommunitiesList) async {
    var lastPendingModeratedObjectsMemory =
        pendingModeratedObjectsCommunitiesList.last;
    var lastPendingModeratedObjectsMemoryId =
        lastPendingModeratedObjectsMemory.id;
    var morePendingModeratedObjectsCommunities =
        (await _userService.getPendingModeratedObjectsCommunities(
      maxId: lastPendingModeratedObjectsMemoryId,
      count: 10,
    ))
            .memories;
    return morePendingModeratedObjectsCommunities;
  }
}
