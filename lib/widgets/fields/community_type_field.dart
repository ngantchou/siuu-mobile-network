import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/divider.dart';
import 'package:Siuu/widgets/theming/primary_accent_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryTypeField extends StatelessWidget {
  final MemoryType value;
  final ValueChanged<MemoryType> onChanged;
  final String title;
  final String hintText;

  const OBMemoryTypeField(
      {@required this.value,
      this.onChanged,
      @required this.title,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    BottomSheetService bottomSheetService =
        OpenbookProvider.of(context).bottomSheetService;
    LocalizationService localizationService =
        OpenbookProvider.of(context).localizationService;

    Widget typeIcon;
    String typeName;

    switch (value) {
      case MemoryType.public:
        typeIcon = OBIcon(
          OBIcons.publicMemory,
          themeColor: OBIconThemeColor.primaryAccent,
        );
        typeName = localizationService.community__type_public;
        break;
      case MemoryType.private:
        typeIcon = OBIcon(OBIcons.privateMemory,
            themeColor: OBIconThemeColor.primaryAccent);
        typeName = localizationService.community__type_private;
        break;
    }

    return MergeSemantics(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBText(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),
              subtitle: hintText != null ? OBText(hintText) : null,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  OBPrimaryAccentText(
                    typeName,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  typeIcon,
                ],
              ),
              onTap: () {
                bottomSheetService.showMemoryTypePicker(
                    initialType: value, context: context, onChanged: onChanged);
              }),
          value == MemoryType.private
              ? Padding(
                  padding: EdgeInsetsDirectional.only(start: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      OBText(localizationService
                          .community__community_type_private_community_hint_text)
                    ],
                  ),
                )
              : const SizedBox(),
          OBDivider()
        ],
      ),
    );
  }
}
