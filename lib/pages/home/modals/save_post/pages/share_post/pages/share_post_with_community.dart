import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/communities_list.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/http_list.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/tiles/community_selectable_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBSharePostWithMemoryPage extends StatefulWidget {
  final OBNewPostData createPostData;

  const OBSharePostWithMemoryPage({Key key, @required this.createPostData})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSharePostWithMemoryPageState();
  }
}

class OBSharePostWithMemoryPageState extends State<OBSharePostWithMemoryPage> {
  UserService _userService;
  LocalizationService _localizationService;

  Memory _chosenMemory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    _userService = openbookProvider.userService;
    _localizationService = openbookProvider.localizationService;

    return OBCupertinoPageScaffold(
        navigationBar: _buildNavigationBar(),
        child: OBPrimaryColorContainer(
          child: _buildAvailableAudience(),
        ));
  }

  Widget _buildAvailableAudience() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
            child: OBHttpList<Memory>(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          separatorBuilder: _buildMemorySeparator,
          listItemBuilder: _buildMemoryItem,
          searchResultListItemBuilder: _buildMemoryItem,
          listRefresher: _refreshCommunities,
          listOnScrollLoader: _loadMoreCommunities,
          listSearcher: _searchCommunities,
          resourceSingularName: _localizationService.trans('community__memory'),
          resourcePluralName: _localizationService.trans('community__memories'),
        ))
      ],
    );
  }

  Widget _buildNavigationBar() {
    return OBThemedNavigationBar(
      title: _localizationService.trans('post__share_to_memory'),
      trailing: OBButton(
        size: OBButtonSize.small,
        type: OBButtonType.primary,
        isDisabled: _chosenMemory == null,
        onPressed: createPost,
        child: Text(_localizationService.trans('post__share_memory')),
      ),
    );
  }

  Widget _buildMemoryItem(BuildContext context, Memory memory) {
    return OBMemorySelectableTile(
      memory: memory,
      onMemoryPressed: _onMemoryPressed,
      isSelected: memory == _chosenMemory,
    );
  }

  Widget _buildMemorySeparator(BuildContext context, int index) {
    return const SizedBox(
      height: 10,
    );
  }

  Future<void> createPost() async {
    widget.createPostData.setMemory(_chosenMemory);

    Navigator.pop(context, widget.createPostData);
  }

  Future<List<Memory>> _refreshCommunities() async {
    CommunitiesList memories = await _userService.getJoinedCommunities();
    return memories.memories;
  }

  Future<List<Memory>> _loadMoreCommunities(List<Memory> memoriesList) async {
    int offset = memoriesList.length;

    List<Memory> moreCommunities = (await _userService.getJoinedCommunities(
      offset: offset,
    ))
        .memories;
    return moreCommunities;
  }

  Future<List<Memory>> _searchCommunities(String query) async {
    CommunitiesList results =
        await _userService.searchJoinedCommunities(query: query);

    return results.memories;
  }

  void _onMemoryPressed(Memory pressedMemory) {
    if (pressedMemory == _chosenMemory) {
      _clearChosenMemory();
    } else {
      _setChosenMemory(pressedMemory);
    }
  }

  void _clearChosenMemory() {
    _setChosenMemory(null);
  }

  void _setChosenMemory(Memory chosenMemory) {
    setState(() {
      _chosenMemory = chosenMemory;
    });
  }
}
