import 'package:Siuu/widgets/alerts/button_alert.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:flutter/material.dart';

class OBNoModeratedObjects extends StatelessWidget {
  final VoidCallback onWantsToRefreshModeratedObjects;

  OBNoModeratedObjects({@required this.onWantsToRefreshModeratedObjects});

  @override
  Widget build(BuildContext context) {
    return OBButtonAlert(
      text: 'No moderation items',
      onPressed: onWantsToRefreshModeratedObjects,
      buttonText: 'Refresh',
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/404.PNG',
    );
  }
}
