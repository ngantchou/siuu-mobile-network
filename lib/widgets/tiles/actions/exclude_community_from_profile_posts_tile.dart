import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBExcludeMemoryFromProfilePostsTile extends StatefulWidget {
  final Post post;
  final ValueChanged<Memory> onPostMemoryExcludedFromProfilePosts;

  const OBExcludeMemoryFromProfilePostsTile({
    Key key,
    @required this.post,
    @required this.onPostMemoryExcludedFromProfilePosts,
  }) : super(key: key);

  @override
  OBExcludeMemoryFromProfilePostsTileState createState() {
    return OBExcludeMemoryFromProfilePostsTileState();
  }
}

class OBExcludeMemoryFromProfilePostsTileState
    extends State<OBExcludeMemoryFromProfilePostsTile> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  BottomSheetService _bottomSheetService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;
    _bottomSheetService = openbookProvider.bottomSheetService;

    return ListTile(
      leading: OBIcon(OBIcons.excludePostMemory),
      title: OBText(
          _localizationService.post__exclude_community_from_profile_posts),
      onTap: _onWantsToExcludeMemory,
    );
  }

  void _onWantsToExcludeMemory() {
    _bottomSheetService.showConfirmAction(
        context: context,
        subtitle: _localizationService
            .post__exclude_community_from_profile_posts_confirmation,
        actionCompleter: (BuildContext context) async {
          await _excludePostMemory();

          widget.onPostMemoryExcludedFromProfilePosts(widget.post.crew);
          _toastService.success(
              message: _localizationService
                  .post__exclude_community_from_profile_posts_success,
              context: context);
        });
  }

  Future _excludePostMemory() async {
    return _userService.excludeMemoryFromProfilePosts(widget.post.crew);
  }
}
