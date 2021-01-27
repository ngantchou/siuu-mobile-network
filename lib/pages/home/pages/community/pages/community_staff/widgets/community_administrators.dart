import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/user_tile.dart';
import 'package:flutter/material.dart';

class OBMemoryAdministrators extends StatelessWidget {
  final Memory crew;

  OBMemoryAdministrators(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;

        List<User> crewAdministrators = crew?.administrators?.users;

        if (crewAdministrators == null || crewAdministrators.isEmpty)
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
                        OBIcons.crewAdministrators,
                        size: OBIconSize.medium,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      OBText(
                        'Administrators',
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
                    children: crewAdministrators.map((User crewAdministrator) {
                      return OBUserTile(
                        crewAdministrator,
                        onUserTilePressed: (User user) {
                          NavigationService navigationService =
                              OpenbookProvider.of(context).navigationService;
                          navigationService.navigateToUserProfile(
                              user: crewAdministrator, context: context);
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
