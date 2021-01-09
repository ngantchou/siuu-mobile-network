import 'package:Siuu/models/reactions_emoji_count.dart';
import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'buttons/button.dart';

class OBEmojiReactionButton extends StatelessWidget {
  final ReactionsEmojiCount postReactionsEmojiCount;
  final bool reacted;
  final ValueChanged<ReactionsEmojiCount> onPressed;
  final ValueChanged<ReactionsEmojiCount> onLongPressed;
  final OBEmojiReactionButtonSize size;

  const OBEmojiReactionButton(this.postReactionsEmojiCount,
      {this.onPressed,
      this.reacted,
      this.onLongPressed,
      this.size = OBEmojiReactionButtonSize.medium});

  @override
  Widget build(BuildContext context) {
    var emoji = postReactionsEmojiCount.emoji;
    String type = '';
    switch (emoji.id) {
      case 1:
        type = "like";
        break;
      case 2:
        type = "dislike";
        break;
      case 3:
        type = "heartReact";
        break;
      case 4:
        type = "brokenHeart";
        break;
      case 5:
        type = "haha";
        break;
      case 6:
        type = "shock";
        break;
      case 7:
        type = "smirk";
        break;
      default:
        type = "like";
    }
    List<Widget> buttonRowItems = [
      /*Image(
        height: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
        image: AdvancedNetworkImage(emoji.image, useDiskCache: true),
      ),*/
      SvgPicture.asset(
        'assets/svg/$type.svg',
        //height: height * 0.043,
        height: size == OBEmojiReactionButtonSize.medium ? 18 : 14,
      ),
      const SizedBox(
        width: 10.0,
      ),
      OBText(
        postReactionsEmojiCount.getPrettyCount(),
        style: TextStyle(
            fontWeight: reacted ? FontWeight.bold : FontWeight.normal,
            fontSize: size == OBEmojiReactionButtonSize.medium ? null : 12),
      )
    ];

    Widget buttonChild = Row(
        mainAxisAlignment: MainAxisAlignment.center, children: buttonRowItems);

    return OBButton(
      minWidth: 50,
      child: buttonChild,
      onLongPressed: () {
        if (onLongPressed != null) onLongPressed(postReactionsEmojiCount);
      },
      onPressed: () {
        if (onPressed != null) onPressed(postReactionsEmojiCount);
      },
      type: OBButtonType.highlight,
    );
  }
}

enum OBEmojiReactionButtonSize { small, medium }
