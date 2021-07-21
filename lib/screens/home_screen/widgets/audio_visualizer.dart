import 'package:flutter/material.dart';
import 'package:rapid_note/constants/recorder_constants.dart';

class AudioVisualizer extends StatelessWidget {
  ///value should be between 0 - 1;
  AudioVisualizer({required this.value}) {
    height = value * 10;
  }
  final double value;
  double height = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        buildBar(0.15),
        buildBar(0.5),
        buildBar(0.25),
        buildBar(0.75),
        buildBar(0.5),
        buildBar(1),
        buildBar(0.75),
        buildBar(0.5),
        buildBar(0.25),
        buildBar(0.5),
        buildBar(0.15),
      ],
    );
  }

  buildBar(double intensity) {
    double barHeight = height * intensity;
    if (barHeight < 5) {
      barHeight = 5;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: RecorderConstants.amplitudeRateInMilliSeconds,
        ),
        height: barHeight,
        width: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Colors.green,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff0099F7),
              Color(0xffF11712),
            ],
          ),
        ),
      ),
    );
  }
}
