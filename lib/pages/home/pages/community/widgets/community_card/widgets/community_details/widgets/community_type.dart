import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../../../../../provider.dart';

class OBMemoryType extends StatelessWidget {
  final Memory crew;

  const OBMemoryType(this.crew);

  @override
  Widget build(BuildContext context) {
    MemoryType type = crew.type;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    if (type == null) {
      return const SizedBox();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        OBIcon(
          type == MemoryType.private
              ? OBIcons.privateMemory
              : OBIcons.publicMemory,
          customSize: 16,
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: OBText(
            type == MemoryType.private
                ? localizationService.community__type_private
                : localizationService.community__type_public,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
      ],
    );
  }
}
