import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_reaction.dart';
import 'package:Siuu/models/reactions_emoji_count.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/reaction_emoji_count.dart';
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
  String expression = null;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;

  CancelableOperation _requestOperation;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    reactionIcon = null;
    _requestInProgress = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_requestOperation != null) _requestOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _navigationService = openbookProvider.navigationService;
    return FlutterReactionButton(
        shouldChangeReaction: false,
        boxColor: Color(0xffFD0767).withOpacity(0.3),
        boxAlignment: Alignment.bottomRight,
        boxPosition: Position.BOTTOM,
        onReactionChanged: (reaction) {
          //print('reaction selected id: ${reaction.id}');
          _onEmojiReactionCountPressed(reaction);

          reactionIcon = reaction.icon;
          expression = reaction.title;
        },
        reactions: <Reaction>[
          Reaction(
            id: 1,
            previewIcon: buildpreview('like'),
            icon: buildIcon('like'),
            title: 'like',
          ),
          Reaction(
            id: 2,
            previewIcon: buildpreview('dislike'),
            icon: buildIcon('dislike'),
            title: 'dislike',
          ),
          Reaction(
            id: 3,
            previewIcon: buildpreview('heartReact'),
            icon: buildIcon('heartReact'),
            title: 'heartReact',
          ),
          Reaction(
            id: 4,
            previewIcon: buildpreview('brokenHeart'),
            icon: buildIcon('brokenHeart'),
            title: 'brokenHeart',
          ),
          Reaction(
            id: 5,
            previewIcon: buildpreview('haha'),
            icon: buildIcon('haha'),
            title: 'haha',
          ),
          Reaction(
            id: 6,
            previewIcon: buildpreview('shock'),
            icon: buildIcon('shock'),
            title: 'shock',
          ),
          Reaction(
            id: 7,
            previewIcon: buildpreview('smirk'),
            icon: buildIcon('smirk'),
            title: 'smirk',
          ),
        ],
        initialReaction: Reaction(
          id: 1,
          icon: StreamBuilder(
              stream: widget.post.updateSubject,
              initialData: widget.post,
              builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
                var post = snapshot.data;

                List<ReactionsEmojiCount> emojiCounts =
                    post.reactionsEmojiCounts?.counts;

                if (emojiCounts == null || emojiCounts.length == 0)
                  return Align(
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
                  );
                if (emojiCounts != null || emojiCounts.length == 1)
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: getEmoji(
                          emojiCounts[0].emoji.id, emojiCounts[0].count),
                    ),
                  );
                emojiCounts.sort((a, b) => a.count.compareTo(b.count));
                return Align(
                  alignment: Alignment.center,
                  child: new Container(
                    height: height * 0.0585,
                    width: width * 0.14,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: emojiCounts.length >= 2
                                ? getEmoji(emojiCounts[1].emoji.id,
                                    emojiCounts[1].count)
                                : getEmoji(1, 0),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: getEmoji(
                                emojiCounts[0].emoji.id, emojiCounts[0].count),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  void _onEmojiReactionCountPressed(Reaction pressedEmojiCount) async {
    bool reacted = widget.post.isReactionSVG(pressedEmojiCount.id);

    if (reacted) {
      await _deleteReaction();
      widget.post.clearReaction();
    } else {
      // React
      PostReaction newPostReaction = await _reactToPost(pressedEmojiCount.id);
      widget.post.setReaction(newPostReaction);
    }
  }

  Future<PostReaction> _reactToPost(int emoji) async {
    _setRequestInProgress(true);
    PostReaction postReaction;
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.reactToPost(post: widget.post, emoji: emoji));
      postReaction = await _requestOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }

    return postReaction;
  }

  Future<void> _deleteReaction() async {
    _setRequestInProgress(true);
    try {
      _requestOperation = CancelableOperation.fromFuture(
          _userService.deletePostReaction(
              postReaction: widget.post.reaction, post: widget.post));
      await _requestOperation.value;
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(message: 'Unknown error', context: context);
      throw error;
    }
  }

  void _setRequestInProgress(requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }

  Padding buildpreview(
    String emoji,
  ) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset('assets/svg/$emoji.svg',
          fit: BoxFit.fill, height: height * 0.038),
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

  getEmoji(int id, int count) {
    final double height = MediaQuery.of(context).size.height;
    String emoji;
    switch (id) {
      case 1:
        emoji = "like";
        break;
      case 2:
        emoji = "dislike";
        break;
      case 3:
        emoji = "heartReact";
        break;
      case 4:
        emoji = "brokenHeart";
        break;
      case 5:
        emoji = "haha";
        break;
      case 6:
        emoji = "shock";
        break;
      case 7:
        emoji = "smirk";
        break;
      default:
        emoji = "like";
    }
    return SvgPicture.asset(
      'assets/svg/$emoji.svg',
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
}

typedef void OnWantsToReactToPost(Post post);
