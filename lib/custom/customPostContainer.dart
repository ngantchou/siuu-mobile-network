import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: widget.height,
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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Column(
              children: [
                Row(
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
                SizedBox(height: height * 0.029),
                Expanded(
                  child: widget.widget,
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
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
                                Navigator.of(context).pushNamed(
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
                                );
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
                            SvgPicture.asset('assets/svg/heart.svg'),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(height: height * 0.014)
      ],
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
