import 'package:Siuu/models/notifications/community_new_post_notification.dart';
import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/community_avatar.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/tiles/notification_tile/notification_tile_post_media_preview.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBMemoryNewPostNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final MemoryNewPostNotification crewNewPostNotification;
  static final double postImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBMemoryNewPostNotificationTile(
      {Key key,
      @required this.notification,
      @required this.crewNewPostNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Post post = crewNewPostNotification.post;

    Widget postImagePreview;
    if (post.hasMediaThumbnail()) {
      postImagePreview = Padding(
          padding: const EdgeInsets.only(left: 10),
          child: OBNotificationTilePostMediaPreview(
            post: post,
          ));
    }
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    Function navigateToMemory = () {
      openbookProvider.navigationService
          .navigateToMemory(crew: post.crew, context: context);
    };

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        openbookProvider.navigationService
            .navigateToPost(post: post, context: context);
      },
      leading: OBMemoryAvatar(
        onPressed: navigateToMemory,
        size: OBAvatarSize.small,
        crew: post.crew,
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(
            text: _localizationService
                .notifications__community_new_post_tile(post.crew.name)),
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created, _localizationService)),
      trailing: postImagePreview,
    );
  }
}
