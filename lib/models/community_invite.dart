import 'package:Siuu/models/community.dart';
import 'package:Siuu/models/user.dart';

class MemoryInvite {
  final int id;
  final int creatorId;
  final int crewId;
  final int invitedUserId;

  User invitedUser;
  User creator;
  Memory crew;

  MemoryInvite(
      {this.id,
      this.creatorId,
      this.invitedUserId,
      this.crewId,
      this.crew,
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

    Memory crew;
    if (parsedJson.containsKey('crew'))
      crew = Memory.fromJSON(parsedJson['crew']);

    return MemoryInvite(
        id: parsedJson['id'],
        crewId: parsedJson['community_id'],
        creatorId: parsedJson['creator_id'],
        invitedUserId: parsedJson['invited_user_id'],
        crew: crew,
        invitedUser: invitedUser,
        creator: creator);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'invited_user_id': invitedUserId,
      'community_id': crewId,
      'crew': crew?.toJson(),
      'invited_user': invitedUser?.toJson(),
      'creator': creator?.toJson()
    };
  }

  void updateFromJson(Map<String, dynamic> json) {
    // No dynamic fields, nothing to update
  }
}
