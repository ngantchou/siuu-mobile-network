import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OBPostActionComment extends StatelessWidget {
  final Post post;
  final VoidCallback onWantsToCommentPost;

  OBPostActionComment(this.post, {this.onWantsToCommentPost});

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var localizationService = openbookProvider.localizationService;

    return Row(
      children: [
        buildNumberText(post.commentsCount.toString()),
        InkWell(
          onTap: () {
            if (onWantsToCommentPost != null) {
              onWantsToCommentPost();
            } else {
              navigationService.navigateToPostComments(
                  post: post, context: context);
            }
          },
          child: SvgPicture.asset('assets/svg/comments.svg'),
        ),
      ],
    );
    /*return OBButton(
        type: OBButtonType.highlight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const OBIcon(
              OBIcons.comment,
              customSize: 20.0,
            ),
            const SizedBox(
              width: 10.0,
            ),
            // OBText(localizationService.trans('post__action_comment')),
          ],
        ),
        onPressed: () {
          if (onWantsToCommentPost != null) {
            onWantsToCommentPost();
          } else {
            navigationService.navigateToPostComments(
                post: _post, context: context);
          }
        });*/
  }

  Text buildNumberText(String number) {
    return Text(
      number,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: Color(0xff78849e),
      ),
    );
  }
}

typedef void OnWantsToCommentPost(Post post);
