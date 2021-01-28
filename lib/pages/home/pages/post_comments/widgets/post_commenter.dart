import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/pages/home/modals/save_post/widgets/remaining_post_characters.dart';
import 'package:Siuu/pages/home/lib/draft_editing_controller.dart';
import 'package:Siuu/pages/home/widgets/lottiePersonaStickers.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/localization.dart';
import 'package:Siuu/services/toast.dart';
import 'package:Siuu/services/user.dart';
import 'package:Siuu/services/validation.dart';
import 'package:Siuu/widgets/alerts/alert.dart';
import 'package:Siuu/widgets/avatars/logged_in_user_avatar.dart';
import 'package:Siuu/widgets/avatars/avatar.dart';
import 'package:Siuu/widgets/buttons/button.dart';
import 'package:Siuu/widgets/fields/text_form_field.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:Siuu/services/httpie.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'post_comment/widgets/post_comment_audio.dart';

class OBPostCommenter extends StatefulWidget {
  final Post post;
  final PostComment postComment;
  final bool autofocus;
  final FocusNode commentTextFieldFocusNode;
  final ValueChanged<PostComment> onPostCommentCreated;
  final VoidCallback onPostCommentWillBeCreated;
  final DraftTextEditingController textController;

  OBPostCommenter(this.post,
      {this.postComment,
      this.autofocus = false,
      this.commentTextFieldFocusNode,
      this.onPostCommentCreated,
      this.onPostCommentWillBeCreated,
      @required this.textController});

  @override
  State<StatefulWidget> createState() {
    return OBPostCommenterState();
  }
}

class OBPostCommenterState extends State<OBPostCommenter> {
  bool _commentInProgress;
  bool _formWasSubmitted;
  bool _needsBootstrap;
  bool viewStickers;
  int _charactersCount;
  bool _isMultiline;

  UserService _userService;
  ToastService _toastService;
  ValidationService _validationService;
  LocalizationService _localizationService;

  CancelableOperation _submitFormOperation;

  final _formKey = GlobalKey<FormState>();
  bool isAudio = false;
  @override
  void initState() {
    super.initState();
    _commentInProgress = false;
    _formWasSubmitted = false;
    _needsBootstrap = true;
    _charactersCount = 0;
    _isMultiline = false;
    viewStickers = false;
  }

  @override
  void dispose() {
    super.dispose();
    if (_submitFormOperation != null) _submitFormOperation.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (_needsBootstrap) {
      var provider = OpenbookProvider.of(context);
      _userService = provider.userService;
      _toastService = provider.toastService;
      _validationService = provider.validationService;
      _localizationService = provider.localizationService;
      widget.textController.addListener(_onPostCommentChanged);
      _needsBootstrap = false;
    }
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    List<Widget> commentItems = [];
    commentItems.addAll([
      Column(
        children: <Widget>[
          OBLoggedInUserAvatar(
            size: OBAvatarSize.extraSmall,
          ),
          _isMultiline
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: OBRemainingPostCharacters(
                    maxCharacters: ValidationService.POST_COMMENT_MAX_LENGTH,
                    currentCharacters: _charactersCount,
                  ),
                )
              : const SizedBox()
        ],
      ),
      const SizedBox(
        width: 10.0,
      ),
      Expanded(
        child: OBAlert(
          padding: const EdgeInsets.all(0),
          child: Form(
              key: _formKey,
              child: LayoutBuilder(builder: (context, size) {
                TextStyle style = TextStyle(
                    fontSize: 14.0, fontFamilyFallback: ['NunitoSans']);
                TextSpan text = new TextSpan(
                    text: widget.textController.text, style: style);

                TextPainter tp = new TextPainter(
                  text: text,
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.left,
                );
                tp.layout(maxWidth: size.maxWidth);

                int lines = (tp.size.height / tp.preferredLineHeight).ceil();

                _isMultiline = lines > 3;

                int maxLines = 5;

                return _buildTextFormField(
                    lines < maxLines ? null : maxLines, style);
              })),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(right: 20.0, left: 10.0),
        child: OBButton(
          isLoading: _commentInProgress,
          size: OBButtonSize.small,
          onPressed: _submitForm,
          child: SvgPicture.asset('assets/svg/postIcon.svg'),
          //Text(_localizationService.trans('post__commenter_post_text')),
        ),
      )
    ]);
    return Padding(
      padding: !viewStickers
          ? EdgeInsets.symmetric(vertical: 0.0)
          : EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            // height: 100,
            //bottom: 0,

            child: keyboardVisible == 0
                ? Column(
                    children: [
                      buildContainer(width),
                      viewStickers
                          ? LottiePersonaStickers(width: width)
                          : Container(),
                    ],
                  )
                : Column(
                    children: [
                      buildContainer(width),
                      viewStickers
                          ? LottiePersonaStickers(width: width)
                          : Container(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Container buildContainer(double width) {
    FocusNode focusNode = widget.commentTextFieldFocusNode ?? null;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 4.00),
            color: Color(0xff455b63).withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.circular(12.00),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          children: [
            Column(
              children: <Widget>[
                OBLoggedInUserAvatar(
                  size: OBAvatarSize.extraSmall,
                ),
                _isMultiline
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: OBRemainingPostCharacters(
                          maxCharacters:
                              ValidationService.POST_COMMENT_MAX_LENGTH,
                          currentCharacters: _charactersCount,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            SizedBox(width: width * 0.024),
            Expanded(
              child: OBAlert(
                padding: const EdgeInsets.all(0),
                child: Form(
                    key: _formKey,
                    child: LayoutBuilder(builder: (context, size) {
                      TextStyle style = TextStyle(
                          fontSize: 14.0, fontFamilyFallback: ['NunitoSans']);
                      TextSpan text = new TextSpan(
                          text: widget.textController.text, style: style);

                      TextPainter tp = new TextPainter(
                        text: text,
                        textDirection: TextDirection.ltr,
                        textAlign: TextAlign.left,
                      );
                      tp.layout(maxWidth: size.maxWidth);

                      int lines =
                          (tp.size.height / tp.preferredLineHeight).ceil();

                      _isMultiline = lines > 3;

                      int maxLines = 5;

                      return _buildTextFormField(
                          lines < maxLines ? null : maxLines, style);
                    })),
              ),
            ),
            Row(
              children: [
                SizedBox(width: width * 0.024),
                InkWell(
                    onTap: () {
                      setState(() {
                        viewStickers = !viewStickers;
                        FocusScope.of(context).unfocus();
                      });
                    },
                    child: viewStickers
                        ? Icon(Icons.close)
                        : SvgPicture.asset(
                            'assets/svg/emoji.svg',
                            height: 50,
                          )),
                SizedBox(width: width * 0.024),
                InkWell(
                  onTap: () {
                    setState(() {
                      isAudio = true;
                    });
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 500,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              PostCommentAudio(),
                              ElevatedButton(
                                child: const Text('Close BottomSheet'),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svg/micIcon.svg',
                    height: 50,
                  ),
                ),
                SizedBox(width: width * 0.024),
                InkWell(
                  onTap: () {
                    _submitForm();
                  },
                  child: SvgPicture.asset(
                    'assets/svg/postIcon.svg',
                    height: 50,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  List<Widget> _listWidget(Widget _widget, List<Widget> _widgetList) {
    _widgetList.add(_widget);
    return _widgetList;
  }

  Widget _buildTextFormField(int maxLines, TextStyle style) {
    EdgeInsetsGeometry inputContentPadding =
        EdgeInsets.symmetric(vertical: 8.0, horizontal: 10);

    bool autofocus = widget.autofocus;
    FocusNode focusNode = widget.commentTextFieldFocusNode ?? null;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 4.00),
            color: Color(0xff455b63).withOpacity(0.08),
            blurRadius: 16,
          ),
        ],
        borderRadius: BorderRadius.circular(12.00),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: TextFormField(
                  focusNode: focusNode,
                  controller: widget.textController,
                  autofocus: autofocus,
                  autocorrect: true,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: maxLines,
                  style: TextStyle(color: Colors.black),
                  validator: (String comment) {
                    if (!_formWasSubmitted) return null;
                    return _validationService
                        .validatePostComment(widget.textController.text);
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a comment..',
                    hintStyle: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 13,
                      color: Color(0xff727272),
                    ),
                  ),
                ),
                /*OBTextFormField(
                  controller: widget.textController,
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  maxLines: maxLines,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Write a comment..',
                    hintStyle: TextStyle(
                      fontFamily: "Segoe UI",
                      fontSize: 13,
                      color: Colors.black,
                    ),
                  ),
                  hasBorder: true,
                  autofocus: autofocus,
                  autocorrect: true,
                  validator: (String comment) {
                    if (!_formWasSubmitted) return null;
                    return _validationService
                        .validatePostComment(widget.textController.text);
                  },
                ),*/
              ),
            ),
          ],
        ),
      ),
    );
    /* return OBTextFormField(
      controller: widget.textController,
      focusNode: focusNode,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      maxLines: maxLines,
      style: style,
      decoration: InputDecoration(
        hintText: _localizationService.trans('post__commenter_write_something'),
        contentPadding: inputContentPadding,
      ),
      hasBorder: false,
      autofocus: autofocus,
      autocorrect: true,
      validator: (String comment) {
        if (!_formWasSubmitted) return null;
        return _validationService.validatePostComment(widget.textController.text);
      },
    );*/
  }

  void _submitForm() async {
    if (_submitFormOperation != null) _submitFormOperation.cancel();
    _setFormWasSubmitted(true);

    bool formIsValid = _validateForm();

    if (!formIsValid) return;

    _setCommentInProgress(true);
    try {
      await (widget.onPostCommentWillBeCreated != null
          ? widget.onPostCommentWillBeCreated()
          : Future.value());
      String commentText = widget.textController.text;
      if (widget.postComment != null) {
        _submitFormOperation = CancelableOperation.fromFuture(
            _userService.replyPostComment(
                text: commentText,
                post: widget.post,
                postComment: widget.postComment));
      } else {
        _submitFormOperation = CancelableOperation.fromFuture(
            _userService.commentPost(text: commentText, post: widget.post));
      }

      PostComment createdPostComment = await _submitFormOperation.value;
      if (createdPostComment.parentComment == null)
        widget.post.incrementCommentsCount();
      widget.textController.clear();
      _setFormWasSubmitted(false);
      _validateForm();
      _setCommentInProgress(false);
      if (widget.onPostCommentCreated != null)
        widget.onPostCommentCreated(createdPostComment);
    } catch (error) {
      _onError(error);
    } finally {
      _submitFormOperation = null;
      widget.textController.clearDraft();
      _setCommentInProgress(false);
    }
  }

  void _onPostCommentChanged() {
    viewStickers = false;
    int charactersCount = widget.textController.text.length;
    _setCharactersCount(charactersCount);
    if (charactersCount == 0) _setFormWasSubmitted(false);
    if (!_formWasSubmitted) return;
    _validateForm();
  }

  bool _validateForm() {
    return _formKey.currentState.validate();
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
          message: _localizationService.trans('error__unknown_error'),
          context: context);
      throw error;
    }
  }

  void _setCommentInProgress(bool commentInProgress) {
    setState(() {
      _commentInProgress = commentInProgress;
    });
  }

  void _setFormWasSubmitted(bool formWasSubmitted) {
    setState(() {
      _formWasSubmitted = formWasSubmitted;
    });
  }

  void _setCharactersCount(int charactersCount) {
    setState(() {
      _charactersCount = charactersCount;
    });
  }

  void debugLog(String log) {
    debugPrint('OBPostCommenter:$log');
  }
}
