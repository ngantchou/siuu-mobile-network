import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/moderation/moderated_object.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBModeratedObjectActions extends StatelessWidget {
  final Memory crew;
  final ModeratedObject moderatedObject;

  OBModeratedObjectActions(
      {@required this.crew, @required this.moderatedObject});

  @override
  Widget build(BuildContext context) {
    LocalizationService _localizationService =
        OpenbookProvider.of(context).localizationService;
    List<Widget> moderatedObjectActions = [
      Expanded(
          child: OBButton(
              type: OBButtonType.highlight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const OBIcon(
                    OBIcons.reviewModeratedObject,
                    customSize: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  OBText(
                      _localizationService.trans('moderation__actions_review')),
                ],
              ),
              onPressed: () {
                OpenbookProviderState openbookProvider =
                    OpenbookProvider.of(context);
                if (crew != null) {
                  openbookProvider.navigationService
                      .navigateToModeratedObjectMemoryReview(
                          moderatedObject: moderatedObject,
                          crew: crew,
                          context: context);
                } else {
                  openbookProvider.navigationService
                      .navigateToModeratedObjectGlobalReview(
                          moderatedObject: moderatedObject, context: context);
                }
              })),
    ];

    return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: moderatedObjectActions,
            )
          ],
        ));
  }
}
