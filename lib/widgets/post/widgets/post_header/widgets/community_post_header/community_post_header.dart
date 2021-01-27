import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/pages/home/bottom_sheets/post_actions.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/bottom_sheet.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/utils_service.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/community_avatar.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/post/post.dart';
import 'package:Siuu/widgets/post/widgets/post_header/widgets/community_post_header/widgets/community_post_creator_identifier.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryPostHeader extends StatelessWidget {
  final Post _post;
  final OnPostDeleted onPostDeleted;
  final ValueChanged<Post> onPostReported;
  final bool hasActions;
  final OBPostDisplayContext displayContext;

  // What are we using these 2 for?
  final Function onMemoryExcluded;
  final Function onUndoMemoryExcluded;

  final ValueChanged<Memory> onPostMemoryExcludedFromProfilePosts;

  const OBMemoryPostHeader(this._post,
      {Key key,
      @required this.onPostDeleted,
      this.onPostReported,
      this.hasActions = true,
      this.onMemoryExcluded,
      this.onUndoMemoryExcluded,
      this.displayContext = OBPostDisplayContext.timelinePosts,
      this.onPostMemoryExcludedFromProfilePosts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openbookProvider = OpenbookProvider.of(context);
    var navigationService = openbookProvider.navigationService;
    var bottomSheetService = openbookProvider.bottomSheetService;
    var localizationService = openbookProvider.localizationService;
    var utilsService = openbookProvider.utilsService;

    return StreamBuilder(
        stream: _post.crew.updateSubject,
        initialData: _post.crew,
        builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
          Memory crew = snapshot.data;

          return displayContext == OBPostDisplayContext.ownProfilePosts ||
                  displayContext == OBPostDisplayContext.foreignProfilePosts
              ? _buildMemoryHighlightHeader(
                  context: context,
                  crew: crew,
                  navigationService: navigationService,
                  bottomSheetService: bottomSheetService,
                  utilsService: utilsService,
                  localizationService: localizationService)
              : _buildUserHighlightHeader(
                  context: context,
                  crew: crew,
                  navigationService: navigationService,
                  bottomSheetService: bottomSheetService);
        });
  }

  Widget _buildMemoryHighlightHeader(
      {BuildContext context,
      Memory crew,
      NavigationService navigationService,
      BottomSheetService bottomSheetService,
      UtilsService utilsService,
      LocalizationService localizationService}) {
    String created = utilsService.timeAgo(_post.created, localizationService);

    return ListTile(
        leading: OBMemoryAvatar(
          crew: crew,
          size: OBAvatarSize.medium,
          onPressed: () {
            navigationService.navigateToMemory(crew: crew, context: context);
          },
        ),
        trailing: hasActions
            ? IconButton(
                icon: const OBIcon(OBIcons.moreVertical),
                onPressed: () {
                  bottomSheetService.showPostActions(
                      context: context,
                      post: _post,
                      displayContext: displayContext,
                      onMemoryExcluded: onMemoryExcluded,
                      onUndoMemoryExcluded: onUndoMemoryExcluded,
                      onPostMemoryExcludedFromProfilePosts:
                          onPostMemoryExcludedFromProfilePosts,
                      onPostDeleted: onPostDeleted,
                      onPostReported: onPostReported);
                })
            : null,
        title: GestureDetector(
          onTap: () {
            navigationService.navigateToMemory(crew: crew, context: context);
          },
          child: OBText(
            crew.title,
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () {
            navigationService.navigateToMemory(crew: crew, context: context);
          },
          child: Row(
            children: <Widget>[
              Expanded(
                child: OBSecondaryText(
                  'c/' + crew.name + ' · $created',
                  style: TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildUserHighlightHeader(
      {BuildContext context,
      Memory crew,
      NavigationService navigationService,
      BottomSheetService bottomSheetService}) {
    return ListTile(
      leading: OBAvatar(
        avatarUrl: _post.creator.getProfileAvatar(),
        size: OBAvatarSize.medium,
        onPressed: () {
          navigationService.navigateToUserProfile(
              user: _post.creator, context: context);
        },
      ),
      trailing: hasActions
          ? IconButton(
              icon: const OBIcon(OBIcons.moreVertical),
              onPressed: () {
                bottomSheetService.showPostActions(
                    context: context,
                    post: _post,
                    displayContext: displayContext,
                    onMemoryExcluded: onMemoryExcluded,
                    onUndoMemoryExcluded: onUndoMemoryExcluded,
                    onPostMemoryExcludedFromProfilePosts:
                        onPostMemoryExcludedFromProfilePosts,
                    onPostDeleted: onPostDeleted,
                    onPostReported: onPostReported);
              })
          : null,
      title: GestureDetector(
        onTap: () {
          navigationService.navigateToMemory(crew: crew, context: context);
        },
        child: Row(
          children: <Widget>[
            OBMemoryAvatar(
              borderRadius: 4,
              customSize: 16,
              crew: crew,
              onPressed: () {
                navigationService.navigateToMemory(
                    crew: crew, context: context);
              },
              size: OBAvatarSize.extraSmall,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: OBText(
                'c/' + crew.name,
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      subtitle: OBMemoryPostCreatorIdentifier(
        post: _post,
        onUsernamePressed: () {
          navigationService.navigateToUserProfile(
              user: _post.creator, context: context);
        },
      ),
    );
  }
}
