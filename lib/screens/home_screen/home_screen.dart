import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapid_note/constants/app_colors.dart';
import 'package:rapid_note/constants/recorder_constants.dart';
import 'package:rapid_note/files/cubit/files_cubit.dart';
import 'package:rapid_note/recordings/record_cubit.dart';
import 'package:rapid_note/screens/home_screen/widgets/audio_visualizer.dart';
import 'package:rapid_note/screens/recordings_list/recordings_list_2.dart';
import '../../concave_decoration.dart';

class HomeScreen3 extends StatefulWidget {
  const HomeScreen3({Key? key}) : super(key: key);

  @override
  _HomeScreen3State createState() => _HomeScreen3State();
}

class _HomeScreen3State extends State<HomeScreen3> {
  bool tapped = false;
  double neomorphicOffset = 5;
  double blurRadius = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: BlocBuilder<RecordCubit, RecordState>(
        builder: (context, state) {
          if (state is RecordStopped || state is RecordInitial) {
            return SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                appTitle(),
                Spacer(),
                neomorphicMic(context, onTap: () {
                  context.read<RecordCubit>().startRecording();
                }),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => List2()));
                  },
                  child: myNotes(),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ));
          } else if (state is RecordOn) {
            Stopwatch stopwatch = Stopwatch();

            stopwatch.start();
            return SafeArea(
                child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                appTitle(),
                SizedBox(
                  height: 15,
                ),
                Text(stopwatch.elapsed.toString()),
                Spacer(),
                Row(
                  children: [
                    Spacer(),
                    StreamBuilder<double>(
                        initialData: RecorderConstants.decibleLimit,
                        stream: context.read<RecordCubit>().aplitudeStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return AudioVisualizer(amplitude: snapshot.data);
                          }
                          if (snapshot.hasError) {
                            return Text('Error');
                          } else {
                            return Text('No');
                          }
                        }),
                    Spacer(),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    stopwatch.reset();
                    context.read<RecordCubit>().stopRecording();
                    context.read<FilesCubit>().getFiles();
                  },
                  child: Container(
                    decoration: ConcaveDecoration(
                      shape: CircleBorder(),
                      depression: 10,
                      colors: [AppColors.highlightColor, AppColors.shadowColor],
                    ),
                    child: Icon(
                      Icons.stop,
                      color: AppColors.accentColor,
                      size: 50,
                    ),
                    height: 100,
                    width: 100,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ));
          } else {
            return Center(
                child: Text(
              'An Error occured',
              style: TextStyle(color: AppColors.accentColor),
            ));
          }
        },
      ),
    );
  }

  Widget neomorphicMic(BuildContext context, {required Function onTap}) {
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
        onTap();
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

  Text myNotes() {
    return Text(
      'MY NOTES',
      style: TextStyle(
          color: AppColors.accentColor,
          fontSize: 20,
          letterSpacing: 5,
          shadows: [
            Shadow(
                offset: Offset(3, 3),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.2)),
          ]
          //decoration: TextDecoration.underline,
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

  Widget appTitle() {
    return Text(
      'RAPID NOTE',
      style: TextStyle(
          color: AppColors.accentColor,
          fontSize: 50,
          letterSpacing: 5,
          fontWeight: FontWeight.w200,
          shadows: [
            Shadow(
                offset: Offset(3, 3),
                blurRadius: 5,
                color: Colors.black.withOpacity(0.2)),
          ]),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
