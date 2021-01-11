import 'package:Siuu/models/theme.dart';
import 'package:Siuu/provider.dart';
import 'package:Siuu/widgets/fields/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OBCreatePostText extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;

  OBCreatePostText({this.controller, this.focusNode, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //controller: _textController,
      keyboardType: TextInputType.multiline,
      onChanged: (value) {
        // textMeta.text = value;
        // widget.onWrited(textMeta);
      },
      // maxLength: 200,
      maxLines: null,
      controller: controller,
      autofocus: true,
      focusNode: focusNode,
      style: TextStyle(color: Colors.black),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Express your seft here',
        hintStyle: TextStyle(
            fontFamily: "Segoe UI",
            fontWeight: FontWeight.w300,
            fontSize: 25,
            color: Colors.black),
      ),
    );
  }
}
