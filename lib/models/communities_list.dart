import 'package:Siuu/models/community.dart';

class CommunitiesList {
  final List<Memory> memories;

  CommunitiesList({
    this.memories,
  });

  factory CommunitiesList.fromJson(List<dynamic> parsedJson) {
    List<Memory> memories =
        parsedJson.map((crewJson) => Memory.fromJSON(crewJson)).toList();

    return new CommunitiesList(
      memories: memories,
    );
  }
}
