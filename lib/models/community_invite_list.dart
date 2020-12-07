import 'package:Siuu/models/community_invite.dart';

class MemoryInviteList {
  final List<MemoryInvite> memoryInvites;

  MemoryInviteList({
    this.memoryInvites,
  });

  factory MemoryInviteList.fromJson(List<dynamic> parsedJson) {
    List<MemoryInvite> memoryInvites = parsedJson
        .map((memoryInviteJson) => MemoryInvite.fromJSON(memoryInviteJson))
        .toList();

    return new MemoryInviteList(
      memoryInvites: memoryInvites,
    );
  }
}
