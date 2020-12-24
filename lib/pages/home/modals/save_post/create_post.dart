import 'dart:io';

import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/memory.dart';
import 'package:Siuu/models/link_preview/link_preview.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_image.dart';
import 'package:Siuu/models/post_media.dart';
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
  PostType type = PostType.Text;
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
  bool _isCreateMemoryPostInProgress;

  bool _isEditingPost;
  VideoPlayerController _videoPlayerController;
  bool _saveInProgress;
  CancelableOperation _saveOperation;
  CancelableOperation<LinkPreview> _linkPreviewCheckOperation;
  File _video;
  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isEditingPost = widget.post != null;

    _focusNode = FocusNode();
    _hasFocus = false;
    _isPostTextAllowedLength = false;
    _isPostTextContainingValidHashtags = false;
    _isCreateMemoryPostInProgress = false;
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
    Widget widgetType;
    switch (type) {
      case PostType.Text:
        widgetType = TextMemory(onWrited: (value) {
          print(value);
          setState(() {
            _onPostTextChanged(onWrited: value);
          });
        });
        break;
      case PostType.Picture:
        widgetType = imageMemory();
        break;
      case PostType.Voice:
        widgetType = VoiceMemory();
        break;
      case PostType.Video:
        widgetType = videoMemory();
        break;
      default:
    }
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
        backgroundColor: Colors.transparent,
        navigationBar: _buildNavigationBar(_localizationService),
        child: OBPrimaryColorContainer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: height * 0.192,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = PostType.Text;
                      });
                    },
                    child: buildSizedBox(
                      text: 'Text',
                      icon: Icons.format_color_text,
                      color: [
                        Color(0xff1a2a6c),
                        Color(0xffb21f1f),
                        Color(0xfffdbb2d),
                        // Color(0xff03001e),
                        // Color(0xff7303c0),
                        // Color(0xffec38bc),
                        // Color(0xfffdeff9),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.024,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = PostType.Picture;
                      });
                    },
                    child: buildSizedBox(
                      text: 'Pictures',
                      icon: Icons.image,
                      color: [
                        Color(0xffc0392b),
                        Color(0xff8e44ad),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.024,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        type = PostType.Voice;
                      });
                    },
                    child: buildSizedBox(
                        text: 'VoiceClips',
                        icon: Icons.record_voice_over,
                        color: [
                          Color(0xff7F00FF),
                          Color(0xffE100FF),
                        ]),
                  ),
                  SizedBox(
                    width: width * 0.004,
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        type = PostType.Video;
                      });
                    },
                    child: buildSizedBox(
                      text: 'Videos',
                      icon: Icons.videocam_sharp,
                      color: [
                        Color(0xffFDC830),
                        Color(0xffF37335),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.024,
            ),
            Expanded(
                flex: isAutocompleting ? 3 : 1,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                  child: widgetType ?? _buildNewPostContent(),
                )),
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
                    child: Container() //_buildPostActions(),
                    ),
          ],
        )));
  }

  SizedBox buildSizedBox({String text, List<Color> color, IconData icon}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SizedBox(
      height: height * 0.292,
      width: width * 0.364,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: color),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(
              height: height * 0.014,
            ),
            Text(
              text,
              style: TextStyle(
                  fontFamily: "Segoe UI",
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
          onPressed: _onWantsToCreateMemoryPost,
          isDisabled: !isEnabled || _isCreateMemoryPostInProgress,
          isLoading: _isCreateMemoryPostInProgress);
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

  Future<void> _onWantsToCreateMemoryPost() {
    if (!_isPostTextContainingValidHashtags) {
      _toastService.error(
          message: _localizationService.post__create_hashtags_invalid(
              ValidationService.POST_MAX_HASHTAGS,
              ValidationService.HASHTAG_MAX_LENGTH),
          context: context);
      return null;
    }
    return _createMemoryPost();
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
        Column(
          children: <Widget>[
            OBLoggedInUserAvatar(
              size: OBAvatarSize.medium,
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
        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _postItemsWidgets,
                )),
          ),
        )
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

  void _onPostTextChanged({String onWrited}) {
    String text = onWrited ?? _textController.text;
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

  Future<void> _createMemoryPost() async {
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
        text: _textController.text, media: media, memory: widget.memory);
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

  Widget imageMemory() {
    return Container(
        child: !_hasImage
            ? Column(
                children: [
                  Text(
                    'Take a picture',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Segoe UI",
                        fontSize: 18,
                        color: Colors.blueGrey),
                  ),
                  Row(
                    children: [
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
                    ],
                  )
                ],
              )
            : _buildNewPostContent());
  }

  _pickVideo() async {
    PickedFile pickedFile = await picker.getVideo(
      source: ImageSource.gallery,
      maxDuration: Duration(seconds: 30),
    );
    _video = File(pickedFile.path);
    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  Widget videoMemory() {
    //File _video = null;
    return InkWell(
      onTap: () async {
        _unfocusTextField();

        try {
          PickedFile pickedFile = await picker.getVideo(
            source: ImageSource.gallery,
            maxDuration: Duration(seconds: 30),
          );
          _video = File(pickedFile.path);
          _videoPlayerController = VideoPlayerController.file(_video)
            ..initialize().then((_) {
              setState(() {});
              _videoPlayerController.play();
            });
          /*var pickedMedia = await _mediaService.pickMedia(
              context: context, source: ImageSource.camera);*/
          if (pickedFile != null) {
            _setPostVideoFile(_video);
          }
        } catch (error) {
          _onError(error);
        }
        //await _pickVideo();
        print("video :$_video");
        setState(() {});
      },
      child: _video == null
          ? Column(
              children: [
                Text(
                  'Record live story with\ncamera here',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 18,
                      color: Colors.blueGrey),
                ),
                IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                    onPressed: null)
              ],
            )
          : VideoMemory(
              video: _video != null
                  ? _videoPlayerController.value.initialized
                      ? AspectRatio(
                          aspectRatio: _videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(_videoPlayerController),
                        )
                      : Container()
                  : Container(),
            ),
    );
  }
}

enum PostType { Text, Picture, Voice, Video }
