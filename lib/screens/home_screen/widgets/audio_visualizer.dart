import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/recorder_constants.dart';

class AudioVisualizer extends StatelessWidget {
  AudioVisualizer({required this.amplitude}) {
    ///limit amplitude to [decibleLimit]
    double db = amplitude ?? RecorderConstants.decibleLimit;
    if (db == double.infinity || db < RecorderConstants.decibleLimit) {
      db = RecorderConstants.decibleLimit;
    }
    if (db > 0) {
      db = 0;
    }

    ///this expression converts [db] to [0 to 1] double
    range = 1 - (db * (1 / RecorderConstants.decibleLimit));
    print(range);
  }
  final double? amplitude;
  final double maxHeight = 100;

  late final double range;
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
    double barHeight = range * maxHeight * intensity;
    if (barHeight < 5) {
      barHeight = 5;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: AnimatedContainer(
        duration: Duration(
          milliseconds: RecorderConstants.amplitudeCaptureRateInMilliSeconds,
        ),
        height: barHeight,
        width: 5,
        decoration: BoxDecoration(
          color: AppColors.mainColor,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 1,
              offset: Offset(1, 1),
            ),
            BoxShadow(
              color: AppColors.highlightColor,
              spreadRadius: 1,
              offset: Offset(-1, -1),
            ),
          ],
        ),
      ),
    );
  }
}
