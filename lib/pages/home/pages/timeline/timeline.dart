import 'dart:async';
import 'dart:io';
import 'package:Siuu/models/circle.dart';
import 'package:Siuu/models/follows_list.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/lib/poppable_page_controller.dart';
import 'package:Siuu/pages/home/pages/memories/memories.dart';
import 'package:Siuu/pages/home/pages/menu/menu.dart';
import 'package:Siuu/pages/home/pages/profile/wallet.dart';
import 'package:Siuu/pages/home/pages/search/search.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/theme.dart';
import 'package:Siuu/services/theme_value_parser.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/badges/badge.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/floating_action_button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/icon_button.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:Siuu/widgets/posts_stream/posts_stream.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OBTimelinePage extends StatefulWidget {
  final OBTimelinePageController controller;

  OBTimelinePage({
    @required this.controller,
  });

  @override
  OBTimelinePageState createState() {
    return OBTimelinePageState();
  }
}

class OBTimelinePageState extends State<OBTimelinePage>
    with TickerProviderStateMixin {
  OBPostsStreamController _timelinePostsStreamController;
  ScrollController _timelinePostsStreamScrollController;
  ModalService _modalService;
  NavigationService _navigationService;
  UserService _userService;
  LocalizationService _localizationService;
  ThemeService _themeService;
  ThemeValueParserService _themeValueParserService;
  OBMainSearchPageController _searchPageController;
  OBMainMenuPageController _mainMenuPageController;

  List<Post> _initialPosts;
  List<OBNewPostData> _newPostsData;
  List<Circle> _filteredCircles;
  List<FollowsList> _filteredFollowsLists;

  StreamSubscription _loggedInUserChangeSubscription;

  bool _needsBootstrap;
  bool _loggedInUserBootstrapped;

  double _hideFloatingButtonTolerance = 10;
  AnimationController _hideFloatingButtonAnimation;
  double _previousScrollPixels;

  @override
  void initState() {
    super.initState();
    _timelinePostsStreamController = OBPostsStreamController();
    _timelinePostsStreamScrollController = ScrollController();
    _searchPageController = OBMainSearchPageController();
    _mainMenuPageController = OBMainMenuPageController();
    widget.controller.attach(context: context, state: this);
    _needsBootstrap = true;
    _loggedInUserBootstrapped = false;
    _filteredCircles = [];
    _filteredFollowsLists = [];
    _newPostsData = [];
    _hideFloatingButtonAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _hideFloatingButtonAnimation.forward();

    _previousScrollPixels = 0;

    _timelinePostsStreamScrollController.addListener(() {
      double newScrollPixelPosition =
          _timelinePostsStreamScrollController.position.pixels;
      double scrollPixelDifference =
          _previousScrollPixels - newScrollPixelPosition;

      if (_timelinePostsStreamScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (scrollPixelDifference * -1 > _hideFloatingButtonTolerance) {
          _hideFloatingButtonAnimation.reverse();
        }
      } else {
        if (scrollPixelDifference > _hideFloatingButtonTolerance) {
          _hideFloatingButtonAnimation.forward();
        }
      }

      _previousScrollPixels = newScrollPixelPosition;
    });
  }

  @override
  void dispose() {
    _hideFloatingButtonAnimation.dispose();
    super.dispose();
    _loggedInUserChangeSubscription.cancel();
  }

  void _bootstrap() async {
    _loggedInUserChangeSubscription =
        _userService.loggedInUserChange.listen(_onLoggedInUserChange);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _modalService = openbookProvider.modalService;
      _navigationService = openbookProvider.navigationService;
      _localizationService = openbookProvider.localizationService;
      _userService = openbookProvider.userService;
      _themeService = openbookProvider.themeService;
      _themeService = openbookProvider.themeService;
      _themeValueParserService = openbookProvider.themeValueParserService;
      _bootstrap();
      _needsBootstrap = false;
    }
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: _themeValueParserService
            .parseColor(_themeService.getActiveTheme().primaryColor),
        floatingActionButton: FloatingActionButton(
            onPressed: _onCreatePost,
            elevation: 0.0,
            child: Container(
              width: width * 0.145,
              height: height * 0.087,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, gradient: linearGradient),
              child: Center(
                child: SizedBox(
                  height: height * 0.033,
                  width: width * 0.058,
                  child: SvgPicture.asset(
                    'assets/svg/pencilIcon.svg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            /* OBThemedNavigationBar(
                title: 'Home', trailing: _buildFiltersButton()),*/
            Container(
              decoration: BoxDecoration(
                gradient: linearGradient,
              ),
              child: Column(
                children: [
                  Container(
                    height: height * 0.058,
                  ),
                  Container(
                    height: height * 0.078,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed('/camera');
                              },
                              child: SvgPicture.asset('assets/svg/Camera.svg')),
                          Text(
                            'Siuu',
                            style: TextStyle(
                              fontFamily: "Segoe UI",
                              fontSize: 15,
                              color: Color(0xffffffff),
                            ),
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OBMainSearchPage(
                                                  controller:
                                                      _searchPageController,
                                                )));
                                  },
                                  child: SizedBox(
                                    height: height * 0.029,
                                    width: width * 0.048,
                                    child: SvgPicture.asset(
                                        'assets/svg/search.svg',
                                        fit: BoxFit.contain,
                                        color: Colors.white),
                                  )),
                              SizedBox(width: width * 0.024),
                              InkWell(
                                onTap: () {
                                  showMenu(
                                    context: context,
                                    position:
                                        RelativeRect.fromLTRB(100, 100, 0, 100),
                                    items: [
                                      PopupMenuItem(
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        OBMainMenuPage(
                                                          controller:
                                                              _mainMenuPageController,
                                                        )));
                                          },
                                          child: Text('Settings'),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          Wallet()));
                                            },
                                            child: Text('Siucoins parameters')),
                                      ),
                                    ],
                                  );
                                },
                                child: SvgPicture.asset('assets/svg/menu.svg'),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Memories(_userService.getLoggedInUser()?.profile?.avatar),
            Container(
              height: height / 1.5,
              child: _loggedInUserBootstrapped
                  ? OBPostsStream(
                      controller: _timelinePostsStreamController,
                      scrollController: _timelinePostsStreamScrollController,
                      prependedItems: _buildPostsStreamPrependedItems(),
                      streamIdentifier: 'timeline',
                      onScrollLoader: _postsStreamOnScrollLoader,
                      refresher: _postsStreamRefresher,
                      initialPosts: _initialPosts,
                    )
                  : const SizedBox(),
            )
          ]),
        ));
  }

  List<Widget> _buildPostsStreamPrependedItems() {
    return _buildNewPostDataUploaders();
  }

  List<Widget> _buildNewPostDataUploaders() {
    return _newPostsData.map(_buildNewPostDataUploader).toList();
  }

  Widget _buildNewPostDataUploader(OBNewPostData newPostData) {
    return OBNewPostDataUploader(
      key: Key(newPostData.getUniqueKey()),
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );
  }

  Widget _buildFiltersButton() {
    int filtersCount = countFilters();
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
            onTap: () {
              _onWantsSearch();
            },
            child: SizedBox(
              height: height * 0.029,
              width: width * 0.048,
              child: SvgPicture.asset(
                'assets/svg/search.svg',
                fit: BoxFit.contain,
                color: Colors.white,
                width: 10,
              ),
            )),
        SizedBox(width: width * 0.04),
        InkWell(
          onTap: () {
            showMenu(
              context: context,
              position: RelativeRect.fromLTRB(100, 100, 0, 100),
              items: [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => OBMainMenuPage(
                                    controller: _mainMenuPageController,
                                  )));
                    },
                    child: Text('Settings'),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).pushNamed('/Wallet');
                      },
                      child: Text('Siucoins parameters')),
                ),
              ],
            );
          },
          child: SvgPicture.asset('assets/svg/menu.svg'),
        ),
      ],
    );
  }

  void _onLoggedInUserChange(User newUser) async {
    if (newUser == null) return;
    List<Post> initialPosts = (await _userService.getStoredFirstPosts()).posts;
    setState(() {
      _loggedInUserBootstrapped = true;
      _initialPosts = initialPosts;
      _loggedInUserChangeSubscription.cancel();
    });
  }

  Future<List<Post>> _postsStreamRefresher() async {
    bool cachePosts = _filteredCircles.isEmpty && _filteredFollowsLists.isEmpty;

    List<Post> posts = (await _userService.getTimelinePosts(
            count: 10,
            circles: _filteredCircles,
            followsLists: _filteredFollowsLists,
            cachePosts: cachePosts))
        .posts;

    return posts;
  }

  Future<List<Post>> _postsStreamOnScrollLoader(List<Post> posts) async {
    Post lastPost = posts.last;
    int lastPostId = lastPost.id;

    List<Post> morePosts = (await _userService.getTimelinePosts(
            maxId: lastPostId,
            circles: _filteredCircles,
            count: 10,
            followsLists: _filteredFollowsLists))
        .posts;

    return morePosts;
  }

  Future<bool> _onCreatePost({String text, File image, File video}) async {
    OBNewPostData createPostData = await _modalService.openCreatePost(
        text: text, image: image, video: video, context: context);
    if (createPostData != null) {
      addNewPostData(createPostData);
      _timelinePostsStreamController.scrollToTop(skipRefresh: true);

      return true;
    }

    return false;
  }

  Future<void> setFilters(
      {List<Circle> circles, List<FollowsList> followsLists}) async {
    _filteredCircles = circles;
    _filteredFollowsLists = followsLists;
    return _timelinePostsStreamController.refreshPosts();
  }

  Future<void> clearFilters() {
    _filteredCircles = [];
    _filteredFollowsLists = [];
    return _timelinePostsStreamController.refreshPosts();
  }

  List<Circle> getFilteredCircles() {
    return _filteredCircles.toList();
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _filteredFollowsLists.toList();
  }

  int countFilters() {
    return _filteredCircles.length + _filteredFollowsLists.length;
  }

  void _onNewPostDataUploaderCancelled(OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, OBNewPostData newPostData) {
    _timelinePostsStreamController.addPostToTop(publishedPost);
    _removeNewPostData(newPostData);
  }

  void addNewPostData(OBNewPostData postUploaderData) {
    setState(() {
      this._newPostsData.insert(0, postUploaderData);
    });
  }

  void _removeNewPostData(OBNewPostData postUploaderData) {
    setState(() {
      this._newPostsData.remove(postUploaderData);
    });
  }

  void scrollToTop() {
    _timelinePostsStreamController.scrollToTop();
  }

  void _onWantsFilters() {
    _modalService.openTimelineFilters(
        timelineController: widget.controller, context: context);
  }

  void _onWantsSearch() {
    _navigationService.navigateToSearch(
        context: context, searchPageController: _searchPageController);
  }
}

class OBTimelinePageController extends PoppablePageController {
  OBTimelinePageState _state;

  void attach({@required BuildContext context, OBTimelinePageState state}) {
    super.attach(context: context);
    _state = state;
  }

  Future<void> setPostFilters(
      {List<Circle> circles, List<FollowsList> followsLists}) async {
    return _state.setFilters(circles: circles, followsLists: followsLists);
  }

  Future<void> clearPostFilters(
      {List<Circle> circles, List<FollowsList> followsLists}) async {
    return _state.setFilters(circles: circles, followsLists: followsLists);
  }

  List<Circle> getFilteredCircles() {
    return _state.getFilteredCircles();
  }

  List<FollowsList> getFilteredFollowsLists() {
    return _state.getFilteredFollowsLists();
  }

  Future<bool> createPost({String text, File image, File video}) {
    return _state._onCreatePost(text: text, image: image, video: video);
  }

  void scrollToTop() {
    _state.scrollToTop();
  }
}
