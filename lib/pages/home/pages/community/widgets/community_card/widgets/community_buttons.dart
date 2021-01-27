import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBMemoryButtons extends StatelessWidget {
  final Memory crew;

  const OBMemoryButtons({Key key, this.crew}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> crewButtons = [];
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    LocalizationService localizationService =
        openbookProvider.localizationService;
    crewButtons.add(
      OBButton(
        child: Row(
          children: <Widget>[
            const OBIcon(
              OBIcons.crewStaff,
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
              .navigateToMemoryStaffPage(context: context, crew: crew);
        },
        type: OBButtonType.highlight,
      ),
    );

    if (crew.rules != null && crew.rules.isNotEmpty) {
      crewButtons.add(
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
                .navigateToMemoryRulesPage(context: context, crew: crew);
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
          itemCount: crewButtons.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, index) {
            return crewButtons[index];
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
