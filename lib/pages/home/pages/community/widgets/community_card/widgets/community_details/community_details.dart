import 'package:Siuu/models/community.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_card/widgets/community_details/widgets/community_type.dart';
import 'package:flutter/material.dart';

import 'widgets/community_favorite.dart';
import 'widgets/community_members_count.dart';
import 'widgets/community_posts_count.dart';

class OBMemoryDetails extends StatelessWidget {
  final Memory memory;

  const OBMemoryDetails(this.memory);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: memory.updateSubject,
      initialData: memory,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory memory = snapshot.data;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: <Widget>[
                    OBMemoryType(memory),
                    OBMemoryMembersCount(memory),
                    OBMemoryPostsCount(memory),
                    OBMemoryFavorite(memory)
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
