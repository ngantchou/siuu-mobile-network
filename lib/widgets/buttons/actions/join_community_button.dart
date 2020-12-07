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
  final Memory memory;
  final bool memoryThemed;

  OBJoinMemoryButton(this.memory, {this.memoryThemed = true});

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
      stream: widget.memory.updateSubject,
      initialData: widget.memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;

        bool isCreator = memory.isCreator ?? true;

        if (isCreator) return SizedBox();

        bool isInvited = memory.isInvited ?? false;

        User loggedInUser = _userService.getLoggedInUser();

        bool isMember = memory.isMember(loggedInUser) ?? false;

        if (memory.type == MemoryType.private && !isMember && !isInvited)
          return SizedBox();

        return widget.memoryThemed
            ? OBMemoryButton(
                memory: memory,
                text: isMember
                    ? _localizationService.community__leave_memory
                    : _localizationService.community__join_memory,
                isLoading: _requestInProgress,
                onPressed: isMember ? _leaveMemory : _joinMemory,
              )
            : OBButton(
                child: Text(isMember
                    ? _localizationService.community__leave_memory
                    : _localizationService.community__join_memory),
                isLoading: _requestInProgress,
                onPressed: isMember ? _leaveMemory : _joinMemory,
              );
      },
    );
  }

  void _joinMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.joinMemory(widget.memory);
      widget.memory.incrementMembersCount();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _leaveMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.leaveMemory(widget.memory);
      widget.memory.decrementMembersCount();
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
