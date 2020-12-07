import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBNewPostNotificationsForMemoryTile extends StatefulWidget {
  final Memory memory;
  final VoidCallback onSubscribed;
  final VoidCallback onUnsubscribed;
  final Widget title;
  final Widget subtitle;

  const OBNewPostNotificationsForMemoryTile(
      {Key key,
      @required this.memory,
      this.onSubscribed,
      this.onUnsubscribed,
      this.title,
      this.subtitle})
      : super(key: key);

  @override
  OBNewPostNotificationsForMemoryTileState createState() {
    return OBNewPostNotificationsForMemoryTileState();
  }
}

class OBNewPostNotificationsForMemoryTileState
    extends State<OBNewPostNotificationsForMemoryTile> {
  bool _requestInProgress;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _localizationService = openbookProvider.localizationService;
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;

    return StreamBuilder(
      stream: widget.memory.updateSubject,
      initialData: widget.memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;

        bool areNotificationsEnabled =
            memory.areNewPostNotificationsEnabled ?? false;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(areNotificationsEnabled
              ? OBIcons.notifications_off
              : OBIcons.notifications),
          title: OBText(areNotificationsEnabled
              ? _localizationService
                  .community__actions_disable_new_post_notifications_title
              : _localizationService
                  .community__actions_enable_new_post_notifications_title),
          subtitle: areNotificationsEnabled ? widget.subtitle : widget.title,
          onTap:
              areNotificationsEnabled ? _unsubscribeMemory : _subscribeMemory,
        );
      },
    );
  }

  void _subscribeMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.enableNewPostNotificationsForMemory(widget.memory);
      _toastService.success(
          message: _localizationService
              .community__actions_enable_new_post_notifications_success,
          context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
      if (widget.onSubscribed != null) widget.onSubscribed();
    }
  }

  void _unsubscribeMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.disableNewPostNotificationsForMemory(widget.memory);
      _toastService.success(
          message: _localizationService
              .community__actions_disable_new_post_notifications_success,
          context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
      if (widget.onUnsubscribed != null) widget.onUnsubscribed();
    }
  }

  void _setRequestInProgress(bool requestInProgress) {
    setState(() {
      _requestInProgress = requestInProgress;
    });
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
}
