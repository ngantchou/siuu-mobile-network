import 'dart:async';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/buttons/actions/invite_user_to_community.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBInviteToMemoryModal extends StatefulWidget {
  final Memory memory;

  const OBInviteToMemoryModal({Key key, @required this.memory})
      : super(key: key);

  @override
  State<OBInviteToMemoryModal> createState() {
    return OBInviteToMemoryModalState();
  }
}

class OBInviteToMemoryModalState extends State<OBInviteToMemoryModal> {
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
  }

  @override
  void dispose() {
    super.dispose();
    User.clearMaxSessionCache();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__invite_to_community_title,
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          key: Key('inviteToMemoryUserList'),
          listItemBuilder: _buildLinkedUserListItem,
          searchResultListItemBuilder: _buildLinkedUserListItem,
          listRefresher: _refreshLinkedUsers,
          listOnScrollLoader: _loadMoreLinkedUsers,
          listSearcher: _searchLinkedUsers,
          resourceSingularName: _localizationService
              .community__invite_to_community_resource_singular,
          resourcePluralName: _localizationService
              .community__invite_to_community_resource_plural,
        ),
      ),
    );
  }

  Widget _buildLinkedUserListItem(BuildContext context, User user) {
    return OBUserTile(
      user,
      key: Key(user.id.toString()),
      trailing: OBInviteUserToMemoryButton(
        user: user,
        memory: widget.memory,
      ),
      //trailing: OBButton,
    );
  }

  Future<List<User>> _refreshLinkedUsers() async {
    UsersList linkedUsers =
        await _userService.getLinkedUsers(withMemory: widget.memory);
    return linkedUsers.users;
  }

  Future<List<User>> _loadMoreLinkedUsers(List<User> linkedUsersList) async {
    var lastLinkedUser = linkedUsersList.last;
    var lastLinkedUserId = lastLinkedUser.id;
    var moreLinkedUsers = (await _userService.getLinkedUsers(
            maxId: lastLinkedUserId, count: 10, withMemory: widget.memory))
        .users;
    return moreLinkedUsers;
  }

  Future<List<User>> _searchLinkedUsers(String query) async {
    UsersList results = await _userService.searchLinkedUsers(
        query: query, withMemory: widget.memory);

    return results.users;
  }
}
