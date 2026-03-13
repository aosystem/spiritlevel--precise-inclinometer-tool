import 'package:flutter/material.dart';

class ConstValue {

  //image
  static const List<String> imageStages = [
    'assets/image/stage06.webp',
    'assets/image/stage07.webp',
    'assets/image/stage08.webp',
    'assets/image/stage09.webp',
    'assets/image/stage04.webp',
    'assets/image/stage05.webp',
    'assets/image/stage03.webp',
    'assets/image/stage01.webp',
    'assets/image/stage02.webp',
  ];
  static const String imageNeedleX = 'assets/image/needle_x.webp';
  static const String imageNeedleY = 'assets/image/needle_y.webp';
  static const String imageNeedleXY = 'assets/image/needle_xy.webp';
  //color
  static const Color colorBack = Color.fromRGBO(21, 52, 0, 1.0);
  static const Color colorHeader = Color.fromRGBO(34, 87, 0, 1);
  static const Color colorSettingAccent = Color.fromRGBO(59, 145, 0, 1.0);
  static const Color colorUiActiveColor = Color.fromRGBO(59, 145, 0,1);
  static const Color colorUiInactiveColor = Color.fromRGBO(50,50,50,1);
  //double
  static const double sensitivityDefault = 0.15;
  static const double sensitivityMin = 0.03;
  static const double sensitivityMax = 0.3;
  static const double needleLimit = 0.28;

}
