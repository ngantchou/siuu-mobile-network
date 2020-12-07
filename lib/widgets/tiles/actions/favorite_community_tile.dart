import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBFavoriteMemoryTile extends StatefulWidget {
  final Memory memory;
  final VoidCallback onFavoritedMemory;
  final VoidCallback onUnfavoritedMemory;
  final Widget favoriteSubtitle;
  final Widget unfavoriteSubtitle;

  const OBFavoriteMemoryTile(
      {Key key,
      @required this.memory,
      this.onFavoritedMemory,
      this.onUnfavoritedMemory,
      this.favoriteSubtitle,
      this.unfavoriteSubtitle})
      : super(key: key);

  @override
  OBFavoriteMemoryTileState createState() {
    return OBFavoriteMemoryTileState();
  }
}

class OBFavoriteMemoryTileState extends State<OBFavoriteMemoryTile> {
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

        bool isFavorite = memory.isFavorite;

        return ListTile(
          enabled: !_requestInProgress,
          leading: OBIcon(
              isFavorite ? OBIcons.unfavoriteMemory : OBIcons.favoriteMemory),
          title: OBText(isFavorite
              ? _localizationService.community__unfavorite_action
              : _localizationService.community__favorite_action),
          onTap: isFavorite ? _unfavoriteMemory : _favoriteMemory,
          subtitle:
              isFavorite ? widget.unfavoriteSubtitle : widget.favoriteSubtitle,
        );
      },
    );
  }

  void _favoriteMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.favoriteMemory(widget.memory);
      if (widget.onFavoritedMemory != null) widget.onFavoritedMemory();
    } catch (e) {
      _onError(e);
    } finally {
      _setRequestInProgress(false);
    }
  }

  void _unfavoriteMemory() async {
    _setRequestInProgress(true);
    try {
      await _userService.unfavoriteMemory(widget.memory);
      if (widget.onUnfavoritedMemory != null) widget.onUnfavoritedMemory();
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
