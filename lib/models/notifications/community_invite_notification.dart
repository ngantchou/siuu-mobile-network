import 'package:Siuu/models/community_invite.dart';

class MemoryInviteNotification {
  final int id;
  final MemoryInvite crewInvite;

  const MemoryInviteNotification({
    this.crewInvite,
    this.id,
  });

  factory MemoryInviteNotification.fromJson(Map<String, dynamic> json) {
    return MemoryInviteNotification(
        id: json['id'],
        crewInvite: _parseMemoryInvite(json['community_invite']));
  }

  static MemoryInvite _parseMemoryInvite(Map crewInviteData) {
    return MemoryInvite.fromJSON(crewInviteData);
  }
}
