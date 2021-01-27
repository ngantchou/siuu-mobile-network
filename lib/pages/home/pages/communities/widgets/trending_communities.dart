import 'package:Siuu/models/category.dart';
import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/alerts/button_alert.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBTrendingCommunities extends StatefulWidget {
  final Category category;
  final ScrollController scrollController;

  const OBTrendingCommunities({Key key, this.category, this.scrollController})
      : super(key: key);

  @override
  OBTrendingCommunitiesState createState() {
    return OBTrendingCommunitiesState();
  }
}

class OBTrendingCommunitiesState extends State<OBTrendingCommunities>
    with AutomaticKeepAliveClientMixin {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  NavigationService _navigationService;
  LocalizationService _localizationService;
  List<Memory> _trendingCommunities;
  bool _refreshInProgress;
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _trendingCommunities = [];
    _refreshInProgress = false;
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _navigationService = openbookProvider.navigationService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return RefreshIndicator(
      onRefresh: _refreshTrendingCommunities,
      key: _refreshIndicatorKey,
      displacement: 80,
      child: ListView(
        // BUG https://github.com/flutter/flutter/issues/22180
        //controller: widget.scrollController,
        padding: EdgeInsets.all(0),
        children: <Widget>[
          _trendingCommunities.isEmpty && !_refreshInProgress
              ? _buildNoTrendingCommunities()
              : _buildTrendingCommunities()
        ],
      ),
    );
  }

  Widget _buildNoTrendingCommunities() {
    return OBButtonAlert(
      text: _localizationService.community__trending_none_found,
      onPressed: _refreshTrendingCommunities,
      buttonText: _localizationService.community__trending_refresh,
      buttonIcon: OBIcons.refresh,
      assetImage: 'assets/images/stickers/perplexed-owl.png',
      isLoading: _refreshInProgress,
    );
  }

  Widget _buildTrendingCommunities() {
    bool hasCategory = widget.category != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: OBText(
            hasCategory
                ? _localizationService
                    .community__trending_in_category(widget.category.title)
                : _localizationService.community__trending_in_all,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            controller: widget.scrollController,
            separatorBuilder: _buildMemorySeparator,
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            shrinkWrap: true,
            itemCount: _trendingCommunities.length,
            itemBuilder: _buildMemory)
      ],
    );
  }

  Widget _buildMemory(BuildContext context, index) {
    Memory crew = _trendingCommunities[index];
    return OBMemoryTile(
      crew,
      key: Key(crew.name),
      onMemoryTilePressed: _onTrendingMemoryPressed,
    );
  }

  Widget _buildMemorySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    Future.delayed(
        Duration(
          milliseconds: 0,
        ), () {
      if (_refreshIndicatorKey.currentState != null) {
        _refreshIndicatorKey.currentState.show();
      }
    });
  }

  Future<void> _refreshTrendingCommunities() async {
    debugPrint('Refreshing trending memories');
    _setRefreshInProgress(true);
    try {
      CommunitiesList trendingCommunitiesList =
          await _userService.getTrendingCommunities(category: widget.category);
      _setTrendingCommunities(trendingCommunitiesList.memories);
    } catch (error) {
      _onError(error);
    } finally {
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

  void _onTrendingMemoryPressed(Memory crew) {
    _navigationService.navigateToMemory(crew: crew, context: context);
  }

  void _setTrendingCommunities(List<Memory> memories) {
    setState(() {
      _trendingCommunities = memories;
    });
  }

  void _setRefreshInProgress(bool refreshInProgress) {
    setState(() {
      _refreshInProgress = refreshInProgress;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
