import 'package:flutter/material.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'InstantShareDialog.dart';

class CustomPostContainer extends StatefulWidget {
  final double height;
  final String image;
  final String personName;
  final Widget widget;
  final String commentsNumber;
  final String heartNumber;

  CustomPostContainer(
      {this.commentsNumber,
      this.heartNumber,
      this.height,
      this.image,
      this.personName,
      this.widget});
  @override
  _CustomPostContainerState createState() => _CustomPostContainerState();
}

class _CustomPostContainerState extends State<CustomPostContainer> {
  Widget reactionIcon;

  @override
  void initState() {
    super.initState();
    reactionIcon = null;
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: widget.height,
          // height: 126,
          decoration: BoxDecoration(
            color: Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                offset: Offset(0.00, 4.00),
                color: Color(0xff455b63).withOpacity(0.08),
                blurRadius: 16,
              ),
            ],
            borderRadius: BorderRadius.circular(12.00),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed('/profile');
                            },
                            child: Image.asset(
                                'assets/images/${widget.image}.png')),
                        SizedBox(width: width * 0.024),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.personName,
                              style: TextStyle(
                                fontFamily: "Segoe UI",
                                fontSize: 17,
                                color: Color(0xff78849e),
                              ),
                            ),
                            Text(
                              "8 Nov",
                              style: TextStyle(
                                fontFamily: "Segoe UI",
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                color: Color(0xff78849e).withOpacity(0.56),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Image.asset('assets/images/arrowDownIcon.png'),
                  ],
                ),
              ),
              SizedBox(height: height * 0.029),
              Expanded(
                child: widget.widget,
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return InstantShareDialog();
                          },
                        );
                      },
                      child: SvgPicture.asset('assets/svg/share.svg'),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            buildNumberText(widget.commentsNumber),
                            SizedBox(width: width * 0.024),
                            InkWell(
                              onTap: () {
                                /*Navigator.of(context).pushNamed(
                                  '/comments',
                                  arguments: CustomPostContainer(
                                    image: 'avatar',
                                    commentsNumber: '256',
                                    heartNumber: '428',
                                    height: height * 0.357,
                                    personName: 'Jerome Gaveau',
                                    widget: Text(
                                      "When one door of happiness closes, another opens, but often we look so long at the closed door that we do not see the one that has been opened for us. ",
                                      style: TextStyle(
                                        height: height * 0.002,
                                        fontFamily: "Segoe UI",
                                        fontSize: 14,
                                        color: Color(0xff78849e),
                                      ),
                                    ),
                                  ),
                                );*/
                              },
                              child:
                                  SvgPicture.asset('assets/svg/comments.svg'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: width * 0.072,
                        ),
                        Row(
                          children: [
                            buildNumberText(widget.heartNumber),
                            SizedBox(width: width * 0.024),
                            FlutterReactionButton(
                              shouldChangeReaction: false,
                              boxColor: Color(0xffFD0767).withOpacity(0.3),
                              boxAlignment: Alignment.bottomRight,
                              onReactionChanged: (reaction) {
                                print('reaction selected id: ${reaction.id}');
                                setState(() {
                                  reactionIcon = reaction.icon;
                                });
                              },
                              reactions: <Reaction>[
                                Reaction(
                                  id: 1,
                                  previewIcon: buildpreview('like'),
                                  icon: buildIcon('like'),
                                ),
                                Reaction(
                                  id: 2,
                                  previewIcon: buildpreview('dislike'),
                                  icon: buildIcon('dislike'),
                                ),
                                Reaction(
                                  id: 3,
                                  previewIcon: buildpreview('heartReact'),
                                  icon: buildIcon('heartReact'),
                                ),
                                Reaction(
                                  id: 4,
                                  previewIcon: buildpreview('brokenHeart'),
                                  icon: buildIcon('brokenHeart'),
                                ),
                                Reaction(
                                  id: 5,
                                  previewIcon: buildpreview('haha'),
                                  icon: buildIcon('haha'),
                                ),
                                Reaction(
                                  id: 6,
                                  previewIcon: buildpreview('shock'),
                                  icon: buildIcon('shock'),
                                ),
                                Reaction(
                                  id: 7,
                                  previewIcon: buildpreview('smirk'),
                                  icon: buildIcon('smirk'),
                                ),
                              ],

                              // Intial reaction showing under the post container
                              initialReaction: Reaction(
                                id: 1,
                                icon: Align(
                                  alignment: Alignment.center,
                                  child: new Container(
                                    height: height * 0.0585,
                                    width: width * 0.14,
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/svg/haha.svg',
                                              height: height * 0.043,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 3),
                                            ),
                                            child: reactionIcon == null
                                                ? SvgPicture.asset(
                                                    'assets/svg/like.svg',
                                                    height: height * 0.043,
                                                  )
                                                : reactionIcon,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: height * 0.014)
      ],
    );
  }

  Padding buildpreview(
    String emoji,
  ) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SvgPicture.asset('assets/svg/$emoji.svg',
          fit: BoxFit.fill, height: height * 0.058),
    );
  }

  buildIcon(String emoji) {
    final double height = MediaQuery.of(context).size.height;
    return SvgPicture.asset(
      'assets/svg/$emoji.svg',
      fit: BoxFit.fill,
      height: height * 0.043,
    );
  }
}

Text buildNumberText(String number) {
  return Text(
    number,
    style: TextStyle(
      fontFamily: "Segoe UI",
      fontWeight: FontWeight.w600,
      fontSize: 12,
      color: Color(0xff78849e),
    ),
  );
}
