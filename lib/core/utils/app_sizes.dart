import 'package:flutter/material.dart';

class AppSizes {
  final BuildContext context;

  AppSizes(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;
  double get screenHeight => MediaQuery.of(context).size.height;
}
