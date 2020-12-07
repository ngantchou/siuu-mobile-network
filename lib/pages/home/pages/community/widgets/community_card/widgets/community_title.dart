import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryTitle extends StatelessWidget {
  final Memory memory;

  OBMemoryTitle(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;
        String title = memory?.title;

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
