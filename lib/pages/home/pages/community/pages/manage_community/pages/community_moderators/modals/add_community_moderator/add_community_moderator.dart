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

class OBAddMemoryModeratorModal extends StatefulWidget {
  final Memory crew;

  const OBAddMemoryModeratorModal({Key key, @required this.crew})
      : super(key: key);

  @override
  State<OBAddMemoryModeratorModal> createState() {
    return OBAddMemoryModeratorModalState();
  }
}

class OBAddMemoryModeratorModalState extends State<OBAddMemoryModeratorModal> {
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
        title: _localizationService.community__add_moderator_title,
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
      onUserTilePressed: _onWantsToAddNewModerator,
    );
  }

  Future<List<User>> _refreshMemoryMembers() async {
    UsersList crewMembers = await _userService.getMembersForMemory(widget.crew,
        exclude: [
          MemoryMembersExclusion.administrators,
          MemoryMembersExclusion.moderators
        ]);
    return crewMembers.users;
  }

  Future<List<User>> _loadMoreMemoryMembers(List<User> crewMembersList) async {
    var lastMemoryMember = crewMembersList.last;
    var lastMemoryMemberId = lastMemoryMember.id;
    var moreMemoryMembers = (await _userService.getMembersForMemory(widget.crew,
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
        crew: widget.crew,
        exclude: [
          MemoryMembersExclusion.administrators,
          MemoryMembersExclusion.moderators
        ]);

    return results.users;
  }

  void _onWantsToAddNewModerator(User user) async {
    var addedMemoryModerator =
        await _navigationService.navigateToConfirmAddMemoryModerator(
            context: context, crew: widget.crew, user: user);

    if (addedMemoryModerator != null && addedMemoryModerator) {
      Navigator.of(context).pop(user);
    }
  }
}
