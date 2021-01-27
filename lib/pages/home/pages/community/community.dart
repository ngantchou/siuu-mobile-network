import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/posts_list.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Siuu/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_card/community_card.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_cover.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_nav_bar.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_posts_stream_status_indicator.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/alerts/alert.dart';
import 'package:Siuu/widgets/buttons/community_new_post_button.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/posts_stream/posts_stream.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OBMemoryPage extends StatefulWidget {
  final Memory crew;

  OBMemoryPage(this.crew);

  @override
  OBMemoryPageState createState() {
    return OBMemoryPageState();
  }
}

class OBMemoryPageState extends State<OBMemoryPage>
    with TickerProviderStateMixin {
  Memory _crew;
  OBPostsStreamController _obPostsStreamController;
  ScrollController _obPostsStreamScrollController;
  UserService _userService;
  LocalizationService _localizationService;

  bool _needsBootstrap;

  CancelableOperation _refreshMemoryOperation;

  List<OBNewPostData> _newPostsData;

  double _hideFloatingButtonTolerance = 10;
  AnimationController _hideFloatingButtonAnimation;
  double _previousScrollPixels;

  @override
  void initState() {
    super.initState();
    _obPostsStreamScrollController = ScrollController();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _crew = widget.crew;
    _newPostsData = [];

    _hideFloatingButtonAnimation =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    _previousScrollPixels = 0;
    _hideFloatingButtonAnimation.forward();

    _obPostsStreamScrollController.addListener(() {
      double newScrollPixelPosition =
          _obPostsStreamScrollController.position.pixels;
      double scrollPixelDifference =
          _previousScrollPixels - newScrollPixelPosition;

      if (_obPostsStreamScrollController.position.userScrollDirection ==
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

  void _onWantsToUploadNewPostData(OBNewPostData newPostData) {
    _insertNewPostData(newPostData);
  }

  @override
  void dispose() {
    _hideFloatingButtonAnimation.dispose();
    super.dispose();
    if (_refreshMemoryOperation != null) _refreshMemoryOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;

      // If the user doesn't have permission to view the crew we need to
      // manually trigger a refresh here to make sure the model contains all
      // relevant crew information (like admins and moderators).
      //
      // If the user can see the content, a refresh will be triggered
      // automatically by the OBPostsStream.
      if (!_userCanSeeMemoryContent(_crew)) {
        _refreshMemory();
      }
    }

    return CupertinoPageScaffold(
        backgroundColor: Color.fromARGB(0, 0, 0, 0),
        navigationBar: OBMemoryNavBar(
          _crew,
        ),
        child: OBPrimaryColorContainer(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: StreamBuilder(
                    stream: _crew.updateSubject,
                    initialData: _crew,
                    builder:
                        (BuildContext context, AsyncSnapshot<Memory> snapshot) {
                      Memory latestMemory = snapshot.data;

                      return _userCanSeeMemoryContent(latestMemory)
                          ? _buildMemoryContent()
                          : _buildPrivateMemoryContent();
                    }),
              )
            ],
          ),
        ));
  }

  bool _userCanSeeMemoryContent(Memory crew) {
    bool crewIsPrivate = crew.isPrivate();

    User loggedInUser = _userService.getLoggedInUser();
    bool userIsMember = crew.isMember(loggedInUser);

    return !crewIsPrivate || userIsMember;
  }

  Widget _buildMemoryContent() {
    List<Widget> prependedItems = [
      OBMemoryCover(_crew),
      OBMemoryCard(
        _crew,
      )
    ];

    if (_newPostsData.isNotEmpty) {
      prependedItems.addAll(_newPostsData.map((OBNewPostData newPostData) {
        return _buildNewPostDataUploader(newPostData);
      }).toList());
    }

    List<Widget> stackItems = [
      OBPostsStream(
        scrollController: _obPostsStreamScrollController,
        onScrollLoader: _loadMoreMemoryPosts,
        refresher: _refreshMemoryPosts,
        controller: _obPostsStreamController,
        prependedItems: prependedItems,
        displayContext: OBPostDisplayContext.crewPosts,
        streamIdentifier: 'community_' + widget.crew.name,
        secondaryRefresher: _refreshMemory,
        statusIndicatorBuilder: _buildPostsStreamStatusIndicator,
      ),
    ];

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    User loggedInUser = openbookProvider.userService.getLoggedInUser();
    bool isMemberOfMemory = _crew.isMember(loggedInUser);

    if (isMemberOfMemory) {
      stackItems.add(Positioned(
          bottom: 20.0,
          right: 20.0,
          child: ScaleTransition(
            scale: _hideFloatingButtonAnimation,
            child: OBMemoryNewPostButton(
              crew: _crew,
              onWantsToUploadNewPostData: _onWantsToUploadNewPostData,
            ),
          )));
    }

    return Stack(
      children: stackItems,
    );
  }

  Widget _buildPostsStreamStatusIndicator(
      {BuildContext context,
      OBPostsStreamStatus streamStatus,
      List<Widget> streamPrependedItems,
      Function streamRefresher}) {
    return OBMemoryPostsStreamStatusIndicator(
        streamRefresher: streamRefresher,
        streamPrependedItems: streamPrependedItems,
        streamStatus: streamStatus);
  }

  Widget _buildNewPostDataUploader(OBNewPostData newPostData) {
    return OBNewPostDataUploader(
      data: newPostData,
      onPostPublished: _onNewPostDataUploaderPostPublished,
      onCancelled: _onNewPostDataUploaderCancelled,
    );
  }

  void _onNewPostDataUploaderCancelled(OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
  }

  void _onNewPostDataUploaderPostPublished(
      Post publishedPost, OBNewPostData newPostData) {
    _removeNewPostData(newPostData);
    _crew.incrementPostsCount();
    _obPostsStreamController.addPostToTop(publishedPost);
  }

  Widget _buildPrivateMemoryContent() {
    bool crewHasInvitesEnabled = _crew.invitesEnabled;
    return ListView(
      padding: EdgeInsets.all(0),
      physics: const ClampingScrollPhysics(),
      children: <Widget>[
        OBMemoryCover(_crew),
        OBMemoryCard(
          _crew,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: OBAlert(
            child: Column(
              children: <Widget>[
                OBText(_localizationService.trans('community__is_private'),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    textAlign: TextAlign.center),
                const SizedBox(
                  height: 10,
                ),
                OBText(
                  crewHasInvitesEnabled
                      ? _localizationService
                          .trans('community__invited_by_member')
                      : _localizationService
                          .trans('community__invited_by_moderator'),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
        OBMemoryAdministrators(_crew),
        OBMemoryModerators(_crew)
      ],
    );
  }

  Future<void> _refreshMemory() async {
    if (_refreshMemoryOperation != null) _refreshMemoryOperation.cancel();
    _refreshMemoryOperation = CancelableOperation.fromFuture(
        _userService.getMemoryWithName(_crew.name));
    debugPrint(_localizationService.trans('community__refreshing'));
    var crew = await _refreshMemoryOperation.value;
    _setMemory(crew);
  }

  Future<List<Post>> _refreshMemoryPosts() async {
    debugPrint('Refreshing crew posts');
    PostsList crewPosts = await _userService.getPostsForMemory(widget.crew);
    return crewPosts.posts;
  }

  Future<List<Post>> _loadMoreMemoryPosts(List<Post> crewPostsList) async {
    debugPrint('Loading more crew posts');
    var lastMemoryPost = crewPostsList.last;
    var lastMemoryPostId = lastMemoryPost.id;
    var moreMemoryPosts = (await _userService.getPostsForMemory(
      widget.crew,
      maxId: lastMemoryPostId,
      count: 10,
    ))
        .posts;
    return moreMemoryPosts;
  }

  void _setMemory(Memory crew) {
    setState(() {
      _crew = crew;
    });
  }

  void _insertNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.insert(0, newPostData);
    });
  }

  void _removeNewPostData(OBNewPostData newPostData) {
    setState(() {
      _newPostsData.remove(newPostData);
    });
  }
}

class MemoryTabBarDelegate extends SliverPersistentHeaderDelegate {
  MemoryTabBarDelegate({
    this.controller,
    this.pageStorageKey,
    this.crew,
  });

  final TabController controller;
  final Memory crew;
  final PageStorageKey pageStorageKey;

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var localizationService = openbookProvider.localizationService;
    var themeValueParserService = openbookProvider.themeValueParserService;

    return StreamBuilder(
        stream: themeService.themeChange,
        initialData: themeService.getActiveTheme(),
        builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
          var theme = snapshot.data;

          Color themePrimaryTextColor =
              themeValueParserService.parseColor(theme.primaryTextColor);

          return new SizedBox(
            height: kToolbarHeight,
            child: TabBar(
              controller: controller,
              key: pageStorageKey,
              indicatorColor: themePrimaryTextColor,
              labelColor: themePrimaryTextColor,
              tabs: <Widget>[
                Tab(text: localizationService.trans('community__posts')),
                Tab(text: localizationService.trans('community__about')),
              ],
            ),
          );
        });
  }

  @override
  bool shouldRebuild(covariant MemoryTabBarDelegate oldDelegate) {
    return oldDelegate.controller != controller;
  }
}

typedef void OnWantsToEditUserMemory(User user);
