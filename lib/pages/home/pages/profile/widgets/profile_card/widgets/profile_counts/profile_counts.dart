import 'package:Siuu/models/user.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_followers_count.dart';
import 'package:Siuu/pages/home/pages/profile/widgets/profile_card/widgets/profile_counts/widgets/profile_following_count.dart';
import 'package:Siuu/widgets/user_posts_count.dart';
import 'package:flutter/material.dart';

class OBProfileCounts extends StatelessWidget {
  final User user;

  const OBProfileCounts(this.user);

  @override
  Widget build(BuildContext context) {
        final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: user.updateSubject,
      initialData: user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        var user = snapshot.data;

        return Padding(
          padding: EdgeInsets.only(top: 20.0),
          /*child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  child: Wrap(
                    runSpacing: 10.0,
                    children: <Widget>[
                      OBProfileFollowersCount(user),
                      OBUserPostsCount(user),
                      OBProfileFollowingCount(user),
                    ],
                  ),
                ),
              )
            ],
          ),*/
          child: Row(
                      children: [
                        Spacer(
                          flex: 2,
                        ),
OBUserPostsCount(user),
                        Spacer(),
                        buildLineContainer(width,height),
                        Spacer(),
OBProfileFollowersCount(user),
                        Spacer(),
                       buildLineContainer(width,height),
                        Spacer(),
OBProfileFollowingCount(user),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
        );
      },
    );
  }
    Container buildLineContainer( double width, double height) {

    return Container(
      height: height * 0.036,
      width: width * 0.004,
      color: Color(0xff3b3b3b),
    );
  }
}
