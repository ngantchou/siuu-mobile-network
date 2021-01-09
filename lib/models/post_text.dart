import 'package:flutter/material.dart';

class PostText {
  final int id;
  bool isPng;
  bool isSvg;
  bool isColor;
  int color;
  bool isfontColorWhite;
  List<Color> gradient;
  String text;
  bool isExpanded;
  String imagePath;

  PostText(
      {this.id,
      this.text,
      this.isPng,
      this.isSvg,
      this.isColor,
      this.color,
      this.isfontColorWhite,
      this.isExpanded,
      this.imagePath,
      this.gradient});

  factory PostText.fromJSON(Map<String, dynamic> json) {
    if (json == null) return null;
    return PostText(
      id: json['id'],
      isPng: json['is_png'],
      isSvg: json['is_svg'],
      isColor: json['is_color'],
      isfontColorWhite: json['is_font_color_white'],
      color: json['color'],
      isExpanded: json['is_expanded'],
      imagePath: json['imagePath'],
      gradient: [Color(json['gradient'][0]), Color(json['gradient'][0])],
    );
  }

  Map<String, dynamic> toJson() {
    List<int> colorsOfGradient = [];
    List<int> toList1() {
      gradient.forEach((item) {
        colorsOfGradient.add(item.value);
      });

      return colorsOfGradient.toList();
    }

    return {
      'id': id,
      'is_png': isPng,
      'is_svg': isSvg,
      'is_color': isColor,
      'is_font_color_white': isfontColorWhite,
      'color': color,
      'is_expanded': isExpanded,
      'imagePath': imagePath,
      'gradient': toList1()
    };
  }
}
