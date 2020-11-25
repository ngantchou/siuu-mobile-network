import 'package:Siuu/models/notifications/notification.dart';
import 'package:Siuu/models/notifications/post_comment_user_mention_notification.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/post_comment_user_mention.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

import 'notification_tile_skeleton.dart';
import 'notification_tile_title.dart';

class OBPostCommentUserMentionNotificationTile extends StatelessWidget {
  final OBNotification notification;
  final PostCommentUserMentionNotification postCommentUserMentionNotification;
  static final double postCommentImagePreviewSize = 40;
  final VoidCallback onPressed;

  const OBPostCommentUserMentionNotificationTile(
      {Key key,
      @required this.notification,
      @required this.postCommentUserMentionNotification,
      this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostCommentUserMention postCommentUserMention =
        postCommentUserMentionNotification.postCommentUserMention;
    PostComment postComment = postCommentUserMention.postComment;

    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    var utilsService = openbookProvider.utilsService;

    Function navigateToMentionerProfile = () {
      openbookProvider.navigationService.navigateToUserProfile(
          user: postCommentUserMention.postComment.commenter, context: context);
    };
    LocalizationService _localizationService = openbookProvider.localizationService;

    String postCommentText = postComment.text;
    return OBNotificationTileSkeleton(
      onTap: () {
        if (onPressed != null) onPressed();
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

        PostComment parentComment = postComment.parentComment;
        if(parentComment!=null){
          openbookProvider.navigationService.navigateToPostCommentRepliesLinked(
              postComment: postComment,
              context: context,
              parentComment: parentComment);
        }else {
          openbookProvider.navigationService.navigateToPostCommentsLinked(
              postComment: postComment, context: context);
        }
      },
      leading: OBAvatar(
        onPressed: navigateToMentionerProfile,
        size: OBAvatarSize.medium,
        avatarUrl: postCommentUserMention.postComment.commenter.getProfileAvatar(),
      ),
      title: OBNotificationTileTitle(
        text: TextSpan(text: _localizationService.notifications__mentioned_in_post_comment_tile(postCommentText)),
        onUsernamePressed: navigateToMentionerProfile,
        user: postCommentUserMention.postComment.commenter,
      ),
      subtitle: OBSecondaryText(
        utilsService.timeAgo(notification.created, _localizationService),
        size: OBTextSize.small,
      ),
    );
  }
}
