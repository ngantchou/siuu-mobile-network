import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/bottom_sheets/rounded_bottom_sheet.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/modal_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/actions/favorite_community_tile.dart';
import 'package:Siuu/widgets/tiles/actions/report_community_tile.dart';
import 'package:Siuu/widgets/tiles/actions/new_post_notifications_for_community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryActionsBottomSheet extends StatefulWidget {
  final Memory memory;
  final OnMemoryReported onMemoryReported;

  const OBMemoryActionsBottomSheet(
      {Key key, @required this.memory, this.onMemoryReported})
      : super(key: key);

  @override
  OBMemoryActionsBottomSheetState createState() {
    return OBMemoryActionsBottomSheetState();
  }
}

class OBMemoryActionsBottomSheetState
    extends State<OBMemoryActionsBottomSheet> {
  UserService _userService;
  ToastService _toastService;
  ModalService _modalService;
  LocalizationService _localizationService;

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _toastService = openbookProvider.toastService;
    _modalService = openbookProvider.modalService;
    _localizationService = openbookProvider.localizationService;

    List<Widget> memoryActions = [
      OBFavoriteMemoryTile(
        memory: widget.memory,
        onFavoritedMemory: _dismiss,
        onUnfavoritedMemory: _dismiss,
      )
    ];

    User loggedInUser = _userService.getLoggedInUser();
    Memory memory = widget.memory;

    bool isMemberOfMemory = memory.isMember(loggedInUser);
    bool isMemoryAdministrator = memory.isAdministrator(loggedInUser);
    bool isMemoryModerator = memory.isModerator(loggedInUser);
    bool memoryHasInvitesEnabled = memory.invitesEnabled;

    if (isMemberOfMemory) {
      memoryActions.add(OBNewPostNotificationsForMemoryTile(
        memory: memory,
        onSubscribed: _dismiss,
        onUnsubscribed: _dismiss,
      ));
    }

    if (memoryHasInvitesEnabled && isMemberOfMemory) {
      memoryActions.add(ListTile(
        leading: const OBIcon(OBIcons.memoryInvites),
        title: OBText(
          _localizationService.community__actions_invite_people_title,
        ),
        onTap: _onWantsToInvitePeople,
      ));
    }

    if (!isMemoryAdministrator && !isMemoryModerator) {
      memoryActions.add(OBReportMemoryTile(
        memory: memory,
        onWantsToReportMemory: () {
          Navigator.of(context).pop();
        },
      ));
    }

    return OBRoundedBottomSheet(
      child: Column(
        children: memoryActions,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Future _onWantsToInvitePeople() async {
    _dismiss();
    _modalService.openInviteToMemory(context: context, memory: widget.memory);
  }

  void _dismiss() {
    Navigator.pop(context);
  }
}

typedef OnMemoryReported(Memory memory);
