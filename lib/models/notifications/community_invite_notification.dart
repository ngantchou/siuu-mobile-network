import 'package:Siuu/models/community_invite.dart';

class MemoryInviteNotification {
  final int id;
  final MemoryInvite memoryInvite;

  const MemoryInviteNotification({
    this.memoryInvite,
    this.id,
  });

  factory MemoryInviteNotification.fromJson(Map<String, dynamic> json) {
    return MemoryInviteNotification(
        id: json['id'],
        memoryInvite: _parseMemoryInvite(json['community_invite']));
  }

  static MemoryInvite _parseMemoryInvite(Map memoryInviteData) {
    return MemoryInvite.fromJSON(memoryInviteData);
  }
}
