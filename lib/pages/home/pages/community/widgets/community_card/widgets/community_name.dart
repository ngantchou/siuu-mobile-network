import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBMemoryName extends StatelessWidget {
  final Memory crew;

  OBMemoryName(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;
        String crewName = crew?.name;

        if (crewName == null)
          return const SizedBox(
            height: 10.0,
          );

        return OBSecondaryText(
          'c/' + crewName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
