import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/hashtag.dart';
import 'package:Siuu/models/user.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/services/text_autocompletion.dart';
import 'package:Siuu/widgets/contextual_search_boxes/contextual_account_search_box.dart';
import 'package:Siuu/widgets/contextual_search_boxes/contextual_community_search_box.dart';
import 'package:Siuu/widgets/contextual_search_boxes/contextual_hashtag_search_box.dart';
import 'package:flutter/material.dart';

abstract class OBContextualSearchBoxState<T extends StatefulWidget>
    extends State<T> {
  TextAutocompletionService _textAutocompletionService;
  OBContextualAccountSearchBoxController _contextualAccountSearchBoxController;
  OBContextualMemorySearchBoxController _contextualMemorySearchBoxController;
  OBContextualHashtagSearchBoxController _contextualHashtagSearchBoxController;

  TextAutocompletionType _autocompletionType;

  TextEditingController _autocompleteTextController;

  bool isAutocompleting;

  @override
  void initState() {
    super.initState();
    _contextualAccountSearchBoxController =
        OBContextualAccountSearchBoxController();
    _contextualMemorySearchBoxController =
        OBContextualMemorySearchBoxController();
    _contextualHashtagSearchBoxController =
        OBContextualHashtagSearchBoxController();
    isAutocompleting = false;
  }

  @override
  void dispose() {
    super.dispose();
    _autocompleteTextController?.removeListener(_checkForAutocomplete);
  }

  void bootstrap() {
    OpenbookProviderState openbookProvider = OpenbookProvider.of(context);
    _textAutocompletionService =
        openbookProvider.textAccountAutocompletionService;
  }

  void setAutocompleteTextController(TextEditingController textController) {
    _autocompleteTextController = textController;
    textController.addListener(_checkForAutocomplete);
  }

  Widget buildSearchBox() {
    if (!isAutocompleting) {
      throw 'There is no current autocompletion';
    }

    switch (_autocompletionType) {
      case TextAutocompletionType.account:
        return _buildAccountSearchBox();
      case TextAutocompletionType.memory:
        return _buildMemorySearchBox();
      case TextAutocompletionType.hashtag:
        return _buildHashtagSearchBox();
      default:
        throw 'Unhandled text autocompletion type';
    }
  }

  Widget _buildAccountSearchBox() {
    return OBContextualAccountSearchBox(
      controller: _contextualAccountSearchBoxController,
      onPostParticipantPressed: _onAccountSearchBoxUserPressed,
      initialSearchQuery:
          _contextualAccountSearchBoxController.getLastSearchQuery(),
    );
  }

  Widget _buildMemorySearchBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: OBContextualMemorySearchBox(
        controller: _contextualMemorySearchBoxController,
        onMemoryPressed: _onMemorySearchBoxUserPressed,
        initialSearchQuery:
            _contextualMemorySearchBoxController.getLastSearchQuery(),
      ),
    );
  }

  Widget _buildHashtagSearchBox() {
    return OBContextualHashtagSearchBox(
      controller: _contextualHashtagSearchBoxController,
      onHashtagPressed: _onHashtagSearchBoxUserPressed,
      initialSearchQuery:
          _contextualHashtagSearchBoxController.getLastSearchQuery(),
    );
  }

  void _onAccountSearchBoxUserPressed(User user) {
    autocompleteFoundAccountUsername(user.username);
  }

  void _onMemorySearchBoxUserPressed(Memory memory) {
    autocompleteFoundMemoryName(memory.name);
  }

  void _onHashtagSearchBoxUserPressed(Hashtag hashtag) {
    autocompleteFoundHashtagName(hashtag.name);
  }

  void _checkForAutocomplete() {
    TextAutocompletionResult result = _textAutocompletionService
        .checkTextForAutocompletion(_autocompleteTextController);

    if (result.isAutocompleting) {
      debugLog('Wants to autocomplete with type ${result.type} searchQuery:' +
          result.autocompleteQuery);
      _setIsAutocompleting(true);
      _setAutocompletionType(result.type);
      switch (result.type) {
        case TextAutocompletionType.hashtag:
          _contextualHashtagSearchBoxController
              .search(result.autocompleteQuery);
          break;
        case TextAutocompletionType.account:
          _contextualAccountSearchBoxController
              .search(result.autocompleteQuery);
          break;
        case TextAutocompletionType.memory:
          _contextualMemorySearchBoxController.search(result.autocompleteQuery);
          break;
      }
    } else if (isAutocompleting) {
      debugLog('Finished autocompleting');
      _setIsAutocompleting(false);
    }
  }

  void autocompleteFoundAccountUsername(String foundAccountUsername) {
    if (!isAutocompleting) {
      debugLog(
          'Tried to autocomplete found account username but was not searching account');
      return;
    }

    debugLog('Autocompleting with username:$foundAccountUsername');
    setState(() {
      _textAutocompletionService.autocompleteTextWithUsername(
          _autocompleteTextController, foundAccountUsername);
    });
  }

  void autocompleteFoundMemoryName(String foundMemoryName) {
    if (!isAutocompleting) {
      debugLog(
          'Tried to autocomplete found memory name but was not searching memory');
      return;
    }

    debugLog('Autocompleting with name:$foundMemoryName');
    setState(() {
      _textAutocompletionService.autocompleteTextWithMemoryName(
          _autocompleteTextController, foundMemoryName);
    });
  }

  void autocompleteFoundHashtagName(String foundHashtagName) {
    if (!isAutocompleting) {
      debugLog(
          'Tried to autocomplete found hashtag name but was not searching hashtag');
      return;
    }

    debugLog('Autocompleting with name:$foundHashtagName');
    setState(() {
      _textAutocompletionService.autocompleteTextWithHashtagName(
          _autocompleteTextController, foundHashtagName);
    });
  }

  void _setIsAutocompleting(bool isSearchingAccount) {
    setState(() {
      isAutocompleting = isSearchingAccount;
    });
  }

  void _setAutocompletionType(TextAutocompletionType autocompletionType) {
    setState(() {
      _autocompletionType = autocompletionType;
    });
  }

  void setState(VoidCallback fn);

  void debugLog(String log) {
    debugPrint('ContextualSearchBoxStateMixin:$log');
  }
}
