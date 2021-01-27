import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBMemoryActionMore extends StatelessWidget {
  final Memory crew;

  const OBMemoryActionMore(this.crew);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const OBIcon(
        OBIcons.moreVertical,
        customSize: 30,
      ),
      onPressed: () {
        OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
        openbookProvider.bottomSheetService
            .showMemoryActions(context: context, crew: crew);
      },
    );
  }
}
