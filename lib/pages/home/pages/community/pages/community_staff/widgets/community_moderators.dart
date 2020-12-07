import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBMemoryModerators extends StatelessWidget {
  final Memory memory;

  OBMemoryModerators(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;

        List<User> memoryModerators = memory?.moderators?.users;

        if (memoryModerators == null || memoryModerators.isEmpty)
          return const SizedBox();

        return Row(
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(children: [
                      OBIcon(
                        OBIcons.memoryModerators,
                        size: OBIconSize.medium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OBText(
                        'Moderators',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )
                    ]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView(
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    children: memoryModerators.map((User memoryModerator) {
                      return OBUserTile(
                        memoryModerator,
                        onUserTilePressed: (User user) {
                          NavigationService navigationService =
                              OpenbookProvider.of(context).navigationService;
                          navigationService.navigateToUserProfile(
                              user: memoryModerator, context: context);
                        },
                      );
                    }).toList(),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
