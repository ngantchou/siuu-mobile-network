import 'dart:async';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/models/users_list.dart';
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
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryBannedUsersPage extends StatefulWidget {
  final Memory crew;

  const OBMemoryBannedUsersPage({Key key, @required this.crew})
      : super(key: key);

  @override
  State<OBMemoryBannedUsersPage> createState() {
    return OBMemoryBannedUsersPageState();
  }
}

class OBMemoryBannedUsersPageState extends State<OBMemoryBannedUsersPage> {
  UserService _userService;
  ModalService _modalService;
  NavigationService _navigationService;
  ToastService _toastService;
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
      _modalService = provider.modalService;
      _navigationService = provider.navigationService;
      _localizationService = provider.localizationService;
      _toastService = provider.toastService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__banned_users_title,
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToAddNewBannedUser,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildMemoryBannedUserListItem,
          searchResultListItemBuilder: _buildMemoryBannedUserListItem,
          listRefresher: _refreshMemoryBannedUsers,
          listOnScrollLoader: _loadMoreMemoryBannedUsers,
          listSearcher: _searchMemoryBannedUsers,
          resourceSingularName:
              _localizationService.community__banned_user_text,
          resourcePluralName: _localizationService.community__banned_users_text,
        ),
      ),
    );
  }

  Widget _buildMemoryBannedUserListItem(BuildContext context, User user) {
    bool isLoggedInUser = _userService.isLoggedInUser(user);

    return OBUserTile(
      user,
      onUserTilePressed: _onMemoryBannedUserListItemPressed,
      onUserTileDeleted:
          isLoggedInUser ? null : _onMemoryBannedUserListItemDeleted,
      trailing: isLoggedInUser
          ? OBText(
              _localizationService.community__user_you_text,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  void _onMemoryBannedUserListItemPressed(User crewBannedUser) {
    _navigationService.navigateToUserProfile(
        user: crewBannedUser, context: context);
  }

  void _onMemoryBannedUserListItemDeleted(User crewBannedUser) async {
    try {
      await _userService.unbanMemoryUser(
          crew: widget.crew, user: crewBannedUser);
      _httpListController.removeListItem(crewBannedUser);
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

  Future<List<User>> _refreshMemoryBannedUsers() async {
    UsersList crewBannedUsers =
        await _userService.getBannedUsersForMemory(widget.crew);
    return crewBannedUsers.users;
  }

  Future<List<User>> _loadMoreMemoryBannedUsers(
      List<User> crewBannedUsersList) async {
    var lastMemoryBannedUser = crewBannedUsersList.last;
    var lastMemoryBannedUserId = lastMemoryBannedUser.id;
    var moreMemoryBannedUsers = (await _userService.getBannedUsersForMemory(
      widget.crew,
      maxId: lastMemoryBannedUserId,
      count: 20,
    ))
        .users;
    return moreMemoryBannedUsers;
  }

  Future<List<User>> _searchMemoryBannedUsers(String query) async {
    UsersList results = await _userService.searchMemoryBannedUsers(
        query: query, crew: widget.crew);

    return results.users;
  }

  void _onWantsToAddNewBannedUser() async {
    User addedMemoryBannedUser = await _modalService.openBanMemoryUser(
        context: context, crew: widget.crew);

    if (addedMemoryBannedUser != null) {
      _httpListController.insertListItem(addedMemoryBannedUser);
    }
  }
}
