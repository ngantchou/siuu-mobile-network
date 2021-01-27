import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBMemoryCover extends StatelessWidget {
  final Memory crew;

  OBMemoryCover(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;
        String crewCover = crew?.cover;

        return OBCover(
          coverUrl: crewCover,
        );
      },
    );
  }
}
