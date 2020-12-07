import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../provider.dart';

class OBMemoryFavorite extends StatelessWidget {
  final Memory memory;

  const OBMemoryFavorite(this.memory);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory memory = snapshot.data;
        if (memory.isFavorite == null || !memory.isFavorite)
          return const SizedBox();

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            OBIcon(
              OBIcons.favoriteMemory,
              themeColor: OBIconThemeColor.primaryAccent,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            OBText(
              localizationService.community__details_favorite,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        );
      },
    );
  }
}
