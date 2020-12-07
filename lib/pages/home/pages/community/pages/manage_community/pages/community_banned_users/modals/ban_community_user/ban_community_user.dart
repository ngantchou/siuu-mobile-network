import 'dart:async';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBBanMemoryUserModal extends StatefulWidget {
  final Memory memory;

  const OBBanMemoryUserModal({Key key, @required this.memory})
      : super(key: key);

  @override
  State<OBBanMemoryUserModal> createState() {
    return OBBanMemoryUserModalState();
  }
}

class OBBanMemoryUserModalState extends State<OBBanMemoryUserModal> {
  UserService _userService;
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
      _userService = provider.userService;
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__ban_user_title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          listItemBuilder: _buildMemoryMemberListItem,
          searchResultListItemBuilder: _buildMemoryMemberListItem,
          listRefresher: _refreshMemoryMembers,
          listOnScrollLoader: _loadMoreMemoryMembers,
          listSearcher: _searchMemoryMembers,
          resourceSingularName: _localizationService.community__member,
          resourcePluralName: _localizationService.community__member_plural,
        ),
      ),
    );
  }

  Widget _buildMemoryMemberListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      onUserTilePressed: _onWantsToAddNewBannedUser,
    );
  }

  Future<List<User>> _refreshMemoryMembers() async {
    UsersList memoryMembers = await _userService
        .getMembersForMemory(widget.memory, exclude: [
      MemoryMembersExclusion.administrators,
      MemoryMembersExclusion.moderators
    ]);
    return memoryMembers.users;
  }

  Future<List<User>> _loadMoreMemoryMembers(
      List<User> memoryMembersList) async {
    var lastMemoryMember = memoryMembersList.last;
    var lastMemoryMemberId = lastMemoryMember.id;
    var moreMemoryMembers = (await _userService.getMembersForMemory(
            widget.memory,
            maxId: lastMemoryMemberId,
            count: 20,
            exclude: [
          MemoryMembersExclusion.administrators,
          MemoryMembersExclusion.moderators
        ]))
        .users;
    return moreMemoryMembers;
  }

  Future<List<User>> _searchMemoryMembers(String query) async {
    UsersList results = await _userService.searchMemoryMembers(
        query: query,
        memory: widget.memory,
        exclude: [
          MemoryMembersExclusion.administrators,
          MemoryMembersExclusion.moderators
        ]);

    return results.users;
  }

  void _onWantsToAddNewBannedUser(User user) async {
    var addedMemoryBannedUser =
        await _navigationService.navigateToConfirmBanMemoryUser(
            context: context, memory: widget.memory, user: user);

    if (addedMemoryBannedUser != null && addedMemoryBannedUser) {
      Navigator.of(context).pop(user);
    }
  }
}
