import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBBlockUserTile extends StatelessWidget {
  final User user;
  final VoidCallback onBlockedUser;
  final VoidCallback onUnblockedUser;

  const OBBlockUserTile({
    Key key,
    @required this.user,
    this.onBlockedUser,
    this.onUnblockedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var userService = openbookProvider.userService;
    var toastService = openbookProvider.toastService;
    var localizationService = openbookProvider.localizationService;
    var bottomSheetService = openbookProvider.bottomSheetService;

    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        bool isBlocked = user.isBlocked ?? false;

        return ListTile(
          leading: OBIcon(isBlocked ? OBIcons.block : OBIcons.block),
          title: OBText(isBlocked
              ? localizationService.user__unblock_user
              : localizationService.user__block_user),
          onTap: isBlocked
              ? () {
                  bottomSheetService.showConfirmAction(
                      context: context,
                      subtitle: localizationService.user__unblock_description,
                      actionCompleter: (BuildContext context) async {
                        await userService.unblockUser(user);
                        toastService.success(
                            message: localizationService.user__profile_action_user_unblocked,
                            context: context);
                        if (onUnblockedUser != null) onUnblockedUser();
                      });
                }
              : () {
                  bottomSheetService.showConfirmAction(
                      context: context,
                      subtitle: localizationService.user__block_description,
                      actionCompleter: (BuildContext context) async {
                        await userService.blockUser(user);
                        toastService.success(
                            message: localizationService.user__profile_action_user_blocked,
                            context: context);
                        if (onBlockedUser != null) onBlockedUser();
                      });
                },
        );
      },
    );
  }
}
