import 'package:Siuu/libs/str_utils.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMyCommunitiesGroup extends StatefulWidget {
  final OBHttpListRefresher<Memory> crewGroupListRefresher;
  final OBHttpListSearcher<Memory> crewGroupListSearcher;
  final OBHttpListItemBuilder<Memory> crewGroupListItemBuilder;
  final OBHttpListItemBuilder<Memory> crewSearchResultListItemBuilder;
  final OBHttpListOnScrollLoader<Memory> crewGroupListOnScrollLoader;
  final OBMyCommunitiesGroupFallbackBuilder noGroupItemsFallbackBuilder;
  final OBMyCommunitiesGroupController controller;
  final String groupItemName;
  final String groupName;
  final int maxGroupListPreviewItems;
  final String title;

  const OBMyCommunitiesGroup({
    Key key,
    @required this.crewGroupListRefresher,
    @required this.crewGroupListOnScrollLoader,
    @required this.groupItemName,
    @required this.groupName,
    @required this.title,
    @required this.maxGroupListPreviewItems,
    @required this.crewGroupListItemBuilder,
    this.crewGroupListSearcher,
    this.crewSearchResultListItemBuilder,
    this.noGroupItemsFallbackBuilder,
    this.controller,
  }) : super(key: key);

  @override
  OBMyCommunitiesGroupState createState() {
    return OBMyCommunitiesGroupState();
  }
}

class OBMyCommunitiesGroupState extends State<OBMyCommunitiesGroup> {
  bool _needsBootstrap;
  ToastService _toastService;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  List<Memory> _crewGroupList;
  bool _refreshInProgress;
  CancelableOperation _refreshOperation;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) widget.controller.attach(this);
    _needsBootstrap = true;
    _crewGroupList = [];
    _refreshInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    int listItemCount = _crewGroupList.length < widget.maxGroupListPreviewItems
        ? _crewGroupList.length
        : widget.maxGroupListPreviewItems;

    if (listItemCount == 0) {
      if (widget.noGroupItemsFallbackBuilder != null && !_refreshInProgress) {
        return widget.noGroupItemsFallbackBuilder(
            context, _refreshJoinedCommunities);
      }
      return const SizedBox();
    }

    List<Widget> columnItems = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: OBText(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      ListView.separated(
          key: Key(widget.groupName + 'memoriesGroup'),
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: _buildMemorySeparator,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          shrinkWrap: true,
          itemCount: listItemCount,
          itemBuilder: _buildGroupListPreviewItem),
    ];

    if (_crewGroupList.length > widget.maxGroupListPreviewItems) {
      columnItems.add(_buildSeeAllButton());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnItems,
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.controller != null) widget.controller.detach();
    if (_refreshOperation != null) _refreshOperation.cancel();
  }

  Widget _buildSeeAllButton() {
    return GestureDetector(
      onTap: _onWantsToSeeAll,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OBSecondaryText(
              _localizationService.user__groups_see_all(widget.groupName),
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              width: 5,
            ),
            OBIcon(OBIcons.seeMore, themeColor: OBIconThemeColor.secondaryText)
          ],
        ),
      ),
    );
  }

  Widget _buildGroupListPreviewItem(BuildContext context, index) {
    Memory crew = _crewGroupList[index];
    return widget.crewGroupListItemBuilder(context, crew);
  }

  Widget _buildMemorySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _refreshJoinedCommunities();
  }

  Future<void> _refreshJoinedCommunities() async {
    if (_refreshOperation != null) _refreshOperation.cancel();
    _setRefreshInProgress(true);
    try {
      _refreshOperation =
          CancelableOperation.fromFuture(widget.crewGroupListRefresher());

      List<Memory> groupCommunities = await _refreshOperation.value;

      _setMemoryGroupList(groupCommunities);
    } catch (error) {
      _onError(error);
    } finally {
      _refreshOperation = null;
      _setRefreshInProgress(false);
    }
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else {
      _toastService.error(
          message: _localizationService.error__unknown_error, context: context);
      throw error;
    }
  }

  void _onWantsToSeeAll() {
    _navigationService.navigateToBlankPageWithWidget(
        context: context,
        key: Key('obMyCommunitiesGroup' + widget.groupItemName),
        navBarTitle: toCapital(widget.groupName),
        widget: _buildSeeAllGroupItemsPage());
  }

  Widget _buildSeeAllGroupItemsPage() {
    return Column(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: OBHttpList<Memory>(
              separatorBuilder: _buildMemorySeparator,
              listItemBuilder: widget.crewGroupListItemBuilder,
              listRefresher: widget.crewGroupListRefresher,
              listSearcher: widget.crewGroupListSearcher,
              searchResultListItemBuilder:
                  widget.crewSearchResultListItemBuilder,
              listOnScrollLoader: widget.crewGroupListOnScrollLoader,
              resourcePluralName: widget.groupName,
              resourceSingularName: widget.groupItemName),
        )),
      ],
    );
  }

  void _setMemoryGroupList(List<Memory> memories) {
    setState(() {
      _crewGroupList = memories;
    });
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }
}

class OBMyCommunitiesGroupController {
  OBMyCommunitiesGroupState _state;

  void attach(OBMyCommunitiesGroupState state) {
    this._state = state;
  }

  void detach() {
    this._state = null;
  }

  Future<void> refresh() {
    if (_state == null) return Future.value();
    return _state._refreshJoinedCommunities();
  }
}

typedef Future<void> OBMyCommunitiesGroupRetry();

typedef Widget OBMyCommunitiesGroupFallbackBuilder(
    BuildContext context, OBMyCommunitiesGroupRetry retry);
