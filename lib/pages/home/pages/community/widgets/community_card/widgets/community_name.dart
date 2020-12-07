import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/secondary_text.dart';
import 'package:flutter/material.dart';

class OBMemoryName extends StatelessWidget {
  final Memory memory;

  OBMemoryName(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;
        String memoryName = memory?.name;

        if (memoryName == null)
          return const SizedBox(
            height: 10.0,
          );

        return OBSecondaryText(
          'c/' + memoryName,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black45),
        );
      },
    );
  }
}
