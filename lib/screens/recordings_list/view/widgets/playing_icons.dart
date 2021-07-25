import 'package:flutter/material.dart';
import 'package:rapid_note/constants/app_colors.dart';

class PlayingIcon extends StatefulWidget {
  PlayingIcon({this.idle = false});
  final bool idle;
  factory PlayingIcon.idle() {
    return PlayingIcon(idle: true);
  }
  @override
  _PlayingIconState createState() => _PlayingIconState();
}

class _PlayingIconState extends State<PlayingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double maxHeight = 50;

  bool forwardDirection = true;

  List<double> offsetArrary = [
    0.0,
    0.1,
    0.2,
    0.3,
    0.4,
    0.5,
    0.5,
    0.7,
    0.8,
    0.9
  ];

  @override
  void initState() {
    super.initState();
    offsetArrary.shuffle();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
          setState(() {
            forwardDirection = false;
          });
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
          setState(() {
            forwardDirection = true;
          });
        }
      })
      ..addListener(() {
        setState(() {});
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: offsetArrary.map((offset) => _bar(offset)).toList());
  }

  Widget _bar(double offset) {
    var value = animation.value;
    var off = 0.0;

    if (forwardDirection) {
      off = value + offset;
      if (off > 1) {
        off -= 1;
      }
    } else {
      off = value - offset;

      if (off < 0) {
        off += 1;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        height: !widget.idle ? off * maxHeight : 5,
        width: 5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.accentColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
