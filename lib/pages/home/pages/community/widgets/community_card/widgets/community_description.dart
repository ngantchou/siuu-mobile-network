import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryDescription extends StatelessWidget {
  final Memory memory;

  const OBMemoryDescription(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;
        var description = memory?.description;

        if (description == null) return const SizedBox();

        return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: OBActionableSmartText(
              text: description,
              size: OBTextSize.mediumSecondary,
            ));
      },
    );
  }
}
