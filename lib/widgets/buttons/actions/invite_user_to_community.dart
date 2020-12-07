import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class OBInviteUserToMemoryButton extends StatefulWidget {
  final User user;
  final Memory memory;

  OBInviteUserToMemoryButton({@required this.user, @required this.memory});

  @override
  OBInviteUserToMemoryButtonState createState() {
    return OBInviteUserToMemoryButtonState();
  }
}

class OBInviteUserToMemoryButtonState
    extends State<OBInviteUserToMemoryButton> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _localizationService = openbookProvider.localizationService;

    User loggedInUser = _userService.getLoggedInUser();

    return StreamBuilder(
      stream: loggedInUser.updateSubject,
      initialData: loggedInUser,
      builder:
          (BuildContext context, AsyncSnapshot<User> loggedInUserSnapshot) {
        User latestLoggedInUser = loggedInUserSnapshot.data;

        return StreamBuilder(
          stream: widget.user.updateSubject,
          initialData: widget.user,
          builder:
              (BuildContext context, AsyncSnapshot<User> latestUserSnapshot) {
            User latestUser = latestUserSnapshot.data;
            if (latestUser == null) return const SizedBox();

            bool isMemoryMember = latestUser.isMemberOfMemory(widget.memory);
            bool isInvitedToMemory =
                latestUser.isInvitedToMemory(widget.memory);

            if (isMemoryMember) {
              return _buildAlreadyMemberButton();
            }

            return isInvitedToMemory
                ? _buildUninviteUserToMemoryButton()
                : _buildInviteUserToMemoryButton();
          },
        );
      },
    );
  }

  Widget _buildInviteUserToMemoryButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.primary,
      isLoading: _requestInProgress,
      onPressed: _inviteUser,
      child: Text(_localizationService.trans('user__invite')),
    );
  }

  Widget _buildUninviteUserToMemoryButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.highlight,
      isLoading: _requestInProgress,
      onPressed: _uninviteUser,
      child: Text(_localizationService.trans('user__uninvite')),
    );
  }

  Widget _buildAlreadyMemberButton() {
    return OBButton(
      size: OBButtonSize.small,
      type: OBButtonType.highlight,
      isDisabled: true,
      isLoading: _requestInProgress,
      onPressed: () {},
      child: Text(_localizationService.trans('user__invite_member')),
    );
  }

  void _inviteUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.inviteUserToMemory(
          user: widget.user, memory: widget.memory);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _uninviteUser() async {
    _setRequestInProgress(true);
    try {
      await _userService.uninviteUserFromMemory(
          user: widget.user, memory: widget.memory);
    } catch (e) {
      _onError(e);
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
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
  }
}
