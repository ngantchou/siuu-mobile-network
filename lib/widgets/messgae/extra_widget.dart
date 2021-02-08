import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'extra_item.dart';


typedef void OnImageSelect(File mImg);


class DefaultExtraWidget extends StatefulWidget {

  final OnImageSelect onImageSelectBack;

  const DefaultExtraWidget({
    Key key,
    this.onImageSelectBack,
  }) : super(key: key);




  @override
  _DefaultExtraWidgetState createState() => _DefaultExtraWidgetState();
}

class _DefaultExtraWidgetState extends State<DefaultExtraWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
         //mainAxisSize: MainAxisSize.min,
         mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          new Flexible(
            child: createPicitem(),
            flex: 1,
          ),
          new Flexible(
            child: createVediotem(),
            flex: 1,
          ),
          new Flexible(
            child: createFileitem(),
            flex: 1,
          ),
          new Flexible(
            child: createLocationitem(),
            flex: 1,
          ),
         ],
      ),
    );
  }

  ExtraItemContainer createPicitem() => ExtraItemContainer(
        leadingIconPath: "assets/svg/Camera2.svg",
        leadingHighLightIconPath:  "assets/svg/Camera2.svg",
        text: "Camera",
        onTab: () {
          Future<File> imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
          imageFile.then((result) {
             widget.onImageSelectBack?.call(result);
          });
        },
      );

  ExtraItemContainer createVediotem() => ExtraItemContainer(
        leadingIconPath:  "assets/svg/File.svg",
        leadingHighLightIconPath:"assets/svg/File.svg",
        text: "File",
        onTab: () {
          print("File");
        },
      );

  ExtraItemContainer createFileitem() => ExtraItemContainer(
        leadingIconPath:  "assets/svg/wink.svg",
        leadingHighLightIconPath: "assets/svg/wink.svg",
        text: "Loties",
        onTab: () {
          print("Loties");
        },
      );

  ExtraItemContainer createLocationitem() => ExtraItemContainer(
        leadingIconPath:  "assets/svg/marker.svg",
        leadingHighLightIconPath: "assets/svg/marker.svg",
        text: "position",
        onTab: () {
          print("position");
        },
      );
}
