import 'package:Siuu/models/community.dart';
import 'package:Siuu/pages/home/pages/community/pages/manage_community/pages/community_closed_posts/widgets/closed_posts.dart';
import 'package:Siuu/widgets/nav_bars/themed_nav_bar.dart';
import 'package:Siuu/widgets/page_scaffold.dart';
import 'package:Siuu/widgets/theming/primary_color_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBMemoryClosedPostsPage extends StatelessWidget {
  final Memory crew;

  OBMemoryClosedPostsPage(this.crew);

  @override
  Widget build(BuildContext context) {
    return OBCupertinoPageScaffold(
      navigationBar: OBThemedNavigationBar(
        title: 'Closed posts',
      ),
      child:
          OBPrimaryColorContainer(child: OBMemoryClosedPosts(crew: this.crew)),
    );
  }
}
