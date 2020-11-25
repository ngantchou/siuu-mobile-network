import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Siuu/custom/customAppBars/appBar1.dart';
import 'package:Siuu/custom/customPostContainer.dart';

class Comments extends StatefulWidget {
  final CustomPostContainer postContainer;
  Comments({this.postContainer});
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(width, height * 0.1755),
        child: CustomAppbar(
          title: 'Home',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              widget.postContainer,
              Container(
                width: double.infinity,
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
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
                  child: Column(
                    children: [
                      buildCommentRow(),
                      Divider(
                        thickness: 1,
                      ),
                      buildCommentRow(),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
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
                  padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                  child: Row(
                    children: [
                      Image.asset('assets/images/boy.png'),
                      SizedBox(width: width * 0.024),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Write a comment..',
                              hintStyle: TextStyle(
                                fontFamily: "Segoe UI",
                                fontSize: 13,
                                color: Color(0xff727272),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(width: width * 0.024),
                          SvgPicture.asset('assets/svg/emoji.svg'),
                          SizedBox(width: width * 0.024),
                          SvgPicture.asset('assets/svg/micIcon.svg'),
                          SizedBox(width: width * 0.024),
                          SvgPicture.asset('assets/svg/postIcon.svg'),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row buildCommentRow() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset('assets/images/boy.png'),
        SizedBox(width: width * 0.024),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jerome ipsum",
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontSize: 15,
                color: Color(0xff433f59),
              ),
            ),
            Text(
              "wow!! i like it",
              style: TextStyle(
                fontFamily: "Segoe UI",
                fontWeight: FontWeight.w300,
                fontSize: 13,
                color: Color(0xff727272),
              ),
            ),
            SizedBox(height: height * 0.007),
            Row(
              children: [
                buildText(text: 'il y a 1 heure ', color: 0xff727272),
                buildText(text: '.  J\'aime   .  Répondre', color: 0xff4D0CBB),
              ],
            )
          ],
        )
      ],
    );
  }

  Text buildText({String text, int color}) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: "Segoe UI",
        fontWeight: FontWeight.w300,
        fontSize: 9,
        color: Color(color),
      ),
    );
  }
}
