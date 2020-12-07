import 'package:Siuu/models/community_membership.dart';

class MemoryMembershipList {
  final List<MemoryMembership> memoryMemberships;

  MemoryMembershipList({
    this.memoryMemberships,
  });

  factory MemoryMembershipList.fromJson(List<dynamic> parsedJson) {
    List<MemoryMembership> memoryMemberships = parsedJson
        .map((memoryMembershipJson) =>
            MemoryMembership.fromJSON(memoryMembershipJson))
        .toList();

    return new MemoryMembershipList(
      memoryMemberships: memoryMemberships,
    );
  }
}
