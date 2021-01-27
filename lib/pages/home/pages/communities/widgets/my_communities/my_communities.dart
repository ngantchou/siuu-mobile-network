import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/communities/widgets/my_communities/widgets/my_communities_group.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/alerts/button_alert.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyCommunities extends StatefulWidget {
  final ScrollController scrollController;

  const OBMyCommunities({Key key, this.scrollController}) : super(key: key);

  @override
  OBMyCommunitiesState createState() {
    return OBMyCommunitiesState();
  }
}

class OBMyCommunitiesState extends State<OBMyCommunities>
    with AutomaticKeepAliveClientMixin {
  OBMyCommunitiesGroupController _favoriteCommunitiesGroupController;
  OBMyCommunitiesGroupController _joinedCommunitiesGroupController;
  OBMyCommunitiesGroupController _moderatedCommunitiesGroupController;
  OBMyCommunitiesGroupController _administratedCommunitiesGroupController;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  UserService _userService;
  bool _needsBootstrap;
  bool _refreshInProgress;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _favoriteCommunitiesGroupController = OBMyCommunitiesGroupController();
    _joinedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _moderatedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _administratedCommunitiesGroupController = OBMyCommunitiesGroupController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    _refreshInProgress = false;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _navigationService = openbookProvider.navigationService;
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }

    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshAllGroups,
      child: ListView(
          key: Key('myCommunities'),
          // Need always scrollable for pull to refresh to work
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(0),
          children: <Widget>[
            Column(
              children: <Widget>[
                OBMyCommunitiesGroup(
                  key: Key('FavoriteCommunitiesGroup'),
                  controller: _favoriteCommunitiesGroupController,
                  title: _localizationService.community__favorites_title,
                  groupName: _localizationService.community__favorite_memories,
                  groupItemName: _localizationService.community__favorite_crew,
                  maxGroupListPreviewItems: 5,
                  crewGroupListSearcher: _searchFavoriteCommunities,
                  crewSearchResultListItemBuilder: _buildFavoriteMemoryListItem,
                  crewGroupListItemBuilder: _buildFavoriteMemoryListItem,
                  crewGroupListRefresher: _refreshFavoriteCommunities,
                  crewGroupListOnScrollLoader: _loadMoreFavoriteCommunities,
                ),
                OBMyCommunitiesGroup(
                    key: Key('AdministratedCommunitiesGroup'),
                    controller: _administratedCommunitiesGroupController,
                    title: _localizationService.community__administrated_title,
                    groupName:
                        _localizationService.community__administrated_memories,
                    groupItemName:
                        _localizationService.community__administrated_crew,
                    maxGroupListPreviewItems: 5,
                    crewGroupListSearcher: _searchAdministratedCommunities,
                    crewSearchResultListItemBuilder:
                        _buildAdministratedMemoryListItem,
                    crewGroupListItemBuilder: _buildAdministratedMemoryListItem,
                    crewGroupListRefresher: _refreshAdministratedCommunities,
                    crewGroupListOnScrollLoader:
                        _loadMoreAdministratedCommunities),
                OBMyCommunitiesGroup(
                  key: Key('ModeratedCommunitiesGroup'),
                  controller: _moderatedCommunitiesGroupController,
                  title: _localizationService.community__moderated_title,
                  groupName: _localizationService.community__moderated_memories,
                  groupItemName: _localizationService.community__moderated_crew,
                  maxGroupListPreviewItems: 5,
                  crewGroupListSearcher: _searchModeratedCommunities,
                  crewSearchResultListItemBuilder:
                      _buildModeratedMemoryListItem,
                  crewGroupListItemBuilder: _buildModeratedMemoryListItem,
                  crewGroupListRefresher: _refreshModeratedCommunities,
                  crewGroupListOnScrollLoader: _loadMoreModeratedCommunities,
                ),
                OBMyCommunitiesGroup(
                  key: Key('JoinedCommunitiesGroup'),
                  controller: _joinedCommunitiesGroupController,
                  title: _localizationService.community__joined_title,
                  groupName: _localizationService.community__joined_memories,
                  groupItemName: _localizationService.community__joined_crew,
                  maxGroupListPreviewItems: 5,
                  crewGroupListSearcher: _searchJoinedCommunities,
                  crewSearchResultListItemBuilder: _buildJoinedMemoryListItem,
                  crewGroupListItemBuilder: _buildJoinedMemoryListItem,
                  crewGroupListRefresher: _refreshJoinedCommunities,
                  crewGroupListOnScrollLoader: _loadMoreJoinedCommunities,
                  noGroupItemsFallbackBuilder:
                      _buildNoJoinedCommunitiesFallback,
                )
              ],
            )
          ]),
    );
  }

  Future<List<Memory>> _refreshJoinedCommunities() async {
    CommunitiesList joinedCommunitiesList =
        await _userService.getJoinedCommunities();
    return joinedCommunitiesList.memories;
  }

  Future<List<Memory>> _loadMoreJoinedCommunities(
      List<Memory> currentJoinedCommunities) async {
    int offset = currentJoinedCommunities.length;

    CommunitiesList moreJoinedCommunitiesList =
        await _userService.getJoinedCommunities(offset: offset);
    return moreJoinedCommunitiesList.memories;
  }

  Future<List<Memory>> _refreshFavoriteCommunities() async {
    CommunitiesList favoriteCommunitiesList =
        await _userService.getFavoriteCommunities();
    return favoriteCommunitiesList.memories;
  }

  Future<List<Memory>> _loadMoreFavoriteCommunities(
      List<Memory> currentFavoriteCommunities) async {
    int offset = currentFavoriteCommunities.length;

    CommunitiesList moreFavoriteCommunitiesList =
        await _userService.getFavoriteCommunities(offset: offset);
    return moreFavoriteCommunitiesList.memories;
  }

  Future<List<Memory>> _refreshAdministratedCommunities() async {
    CommunitiesList administratedCommunitiesList =
        await _userService.getAdministratedCommunities();
    return administratedCommunitiesList.memories;
  }

  Future<List<Memory>> _loadMoreAdministratedCommunities(
      List<Memory> currentAdministratedCommunities) async {
    int offset = currentAdministratedCommunities.length;

    CommunitiesList moreAdministratedCommunitiesList =
        await _userService.getAdministratedCommunities(offset: offset);
    return moreAdministratedCommunitiesList.memories;
  }

  Future<List<Memory>> _refreshModeratedCommunities() async {
    CommunitiesList moderatedCommunitiesList =
        await _userService.getModeratedCommunities();
    return moderatedCommunitiesList.memories;
  }

  Future<List<Memory>> _loadMoreModeratedCommunities(
      List<Memory> currentModeratedCommunities) async {
    int offset = currentModeratedCommunities.length;

    CommunitiesList moreModeratedCommunitiesList =
        await _userService.getModeratedCommunities(offset: offset);
    return moreModeratedCommunitiesList.memories;
  }

  Widget _buildNoJoinedCommunitiesFallback(
      BuildContext context, OBMyCommunitiesGroupRetry retry) {
    return OBButtonAlert(
      text: _localizationService.community__join_memories_desc,
      onPressed: _refreshAllGroups,
      buttonText: _localizationService.community__refresh_text,
      buttonIcon: OBIcons.refresh,
      isLoading: _refreshInProgress,
      assetImage: 'assets/images/stickers/got-it.png',
      //isLoading: _refreshInProgress,
    );
  }

  Widget _buildJoinedMemoryListItem(BuildContext context, Memory crew) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory latestMemory = snapshot.data;

        User loggedInUser = _userService.getLoggedInUser();
        return latestMemory.isMember(loggedInUser)
            ? _buildMemoryListItem(crew)
            : const SizedBox();
      },
    );
  }

  Widget _buildModeratedMemoryListItem(BuildContext context, Memory crew) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory latestMemory = snapshot.data;

        User loggedInUser = _userService.getLoggedInUser();
        return latestMemory.isModerator(loggedInUser)
            ? _buildMemoryListItem(crew)
            : const SizedBox();
      },
    );
  }

  Widget _buildAdministratedMemoryListItem(BuildContext context, Memory crew) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory latestMemory = snapshot.data;

        User loggedInUser = _userService.getLoggedInUser();
        return latestMemory.isAdministrator(loggedInUser)
            ? _buildMemoryListItem(crew)
            : const SizedBox();
      },
    );
  }

  Widget _buildFavoriteMemoryListItem(BuildContext context, Memory crew) {
    return StreamBuilder(
      initialData: crew,
      stream: crew.updateSubject,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory latestMemory = snapshot.data;

        return latestMemory.isFavorite
            ? _buildMemoryListItem(crew)
            : const SizedBox();
      },
    );
  }

  Future<List<Memory>> _searchFavoriteCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchFavoriteCommunities(query: query);

    return results.memories;
  }

  Future<List<Memory>> _searchAdministratedCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchAdministratedCommunities(query: query);

    return results.memories;
  }

  Future<List<Memory>> _searchModeratedCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchModeratedCommunities(query: query);

    return results.memories;
  }

  Future<List<Memory>> _searchJoinedCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchJoinedCommunities(query: query);

    return results.memories;
  }

  Widget _buildMemoryListItem(Memory crew) {
    return OBMemoryTile(
      crew,
      size: OBMemoryTileSize.small,
      onMemoryTilePressed: _onMemoryPressed,
    );
  }

  void _onMemoryPressed(Memory crew) {
    _navigationService.navigateToMemory(context: context, crew: crew);
  }

  Future<void> _refreshAllGroups() async {
    _setRefreshInProgress(true);
    try {
      await Future.wait([
        _favoriteCommunitiesGroupController.refresh(),
        _administratedCommunitiesGroupController.refresh(),
        _moderatedCommunitiesGroupController.refresh(),
        _joinedCommunitiesGroupController.refresh(),
      ]);
    } finally {
      _setRefreshInProgress(false);
    }
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
