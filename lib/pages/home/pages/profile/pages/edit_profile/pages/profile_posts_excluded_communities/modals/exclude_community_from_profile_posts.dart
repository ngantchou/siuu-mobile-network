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
        title: _localizationService.user__profile_posts_exclude_communities,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Community>(
          isSelectable: true,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildCommunityListItem,
          searchResultListItemBuilder: _buildCommunityListItem,
          selectedListItemBuilder: _buildCommunityListItem,
          listRefresher: _refreshJoinedCommunities,
          listOnScrollLoader: _loadMoreJoinedCommunities,
          listSearcher: _searchCommunities,
          selectionSubmitter: _excludeCommunities,
          onSelectionSubmitted: _onCommunitiesWereExcluded,
          resourceSingularName: _localizationService.community__community,
          resourcePluralName: _localizationService.community__communities,
        ),
      ),
    );
  }

  Widget _buildCommunityListItem(BuildContext context, Community community) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBCommunityTile(
        community,
        size: OBCommunityTileSize.small,
      ),
    );
  }

  Future<void> _excludeCommunities(List<Community> communities) {
    return Future.wait(communities
        .map((community) =>
            _userService.excludeCommunityFromProfilePosts(community))
        .toList());
  }

  void _onCommunitiesWereExcluded(List<Community> communities) {
    Navigator.pop(context, communities);
  }

  Future<List<Community>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunities = await _userService.getJoinedCommunities(
        excludedFromProfilePosts: false);
    return joinedCommunities.communities;
  }

  Future<List<Community>> _loadMoreJoinedCommunities(
      List<Community> joinedCommunitiesList) async {
    var moreJoinedCommunities = (await _userService.getJoinedCommunities(
      offset: joinedCommunitiesList.length,
    ))
        .communities;

    return moreJoinedCommunities;
  }

  Future<List<Community>> _searchCommunities(String query) async {
    CommunitiesList results = await _userService
        .searchCommunitiesWithQuery(query, excludedFromProfilePosts: false);

    return results.communities;
  }
}
