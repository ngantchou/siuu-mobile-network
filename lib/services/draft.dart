import 'dart:collection';

class DraftService {
  static const _maxSavedDrafts = 25;

  Map<String, String> _drafts = LinkedHashMap();

  String getCommentDraft(int postId, [int commentId]) =>
      _drafts[_buildCommentKey(postId, commentId)] ?? '';

  String getPostDraft([int crewId]) => _drafts[_buildPostKey(crewId)] ?? '';

  void _set(String key, String text) {
    _drafts.update(key, (e) => text, ifAbsent: () => text);
    _trimDraftsIfNeeded();
  }

  void setCommentDraft(String text, int postId, [int commentId]) {
    if (text.trim().isNotEmpty) {
      _set(_buildCommentKey(postId, commentId), text);
    } else {
      removeCommentDraft(postId, commentId);
    }
  }

  void setPostDraft(String text, [int crewId]) {
    if (text.trim().isNotEmpty) {
      _set(_buildPostKey(crewId), text);
    } else {
      removePostDraft(crewId);
    }
  }

  void removeCommentDraft(int postId, [commentId]) =>
      _drafts.remove(_buildCommentKey(postId, commentId));

  void removePostDraft([int crewId]) => _drafts.remove(_buildPostKey(crewId));

  void _trimDraftsIfNeeded() {
    if (_drafts.length > _maxSavedDrafts) {
      _drafts.remove(_drafts.keys.first);
    }
  }

  void clear() {
    _drafts.clear();
  }

  String _buildCommentKey(int postId, int commentId) =>
      'c|$postId|${commentId ?? "-1"}';

  String _buildPostKey(int crewId) => 'p|${crewId ?? "-1"}';
}
