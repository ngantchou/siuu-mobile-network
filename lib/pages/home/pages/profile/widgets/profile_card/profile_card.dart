import 'package:Siuu/models/badge.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_actions/profile_inline_actions.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_bio.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_connected_in.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_connection_request.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/profile_counts.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_details/profile_details.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_follow_request.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_in_lists.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_name.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_username.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/user_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_cover.dart';

class OBProfileCard extends StatelessWidget {
  final User user;
  final VoidCallback onUserProfileUpdated;
  final ValueChanged<Memory> onExcludedMemoryRemoved;
  final ValueChanged<List<Memory>> onExcludedCommunitiesAdded;

  const OBProfileCard(
    this.user, {
    Key key,
    this.onUserProfileUpdated,
    this.onExcludedMemoryRemoved,
    this.onExcludedCommunitiesAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var toastService = openbookProvider.toastService;

    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              /*Row(
                children: <Widget>[
                  const SizedBox(
                    height: (OBAvatar.AVATAR_SIZE_EXTRA_LARGE * 0.2),
                    width: OBAvatar.AVATAR_SIZE_EXTRA_LARGE,
                  ),
                  Expanded(
                      child: OBProfileInlineActions(user,
                          onUserProfileUpdated: onUserProfileUpdated,
                          onExcludedMemoryRemoved: onExcludedMemoryRemoved,
                          onExcludedCommunitiesAdded:
                              onExcludedCommunitiesAdded)),
                ],
              ),*/
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _buildNameRow(
                      user: user, context: context, toastService: toastService),
                  OBProfileUsername(user),
                  OBProfileBio(user),
                  //OBProfileDetails(user),
                  OBProfileCounts(user),
                  OBProfileConnectedIn(user),
                  OBProfileConnectionRequest(user),
                  OBProfileFollowRequest(user),
                  OBProfileInLists(user)
                ],
              ),
            ],
          ),
        ),
        Positioned(
          child: StreamBuilder(
              stream: themeService.themeChange,
              initialData: themeService.getActiveTheme(),
              builder: (BuildContext context, AsyncSnapshot<OBTheme> snapshot) {
                var theme = snapshot.data;

                return Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: themeValueParserService
                          .parseColor(theme.primaryColor),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50))),
                );
              }),
          top: -19,
        ),
        Positioned(
          top: -((OBAvatar.AVATAR_SIZE_EXTRA_LARGE / 2)) - 10,
          //left: (MediaQuery.of(context).size.width / 2) - 10,
          //      bottom: 0.0,
          right: 0.0,
          left: 0.0,
          child: StreamBuilder(
              stream: user.updateSubject,
              initialData: user,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                var user = snapshot.data;

                return OBAvatar(
                  borderWidth: 3,
                  borderRadius: 100,
                  avatarUrl: user?.getProfileAvatar(),
                  size: OBAvatarSize.extraLarge,
                  customSize: 50,
                  isZoomable: true,
                );
              }),
        ),
      ],
    );
  }

  Widget _buildNameRow(
      {@required User user,
      @required BuildContext context,
      @required ToastService toastService}) {
    /* if (user.hasProfileBadges() && user.getProfileBadges().length > 0) {
      return Row(children: <Widget>[
        OBProfileName(user),
        _getUserBadge(user: user, toastService: toastService, context: context)
      ]);
    }*/
    return OBProfileName(user);
  }

  Widget _getUserBadge(
      {@required User user,
      @required ToastService toastService,
      @required BuildContext context}) {
    Badge badge = user.getProfileBadges()[0];
    return GestureDetector(
      onTap: () {
        toastService.info(
            message: _getUserBadgeDescription(user), context: context);
      },
      child: OBUserBadge(badge: badge, size: OBUserBadgeSize.small),
    );
  }

  String _getUserBadgeDescription(User user) {
    Badge badge = user.getProfileBadges()[0];
    return badge.getKeywordDescription();
  }
}
