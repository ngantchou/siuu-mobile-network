import 'package:Siuu/models/post_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

typedef IntCallback = Function(PostText textMeta);

class TextMemory extends StatefulWidget {
  IntCallback onWrited;
  TextMemory({this.onWrited});
  @override
  _TextMemoryState createState() => _TextMemoryState();
}

class _TextMemoryState extends State<TextMemory> {
  bool isPng;
  bool isSvg;
  bool isColor;
  int color;
  TextEditingController _textController = TextEditingController();
  bool isfontColorWhite;
  PostText textMeta;
  LinearGradient gradient;

  bool isExpanded;
  String imagePath;

  Widget expressYourselfPost;

  @override
  void initState() {
    super.initState();

    imagePath = '';
    expressYourselfPost = Container();
    isfontColorWhite = false;
    gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Colors.white, Colors.white],
    );
    isPng = false;
    isSvg = false;
    isColor = true;
    color = 0xffffffff;
    isExpanded = false;
    textMeta = new PostText(
        color: color,
        gradient: [Colors.white, Colors.white],
        imagePath: '',
        isExpanded: false,
        isColor: true,
        isPng: false,
        isSvg: false,
        isfontColorWhite: false,
        text: '');
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: new Container(
                decoration: new BoxDecoration(
                  gradient: textMeta.isColor
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: textMeta.gradient,
                        )
                      : null,
                ),
                child: textMeta.isSvg
                    ? SvgPicture.asset(
                        textMeta.imagePath,
                        fit: BoxFit.cover,
                      )
                    : textMeta.isPng
                        ? Image.asset(
                            textMeta.imagePath,
                            fit: BoxFit.cover,
                          )
                        : null),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: TextFormField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  textMeta.text = value;
                  widget.onWrited(textMeta);
                },
                maxLength: 200,
                maxLines: null,
                style: TextStyle(
                    color: textMeta.isfontColorWhite
                        ? Colors.white
                        : Colors.black),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Express your seft here',
                  hintStyle: TextStyle(
                      fontFamily: "Segoe UI",
                      fontWeight: FontWeight.w300,
                      fontSize: 25,
                      color: textMeta.isfontColorWhite
                          ? Colors.white
                          : Colors.black),
                ),
              ),
            ),
          ),
          Positioned(
            //bottom: MediaQuery.of(context).viewInsets.bottom,
            bottom: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: SizedBox(
                height: height * 0.043,
                child: Row(
                  children: [
                    Container(
                      height: height * 0.043,
                      width: width * 0.0729,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 0.5, color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_outlined,
                        color: Colors.blueGrey,
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: Colors.black54,
                              ),
                            ),
                            child: coloredBox(
                                boxColor: 0xffffffff, fontColor: 'black'),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xff293DA8, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          InkWell(
                            onTap: () {
                              /*widget.onWrited(_textController.text,
                                  "abstractBackground.png");*/
                              setState(() {
                                textMeta.isfontColorWhite = true;
                                textMeta.isColor = false;
                                textMeta.isSvg = false;
                                textMeta.isPng = true;
                                textMeta.imagePath =
                                    'assets/images/abstractBackground.png';
                              });
                              widget.onWrited(textMeta);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: height * 0.0365,
                                width: width * 0.083,
                                child: Image.asset(
                                  "assets/images/abstractBackground.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xffA32775, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/abstraction.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(boxColor: 0xffDD15B5, fontColor: 'white'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/giraffe.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          coloredBox(fontColor: 'white', boxColor: 0xff1549DD),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/heart3.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/hearts2.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/lines.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/lines2.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/love.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'black',
                              boxImagePath:
                                  'assets/svg/oldSchoolMusicBackground.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          imageBox(
                              fontColor: 'white',
                              boxImagePath: 'assets/svg/planets.svg'),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                textMeta.isfontColorWhite = true;
                                textMeta.isColor = false;
                                textMeta.isSvg = false;
                                textMeta.isPng = true;
                                textMeta.imagePath =
                                    'assets/images/triangles.png';
                              });
                              widget.onWrited(textMeta);
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: height * 0.0365,
                                width: width * 0.083,
                                child: Image.asset(
                                  "assets/images/triangles.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                          SizedBox(
                            width: width * 0.024,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: width * 0.012,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 30,
            child: InkWell(
              onTap: () {},
              child: Text(
                "Share",
                style: TextStyle(
                    fontFamily: "Segoe UI",
                    fontWeight: FontWeight.w300,
                    fontSize: 18,
                    color: textMeta.isfontColorWhite
                        ? Colors.white
                        : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InkWell imageBox({String boxImagePath, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          textMeta.isSvg = true;
          textMeta.isPng = false;
          textMeta.isColor = false;
          fontColor == 'white'
              ? textMeta.isfontColorWhite = true
              : textMeta.isfontColorWhite = false;
          textMeta.imagePath = boxImagePath;
        });
        widget.onWrited(textMeta);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: height * 0.0365,
          width: width * 0.083,
          child: SvgPicture.asset(
            boxImagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  InkWell coloredBox({int boxColor, String fontColor}) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(
          () {
            gradient = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(boxColor), Colors.white],
            );
            textMeta.gradient = [Color(boxColor), Colors.white];
            fontColor == 'white'
                ? textMeta.isfontColorWhite = true
                : textMeta.isfontColorWhite = false;
            textMeta.isColor = true;
            textMeta.isSvg = false;
            textMeta.isPng = false;
            textMeta.color = boxColor;
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(boxColor), Colors.white],
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        height: height * 0.0365,
        width: width * 0.083,
      ),
    );
  }
}
