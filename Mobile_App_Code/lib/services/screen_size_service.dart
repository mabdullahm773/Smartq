import 'package:flutter/material.dart';

late double Width;
late double Height;

class ScreenSizeScreen{
  // Update the height and width using the context
  static void updateSize(BuildContext context) {
    Width = MediaQuery.of(context).size.width;
    Height = MediaQuery.of(context).size.height;
  }
}