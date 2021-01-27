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

class OBMemoryModeratorsPage extends StatefulWidget {
  final Memory crew;

  const OBMemoryModeratorsPage({Key key, @required this.crew})
      : super(key: key);

  @override
  State<OBMemoryModeratorsPage> createState() {
    return OBMemoryModeratorsPageState();
  }
}

class OBMemoryModeratorsPageState extends State<OBMemoryModeratorsPage> {
  UserService _userService;
  ModalService _modalService;
  NavigationService _navigationService;
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
      _modalService = provider.modalService;
      _navigationService = provider.navigationService;
      _toastService = provider.toastService;
      _localizationService = provider.localizationService;
      _needsBootstrap = false;
    }

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.trans('community__moderators_title'),
        trailing: OBIconButton(
          OBIcons.add,
          themeColor: OBIconThemeColor.primaryAccent,
          onPressed: _onWantsToAddNewModerator,
        ),
      ),
      child: OBPrimaryColorContainer(
        child: OBHttpList<User>(
          controller: _httpListController,
          listItemBuilder: _buildMemoryModeratorListItem,
          searchResultListItemBuilder: _buildMemoryModeratorListItem,
          listRefresher: _refreshMemoryModerators,
          listOnScrollLoader: _loadMoreMemoryModerators,
          listSearcher: _searchMemoryModerators,
          resourceSingularName:
              _localizationService.trans('community__moderator_resource_name'),
          resourcePluralName:
              _localizationService.trans('community__moderators_resource_name'),
        ),
      ),
    );
  }

  Widget _buildMemoryModeratorListItem(BuildContext context, User user) {
    bool isLoggedInUser = _userService.isLoggedInUser(user);

    return OBUserTile(
      user,
      onUserTilePressed: _onMemoryModeratorListItemPressed,
      onUserTileDeleted:
          isLoggedInUser ? null : _onMemoryModeratorListItemDeleted,
      trailing: isLoggedInUser
          ? OBText(
              _localizationService.trans('community__moderators_you'),
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : null,
    );
  }

  void _onMemoryModeratorListItemPressed(User crewModerator) {
    _navigationService.navigateToUserProfile(
        user: crewModerator, context: context);
  }

  void _onMemoryModeratorListItemDeleted(User crewModerator) async {
    try {
      await _userService.removeMemoryModerator(
          crew: widget.crew, user: crewModerator);
      _httpListController.removeListItem(crewModerator);
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
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  Future<List<User>> _refreshMemoryModerators() async {
    UsersList crewModerators =
        await _userService.getModeratorsForMemory(widget.crew);
    return crewModerators.users;
  }

  Future<List<User>> _loadMoreMemoryModerators(
      List<User> crewModeratorsList) async {
    var lastMemoryModerator = crewModeratorsList.last;
    var lastMemoryModeratorId = lastMemoryModerator.id;
    var moreMemoryModerators = (await _userService.getModeratorsForMemory(
      widget.crew,
      maxId: lastMemoryModeratorId,
      count: 20,
    ))
        .users;
    return moreMemoryModerators;
  }

  Future<List<User>> _searchMemoryModerators(String query) async {
    UsersList results = await _userService.searchMemoryModerators(
        query: query, crew: widget.crew);

    return results.users;
  }

  void _onWantsToAddNewModerator() async {
    User addedMemoryModerator = await _modalService.openAddMemoryModerator(
        context: context, crew: widget.crew);

    if (addedMemoryModerator != null) {
      _httpListController.insertListItem(addedMemoryModerator);
    }
  }
}

typedef Future<User> OnWantsToCreateMemoryModerator();
typedef Future<User> OnWantsToEditMemoryModerator(User crewModerator);
typedef void OnWantsToSeeMemoryModerator(User crewModerator);
