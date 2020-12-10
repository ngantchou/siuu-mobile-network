import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:async/async.dart';

class ReactinPostContainer extends StatefulWidget {
  final Post post;
  ReactinPostContainer(this.post);
  @override
  _ReactionPostContainerState createState() => _ReactionPostContainerState();
}

class _ReactionPostContainerState extends State<ReactinPostContainer> {
  Widget reactionIcon;
  CancelableOperation _clearPostReactionOperation;
  bool _clearPostReactionInProgress;
  LocalizationService _localizationService;
  Text expression = Text('');
  @override
  void initState() {
    super.initState();
    reactionIcon = null;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        expression,
        FlutterReactionButton(
          shouldChangeReaction: false,
          boxColor: Color(0xffFD0767).withOpacity(0.3),
          boxAlignment: Alignment.bottomRight,
          onReactionChanged: (reaction) {
            print('reaction selected id: ${reaction.id}');
            setState(() {
              reactionIcon = reaction.icon;
              expression = reaction.title;
            });
          },
          reactions: <Reaction>[
            Reaction(
              id: 1,
              previewIcon: buildpreview('like'),
              icon: buildIcon('like'),
              title: Text('like'),
            ),
            Reaction(
              id: 2,
              previewIcon: buildpreview('dislike'),
              icon: buildIcon('dislike'),
              title: Text('like'),
            ),
            Reaction(
              id: 3,
              previewIcon: buildpreview('heartReact'),
              icon: buildIcon('heartReact'),
              title: Text('like'),
            ),
            Reaction(
              id: 4,
              previewIcon: buildpreview('brokenHeart'),
              icon: buildIcon('brokenHeart'),
              title: Text('like'),
            ),
            Reaction(
              id: 5,
              previewIcon: buildpreview('haha'),
              icon: buildIcon('haha'),
              title: Text('like'),
            ),
            Reaction(
              id: 6,
              previewIcon: buildpreview('shock'),
              icon: buildIcon('shock'),
              title: Text('like'),
            ),
            Reaction(
              id: 7,
              previewIcon: buildpreview('smirk'),
              icon: buildIcon('smirk'),
              title: Text('like'),
            ),
          ],
          initialReaction: Reaction(
            id: 1,
            icon: Align(
              alignment: Alignment.center,
              child: new Container(
                height: height * 0.0585,
                width: width * 0.14,
                child: Stack(
                  children: [
                    Text('like'),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: SvgPicture.asset(
                          'assets/svg/haha.svg',
                          height: height * 0.043,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: reactionIcon == null
                            ? SvgPicture.asset(
                                'assets/svg/like.svg',
                                height: height * 0.043,
                              )
                            : reactionIcon,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Padding buildpreview(
    String emoji,
  ) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset('assets/svg/$emoji.svg',
          fit: BoxFit.fill, height: height * 0.058),
    );
  }

  buildIcon(String emoji) {
    final double height = MediaQuery.of(context).size.height;
    return SvgPicture.asset(
      'assets/svg/$emoji.svg',
      fit: BoxFit.fill,
      height: height * 0.043,
    );
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

  void _onPressed() {
    if (widget.post.hasReaction()) {
      _clearPostReaction();
    } else {
      var openbookProvider = OpenbookProvider.of(context);
      openbookProvider.bottomSheetService
          .showReactToPost(post: widget.post, context: context);
    }
  }

  Future _clearPostReaction() async {
    if (_clearPostReactionInProgress) return;
    _setClearPostReactionInProgress(true);
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);

    try {
      _clearPostReactionOperation = CancelableOperation.fromFuture(
          openbookProvider.userService.deletePostReaction(
              postReaction: widget.post.reaction, post: widget.post));

      await _clearPostReactionOperation.value;
      widget.post.clearReaction();
    } catch (error) {
      _onError(error: error, openbookProvider: openbookProvider);
    } finally {
      _clearPostReactionOperation = null;
      _setClearPostReactionInProgress(false);
    }
  }

  void _setClearPostReactionInProgress(bool clearPostReactionInProgress) {
    setState(() {
      _clearPostReactionInProgress = clearPostReactionInProgress;
    });
  }

  void _onError(
      {@required error,
      @required OpenbookProviderState openbookProvider}) async {
    ToastService toastService = openbookProvider.toastService;

    if (error is HttpieConnectionRefusedError) {
      toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      toastService.error(message: errorMessage, context: context);
    } else {
      toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }
}

typedef void OnWantsToReactToPost(Post post);
