import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/profile_card.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_cover.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_nav_bar.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_posts_stream_status_indicator.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/alerts/alert.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/posts_stream/posts_stream.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Siuu/res/colors.dart';

class OBProfilePage extends StatefulWidget {
  final OBProfilePageController controller;
  final User user;

  OBProfilePage(
    this.user, {
    this.controller,
  });

  @override
  OBProfilePageState createState() {
    return OBProfilePageState();
  }
}

class OBProfilePageState extends State<OBProfilePage>
    with SingleTickerProviderStateMixin {
  User _user;
  bool _needsBootstrap;
  UserService _userService;
  LocalizationService _localizationService;
  OBPostsStreamController _obPostsStreamController;
  bool _profileMemoryPostsVisible;
  OBPostDisplayContext _postsDisplayContext;

  List<Memory> _recentlyExcludedCommunities;
  GlobalKey<RefreshIndicatorState> _protectedProfileRefreshIndicatorKey =
      GlobalKey();
  bool _needsProtectedProfileBootstrap;
  bool isInformationPressed = true;
  bool isPublicationsPressed = false;

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _obPostsStreamController = OBPostsStreamController();
    _needsBootstrap = true;
    _needsProtectedProfileBootstrap = true;
    _user = widget.user;
    if (widget.controller != null) widget.controller.attach(this);
    _profileMemoryPostsVisible = widget.user.getProfileMemoryPostsVisible();
    _recentlyExcludedCommunities = [];
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      switch (_tabController.index) {
        case 0:
          setState(() {
            isInformationPressed = true;
            isPublicationsPressed = false;
          });

          break;
        case 1:
          setState(() {
            isInformationPressed = false;
            isPublicationsPressed = true;
          });

          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      bool isLoggedInUserProfile = _userService.isLoggedInUser(widget.user);
      _postsDisplayContext = isLoggedInUserProfile
          ? OBPostDisplayContext.ownProfilePosts
          : OBPostDisplayContext.foreignProfilePosts;
      _localizationService = openbookProvider.localizationService;
      _needsBootstrap = false;
    }
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
          initialData: widget.user,
          stream: widget.user.updateSubject,
          builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
            User user = snapshot.data;
            if (user == null) return const SizedBox();

            if (_postsDisplayContext == OBPostDisplayContext.ownProfilePosts ||
                user.visibility != UserVisibility.private ||
                (user.isFollowing != null && user.isFollowing)) {
              return _buildVisibleProfileContent();
            }

            // User is private and its not us
            return _buildProtectedProfileContent();
          }),
    );
  }

  Column buildColumn({String title, String trailing}) {
    final double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(height: height * 0.014),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.w300,
                fontSize: 13,
                color: Color(0xffbbbbbb),
              ),
            ),
            Text(
              trailing,
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.w300,
                fontSize: 16,
                color: Color(0xff4d0cbb),
              ),
            )
          ],
        ),
        Divider(
          color: Color(0xff707070),
          thickness: 1,
        )
      ],
    );
  }

  CustomPostContainer buildCustomPostContainer() {
    final double height = MediaQuery.of(context).size.height;
    return CustomPostContainer();
  }

  Text buildText(
      {String label, double fontSize, int color, FontWeight fontWeight}) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: fontWeight != null ? fontWeight : null,
        fontSize: fontSize,
        color: Color(color),
      ),
    );
  }

  Container buildLineContainer() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      height: height * 0.036,
      width: width * 0.004,
      color: Color(0xff3b3b3b),
    );
  }

  Widget _buildVisibleProfileContent() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: OBPostsStream(
              streamIdentifier: 'profile_${widget.user.username}',
              displayContext: _postsDisplayContext,
              prependedItems: _buildProfileContentDetails(),
              controller: _obPostsStreamController,
              postBuilder: _buildPostsStreamPost,
              secondaryRefresher: _refreshUser,
              refresher: _refreshPosts,
              onScrollLoader: _loadMorePosts,
              onPostsRefreshed: _onPostsRefreshed,
              statusIndicatorBuilder: _buildPostsStreamStatusIndicator),
        ),
      ],
    );
  }

  Widget _buildProtectedProfileContent() {
    if (_needsProtectedProfileBootstrap) {
      Future.delayed(Duration(milliseconds: 100), () {
        _protectedProfileRefreshIndicatorKey.currentState.show();
      });
      _needsProtectedProfileBootstrap = false;
    }

    List<Widget> profileDetails = _buildProfileContentDetails();

    profileDetails.addAll([
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: _buildPrivateProfileContentAlert(),
      )
    ]);

    return RefreshIndicator(
      displacement: 40,
      key: _protectedProfileRefreshIndicatorKey,
      onRefresh: _refreshUser,
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: profileDetails,
        ),
      ),
    );
  }

  Widget _buildPrivateProfileContentAlert() {
    return OBAlert(
        child: Row(
      children: [
        OBIcon(
          OBIcons.visibilityPrivate,
          size: OBIconSize.large,
        ),
        const SizedBox(
          width: 20,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              OBText(
                _localizationService.user__protected_account_title,
                size: OBTextSize.large,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              OBSecondaryText(
                _localizationService
                    .user__protected_account_desc(widget.user.username),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                stream: widget.user.updateSubject,
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  if (snapshot.data == null ||
                      snapshot.data.isFollowRequested == null)
                    return const SizedBox();
                  User user = snapshot.data;
                  return OBSecondaryText((user.isFollowRequested
                      ? _localizationService
                          .user__protected_account_instructions_complete
                      : _localizationService
                          .user__protected_account_instructions(
                              getFollowButtonText())));
                },
              ),
            ],
          ),
        )
      ],
    ));
  }

  List<Widget> _buildProfileContentDetails() {
    return [
      //OBProfileCover(_user),
      OBProfileCard(
        _user,
        onUserProfileUpdated: _onUserProfileUpdated,
        onExcludedCommunitiesAdded: _onExcludedCommunitiesAdded,
        onExcludedMemoryRemoved: _onExcludedMemoryRemoved,
      )
    ];
  }

  Widget _buildPostsStreamStatusIndicator(
      {BuildContext context,
      OBPostsStreamStatus streamStatus,
      List<Widget> streamPrependedItems,
      Function streamRefresher}) {
    return OBProfilePostsStreamStatusIndicator(
        user: widget.user,
        streamRefresher: streamRefresher,
        streamPrependedItems: streamPrependedItems,
        streamStatus: streamStatus);
  }

  Widget _buildPostsStreamPost({
    BuildContext context,
    Post post,
    String postIdentifier,
    OBPostDisplayContext displayContext,
    ValueChanged<Post> onPostDeleted,
  }) {
    return _recentlyExcludedCommunities.contains(post.memory)
        ? const SizedBox()
        : OBPost(
            post,
            key: Key(postIdentifier),
            onPostDeleted: onPostDeleted,
            displayContext: displayContext,
            inViewId: postIdentifier,
            onPostMemoryExcludedFromProfilePosts:
                _onPostMemoryExcludedFromProfilePosts,
          );
  }

  String getFollowButtonText() {
    return widget.user.isFollowed != null && widget.user.isFollowed
        ? _localizationService.user__follow_button_follow_back_text
        : _localizationService.user__follow_button_follow_text;
  }

  void _onPostMemoryExcludedFromProfilePosts(Memory memory) {
    _addRecentlyExcludedMemory(memory);
  }

  void _onUserProfileUpdated() {
    if (_profileMemoryPostsVisible != _user.getProfileMemoryPostsVisible()) {
      _refreshPosts();
    }
  }

  void _onExcludedCommunitiesAdded(List<Memory> excludedCommunities) {
    excludedCommunities.forEach((excludedMemory) {
      _addRecentlyExcludedMemory(excludedMemory);
    });
  }

  void _onExcludedMemoryRemoved(Memory excludedMemory) {
    _obPostsStreamController.refresh();
  }

  void scrollToTop() {
    _obPostsStreamController.scrollToTop();
  }

  Future<void> _refreshUser() async {
    var user = await _userService.getUserWithUsername(_user.username);
    _setUser(user);
  }

  Future<List<Post>> _refreshPosts() async {
    return (await _userService.getTimelinePosts(username: _user.username))
        .posts;
  }

  Future<List<Post>> _loadMorePosts(List<Post> posts) async {
    Post lastPost = posts.last;

    return (await _userService.getTimelinePosts(
            maxId: lastPost.id, username: _user.username))
        .posts;
  }

  void _onPostsRefreshed(List<Post> posts) {
    _clearRecentlyExcludedMemory();
  }

  void _setUser(User user) {
    setState(() {
      _user = user;
    });
  }

  void _clearRecentlyExcludedMemory() {
    setState(() {
      _recentlyExcludedCommunities = [];
    });
  }

  void _addRecentlyExcludedMemory(Memory memory) {
    setState(() {
      _recentlyExcludedCommunities.add(memory);
    });
  }
}

class OBProfilePageController {
  OBProfilePageState _timelinePageState;

  void attach(OBProfilePageState profilePageState) {
    assert(profilePageState != null, 'Cannot attach to empty state');
    _timelinePageState = profilePageState;
  }

  void scrollToTop() {
    if (_timelinePageState != null) _timelinePageState.scrollToTop();
  }
}

typedef void OnWantsToEditUserProfile(User user);
