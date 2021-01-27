import 'package:Siuu/models/community_membership.dart';

class MemoryMembershipList {
  final List<MemoryMembership> crewMemberships;

  MemoryMembershipList({
    this.crewMemberships,
  });

  factory MemoryMembershipList.fromJson(List<dynamic> parsedJson) {
    List<MemoryMembership> crewMemberships = parsedJson
        .map((crewMembershipJson) =>
            MemoryMembership.fromJSON(crewMembershipJson))
        .toList();

    return new MemoryMembershipList(
      crewMemberships: crewMemberships,
    );
  }
}
