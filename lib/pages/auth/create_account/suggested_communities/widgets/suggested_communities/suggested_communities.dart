import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/actions/join_community_button.dart';
import 'package:Siuu/widgets/tiles/community_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSuggestedCommunities extends StatefulWidget {
  final VoidCallback onNoSuggestions;

  const OBSuggestedCommunities({this.onNoSuggestions});

  @override
  OBSuggestedCommunitiesState createState() {
    return OBSuggestedCommunitiesState();
  }
}

class OBSuggestedCommunitiesState extends State<OBSuggestedCommunities>
    with AutomaticKeepAliveClientMixin {
  bool _needsBootstrap;
  UserService _userService;
  ToastService _toastService;
  LocalizationService _localizationService;
  List<Memory> _suggestedCommunities;
  bool _requestInProgress;

  @override
  void initState() {
    super.initState();
    _needsBootstrap = true;
    _suggestedCommunities = [];
    _requestInProgress = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _userService = openbookProvider.userService;
      _toastService = openbookProvider.toastService;
      _localizationService = openbookProvider.localizationService;
      _bootstrap();
      _needsBootstrap = false;
    }

    return _suggestedCommunities.isEmpty
        ? _requestInProgress
            ? _buildProgressIndicator()
            : const SizedBox()
        : _buildSuggestedCommunities();
  }

  Widget _buildProgressIndicator() {
    return Container(
      child: Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildSuggestedCommunities() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: _buildMemorySeparator,
            padding: const EdgeInsets.only(bottom: 20),
            shrinkWrap: true,
            itemCount: _suggestedCommunities.length,
            itemBuilder: _buildMemory)
      ],
    );
  }

  Widget _buildMemory(BuildContext context, index) {
    Memory memory = _suggestedCommunities[index];

    //bool memoryIsJoined = _selectedCommunities?.contains(memory);

    return OBMemoryTile(
      memory,
      size: OBMemoryTileSize.normal,
      trailing: OBJoinMemoryButton(
        memory,
        memoryThemed: false,
      ),
    );
  }

  Widget _buildMemorySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  void _bootstrap() {
    _fetchSuggestedCommunities();
  }

  Future<void> _fetchSuggestedCommunities() async {
    debugPrint('Fetching suggested memories');
    _setRequestInProgress(true);
    try {
      CommunitiesList suggestedCommunitiesList =
          await _userService.getSuggestedCommunities();
      _setSuggestedCommunities(suggestedCommunitiesList.memories);
      if (widget.onNoSuggestions != null &&
          suggestedCommunitiesList.memories.isEmpty) widget.onNoSuggestions();
    } catch (error) {
      _onError(error);
    } finally {
      _setRequestInProgress(false);
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

  void _setSuggestedCommunities(List<Memory> memories) {
    setState(() {
      _suggestedCommunities = memories;
    });
  }

  void _setRequestInProgress(bool refreshInProgress) {
    setState(() {
      _requestInProgress = refreshInProgress;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
