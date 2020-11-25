import 'package:Siuu/models/emoji.dart';
import 'package:Siuu/models/emoji_group.dart';
import 'package:Siuu/widgets/emoji_picker/emoji_picker.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBPickFollowsListEmojiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Pick emoji',
      ),
      child: OBPrimaryColorContainer(
        child: OBEmojiPicker(
          onEmojiPicked: (Emoji pickedEmoji, EmojiGroup emojiGroup) {
            Navigator.pop(context, pickedEmoji);
          },
        ),
      ),
    );
  }
}
