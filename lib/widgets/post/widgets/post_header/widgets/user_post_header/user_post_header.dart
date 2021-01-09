import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/bottom_sheets/post_actions.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/res/colors.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/letter_avatar.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/user_badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBUserPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final OBPostDisplayContext displayContext;
  final bool hasActions;

  const OBUserPostHeader(this._post,
      {Key key,
      @required this.onPostDeleted,
      this.onPostReported,
      this.hasActions = true,
      this.displayContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var bottomSheetService = openbookProvider.bottomSheetService;
    var utilsService = openbookProvider.utilsService;
    var localizationService = openbookProvider.localizationService;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    if (_post.creator == null) return const SizedBox();

    String username = '@${_post.creator.username}';
    String timeAgo = '';
    if (_post.created != null)
      timeAgo =
          '${utilsService.timeAgo(_post.created, localizationService)} agos';

    Function navigateToUserProfile = () {
      navigationService.navigateToUserProfile(
          user: _post.creator, context: context);
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                  onTap: () {
                    navigateToUserProfile();
                  },
                  child: StreamBuilder(
                      stream: _post.creator.updateSubject,
                      initialData: _post.creator,
                      builder:
                          (BuildContext context, AsyncSnapshot<User> snapshot) {
                        User postCreator = snapshot.data;

                        if (!postCreator.hasProfileAvatar())
                          return OBLetterAvatar(
                            color: Color(pinkColor),
                            letter: postCreator.username[0],
                            borderRadius: 30,
                            customSize: OBLetterAvatar.fontSizeLarge,
                            labelColor: Colors.white,
                            size: OBAvatarSize.extraSmall,
                          );

                        return OBAvatar(
                          size: OBAvatarSize.extraSmall,
                          avatarUrl: postCreator.getProfileAvatar(),
                        );
                      })),
              SizedBox(width: width * 0.024),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _post.creator.getProfileName(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 17,
                      color: Color(0xff78849e),
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Color(0xff78849e).withOpacity(0.56),
                    ),
                  )
                ],
              ),
            ],
          ),
          hasActions
              ? InkWell(
                  child: Image.asset('assets/images/arrowDownIcon.png'),
                  onTap: () {
                    bottomSheetService.showPostActions(
                        context: context,
                        post: _post,
                        onPostDeleted: onPostDeleted,
                        displayContext: displayContext,
                        onPostReported: onPostReported);
                  })
              : null,
        ],
      ),
    );
    /* return ListTile(
        onTap: navigateToUserProfile,
        leading: StreamBuilder(
            stream: _post.creator.updateSubject,
            initialData: _post.creator,
            builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              User postCreator = snapshot.data;

              if (!postCreator.hasProfileAvatar()) return const SizedBox();

              return OBAvatar(
                size: OBAvatarSize.medium,
                avatarUrl: postCreator.getProfileAvatar(),
              );
            }),
        trailing: hasActions
            ? IconButton(
                icon: const OBIcon(OBIcons.moreVertical),
                onPressed: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      onPostDeleted: onPostDeleted,
                      displayContext: displayContext,
                      onPostReported: onPostReported);
                })
            : null,
        title: Row(
          children: <Widget>[
            Flexible(
              child: OBText(
                _post.creator.getProfileName(),
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              width: 3,
            ),
            _buildBadge()
          ],
        ),
        subtitle: OBSecondaryText(
          subtitle,
          style: TextStyle(fontSize: 12.0),
        ));*/
  }

  Widget _buildBadge() {
    User postCommenter = _post.creator;

    if (postCommenter.hasProfileBadges())
      return OBUserBadge(
          badge: _post.creator.getDisplayedProfileBadge(),
          size: OBUserBadgeSize.small);

    return const SizedBox();
  }
}
