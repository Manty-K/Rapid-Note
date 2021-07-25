import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class NeumorphicMic extends StatefulWidget {
  NeumorphicMic({Key? key, required this.onTap}) : super(key: key);
  final Function onTap;
  @override
  _NeumorphicMicState createState() => _NeumorphicMicState();
}

class _NeumorphicMicState extends State<NeumorphicMic> {
  bool tapped = false;
  double neomorphicOffset = 5;
  double blurRadius = 3;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          tapped = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          tapped = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          tapped = false;
        });
      },
      child: Stack(
        children: [
          Positioned(
            bottom: tapped ? 0 : neomorphicOffset,
            right: tapped ? 0 : neomorphicOffset,
            child: Stack(
              // fit: StackFit.expand,
              children: [
                micIcon(
                  context: context,
                  color: AppColors.highlightColor,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: tapped ? 0 : blurRadius,
                    sigmaY: tapped ? 0 : blurRadius,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: tapped ? 0 : neomorphicOffset,
            left: tapped ? 0 : neomorphicOffset,
            child: Stack(
              // fit: StackFit.expand,
              children: [
                micIcon(
                  context: context,
                  color: AppColors.shadowColor,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: tapped ? 0 : blurRadius,
                    sigmaY: tapped ? 0 : blurRadius,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
          micIcon(context: context, color: AppColors.mainColor),
        ],
      ),
    );
  }

  Widget micIcon({
    required BuildContext context,
    Color color = Colors.black12,
    // Color color = const Color(0xffff0048),
  }) {
    return Icon(
      Icons.mic_rounded,
      size: MediaQuery.of(context).size.height / 2,
      color: color,
    );
  }
}
