import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/fields/toggle_field.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBDisplayProfileMemoryPostsToggleTile extends StatefulWidget {
  final User user;
  final ValueChanged<bool> onChanged;
  final bool hasDivider;

  const OBDisplayProfileMemoryPostsToggleTile(
      {Key key, this.onChanged, @required this.user, this.hasDivider = false})
      : super(key: key);

  @override
  OBDisplayProfileMemoryPostsToggleTileState createState() {
    return OBDisplayProfileMemoryPostsToggleTileState();
  }
}

class OBDisplayProfileMemoryPostsToggleTileState
    extends State<OBDisplayProfileMemoryPostsToggleTile> {
  static const double inputIconsSize = 16;
  static EdgeInsetsGeometry inputContentPadding =
      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0);

  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  bool _requestInProgress;

  bool _memoryPostsVisible;

  @override
  void initState() {
    super.initState();

    _requestInProgress = false;

    _memoryPostsVisible = widget.user.getProfileMemoryPostsVisible();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    return OBToggleField(
      hasDivider: widget.hasDivider,
      value: _memoryPostsVisible,
      title: _localizationService.user__manage_profile_community_posts_toggle,
      subtitle: OBText(
        _localizationService.user__manage_profile_community_posts_toggle__descr,
        size: OBTextSize.mediumSecondary,
      ),
      leading: const OBIcon(OBIcons.memories),
      isLoading: _requestInProgress,
      onTap: () {
        setState(() {
          _memoryPostsVisible = !_memoryPostsVisible;
          _saveMemoryPosts();
        });
      },
    );
  }

  void _saveMemoryPosts() async {
    _setRequestInProgress(true);
    try {
      await _userService.updateUser(
        memoryPostsVisible: _memoryPostsVisible,
      );
      if (widget.onChanged != null) widget.onChanged(_memoryPostsVisible);
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
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
