import 'package:Siuu/models/community_invite.dart';

class MemoryInviteList {
  final List<MemoryInvite> crewInvites;

  MemoryInviteList({
    this.crewInvites,
  });

  factory MemoryInviteList.fromJson(List<dynamic> parsedJson) {
    List<MemoryInvite> crewInvites = parsedJson
        .map((crewInviteJson) => MemoryInvite.fromJSON(crewInviteJson))
        .toList();

    return new MemoryInviteList(
      crewInvites: crewInvites,
    );
  }
}
