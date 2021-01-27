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
  final Memory crew;
  final OnMemoryReported onMemoryReported;

  const OBMemoryActionsBottomSheet(
      {Key key, @required this.crew, this.onMemoryReported})
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

    List<Widget> crewActions = [
      OBFavoriteMemoryTile(
        crew: widget.crew,
        onFavoritedMemory: _dismiss,
        onUnfavoritedMemory: _dismiss,
      )
    ];

    User loggedInUser = _userService.getLoggedInUser();
    Memory crew = widget.crew;

    bool isMemberOfMemory = crew.isMember(loggedInUser);
    bool isMemoryAdministrator = crew.isAdministrator(loggedInUser);
    bool isMemoryModerator = crew.isModerator(loggedInUser);
    bool crewHasInvitesEnabled = crew.invitesEnabled;

    if (isMemberOfMemory) {
      crewActions.add(OBNewPostNotificationsForMemoryTile(
        crew: crew,
        onSubscribed: _dismiss,
        onUnsubscribed: _dismiss,
      ));
    }

    if (crewHasInvitesEnabled && isMemberOfMemory) {
      crewActions.add(ListTile(
        leading: const OBIcon(OBIcons.crewInvites),
        title: OBText(
          _localizationService.community__actions_invite_people_title,
        ),
        onTap: _onWantsToInvitePeople,
      ));
    }

    if (!isMemoryAdministrator && !isMemoryModerator) {
      crewActions.add(OBReportMemoryTile(
        crew: crew,
        onWantsToReportMemory: () {
          Navigator.of(context).pop();
        },
      ));
    }

    return OBRoundedBottomSheet(
      child: Column(
        children: crewActions,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  Future _onWantsToInvitePeople() async {
    _dismiss();
    _modalService.openInviteToMemory(context: context, crew: widget.crew);
  }

  void _dismiss() {
    Navigator.pop(context);
  }
}

typedef OnMemoryReported(Memory crew);
