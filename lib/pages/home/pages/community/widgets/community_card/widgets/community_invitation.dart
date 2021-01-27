import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/alerts/alert.dart';
import 'package:Siuu/widgets/buttons/actions/join_community_button.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryInvitation extends StatelessWidget {
  final Memory crew;

  OBMemoryInvitation(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory crew = snapshot.data;
        bool isInvited = crew?.isInvited;

        if (isInvited == null) return const SizedBox();

        return Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            OBAlert(
              child: Column(
                children: <Widget>[
                  OBText(
                    'You have been invited to join the crew.',
                    maxLines: 4,
                    size: OBTextSize.medium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      OBJoinMemoryButton(crew),
                    ],
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
