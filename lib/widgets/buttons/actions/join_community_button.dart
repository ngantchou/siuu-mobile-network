import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/community_button.dart';
import 'package:flutter/material.dart';

class OBJoinMemoryButton extends StatefulWidget {
  final Memory crew;
  final bool crewThemed;

  OBJoinMemoryButton(this.crew, {this.crewThemed = true});

  @override
  OBJoinMemoryButtonState createState() {
    return OBJoinMemoryButtonState();
  }
}

class OBJoinMemoryButtonState extends State<OBJoinMemoryButton> {
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

    return StreamBuilder(
      stream: widget.crew.updateSubject,
      initialData: widget.crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;

        bool isCreator = crew.isCreator ?? true;

        if (isCreator) return SizedBox();

        bool isInvited = crew.isInvited ?? false;

        User loggedInUser = _userService.getLoggedInUser();

        bool isMember = crew.isMember(loggedInUser) ?? false;

        if (crew.type == MemoryType.private && !isMember && !isInvited)
          return SizedBox();

        return widget.crewThemed
            ? OBMemoryButton(
                crew: crew,
                text: isMember
                    ? _localizationService.community__leave_crew
                    : _localizationService.community__join_crew,
                isLoading: _requestInProgress,
                onPressed: isMember ? _leaveMemory : _joinMemory,
              )
            : OBButton(
                child: Text(isMember
                    ? _localizationService.community__leave_crew
                    : _localizationService.community__join_crew),
                isLoading: _requestInProgress,
                onPressed: isMember ? _leaveMemory : _joinMemory,
              );
      },
    );
  }

  void _joinMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.joinMemory(widget.crew);
      widget.crew.incrementMembersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _leaveMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.leaveMemory(widget.crew);
      widget.crew.decrementMembersCount();
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
