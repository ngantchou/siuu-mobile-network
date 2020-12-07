import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBMemoryButtons extends StatelessWidget {
  final Memory memory;

  const OBMemoryButtons({Key key, this.memory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> memoryButtons = [];
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    LocalizationService localizationService =
        openbookProvider.localizationService;
    memoryButtons.add(
      OBButton(
        child: Row(
          children: <Widget>[
            const OBIcon(
              OBIcons.memoryStaff,
              size: OBIconSize.small,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(localizationService.trans('community__button_staff'))
          ],
        ),
        onPressed: () async {
          openbookProvider.navigationService
              .navigateToMemoryStaffPage(context: context, memory: memory);
        },
        type: OBButtonType.highlight,
      ),
    );

    if (memory.rules != null && memory.rules.isNotEmpty) {
      memoryButtons.add(
        OBButton(
          child: Row(
            children: <Widget>[
              const OBIcon(
                OBIcons.rules,
                size: OBIconSize.small,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(localizationService.trans('community__button_rules'))
            ],
          ),
          onPressed: () async {
            openbookProvider.navigationService
                .navigateToMemoryRulesPage(context: context, memory: memory);
          },
          type: OBButtonType.highlight,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        height: 35,
        child: ListView.separated(
          physics: const ClampingScrollPhysics(),
          itemCount: memoryButtons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return memoryButtons[index];
          },
          separatorBuilder: (BuildContext context, index) {
            return const SizedBox(
              width: 10,
            );
          },
        ),
      ),
    );
  }
}
