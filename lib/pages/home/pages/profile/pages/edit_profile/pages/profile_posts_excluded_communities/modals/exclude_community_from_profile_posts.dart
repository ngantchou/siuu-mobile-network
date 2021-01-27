import 'dart:async';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBExcludeCommunitiesFromProfilePostsModal extends StatefulWidget {
  @override
  State<OBExcludeCommunitiesFromProfilePostsModal> createState() {
    return OBProfilePostsExcludedCommunitiesState();
  }
}

class OBProfilePostsExcludedCommunitiesState
    extends State<OBExcludeCommunitiesFromProfilePostsModal> {
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

    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__profile_posts_exclude_memories,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Memory>(
          isSelectable: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildMemoryListItem,
          searchResultListItemBuilder: _buildMemoryListItem,
          selectedListItemBuilder: _buildMemoryListItem,
          listRefresher: _refreshJoinedCommunities,
          listOnScrollLoader: _loadMoreJoinedCommunities,
          listSearcher: _searchCommunities,
          selectionSubmitter: _excludeCommunities,
          onSelectionSubmitted: _onCommunitiesWereExcluded,
          resourceSingularName: _localizationService.community__crew,
          resourcePluralName: _localizationService.community__memories,
        ),
      ),
    );
  }

  Widget _buildMemoryListItem(BuildContext context, Memory crew) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBMemoryTile(
        crew,
        size: OBMemoryTileSize.small,
      ),
    );
  }

  Future<void> _excludeCommunities(List<Memory> memories) {
    return Future.wait(memories
        .map((crew) => _userService.excludeMemoryFromProfilePosts(crew))
        .toList());
  }

  void _onCommunitiesWereExcluded(List<Memory> memories) {
    Navigator.pop(context, memories);
  }

  Future<List<Memory>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunities = await _userService.getJoinedCommunities(
        excludedFromProfilePosts: false);
    return joinedCommunities.memories;
  }

  Future<List<Memory>> _loadMoreJoinedCommunities(
      List<Memory> joinedCommunitiesList) async {
    var moreJoinedCommunities = (await _userService.getJoinedCommunities(
      offset: joinedCommunitiesList.length,
    ))
        .memories;

    return moreJoinedCommunities;
  }

  Future<List<Memory>> _searchCommunities(String query) async {
    CommunitiesList results = await _userService
        .searchCommunitiesWithQuery(query, excludedFromProfilePosts: false);

    return results.memories;
  }
}
