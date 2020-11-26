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
  final ValueChanged<Community> onExcludedCommunityRemoved;
  final ValueChanged<List<Community>> onExcludedCommunitiesAdded;

  const OBProfileCard(
    this.user, {
    Key key,
    this.onUserProfileUpdated,
    this.onExcludedCommunityRemoved,
    this.onExcludedCommunitiesAdded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var themeService = openbookProvider.themeService;
    var themeValueParserService = openbookProvider.themeValueParserService;
    var toastService = openbookProvider.toastService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Column(
                  children: [
                    Container(
                      height: height * 0.512,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: linearGradient,
                            ),
                            height: height * 0.336,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                children: [
                                  Spacer(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.white,
                                          ),
                                          onPressed: null),
                                      SvgPicture.asset('assets/svg/menu.svg'),
                                    ],
                                  ),
                                  Spacer(
                                    flex: 3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: height * 0.365,
                              width: width * 0.607,
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child:  StreamBuilder(
              stream: user.updateSubject,
              initialData: user,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                var user = snapshot.data;

                return OBAvatar(
                  borderWidth: 3,
                  avatarUrl: user?.getProfileAvatar(),
                  size: OBAvatarSize.extraLarge,
                  isZoomable: true,
                );
              }),
                                  ),
                                  Positioned(
                                    left: 20,
                                    top: 20,
                                    child:
                                        SvgPicture.asset('assets/svg/DM.svg'),
                                  ),
                                  Positioned(
                                    bottom: 20,
                                    right: 20,
                                    child:  OBProfileInlineActions(user,
                                    onUserProfileUpdated: onUserProfileUpdated,
                                    onExcludedCommunityRemoved:
                                        onExcludedCommunityRemoved,
                                    onExcludedCommunitiesAdded:
                                        onExcludedCommunitiesAdded)
                                  ),
                                  Positioned(
                                    left: 40,
                                    bottom: 40,
                                    child: SvgPicture.asset(
                                        'assets/svg/active.svg'),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.014),
                  _buildNameRow(
                      user: user, context: context, toastService: toastService),
                  OBProfileUsername(user),
                  OBProfileBio(user),
                 // OBProfileDetails(user),
                  OBProfileConnectedIn(user),
                  OBProfileConnectionRequest(user),
                  OBProfileFollowRequest(user),
                  OBProfileInLists(user),
                    SizedBox(height: height * 0.029),
                    OBProfileCounts(user),
                    SizedBox(height: height * 0.029),
                    SizedBox(
                      height: height * 0.321,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                Image.asset(
                                  'assets/images/girl1.png',
                                ),
                                Image.asset('assets/images/girl2.png'),
                                Image.asset('assets/images/girl3.png'),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 50,
                            bottom: 50,
                            left: 50,
                            child: Container(
                              height: height * 0.157,
                              width: width * 0.261,
                              decoration: BoxDecoration(
                                color: Color(0xff52575d),
                                boxShadow: [
                                  BoxShadow(
                                    offset: Offset(0.00, 10.00),
                                    color: Color(0xff000000).withOpacity(0.38),
                                    blurRadius: 20,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(12.00),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  buildText(
                                      color: 0xffDFD8C8,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      label: '5'),
                                  buildText(
                                      color: 0xffAEB5BC,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      label: 'PICS')
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),


                  ],
                );
   /* return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 18.0, right: 18),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(
                    height: (OBAvatar.AVATAR_SIZE_EXTRA_LARGE * 0.2),
                    width: OBAvatar.AVATAR_SIZE_EXTRA_LARGE,
                  ),
                  Expanded(
                      child: OBProfileInlineActions(user,
                          onUserProfileUpdated: onUserProfileUpdated,
                          onExcludedCommunityRemoved:
                              onExcludedCommunityRemoved,
                          onExcludedCommunitiesAdded:
                              onExcludedCommunitiesAdded)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  _buildNameRow(
                      user: user, context: context, toastService: toastService),
                  OBProfileUsername(user),
                  OBProfileBio(user),
                  OBProfileDetails(user),
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
          left: 18,
          child: StreamBuilder(
              stream: user.updateSubject,
              initialData: user,
              builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                var user = snapshot.data;

                return OBAvatar(
                  borderWidth: 3,
                  avatarUrl: user?.getProfileAvatar(),
                  size: OBAvatarSize.extraLarge,
                  isZoomable: true,
                );
              }),
        ),
      ],
    );*/
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
  Container buildLineContainer( double width, double height) {

    return Container(
      height: height * 0.036,
      width: width * 0.004,
      color: Color(0xff3b3b3b),
    );
  }
  Widget _buildNameRow(
      {@required User user,
      @required BuildContext context,
      @required ToastService toastService}) {
    if (user.hasProfileBadges() && user.getProfileBadges().length > 0) {
      return Row(
        crossAxisAlignment:CrossAxisAlignment.center,
        children: <Widget>[
        OBProfileName(user),
        _getUserBadge(user: user, toastService: toastService, context: context)
      ]);
    }
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
