import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/notifications/user_new_post_notification.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBUserNewPostNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final UserNewPostNotification userNewPostNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBUserNewPostNotificationTile(
      {Key key,
      @required this.notification,
      @required this.userNewPostNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Post post = userNewPostNotification.post;

    Widget postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = OBNotificationTilePostMediaPreview(
        post: post,
      );
    }
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToCreatorProfile = () {
      openbookProvider.navigationService.navigateToUserProfile(
          user: userNewPostNotification.post.creator, context: context);
    };
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    Function onTileTapped = () {
      if (onPressed != null) onPressed();
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      openbookProvider.navigationService
          .navigateToPost(post: userNewPostNotification.post, context: context);
    };
    return OBNotificationTileSkeleton(
      onTap: onTileTapped,
      leading: OBAvatar(
        onPressed: navigateToCreatorProfile,
        size: OBAvatarSize.small,
        avatarUrl: userNewPostNotification.post.creator.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        onUsernamePressed: navigateToCreatorProfile,
        user: userNewPostNotification.post.creator,
        text: TextSpan(
            text: _localizationService.notifications__user_new_post_tile),
      ),
      trailing: postImagePreview,
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created, _localizationService)),
    );
  }
}
