import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/loading_tile.dart';
import 'package:flutter/material.dart';

class OBReportMemoryTile extends StatefulWidget {
  final Memory memory;
  final ValueChanged<dynamic> onMemoryReported;
  final VoidCallback onWantsToReportMemory;

  const OBReportMemoryTile({
    Key key,
    this.onMemoryReported,
    @required this.memory,
    this.onWantsToReportMemory,
  }) : super(key: key);

  @override
  OBReportMemoryTileState createState() {
    return OBReportMemoryTileState();
  }
}

class OBReportMemoryTileState extends State<OBReportMemoryTile> {
  NavigationService _navigationService;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _navigationService = openbookProvider.navigationService;
    LocalizationService _localizationService =
        openbookProvider.localizationService;

    return StreamBuilder(
      stream: widget.memory.updateSubject,
      initialData: widget.memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;

        bool isReported = memory.isReported ?? false;

        return OBLoadingTile(
          isLoading: _requestInProgress || isReported,
          leading: OBIcon(OBIcons.report),
          title: OBText(isReported
              ? _localizationService
                  .moderation__you_have_reported_community_text
              : _localizationService.moderation__report_community_text),
          onTap: isReported ? () {} : _reportMemory,
        );
      },
    );
  }

  void _reportMemory() {
    if (widget.onWantsToReportMemory != null) widget.onWantsToReportMemory();
    _navigationService.navigateToReportObject(
        context: context,
        object: widget.memory,
        onObjectReported: widget.onMemoryReported);
  }
}
