import 'package:Siuu/models/community.dart';
import 'package:Siuu/widgets/cover.dart';
import 'package:flutter/cupertino.dart';

class OBMemoryCover extends StatelessWidget {
  final Memory memory;

  OBMemoryCover(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        var memory = snapshot.data;
        String memoryCover = memory?.cover;

        return OBCover(
          coverUrl: memoryCover,
        );
      },
    );
  }
}
