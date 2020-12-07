import 'dart:async';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTopPostsExcludedCommunitiesPage extends StatefulWidget {
  @override
  State<OBTopPostsExcludedCommunitiesPage> createState() {
    return OBTopPostsExcludedCommunitiesState();
  }
}

class OBTopPostsExcludedCommunitiesState
    extends State<OBTopPostsExcludedCommunitiesPage> {
  UserService _userService;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  ToastService _toastService;

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
      _toastService = provider.toastService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__top_posts_excluded_memories,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Memory>(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildExcludedMemoryListItem,
          searchResultListItemBuilder: _buildExcludedMemoryListItem,
          listRefresher: _refreshExcludedCommunities,
          listOnScrollLoader: _loadMoreExcludedCommunities,
          listSearcher: _searchExcludedCommunities,
          resourceSingularName: _localizationService.community__excluded_memory,
          resourcePluralName: _localizationService.community__excluded_memories,
        ),
      ),
    );
  }

  Widget _buildExcludedMemoryListItem(BuildContext context, Memory memory) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBMemoryTile(
        memory,
        size: OBMemoryTileSize.small,
        onMemoryTilePressed: _onExcludedMemoryListItemPressed,
        onMemoryTileDeleted: _onExcludedMemoryListItemDeleted,
      ),
    );
  }

  void _onExcludedMemoryListItemPressed(Memory memory) {
    _navigationService.navigateToMemory(memory: memory, context: context);
  }

  void _onExcludedMemoryListItemDeleted(Memory excludedMemory) async {
    try {
      await _userService.undoExcludeMemoryFromTopPosts(excludedMemory);
      _httpListController.removeListItem(excludedMemory);
    } catch (error) {
      _onError(error);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  Future<List<Memory>> _refreshExcludedCommunities() async {
    CommunitiesList excludedCommunities =
        await _userService.getTopPostsExcludedCommunities();
    return excludedCommunities.memories;
  }

  Future<List<Memory>> _loadMoreExcludedCommunities(
      List<Memory> excludedCommunitiesList) async {
    var lastExcludedMemory = excludedCommunitiesList.last;
    var lastExcludedMemoryId = lastExcludedMemory.id;
    var moreExcludedCommunities =
        (await _userService.getTopPostsExcludedCommunities(
      offset: lastExcludedMemoryId,
      count: 10,
    ))
            .memories;

    return moreExcludedCommunities;
  }

  Future<List<Memory>> _searchExcludedCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchTopPostsExcludedCommunities(query: query);

    return results.memories;
  }
}
