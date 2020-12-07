import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';

class MemoryInvite {
  final int id;
  final int creatorId;
  final int memoryId;
  final int invitedUserId;

  User invitedUser;
  User creator;
  Memory memory;

  MemoryInvite(
      {this.id,
      this.creatorId,
      this.invitedUserId,
      this.memoryId,
      this.memory,
      this.invitedUser,
      this.creator});

  factory MemoryInvite.fromJSON(Map<String, dynamic> parsedJson) {
    assert(parsedJson != null);
    User invitedUser;
    if (parsedJson.containsKey('invited_user'))
      invitedUser = User.fromJson(parsedJson['invited_user']);

    User creator;
    if (parsedJson.containsKey('creator'))
      creator = User.fromJson(parsedJson['creator']);

    Memory memory;
    if (parsedJson.containsKey('memory'))
      memory = Memory.fromJSON(parsedJson['memory']);

    return MemoryInvite(
        id: parsedJson['id'],
        memoryId: parsedJson['community_id'],
        creatorId: parsedJson['creator_id'],
        invitedUserId: parsedJson['invited_user_id'],
        memory: memory,
        invitedUser: invitedUser,
        creator: creator);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'invited_user_id': invitedUserId,
      'community_id': memoryId,
      'memory': memory?.toJson(),
      'invited_user': invitedUser?.toJson(),
      'creator': creator?.toJson()
    };
  }

  void updateFromJson(Map<String, dynamic> json) {
    // No dynamic fields, nothing to update
  }
}
