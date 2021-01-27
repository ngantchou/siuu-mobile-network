import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../provider.dart';

class OBMemoryFavorite extends StatelessWidget {
  final Memory crew;

  const OBMemoryFavorite(this.crew);

  @override
  Widget build(BuildContext context) {
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory crew = snapshot.data;
        if (crew.isFavorite == null || !crew.isFavorite)
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
