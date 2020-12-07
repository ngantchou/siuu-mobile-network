import 'package:Siuu/models/community.dart';
import 'package:Siuu/pages/home/pages/community/pages/community_staff/widgets/community_administrators.dart';
import 'package:Siuu/pages/home/pages/community/pages/community_staff/widgets/community_moderators.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/material.dart';

import '../../../../../../provider.dart';

class OBMemoryStaffPage extends StatelessWidget {
  final Memory memory;

  const OBMemoryStaffPage({Key key, @required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: localizationService.community__community_staff,
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: memory.updateSubject,
          initialData: memory,
          builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OBMemoryAdministrators(memory),
                  OBMemoryModerators(memory),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
