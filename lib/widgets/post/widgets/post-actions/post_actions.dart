import 'package:Siuu/custom/InstantShareDialog.dart';
import 'package:Siuu/custom/customPostContainer.dart';
import 'package:Siuu/custom/reactionPostContainer.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/widgets/post_action_comment.dart';
import 'package:Siuu/widgets/post/widgets/post-actions/widgets/post_action_react.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OBPostActions extends StatelessWidget {
  final Post _post;
  final VoidCallback onWantsToCommentPost;

  OBPostActions(this._post, {this.onWantsToCommentPost});

  @override
  Widget build(BuildContext context) {
    List<Widget> postActions = [
      //Expanded(child: OBPostActionReact(_post)),
    ];
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    bool commentsEnabled = _post.areCommentsEnabled ?? true;

    bool canDisableOrEnableCommentsForPost = false;

    if (!commentsEnabled) {
      OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
      canDisableOrEnableCommentsForPost = openbookProvider.userService
          .getLoggedInUser()
          .canDisableOrEnableCommentsForPost(_post);
    }

    if (commentsEnabled || canDisableOrEnableCommentsForPost) {
      postActions.addAll([
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return InstantShareDialog(_post);
              },
            );
          },
          child: SvgPicture.asset('assets/svg/share.svg'),
        ),
        Row(
          children: [
            Row(
              children: [
                OBPostActionComment(
                  _post,
                  onWantsToCommentPost: onWantsToCommentPost,
                ),
              ],
            ),
            SizedBox(
              width: width * 0.072,
            ),
            Row(
              children: [ReactinPostContainer(_post)],
            ),
          ],
        )
        /* GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return InstantShareDialog(_post);
              },
            );
          },
          child: SvgPicture.asset('assets/svg/share.svg'),
        ),
        const SizedBox(
          width: 20.0,
        ),
        OBPostActionComment(
          _post,
          onWantsToCommentPost: onWantsToCommentPost,
        ),
        ReactinPostContainer(_post),*/
      ]);
    }
    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: postActions,
            ),
          ],
        ));
  }
}
