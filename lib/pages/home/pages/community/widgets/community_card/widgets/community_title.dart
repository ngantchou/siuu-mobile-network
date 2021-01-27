import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryTitle extends StatelessWidget {
  final Memory crew;

  OBMemoryTitle(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;
        String title = crew?.title;

        if (title == null)
          return const SizedBox(
            height: 20.0,
          );

        return OBText(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        );
      },
    );
  }
}
