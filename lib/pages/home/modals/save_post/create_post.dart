import 'dart:io';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/memory.dart';
import 'package:Siuu/models/memory.dart';
import 'package:Siuu/models/link_preview/link_preview.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_image.dart';
import 'package:Siuu/models/post_media.dart';
import 'package:Siuu/models/post_text.dart';
import 'package:Siuu/models/post_video.dart';
import 'package:Siuu/pages/home/lib/draft_editing_controller.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/create_post_text.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/post_community_previewer.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/post_image_previewer.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/post_video_previewer.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/remaining_post_characters.dart';
import 'package:Siuu/pages/home/pages/memories/TextMemory.dart';
import 'package:Siuu/pages/home/pages/memories/VoiceMemory.dart';
import 'package:Siuu/pages/home/pages/memories/categories.dart';
import 'package:Siuu/pages/home/pages/memories/videoMemory.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/draft.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/media/media.dart';
import 'package:Siuu/services/navigation_service.dart';
import 'package:Siuu/services/share.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/utils_service.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/buttons/pill_button.dart';
import 'package:Siuu/widgets/contextual_search_boxes/contextual_search_box_state.dart';
import 'package:Siuu/widgets/icon.dart';
import 'package:Siuu/widgets/link_preview.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/new_post_data_uploader.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:Siuu/widgets/theming/smart_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pigment/pigment.dart';
import 'package:video_player/video_player.dart';

class OBSavePostModal extends StatefulWidget {
  final Memory memory;
  final String text;
  final File image;
  final File video;
  final Post post;

  const OBSavePostModal(
      {Key key, this.memory, this.text, this.image, this.video, this.post})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBSavePostModalState();
  }
}

class OBSavePostModalState extends OBContextualSearchBoxState<OBSavePostModal> {
  ValidationService _validationService;
  UserService _userService;
  NavigationService _navigationService;
  MediaService _mediaService;
  ToastService _toastService;
  LocalizationService _localizationService;
  DraftService _draftService;
  ShareService _shareService;
  UtilsService _utilsService;

  TextEditingController _textController;
  FocusNode _focusNode;
  int _charactersCount;
  LinkPreview _linkPreview;

  bool _isPostTextAllowedLength;
  bool _isPostTextContainingValidHashtags;

  bool _hasFocus;
  bool _hasImage;
  bool _hasVideo;

  // When creating a post
  File _postImageFile;
  File _postVideoFile;

  // When editing a post
  PostImage _postImage;
  PostVideo _postVideo;

  VoidCallback _postImageWidgetRemover;
  VoidCallback _postVideoWidgetRemover;
  VoidCallback _linkPreviewWidgetRemover;

  List<Widget> _postItemsWidgets;

  bool _needsBootstrap;
  bool _isCreateCommunityPostInProgress;

  bool _isEditingPost;
  PostText textMeta;
  int color;
  bool _saveInProgress;
  CancelableOperation _saveOperation;
  CancelableOperation<LinkPreview> _linkPreviewCheckOperation;

  @override
  void initState() {
    super.initState();
    _isEditingPost = widget.post != null;
    textMeta = new PostText(
        color: 0xffffffff,
        gradient: [Colors.white, Colors.white],
        imagePath: '',
        isExpanded: false,
        isColor: true,
        isPng: false,
        isSvg: false,
        isfontColorWhite: false,
        text: '');
    _focusNode = FocusNode();
    _hasFocus = false;
    _isPostTextAllowedLength = false;
    _isPostTextContainingValidHashtags = false;
    _isCreateCommunityPostInProgress = false;
    _needsBootstrap = true;

    _focusNode.addListener(_onFocusNodeChanged);
  }

  @override
  void bootstrap() {
    super.bootstrap();

    if (_isEditingPost) {
      _saveInProgress = false;
      _textController = TextEditingController(text: widget.post?.text ?? '');
      _postItemsWidgets = [
        OBCreatePostText(controller: _textController, focusNode: _focusNode)
      ];
      if (widget.post.hasMedia()) {
        PostMedia postMedia = widget.post.getFirstMedia();
        if (postMedia.type == PostMediaType.video) {
          _setPostVideo(postMedia.contentObject as PostVideo);
          _hasImage = false;
        } else {
          _setPostImage(postMedia.contentObject as PostImage);
          _hasVideo = false;
        }
      } else {
        _hasVideo = false;
        _hasImage = false;
      }
    } else {
      _textController = DraftTextEditingController.post(
          text: widget.text,
          memoryId: widget.memory != null ? widget.memory.id : null,
          draftService: _draftService);
      _postItemsWidgets = [
        OBCreatePostText(controller: _textController, focusNode: _focusNode)
      ];
      _hasImage = false;
      _hasVideo = false;
      if (widget.image != null) {
        _setPostImageFile(widget.image);
      }
      if (widget.video != null) {
        _setPostVideoFile(widget.video);
      }
    }

    setAutocompleteTextController(_textController);

    if (!_isEditingPost && widget.memory != null)
      _postItemsWidgets.add(OBPostMemoryPreviewer(
        community: widget.memory,
      ));

    _textController.addListener(_onPostTextChanged);
    _charactersCount = _textController.text.length;
    _isPostTextAllowedLength =
        _validationService.isPostTextAllowedLength(_textController.text);
    _isPostTextContainingValidHashtags = _validationService
        .isPostTextContainingValidHashtags(_textController.text);
    if (!_isEditingPost) {
      _shareService.subscribe(_onShare);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onPostTextChanged);
    _focusNode.removeListener(_onFocusNodeChanged);
    _saveOperation?.cancel();
    _shareService.unsubscribe(_onShare);
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var openbookProvider = OpenbookProvider.of(context);
      _validationService = openbookProvider.validationService;
      _navigationService = openbookProvider.navigationService;
      _mediaService = openbookProvider.mediaService;
      _localizationService = openbookProvider.localizationService;
      _toastService = openbookProvider.toastService;
      _userService = openbookProvider.userService;
      _draftService = openbookProvider.draftService;
      _shareService = openbookProvider.shareService;
      _utilsService = openbookProvider.utilsService;
      bootstrap();
      _needsBootstrap = false;
    }

    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(_localizationService),
        child: OBPrimaryColorContainer(
            child: Column(
          children: <Widget>[
            _buildNewPostContent(),
            /* Expanded(
                flex: isAutocompleting ? 3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: _buildNewPostContent1(),
                )),*/
            isAutocompleting || (_hasImage || _hasVideo)
                ? Expanded(
                    child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _postItemsWidgets,
                        )),
                  ))
                : Expanded(
                    child: TextMemory(
                      controller: _textController,
                      focusNode: _focusNode,
                      onWrited: (meta) {
                        //print(_textController);

                        // setState(() {
                        textMeta = meta;
                        // _checkForLinkPreview()
                        // _onPostTextChanged();
                        //  });
                      },
                    ),
                  ),
            isAutocompleting
                ? Expanded(
                    flex: 7,
                    child: buildSearchBox(),
                  )
                : const SizedBox(),
            isAutocompleting || (_hasImage || _hasVideo)
                ? const SizedBox()
                : Container(
                    height: _hasFocus == true ? 51 : 67,
                    padding: EdgeInsets.only(
                        top: 8.0, bottom: _hasFocus == true ? 8 : 24),
                    color: Color.fromARGB(5, 0, 0, 0),
                    child: _buildPostActions(),
                  ),
          ],
        )));
  }

  Widget _buildNavigationBar(LocalizationService _localizationService) {
    bool isPrimaryActionButtonIsEnabled =
        (_isPostTextAllowedLength && _charactersCount > 0) ||
            _hasImage ||
            _hasVideo;

    return OBThemedNavigationBar(
      leading: GestureDetector(
        child: OBIcon(OBIcons.close,
            semanticLabel: _localizationService.post__close_create_post_label),
        onTap: () {
          if (this._postImageFile != null) this._postImageFile.delete();
          if (this._postVideoFile != null)
            _mediaService.clearThumbnailForFile(this._postVideoFile);
          if (this._postVideoFile != null) this._postVideoFile.delete();
          Navigator.pop(context);
        },
      ),
      title: _isEditingPost
          ? _localizationService.post__edit_title
          : _localizationService.trans('post__create_new'),
      trailing:
          _buildPrimaryActionButton(isEnabled: isPrimaryActionButtonIsEnabled),
    );
  }

  Widget _buildPrimaryActionButton({bool isEnabled}) {
    Widget nextButton;

    if (_isEditingPost) {
      return OBButton(
          type: OBButtonType.primary,
          child: Text(_localizationService.post__edit_save),
          size: OBButtonSize.small,
          onPressed: _savePost,
          isDisabled: !isEnabled || _saveInProgress,
          isLoading: _saveInProgress);
    } else if (widget.memory != null) {
      return OBButton(
          type: OBButtonType.primary,
          child: Text(_localizationService.trans('post__share')),
          size: OBButtonSize.small,
          onPressed: _onWantsToCreateCommunityPost,
          isDisabled: !isEnabled || _isCreateCommunityPostInProgress,
          isLoading: _isCreateCommunityPostInProgress);
    } else {
      if (isEnabled) {
        nextButton = GestureDetector(
          onTap: _onWantsToGoNext,
          child: OBText(_localizationService.trans('post__create_next')),
        );
      } else {
        nextButton = Opacity(
          opacity: 0.5,
          child: OBText(_localizationService.trans('post__create_next')),
        );
      }
    }

    return nextButton;
  }

  Future<void> _onWantsToCreateCommunityPost() {
    if (!_isPostTextContainingValidHashtags) {
      _toastService.error(
          message: _localizationService.post__create_hashtags_invalid(
              ValidationService.POST_MAX_HASHTAGS,
              ValidationService.HASHTAG_MAX_LENGTH),
          context: context);
      return null;
    }
    return _createCommunityPost();
  }

  void _onWantsToGoNext() async {
    if (!_isPostTextContainingValidHashtags) {
      _toastService.error(
          message: _localizationService.post__create_hashtags_invalid(
              ValidationService.POST_MAX_HASHTAGS,
              ValidationService.HASHTAG_MAX_LENGTH),
          context: context);
      return;
    }

    OBNewPostData createPostData = await _navigationService.navigateToSharePost(
        context: context, createPostData: _makeNewPostData());

    if (createPostData != null) {
      // Remove modal
      if (this._postVideoFile != null)
        _mediaService.clearThumbnailForFile(this._postVideoFile);
      Navigator.pop(context, createPostData);
      _clearDraft();
    }
  }

  Widget _buildNewPostContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
          child: Column(
            children: <Widget>[
              OBLoggedInUserAvatar(
                size: OBAvatarSize.small,
              ),
              const SizedBox(
                height: 12.0,
              ),
              OBRemainingPostCharacters(
                maxCharacters: ValidationService.POST_MAX_LENGTH,
                currentCharacters: _charactersCount,
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
              child: Text(
                _userService.getLoggedInUser().username,
                style: TextStyle(fontSize: 20),
              )),
        )
        /*Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _postItemsWidgets,
                )),
          ),
        )*/
      ],
    );
  }

  Widget _buildPostActions() {
    List<Widget> postActions = [];

    if (!_hasImage && !_hasVideo && !_isEditingPost) {
      postActions.addAll(_getImagePostActions());
    }

    if (postActions.isEmpty) return const SizedBox();

    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      itemCount: postActions.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, index) {
        var postAction = postActions[index];

        return index == 0
            ? Row(
                children: <Widget>[
                  const SizedBox(
                    width: 10,
                  ),
                  postAction
                ],
              )
            : postAction;
      },
      separatorBuilder: (BuildContext context, index) {
        return const SizedBox(
          width: 10,
        );
      },
    );
  }

  List<Widget> _getImagePostActions() {
    return [
      OBPillButton(
        text: _localizationService.post__create_media,
        color: Pigment.fromString('#FCC14B'),
        icon: const OBIcon(OBIcons.photo),
        onPressed: () async {
          _unfocusTextField();
          try {
            var pickedMedia = await _mediaService.pickMedia(
              context: context,
              source: ImageSource.gallery,
              flattenGifs: false,
            );
            if (pickedMedia != null) {
              if (pickedMedia.type == FileType.image) {
                _setPostImageFile(pickedMedia.file);
              } else {
                _setPostVideoFile(pickedMedia.file);
              }
            }
          } catch (error) {
            _onError(error);
          }
        },
      ),
      OBPillButton(
        text: _localizationService.post__create_camera,
        color: Pigment.fromString('#50b1f2'),
        icon: const OBIcon(OBIcons.cameraCartoon),
        onPressed: () async {
          _unfocusTextField();
          try {
            var pickedMedia = await _mediaService.pickMedia(
                context: context, source: ImageSource.camera);
            if (pickedMedia != null) {
              if (pickedMedia.type == FileType.image) {
                _setPostImageFile(pickedMedia.file);
              } else {
                _setPostVideoFile(pickedMedia.file);
              }
            }
          } catch (error) {
            _onError(error);
          }
        },
      ),
    ];
  }

  void _onPostTextChanged() {
    String text = _textController.text;
    _checkForLinkPreview();
    setState(() {
      _charactersCount = text.length;
      _isPostTextAllowedLength =
          _validationService.isPostTextAllowedLength(text);
      _isPostTextContainingValidHashtags =
          _validationService.isPostTextContainingValidHashtags(text);
    });
  }

  void _onFocusNodeChanged() {
    _hasFocus = _focusNode.hasFocus;
  }

  void _setPostImageFile(File image) {
    if (!mounted) {
      return;
    }

    setState(() {
      this._postImageFile = image;
      _hasImage = true;

      var postImageWidget = OBPostImagePreviewer(
        key: Key(_postImageFile.path),
        postImageFile: _postImageFile,
        onRemove: () {
          _removePostImageFile();
        },
        onWillEditImage: () {
          _unfocusTextField();
        },
        onPostImageEdited: (File editedImage) {
          _removePostImageFile();
          _setPostImageFile(editedImage);
        },
      );

      _postImageWidgetRemover = _addPostItemWidget(postImageWidget);
    });

    _clearLinkPreview();
  }

  void _setPostVideoFile(File video) {
    if (!mounted) {
      return;
    }

    setState(() {
      this._postVideoFile = video;
      _hasVideo = true;

      var postVideoWidget = OBPostVideoPreview(
        key: Key(_postVideoFile.path),
        postVideoFile: _postVideoFile,
        onRemove: () {
          _removePostVideoFile();
        },
      );

      _postVideoWidgetRemover = _addPostItemWidget(postVideoWidget);
    });

    _clearLinkPreview();
  }

  void _setPostVideo(PostVideo postVideo) {
    // To be called on init only, therefore no setState
    _hasVideo = true;
    _postVideo = postVideo;

    var postVideoWidget = OBPostVideoPreview(
      postVideo: _postVideo,
    );

    _addPostItemWidget(postVideoWidget);
  }

  void _setPostImage(PostImage postImage) {
    // To be called on init only, therefore no setState
    _hasImage = true;
    _postImage = postImage;

    var postImageWidget = OBPostImagePreviewer(
      postImage: _postImage,
    );

    _addPostItemWidget(postImageWidget);
  }

  Future<dynamic> _onShare({String text, File image, File video}) async {
    if (image != null || video != null) {
      if (_hasImage) {
        _removePostImageFile();
      } else if (_hasVideo) {
        _removePostVideoFile();
      }
    }

    if (text != null) {
      _textController.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }

    if (image != null) {
      _setPostImageFile(image);
    }

    if (video != null) {
      _setPostVideoFile(video);
    }

    return true;
  }

  Future<void> _createCommunityPost() async {
    OBNewPostData newPostData = _makeNewPostData();
    if (this._postVideoFile != null)
      _mediaService.clearThumbnailForFile(this._postVideoFile);
    Navigator.pop(context, newPostData);
    _clearDraft();
  }

  void _savePost() async {
    _setSaveInProgress(true);
    Post editedPost;
    try {
      _saveOperation = CancelableOperation.fromFuture(_userService.editPost(
          postUuid: widget.post.uuid, text: _textController.text));

      editedPost = await _saveOperation.value;
      Navigator.pop(context, editedPost);
    } catch (error) {
      _onError(error);
    } finally {
      _setSaveInProgress(false);
      _clearDraft();
    }
  }

  void _clearDraft() {
    if (_textController is DraftTextEditingController) {
      (_textController as DraftTextEditingController).clearDraft();
    }
  }

  void _checkForLinkPreview() async {
    if (_linkPreviewCheckOperation != null) {
      _linkPreviewCheckOperation.cancel();
      _linkPreviewCheckOperation = null;
    }

    String text = _textController.text;

    String linkPreviewUrl = _utilsService.getLinkToPreviewFromText(text);

    if (_hasImage || _hasVideo || linkPreviewUrl == null) {
      _clearLinkPreview();
      return;
    }

    bool isNewLinkPreview =
        _linkPreview == null || _linkPreview.url != linkPreviewUrl;

    if (isNewLinkPreview) {
      try {
        _linkPreviewCheckOperation = CancelableOperation.fromFuture(
            _userService.previewLink(link: linkPreviewUrl));
        LinkPreview linkPreview = await _linkPreviewCheckOperation.value;
        _setLinkPreview(linkPreview);
      } catch (error) {
        debugLog('Could not check whether link was previewable');
        _clearLinkPreview();
      } finally {
        _linkPreviewCheckOperation = null;
      }
    }
  }

  void _setLinkPreview(LinkPreview linkPreview) {
    if (_linkPreviewWidgetRemover != null) _linkPreviewWidgetRemover();

    setState(() {
      _linkPreview = linkPreview;
      _linkPreviewWidgetRemover = _addPostItemWidget(OBLinkPreview(
        linkPreview: _linkPreview,
      ));
    });
  }

  void _clearLinkPreview() {
    setState(() {
      _linkPreview = null;
      if (_linkPreviewWidgetRemover != null) _linkPreviewWidgetRemover();
    });
  }

  void _onError(error) async {
    if (error is HttpieConnectionRefusedError) {
      _toastService.error(
          message: error.toHumanReadableMessage(), context: context);
    } else if (error is HttpieRequestError) {
      String errorMessage = await error.toHumanReadableMessage();
      _toastService.error(message: errorMessage, context: context);
    } else if (error is FileTooLargeException) {
      int limit = error.getLimitInMB();
      _toastService.error(
          message: _localizationService.image_picker__error_too_large(limit),
          context: context);
    } else {
      _toastService.error(
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _removePostImageFile() {
    setState(() {
      if (this._postImageFile != null) this._postImageFile.deleteSync();
      this._postImage = null;
      _hasImage = false;
      _postImageWidgetRemover();
    });
  }

  void _removePostVideoFile() {
    setState(() {
      _mediaService.clearThumbnailForFile(this._postVideoFile);
      if (this._postVideoFile != null) this._postVideoFile.deleteSync();
      this._postVideoFile = null;
      _hasVideo = false;
      _postVideoWidgetRemover();
    });
  }

  OBNewPostData _makeNewPostData() {
    List<File> media = [];
    if (_postImageFile != null) media.add(_postImageFile);
    if (_postVideoFile != null) media.add(_postVideoFile);

    return OBNewPostData(
        text: _textController.text,
        media: media,
        memory: widget.memory,
        textMeta: textMeta);
  }

  VoidCallback _addPostItemWidget(Widget postItemWidget) {
    var widgetSpacing = const SizedBox(
      height: 20.0,
    );

    List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
    newPostItemsWidgets.insert(1, widgetSpacing);
    newPostItemsWidgets.insert(1, postItemWidget);

    _setPostItemsWidgets(newPostItemsWidgets);

    return () {
      List<Widget> newPostItemsWidgets = List.from(_postItemsWidgets);
      newPostItemsWidgets.remove(postItemWidget);
      newPostItemsWidgets.remove(widgetSpacing);
      _setPostItemsWidgets(newPostItemsWidgets);
    };
  }

  void _setPostItemsWidgets(List<Widget> postItemsWidgets) {
    setState(() {
      _postItemsWidgets = postItemsWidgets;
    });
  }

  void _setSaveInProgress(bool saveInProgress) {
    setState(() {
      _saveInProgress = saveInProgress;
    });
  }

  void _unfocusTextField() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void debugLog(String log) {
    debugPrint('CreatePostModal:$log');
  }
}
