import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/community_invite.dart';
import 'package:Siuu/models/notifications/community_invite_notification.dart';
import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/community_avatar.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBMemoryInviteNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final MemoryInviteNotification crewInviteNotification;
  final VoidCallback onPressed;
  static final double postImagePreviewSize = 40;

  const OBMemoryInviteNotificationTile(
      {Key key,
      @required this.notification,
      @required this.crewInviteNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    MemoryInvite crewInvite = crewInviteNotification.crewInvite;
    User inviteCreator = crewInvite.creator;
    Memory crew = crewInvite.crew;

    String crewName = crew.name;

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToInviteCreatorProfile = () {
      openbookProvider.navigationService
          .navigateToUserProfile(user: inviteCreator, context: context);
    };
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        openbookProvider.navigationService
            .navigateToMemory(crew: crew, context: context);
      },
      leading: OBAvatar(
        onPressed: navigateToInviteCreatorProfile,
        size: OBAvatarSize.small,
        avatarUrl: inviteCreator.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        user: inviteCreator,
        onUsernamePressed: navigateToInviteCreatorProfile,
        text: TextSpan(
            text: _localizationService
                .notifications__user_community_invite_tile(crewName)),
      ),
      trailing: OBMemoryAvatar(
        crew: crew,
        size: OBAvatarSize.small,
      ),
      subtitle: OBSecondaryText(
          utilsService.timeAgo(notification.created, _localizationService)),
    );
  }
}
