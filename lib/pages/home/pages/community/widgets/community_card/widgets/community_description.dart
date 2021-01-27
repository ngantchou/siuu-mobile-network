import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/theming/actionable_smart_text.dart';
import 'package:Siuu/widgets/theming/text.dart';
import 'package:flutter/material.dart';

class OBMemoryDescription extends StatelessWidget {
  final Memory crew;

  const OBMemoryDescription(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var crew = snapshot.data;
        var description = crew?.description;

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
