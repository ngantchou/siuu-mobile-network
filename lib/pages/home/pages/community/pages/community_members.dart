import 'dart:async';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/buttons/actions/follow_button.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryMembersPage extends StatefulWidget {
  final Memory crew;

  const OBMemoryMembersPage({Key key, @required this.crew}) : super(key: key);

  @override
  State<OBMemoryMembersPage> createState() {
    return OBMemoryMembersPageState();
  }
}

class OBMemoryMembersPageState extends State<OBMemoryMembersPage> {
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

    String title = widget.crew.usersAdjective ??
        _localizationService.community__community_members;
    String singularName =
        widget.crew.userAdjective ?? _localizationService.community__member;
    String pluralName = widget.crew.usersAdjective ??
        _localizationService.community__member_plural;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildMemoryMemberListItem,
          searchResultListItemBuilder: _buildMemoryMemberListItem,
          listRefresher: _refreshMemoryMembers,
          listOnScrollLoader: _loadMoreMemoryMembers,
          listSearcher: _searchMemoryMembers,
          resourceSingularName: singularName.toLowerCase(),
          resourcePluralName: pluralName.toLowerCase(),
        ),
      ),
    );
  }

  Widget _buildMemoryMemberListItem(BuildContext context, User user) {
    bool isLoggedInUser = _userService.isLoggedInUser(user);

    return OBUserTile(user,
        onUserTilePressed: _onMemoryMemberListItemPressed,
        trailing: isLoggedInUser
            ? null
            : OBFollowButton(
                user,
                size: OBButtonSize.small,
                unfollowButtonType: OBButtonType.highlight,
              ));
  }

  void _onMemoryMemberListItemPressed(User crewMember) {
    _navigationService.navigateToUserProfile(
        user: crewMember, context: context);
  }

  Future<List<User>> _refreshMemoryMembers() async {
    UsersList crewMembers = await _userService.getMembersForMemory(widget.crew);
    return crewMembers.users;
  }

  Future<List<User>> _loadMoreMemoryMembers(List<User> crewMembersList) async {
    var lastMemoryMember = crewMembersList.last;
    var lastMemoryMemberId = lastMemoryMember.id;
    var moreMemoryMembers = (await _userService.getMembersForMemory(
      widget.crew,
      maxId: lastMemoryMemberId,
      count: 20,
    ))
        .users;
    return moreMemoryMembers;
  }

  Future<List<User>> _searchMemoryMembers(String query) async {
    UsersList results =
        await _userService.searchMemoryMembers(query: query, crew: widget.crew);

    return results.users;
  }
}
