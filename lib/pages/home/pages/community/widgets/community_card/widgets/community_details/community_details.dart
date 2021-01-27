import 'package:Siuu/models/community.dart';
import 'package:Siuu/pages/home/pages/community/widgets/community_card/widgets/community_details/widgets/community_type.dart';
import 'package:flutter/material.dart';

import 'widgets/community_favorite.dart';
import 'widgets/community_members_count.dart';
import 'widgets/community_posts_count.dart';

class OBMemoryDetails extends StatelessWidget {
  final Memory crew;

  const OBMemoryDetails(this.crew);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: crew.updateSubject,
      initialData: crew,
      builder: (BuildContext context, AsyncSnapshot<Memory> snapshot) {
        Memory crew = snapshot.data;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: SizedBox(
                child: Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: <Widget>[
                    OBMemoryType(crew),
                    OBMemoryMembersCount(crew),
                    OBMemoryPostsCount(crew),
                    OBMemoryFavorite(crew)
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
