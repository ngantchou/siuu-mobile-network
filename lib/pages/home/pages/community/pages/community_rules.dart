import 'package:Siuu/models/community.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

import '../../../../../provider.dart';

class OBMemoryRulesPage extends StatelessWidget {
  final Memory memory;

  const OBMemoryRulesPage({Key key, @required this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;

    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: _localizationService.community__rules_title,
      ),
      child: OBPrimaryColorContainer(
        child: StreamBuilder(
          stream: memory.updateSubject,
          initialData: memory,
          builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
            var memory = snapshot.data;

            String memoryRules = memory?.rules;
            String memoryColor = memory?.color;

            if (memoryRules == null ||
                memoryRules.isEmpty ||
                memoryColor == null) return const SizedBox();

            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        OBIcon(
                          OBIcons.rules,
                          size: OBIconSize.medium,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        OBText(
                          _localizationService.community__rules_text,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OBActionableSmartText(text: memory.rules)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
