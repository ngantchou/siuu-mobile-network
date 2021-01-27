import 'dart:async';
import 'dart:io';
import 'package:Siuu/pages/home/pages/Messages/Message.dart';
import 'package:Siuu/pages/home/pages/place/place.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/models/push_notification.dart';
import 'package:Siuu/pages/home/lib/poppable_page_controller.dart';
import 'package:Siuu/services/intercom.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/services/push_notifications/push_notifications.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/notifications/notifications.dart';
import 'package:Siuu/pages/home/pages/own_profile.dart';
import 'package:Siuu/pages/home/pages/timeline/timeline.dart';
import 'package:Siuu/pages/home/pages/menu/menu.dart';
import 'package:Siuu/pages/home/pages/search/search.dart';
import 'package:Siuu/pages/home/widgets/bottom-tab-bar.dart';
import 'package:Siuu/pages/home/widgets/own_profile_active_icon.dart';
import 'package:Siuu/pages/home/widgets/tab-scaffold.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/share.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/user_preferences.dart';
import 'package:Siuu/translation/constants.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/badges/badge.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/res/colors.dart';

import 'pages/communities/communities.dart';

class OBHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OBHomePageState();
  }
}

class OBHomePageState extends State<OBHomePage> with WidgetsBindingObserver {
  static const String oneSignalAppId = '66074bf4-9943-4504-a011-531c2635698b';
  UserService _userService;
  ToastService _toastService;
  PushNotificationsService _pushNotificationsService;
  IntercomService _intercomService;
  ModalService _modalService;
  UserPreferencesService _userPreferencesService;
  ShareService _shareService;
  MediaService _mediaService;
  bool preventCloseApp = false;
  int _currentIndex;
  int _lastIndex;
  bool _needsBootstrap;

  StreamSubscription _loggedInUserChangeSubscription;
  StreamSubscription _loggedInUserUpdateSubscription;
  StreamSubscription _pushNotificationOpenedSubscription;
  StreamSubscription _pushNotificationSubscription;

  OBTimelinePageController _timelinePageController;
  OBOwnProfilePageController _ownProfilePageController;
  OBMainSearchPageController _searchPageController;
  OBMainMenuPageController _mainMenuPageController;
  OBCommunitiesPageController _memoriesPageController;
  OBNotificationsPageController _notificationsPageController;
  DateTime currentBackPressTime;
  int _loggedInUserUnreadNotifications;
  String _loggedInUserAvatarUrl;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(_backButtonInterceptor);
    WidgetsBinding.instance.addObserver(this);
    _needsBootstrap = true;
    _loggedInUserUnreadNotifications = 0;
    _lastIndex = 0;
    _currentIndex = 0;
    _timelinePageController = OBTimelinePageController();
    _ownProfilePageController = OBOwnProfilePageController();
    _searchPageController = OBMainSearchPageController();
    _mainMenuPageController = OBMainMenuPageController();
    _memoriesPageController = OBCommunitiesPageController();
    _notificationsPageController = OBNotificationsPageController();
  }

  @override
  void dispose() {
    super.dispose();
    BackButtonInterceptor.remove(_backButtonInterceptor);
    WidgetsBinding.instance.removeObserver(this);
    _loggedInUserChangeSubscription.cancel();
    if (_loggedInUserUpdateSubscription != null)
      _loggedInUserUpdateSubscription.cancel();
    if (_pushNotificationOpenedSubscription != null) {
      _pushNotificationOpenedSubscription.cancel();
    }
    if (_pushNotificationSubscription != null) {
      _pushNotificationSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _pushNotificationsService = openbookProvider.pushNotificationsService;
      _intercomService = openbookProvider.intercomService;
      _toastService = openbookProvider.toastService;
      _modalService = openbookProvider.modalService;
      _userPreferencesService = openbookProvider.userPreferencesService;
      _shareService = openbookProvider.shareService;
      _mediaService = openbookProvider.mediaService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return Material(
      child: WillPopScope(
          child: OBCupertinoTabScaffold(
            tabBuilder: (BuildContext context, int index) {
              return CupertinoTabView(
                builder: (BuildContext context) {
                  return _getPageForTabIndex(index);
                },
              );
            },
            tabBar: _createTabBar(),
          ),
          onWillPop: onWillPop),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    Future<bool> confirm = Future.value(true);
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      AlertDialog(
        actions: [
          FlatButton(
              onPressed: () {
                confirm = Future.value(false);
              },
              child: Text('No')),
          FlatButton(
              onPressed: () {
                confirm = Future.value(true);
              },
              child: Text('Yes'))
        ],
        content: Text("will you want to quit Siuu ?"),
      );
    }
    return confirm;
  }

  Widget _getPageForTabIndex(int index) {
    Widget page;
    switch (OBHomePageTabs.values[index]) {
      case OBHomePageTabs.timeline:
        page = OBTimelinePage(
          controller: _timelinePageController,
        );
        break;
      case OBHomePageTabs.search:
        page = MessagePage(
            //controller: _searchPageController,
            );
        break;
      case OBHomePageTabs.notifications:
        page = OBNotificationsPage(
          controller: _notificationsPageController,
        );
        break;
      case OBHomePageTabs.memories:
        page = OBMainCommunitiesPage(
          controller: _memoriesPageController,
        );
        break;
      /*case OBHomePageTabs.profile:
        page = OBOwnProfilePage(controller: _ownProfilePageController);
        break;*/
      case OBHomePageTabs.menu:
        page = PlacesPage(
            //controller: _mainMenuPageController,
            );
        break;
      default:
        throw 'Unhandled index';
    }

    return page;
  }

  Widget buildBottomNavigationBarItem(
      {String iconPath, int index, String title, Color color}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width * 0.170,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: SvgPicture.asset(
              iconPath,
              color: color,
            ),
          ),
          title != null
              ? FittedBox(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 12,
                      color: color != null ? color : Color(0xff78849e),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _createTabBar() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return OBCupertinoTabBar(
      activeColor: Colors.blueAccent,
      backgroundColor: Colors.white,
      currentIndex: _currentIndex,
      onTap: (int index) {
        var tappedTab = OBHomePageTabs.values[index];
        var currentTab = OBHomePageTabs.values[_lastIndex];

        if (tappedTab == OBHomePageTabs.timeline &&
            currentTab == OBHomePageTabs.timeline) {
          if (_timelinePageController.isFirstRoute()) {
            _timelinePageController.scrollToTop();
          } else {
            _timelinePageController.popUntilFirstRoute();
          }
        }

        /*if (tappedTab == OBHomePageTabs.profile &&
            currentTab == OBHomePageTabs.profile) {
          if (_ownProfilePageController.isFirstRoute()) {
            _ownProfilePageController.scrollToTop();
          } else {
            _ownProfilePageController.popUntilFirstRoute();
          }
        }*/

        if (tappedTab == OBHomePageTabs.memories &&
            currentTab == OBHomePageTabs.memories) {
          if (_memoriesPageController.isFirstRoute()) {
            _memoriesPageController.scrollToTop();
          } else {
            _memoriesPageController.popUntilFirstRoute();
          }
        }

        if (tappedTab == OBHomePageTabs.search &&
            currentTab == OBHomePageTabs.search) {
          if (_searchPageController.isFirstRoute()) {
            _searchPageController.scrollToTop();
          } else {
            _searchPageController.popUntilFirstRoute();
          }
        }

        if (currentTab == OBHomePageTabs.notifications) {
          // If we're coming from the notifications page, make sure to clear!
          _resetLoggedInUserUnreadNotificationsCount();
        }

        if (tappedTab == OBHomePageTabs.menu &&
            currentTab == OBHomePageTabs.menu) {
          _mainMenuPageController.popUntilFirstRoute();
        }

        if (tappedTab == OBHomePageTabs.notifications) {
          _notificationsPageController.setIsActivePage(true);
          if (currentTab == OBHomePageTabs.notifications) {
            if (_notificationsPageController.isFirstRoute()) {
              _notificationsPageController.scrollToTop();
            } else {
              _notificationsPageController.popUntilFirstRoute();
            }
          }
        } else {
          _notificationsPageController.setIsActivePage(false);
        }

        _lastIndex = index;
        return true;
      },
      items: [
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: buildBottomNavigationBarItem(
              iconPath: "assets/svg/home.svg", index: 0, title: 'Accueil'),
          activeIcon: buildBottomNavigationBarItem(
              color: Color(pinkColor),
              iconPath: "assets/svg/home.svg",
              index: 0,
              title: 'Accueil'),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: buildBottomNavigationBarItem(
              iconPath: "assets/svg/message.svg", index: 1, title: 'Message'),
          activeIcon: buildBottomNavigationBarItem(
              color: Color(pinkColor),
              iconPath: "assets/svg/message.svg",
              index: 1,
              title: 'Message'),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        height: height * 0.152,
                        width: width * 0.170,
                        decoration: BoxDecoration(
                            gradient: linearGradient, shape: BoxShape.circle),
                        child: Center(
                          child:
                              SvgPicture.asset('assets/svg/lightningIcon.svg'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          activeIcon: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Container(
                        height: height * 0.102,
                        width: width * 0.170,
                        decoration: BoxDecoration(
                            gradient: linearGradient, shape: BoxShape.circle),
                        child: Center(
                          child:
                              SvgPicture.asset('assets/svg/lightningIcon.svg'),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: buildBottomNavigationBarItem(
              iconPath: "assets/svg/memories.svg", index: 3, title: 'Places'),
          activeIcon: buildBottomNavigationBarItem(
              color: Color(pinkColor),
              iconPath: "assets/svg/memories.svg",
              index: 3,
              title: 'Places'),
        ),
        BottomNavigationBarItem(
          title: const SizedBox(),
          icon: buildBottomNavigationBarItem(
              iconPath: "assets/svg/notification.svg",
              index: 2,
              title: 'Notifications'),
          activeIcon: buildBottomNavigationBarItem(
              color: Color(pinkColor),
              iconPath: "assets/svg/notification.svg",
              index: 3,
              title: 'Notifications'),
        ),
        /* BottomNavigationBarItem(
          title: const SizedBox(),
          icon: const OBIcon(
            OBIcons.menu,
            semanticLabel: "Setting",
          ),
          activeIcon: const OBIcon(
            OBIcons.menu,
            themeColor: OBIconThemeColor.primaryAccent,
          ),
        ),*/
      ],
    );
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);

    if (!_userService.isLoggedIn()) {
      try {
        await _userService.loginWithStoredUserData();
      } catch (error) {
        if (error is AuthTokenMissingError) {
          _logout();
        } else if (error is HttpieRequestError) {
          HttpieResponse response = error.response;
          if (response.isForbidden() || response.isUnauthorized()) {
            _logout(unsubscribePushNotifications: true);
          } else {
            _onError(error);
          }
        } else {
          _onError(error);
        }
      }
    }

    _shareService.subscribe(_onShare);
  }

  Future _logout({unsubscribePushNotifications = false}) async {
    try {
      if (unsubscribePushNotifications)
        await _pushNotificationsService.unsubscribeFromPushNotifications();
    } catch (error) {
      throw error;
    } finally {
      await _userService.logout();
    }
  }

  bool _backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    OBHomePageTabs currentTab = OBHomePageTabs.values[_lastIndex];
    PoppablePageController currentTabController;

    switch (currentTab) {
      case OBHomePageTabs.notifications:
        currentTabController = _notificationsPageController;
        break;
      case OBHomePageTabs.memories:
        currentTabController = _memoriesPageController;
        break;
      case OBHomePageTabs.timeline:
        currentTabController = _timelinePageController;
        break;
      case OBHomePageTabs.menu:
        currentTabController = _mainMenuPageController;
        break;
      case OBHomePageTabs.search:
        currentTabController = _searchPageController;
        break;
      /*case OBHomePageTabs.profile:
        currentTabController = _ownProfilePageController;
        break;*/
      default:
        throw 'No tab controller to pop';
    }

    bool canPopRootRoute = Navigator.of(context, rootNavigator: true).canPop();
    bool canPopRoute = currentTabController.canPop();

    if (canPopRoute && !canPopRootRoute) {
      currentTabController.pop();
      // Stop default

      willQuitApp();
    }

    // Close the app
    return preventCloseApp;
  }

  void willQuitApp() async {
    final value = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes, exit'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    preventCloseApp = value == true;
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) {
      Navigator.pushReplacementNamed(context, '/auth');
    } else {
      _pushNotificationsService.bootstrap();
      _intercomService.enableIntercom();

      _loggedInUserUpdateSubscription =
          newUser.updateSubject.listen(_onLoggedInUserUpdate);

      _pushNotificationOpenedSubscription = _pushNotificationsService
          .pushNotificationOpened
          .listen(_onPushNotificationOpened);

      _pushNotificationSubscription = _pushNotificationsService.pushNotification
          .listen(_onPushNotification);

      if (newUser.areGuidelinesAccepted != null &&
          !newUser.areGuidelinesAccepted) {
        _modalService.openAcceptGuidelines(context: context);
      }

      if (newUser.language == null ||
          !supportedLanguages.contains(newUser.language.code)) {
        _userService.setLanguageFromDefaults();
      }
      _userService.checkAndClearTempDirectories();
    }
  }

  void _onPushNotification(PushNotification pushNotification) {
    OBHomePageTabs currentTab = OBHomePageTabs.values[_lastIndex];

    if (currentTab != OBHomePageTabs.notifications) {
      // When a user taps in notifications, notifications count should be removed
      // Therefore if the user is already there, dont increment.
      User loggedInUser = _userService.getLoggedInUser();
      if (loggedInUser != null) {
        loggedInUser.incrementUnreadNotificationsCount();
      }
    }
  }

  void _onPushNotificationOpened(
      PushNotificationOpenedResult pushNotificationOpenedResult) {
    _navigateToTab(OBHomePageTabs.notifications);
  }

  Future<bool> _onShare({String text, File image, File video}) async {
    bool postCreated = await _timelinePageController.createPost(
        text: text, image: image, video: video);

    if (postCreated) {
      _timelinePageController.popUntilFirstRoute();
      _navigateToTab(OBHomePageTabs.timeline);
    }

    return true;
  }

  void _navigateToTab(OBHomePageTabs tab) {
    int newIndex = OBHomePageTabs.values.indexOf(tab);
    // This only works once... bug with flutter.
    // Reported it here https://github.com/flutter/flutter/issues/28992
    _setCurrentIndex(newIndex);
  }

  void _setCurrentIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool hasAuthToken = await _userService.hasAuthToken();
      if (hasAuthToken) _userService.refreshUser();
    }
  }

  void _onLoggedInUserUpdate(User user) {
    _setAvatarUrl(user.getProfileAvatar());
    OBHomePageTabs currentTab = _getCurrentTab();
    if (currentTab != OBHomePageTabs.notifications) {
      _setUnreadNotifications(user.unreadNotificationsCount);
    }
  }

  void _setAvatarUrl(String avatarUrl) {
    setState(() {
      _loggedInUserAvatarUrl = avatarUrl;
    });
  }

  void _setUnreadNotifications(int unreadNotifications) {
    setState(() {
      _loggedInUserUnreadNotifications = unreadNotifications;
    });
  }

  OBHomePageTabs _getCurrentTab() {
    return OBHomePageTabs.values[_lastIndex];
  }

  void _resetLoggedInUserUnreadNotificationsCount() {
    User loggedInUser = _userService.getLoggedInUser();
    if (loggedInUser != null) {
      loggedInUser.resetUnreadNotificationsCount();
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
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }
}

enum OBHomePageTabs { timeline, search, memories, menu, notifications }
