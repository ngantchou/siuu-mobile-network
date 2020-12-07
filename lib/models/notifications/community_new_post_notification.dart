import '../post.dart';

class MemoryNewPostNotification {
  final int id;
  final Post post;

  const MemoryNewPostNotification({
    this.post,
    this.id,
  });

  factory MemoryNewPostNotification.fromJson(Map<String, dynamic> json) {
    return MemoryNewPostNotification(
        id: json['id'], post: _parsePost(json['post']));
  }

  static Post _parsePost(Map postData) {
    return Post.fromJson(postData);
  }
}
