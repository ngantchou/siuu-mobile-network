import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/posts_count.dart';
import 'package:Siuu/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class OBMemoryPostsCount extends StatefulWidget {
  final Memory memory;

  OBMemoryPostsCount(this.memory);

  @override
  OBMemoryPostsCountState createState() {
    return OBMemoryPostsCountState();
  }
}

class OBMemoryPostsCountState extends State<OBMemoryPostsCount> {
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  bool _requestInProgress;
  bool _hasError;
  bool _needsBootstrap;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
    _hasError = false;
    _needsBootstrap = true;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    if (_needsBootstrap) {
      _localizationService = openbookProvider.localizationService;
      _toastService = openbookProvider.toastService;
      _refreshMemoryPostsCount();
      _needsBootstrap = false;
    }

    return StreamBuilder(
      stream: widget.memory.updateSubject,
      initialData: widget.memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;

        return _hasError
            ? _buildErrorIcon()
            : _requestInProgress
                ? _buildLoadingIcon()
                : _buildPostsCount(memory);
      },
    );
  }

  Widget _buildPostsCount(Memory memory) {
    return OBPostsCount(
      memory.postsCount,
      showZero: true,
      fontSize: 16,
    );
  }

  Widget _buildErrorIcon() {
    return const SizedBox();
  }

  Widget _buildLoadingIcon() {
    return OBProgressIndicator(
      size: 15.0,
    );
  }

  void _refreshMemoryPostsCount() async {
    _setRequestInProgress(true);
    try {
      await _userService.countPostsForMemory(widget.memory);
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
