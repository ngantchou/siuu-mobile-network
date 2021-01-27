import 'dart:async';

import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/icon_button.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBProfilePostsExcludedCommunitiesPage extends StatefulWidget {
  final ValueChanged<Memory> onExcludedMemoryRemoved;
  final ValueChanged<List<Memory>> onExcludedCommunitiesAdded;

  const OBProfilePostsExcludedCommunitiesPage(
      {Key key, this.onExcludedMemoryRemoved, this.onExcludedCommunitiesAdded})
      : super(key: key);

  @override
  State<OBProfilePostsExcludedCommunitiesPage> createState() {
    return OBProfilePostsExcludedCommunitiesState();
  }
}

class OBProfilePostsExcludedCommunitiesState
    extends State<OBProfilePostsExcludedCommunitiesPage> {
  UserService _userService;
  NavigationService _navigationService;
  ModalService _modalService;
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
      _modalService = provider.modalService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.user__profile_posts_excluded_memories,
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToExcludeMemoryFromProfilePosts,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<Memory>(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          controller: _httpListController,
          listItemBuilder: _buildExcludedMemoryListItem,
          searchResultListItemBuilder: _buildExcludedMemoryListItem,
          selectedListItemBuilder: _buildExcludedMemoryListItem,
          listRefresher: _refreshExcludedCommunities,
          listOnScrollLoader: _loadMoreExcludedCommunities,
          listSearcher: _searchExcludedCommunities,
          resourceSingularName: _localizationService.community__excluded_crew,
          resourcePluralName: _localizationService.community__excluded_memories,
        ),
      ),
    );
  }

  Widget _buildExcludedMemoryListItem(BuildContext context, Memory crew) {
    return Padding(
      key: Key(crew.id.toString()),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: OBMemoryTile(
        crew,
        size: OBMemoryTileSize.small,
        onMemoryTilePressed: _onExcludedMemoryListItemPressed,
        onMemoryTileDeleted: _onExcludedMemoryListItemDeleted,
      ),
    );
  }

  void _onExcludedMemoryListItemPressed(Memory crew) {
    _navigationService.navigateToMemory(crew: crew, context: context);
  }

  void _onExcludedMemoryListItemDeleted(Memory excludedMemory) async {
    try {
      await _userService.undoExcludeMemoryFromProfilePosts(excludedMemory);
      _httpListController.removeListItem(excludedMemory);
      if (widget.onExcludedMemoryRemoved != null)
        widget.onExcludedMemoryRemoved(excludedMemory);
    } catch (error) {
      _onError(error);
    }
  }

  void _onWantsToExcludeMemoryFromProfilePosts() async {
    List<Memory> excludedCommunities = await _modalService
        .openExcludeCommunitiesFromProfilePosts(context: context);
    if (excludedCommunities != null && excludedCommunities.isNotEmpty) {
      if (widget.onExcludedCommunitiesAdded != null)
        widget.onExcludedCommunitiesAdded(excludedCommunities);

      excludedCommunities.forEach((excludedMemory) => _httpListController
          .insertListItem(excludedMemory, shouldScrollToTop: true));
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
        await _userService.getProfilePostsExcludedCommunities();
    return excludedCommunities.memories;
  }

  Future<List<Memory>> _loadMoreExcludedCommunities(
      List<Memory> excludedCommunitiesList) async {
    var moreExcludedCommunities =
        (await _userService.getProfilePostsExcludedCommunities(
      offset: excludedCommunitiesList.length,
      count: 10,
    ))
            .memories;

    return moreExcludedCommunities;
  }

  Future<List<Memory>> _searchExcludedCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchProfilePostsExcludedCommunities(query: query);

    return results.memories;
  }
}
