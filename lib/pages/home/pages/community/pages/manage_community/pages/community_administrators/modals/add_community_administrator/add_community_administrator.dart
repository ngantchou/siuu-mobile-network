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

class OBAddMemoryAdministratorModal extends StatefulWidget {
  final Memory crew;

  const OBAddMemoryAdministratorModal({Key key, @required this.crew})
      : super(key: key);

  @override
  State<OBAddMemoryAdministratorModal> createState() {
    return OBAddMemoryAdministratorModalState();
  }
}

class OBAddMemoryAdministratorModalState
    extends State<OBAddMemoryAdministratorModal> {
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
        title: _localizationService.community__add_administrators_title,
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
      onUserTilePressed: _onWantsToAddNewAdministrator,
    );
  }

  Future<List<User>> _refreshMemoryMembers() async {
    UsersList crewMembers = await _userService.getMembersForMemory(widget.crew,
        exclude: [MemoryMembersExclusion.administrators]);
    return crewMembers.users;
  }

  Future<List<User>> _loadMoreMemoryMembers(List<User> crewMembersList) async {
    var lastMemoryMember = crewMembersList.last;
    var lastMemoryMemberId = lastMemoryMember.id;
    var moreMemoryMembers = (await _userService.getMembersForMemory(widget.crew,
            maxId: lastMemoryMemberId,
            count: 20,
            exclude: [MemoryMembersExclusion.administrators]))
        .users;
    return moreMemoryMembers;
  }

  Future<List<User>> _searchMemoryMembers(String query) async {
    UsersList results = await _userService.searchMemoryMembers(
        query: query,
        crew: widget.crew,
        exclude: [MemoryMembersExclusion.administrators]);

    return results.users;
  }

  void _onWantsToAddNewAdministrator(User user) async {
    var addedMemoryAdministrator =
        await _navigationService.navigateToConfirmAddMemoryAdministrator(
            context: context, crew: widget.crew, user: user);

    if (addedMemoryAdministrator != null && addedMemoryAdministrator) {
      Navigator.of(context).pop(user);
    }
  }
}
