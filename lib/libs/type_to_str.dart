import 'package:Siuu/libs/str_utils.dart';
import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/post.dart';
import 'package:Siuu/models/post_comment.dart';
import 'package:Siuu/models/user.dart';

String modelTypeToString(dynamic modelInstance, {bool capitalize = false}) {
  String result;
  if (modelInstance is Post) {
    result = 'post';
  } else if (modelInstance is PostComment) {
    result = 'post comment';
  } else if (modelInstance is Memory) {
    result = 'memory';
  } else if (modelInstance is User) {
    result = 'user';
  } else {
    result = 'item';
  }

  return capitalize ? toCapital(result) : result;
}
