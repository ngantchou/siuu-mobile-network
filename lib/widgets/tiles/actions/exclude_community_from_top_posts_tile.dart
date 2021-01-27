import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class OBExcludeMemoryFromTopPostsTile extends StatefulWidget {
  final Post post;
  final VoidCallback onExcludedPostMemory;
  final VoidCallback onUndoExcludedPostMemory;

  const OBExcludeMemoryFromTopPostsTile({
    Key key,
    @required this.post,
    this.onExcludedPostMemory,
    this.onUndoExcludedPostMemory,
  }) : super(key: key);

  @override
  OBExcludeMemoryFromTopPostsTileState createState() {
    return OBExcludeMemoryFromTopPostsTileState();
  }
}

class OBExcludeMemoryFromTopPostsTileState
    extends State<OBExcludeMemoryFromTopPostsTile> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  CancelableOperation _excludeMemoryOperation;
  CancelableOperation _undoExcludeMemoryOperation;

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
      stream: widget.post.updateSubject,
      initialData: widget.post,
      builder: (BuildContext context, AsyncSnapshot<Post> snapshot) {
        var post = snapshot.data;

        bool isExcluded = post.isExcludedFromTopPosts;

        return OBLoadingTile(
          isLoading: _requestInProgress,
          leading: OBIcon(isExcluded
              ? OBIcons.undoExcludePostMemory
              : OBIcons.excludePostMemory),
          title: OBText(isExcluded
              ? _localizationService.post__undo_exclude_post_crew
              : _localizationService.post__exclude_post_crew),
          onTap: isExcluded ? _undoExcludePostMemory : _excludePostMemory,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_excludeMemoryOperation != null) _excludeMemoryOperation.cancel();
    if (_undoExcludeMemoryOperation != null)
      _undoExcludeMemoryOperation.cancel();
  }

  void _excludePostMemory() async {
    if (_excludeMemoryOperation != null) return;
    _setRequestInProgress(true);
    try {
      _excludeMemoryOperation = CancelableOperation.fromFuture(
          _userService.excludeMemoryFromTopPosts(widget.post.crew));
      String message = await _excludeMemoryOperation.value;
      if (widget.onExcludedPostMemory != null) widget.onExcludedPostMemory();
      widget.post.updateIsExcludedFromTopPosts(true);
      _toastService.success(message: message, context: context);
    } catch (e) {
      _onError(e);
    } finally {
      _excludeMemoryOperation = null;
      _setRequestInProgress(false);
    }
  }

  void _undoExcludePostMemory() async {
    if (_undoExcludeMemoryOperation != null) return;
    _setRequestInProgress(true);
    try {
      _undoExcludeMemoryOperation = CancelableOperation.fromFuture(
          _userService.undoExcludeMemoryFromTopPosts(widget.post.crew));
      await _undoExcludeMemoryOperation.value;
      if (widget.onUndoExcludedPostMemory != null)
        widget.onUndoExcludedPostMemory();
      _toastService.success(
          message: _localizationService
              .post__exclude_community_from_profile_posts_success,
          context: context);
      widget.post.updateIsExcludedFromTopPosts(false);
    } catch (e) {
      _onError(e);
    } finally {
      _undoExcludeMemoryOperation = null;
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
