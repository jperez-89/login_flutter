library ch_color_ab;

import 'package:flutter/material.dart';
import 'dart:math';

class ChangeColor {
  final random = Random();

  Color change() => Color.fromRGBO(
      random.nextInt(255), random.nextInt(255), random.nextInt(255), 1);
}
