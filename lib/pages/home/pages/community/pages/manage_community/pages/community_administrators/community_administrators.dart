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

class OBMemoryAdministratorsPage extends StatefulWidget {
  final Memory memory;

  const OBMemoryAdministratorsPage({Key key, @required this.memory})
      : super(key: key);

  @override
  State<OBMemoryAdministratorsPage> createState() {
    return OBMemoryAdministratorsPageState();
  }
}

class OBMemoryAdministratorsPageState
    extends State<OBMemoryAdministratorsPage> {
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
        title: _localizationService.community__administrators_title,
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToAddNewAdministrator,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildMemoryAdministratorListItem,
          searchResultListItemBuilder: _buildMemoryAdministratorListItem,
          listRefresher: _refreshMemoryAdministrators,
          listOnScrollLoader: _loadMoreMemoryAdministrators,
          listSearcher: _searchMemoryAdministrators,
          resourceSingularName:
              _localizationService.community__administrator_text,
          resourcePluralName:
              _localizationService.community__administrator_plural,
        ),
      ),
    );
  }

  Widget _buildMemoryAdministratorListItem(BuildContext context, User user) {
    bool isLoggedInUser = _userService.isLoggedInUser(user);

    return OBUserTile(
      user,
      onUserTilePressed: _onMemoryAdministratorListItemPressed,
      onUserTileDeleted:
          isLoggedInUser ? null : _onMemoryAdministratorListItemDeleted,
      trailing: isLoggedInUser
          ? OBText(
              _localizationService.community__administrator_you,
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  void _onMemoryAdministratorListItemPressed(User memoryAdministrator) {
    _navigationService.navigateToUserProfile(
        user: memoryAdministrator, context: context);
  }

  void _onMemoryAdministratorListItemDeleted(User memoryAdministrator) async {
    try {
      await _userService.removeMemoryAdministrator(
          memory: widget.memory, user: memoryAdministrator);
      _httpListController.removeListItem(memoryAdministrator);
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

  Future<List<User>> _refreshMemoryAdministrators() async {
    UsersList memoryAdministrators =
        await _userService.getAdministratorsForMemory(widget.memory);
    return memoryAdministrators.users;
  }

  Future<List<User>> _loadMoreMemoryAdministrators(
      List<User> memoryAdministratorsList) async {
    var lastMemoryAdministrator = memoryAdministratorsList.last;
    var lastMemoryAdministratorId = lastMemoryAdministrator.id;
    var moreMemoryAdministrators =
        (await _userService.getAdministratorsForMemory(
      widget.memory,
      maxId: lastMemoryAdministratorId,
      count: 20,
    ))
            .users;
    return moreMemoryAdministrators;
  }

  Future<List<User>> _searchMemoryAdministrators(String query) async {
    UsersList results = await _userService.searchMemoryAdministrators(
        query: query, memory: widget.memory);

    return results.users;
  }

  void _onWantsToAddNewAdministrator() async {
    User addedMemoryAdministrator = await _modalService
        .openAddMemoryAdministrator(context: context, memory: widget.memory);

    if (addedMemoryAdministrator != null) {
      _httpListController.insertListItem(addedMemoryAdministrator);
    }
  }
}

typedef Future<User> OnWantsToCreateMemoryAdministrator();
typedef Future<User> OnWantsToEditMemoryAdministrator(User memoryAdministrator);
typedef void OnWantsToSeeMemoryAdministrator(User memoryAdministrator);
