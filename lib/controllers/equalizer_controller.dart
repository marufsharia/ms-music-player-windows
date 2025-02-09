import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EqualizerController extends GetxController {
 
}

class EqualizerBand {
  final int frequency;
  double level;

  EqualizerBand(this.frequency, this.level);
}
